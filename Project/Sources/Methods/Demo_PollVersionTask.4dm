// Project Method: Demo_PollVersionTask
// Polls the VersionLab version() task and logs every state transition.
#DECLARE($form : Object)

var $result : Object
var $ms : Integer

If ($form.task=Null)
	return
End if

If (Not($form.task.done))
	If (($form.busy=1) && (Not($form.loggedRunning)))
		$form.loggedRunning:=True
		Demo_AppendLog($form; Localized string("VersionLab_LogRunning"))
	End if
	return
End if

SET TIMER(0)
$form.busy:=0
$ms:=Round(((Tickcount-$form.t0)*1000)/60; 0)

$result:=$form.task.result()  // read before dispose(): dispose() discards it

If (Value type($result)#Is object)
	// the task was disposed before completion: nothing was published
	$form.status:=Localized string("VersionLab_Discarded")
	Demo_AppendLog($form; Localized string("VersionLab_LogDiscarded"))
Else
	If ($result.ok)
		$form.version:=$result.version
		$form.status:=LocalizedFormat(Localized string("VersionLab_Done"); New collection(String($ms)))
		Demo_AppendLog($form; LocalizedFormat(Localized string("VersionLab_LogDone"); New collection($result.version; String($ms))))
	Else
		$form.status:=LocalizedFormat(Localized string("Login_Failed"); New collection($result.error.code))
		Demo_AppendLog($form; LocalizedFormat(Localized string("VersionLab_LogError"); New collection($result.error.code)))
	End if
End if

$form.task.dispose()
$form.task:=Null
