// Project Method: Demo_BuildConfig
// Builds a protocol v1 configuration object from the demo form fields.
// The wrapper re-validates everything; this pre-check only gives friendly,
// localised feedback before a Task is created. No secret is involved: the
// client is a public/native application (authorization code + PKCE).
#DECLARE($form : Object) -> $built : Object

var $config : Object
var $scopes : Collection
var $parts : Collection
var $timeout : Integer
var $blob : Blob
var $path : Text

$built:=New object("ok"; False; "config"; Null; "error"; "")

// issuer: exact and trusted, trailing slash preserved (never normalised)
If (Length($form.issuer)=0)
	$built.error:=Localized string("Config_Error_Issuer")
	return
End if

// client_id: public native client, no secret anywhere in this demo
If (Length($form.clientID)=0)
	$built.error:=Localized string("Config_Error_ClientID")
	return
End if

// scopes: must include "openid"; the wrapper rejects offline_access
$scopes:=New collection
$parts:=Split string(Replace string($form.scopes; ","; " "); " ")
var $scope : Text
For each ($scope; $parts)
	If (Length($scope)>0) && ($scopes.indexOf($scope)=-1)
		$scopes.push($scope)
	End if
End for each
If ($scopes.indexOf("openid")=-1)
	$built.error:=Localized string("Config_Error_Scopes")
	return
End if
If ($scopes.indexOf("offline_access")#-1)
	$built.error:=Localized string("Config_Error_OfflineAccess")
	return
End if

// timeout_seconds: 0 keeps the component default (180); allowed range 1-900
$timeout:=Round(Num($form.timeout); 0)
If ($timeout#0) && (($timeout<1) || ($timeout>900))
	$built.error:=Localized string("Config_Error_Timeout")
	return
End if

$config:=New object
$config.issuer:=$form.issuer
$config.client_id:=$form.clientID
If (Length($form.listenAddress)>0)
	$config.listen_address:=$form.listenAddress
End if
If ($scopes.length>1)
	$config.scopes:=$scopes
End if
If ($timeout#0)
	$config.timeout_seconds:=$timeout
End if
$config.include_tokens:=($form.includeTokens=True)

// optional static result pages, exactly one form per page
Case of
	: ($form.pageMode="inline")
		If (Length($form.successHtml)>0)
			TEXT TO BLOB($form.successHtml; $blob; UTF-8 text without length)
			If (BLOB size($blob)>65536)
				$built.error:=Localized string("Config_Error_PageSize")
				return
			End if
			$config.success_html:=$form.successHtml
		End if
		If (Length($form.failureHtml)>0)
			TEXT TO BLOB($form.failureHtml; $blob; UTF-8 text without length)
			If (BLOB size($blob)>65536)
				$built.error:=Localized string("Config_Error_PageSize")
				return
			End if
			$config.failure_html:=$form.failureHtml
		End if
	: ($form.pageMode="file")
		$path:=Demo_NativePath($form.successFile)
		If (Length($path)>0)
			$config.success_html_file:=$path
		End if
		$path:=Demo_NativePath($form.failureFile)
		If (Length($path)>0)
			$config.failure_html_file:=$path
		End if
End case

$built.ok:=True
$built.config:=$config
