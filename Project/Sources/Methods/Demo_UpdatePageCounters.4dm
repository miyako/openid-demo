// Project Method: Demo_UpdatePageCounters
// Shows the UTF-8 byte size of the inline pages against the 65536 limit.
#DECLARE($form : Object)

var $blob : Blob

If ($form.pageMode="inline")
	TEXT TO BLOB($form.successHtml; $blob; UTF8 text without length)
	$form.successBytes:=LocalizedFormat(Localized string("ResultPages_Bytes"); New collection(String(BLOB size($blob))))
	TEXT TO BLOB($form.failureHtml; $blob; UTF8 text without length)
	$form.failureBytes:=LocalizedFormat(Localized string("ResultPages_Bytes"); New collection(String(BLOB size($blob))))
Else
	$form.successBytes:=""
	$form.failureBytes:=""
End if
