// Object method: VersionLab/btnRunDispose
// dispose() before completion: the result must never surface afterwards.
If (Form event code=On Clicked)
	Form.task:=Form.client.version()
	Form.t0:=Tickcount
	Form.loggedRunning:=False
	Form.busy:=1
	Form.status:=Localized string("VersionLab_Running")
	Demo_AppendLog(Form; Localized string("VersionLab_LogDispose"))
	Form.task.dispose()
	SET TIMER(6)
End if
