// Project Method: Demo_PollTask
// Shared On Timer poll for the demo lab forms. Reads the result BEFORE
// dispose(): dispose() discards a completed result by contract.
#DECLARE($form : Object; $autoDispose : Boolean)

var $result : Object
var $tokens : Object
var $shape : Text
var $key : Text

If ($form.task=Null)
	return
End if

If (Not($form.task.done))
	return
End if

SET TIMER(0)
$form.busy:=0

$result:=$form.task.result()

If (Value type($result)#Is object)
	// the task was disposed before completion: nothing was published
	$form.status:=Localized string("VersionLab_Discarded")
Else
	If ($result.ok)
		$form.status:=Localized string("Login_Success")
		$form.resultIssuer:=$result.identity.issuer
		$form.resultSubject:=$result.identity.subject
	Else
		$form.status:=LocalizedFormat(Localized string("Login_Failed"); New collection($result.error.code))
		$form.resultIssuer:=""
		$form.resultSubject:=""
	End if

	// Tokens are an explicit opt-in: show their shape only, never their values.
	$form.tokenInfo:=""
	If (OB Is defined($result; "tokens"))
		$tokens:=$result.tokens
		$shape:=""
		For each ($key; New collection("id_token"; "access_token"; "token_type"))
			If (OB Is defined($tokens; $key))
				$shape+=(($shape="") ? "" : "; ")+$key+"="+String(Length($tokens[$key]))+"ch"
			End if
		End for each
		If (OB Is defined($tokens; "expires_at"))
			$shape+="; expires_at="+JSON Stringify($tokens.expires_at)
		End if
		$form.tokenInfo:=Localized string("Login_TokensPresent")+" "+$shape
	End if
End if

If ($autoDispose)
	$form.task.dispose()
	$form.task:=Null
	OBJECT SET ENABLED(*; "btnLogin"; True)
	OBJECT SET ENABLED(*; "btnCancel"; False)
End if
