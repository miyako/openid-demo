// Project Method: Demo_PollURLTask
// Polls the in-memory authorization event first, then task completion.
// The completed Task is kept (no auto dispose) so the URL-lab can show
// that takeAuthorizationURL() is empty after completion.
#DECLARE($form : Object)

var $url : Text

If ($form.task=Null)
	return
End if

$url:=$form.task.takeAuthorizationURL()
If (Length($url)>0)
	$form.url:=$url
	Demo_AppendLog($form; Localized string("URLCapture_LogURL"))
End if

If (Not($form.task.done))
	return
End if

SET TIMER(0)
$form.busy:=0
Demo_PollTask($form; False)
