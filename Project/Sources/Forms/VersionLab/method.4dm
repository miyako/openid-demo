// Form method: VersionLab
// Each attempt owns its own cooperative worker and Task: two version()
// tasks can run side by side, and the UI process never waits.
Case of
	: (Form event code=On Load)
		Form.client:=cs.OpenID.Client.new(New object; Demo_TargetPlatform())
		Form.task:=Null
		Form.busy:=0
		Form.compiled:=String(Form.client.compiled)
		Form.version:=""
		Form.status:=Localized string("Status_Ready")
		Form.log:=""
	: (Form event code=On Timer)
		Demo_PollVersionTask(Form)
	: (Form event code=On Unload)
		If (Not(Form.task=Null))
			Form.task.dispose()
			Form.task:=Null
		End if
End case
