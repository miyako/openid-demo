// Object method: VersionLab/btnRunVersion
If (Form event code=On Clicked)
	Form.task:=Form.client.version()
	Form.t0:=Tickcount
	Form.loggedRunning:=False
	Form.busy:=1
	Form.status:=Localized string("VersionLab_Running")
	SET TIMER(6)
End if
