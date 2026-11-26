// Form method: Login
// Nonblocking pattern: authenticate() returns a Task immediately; the form
// polls it with On Timer. Cancellation and disposal never touch the worker.
Case of
	: (Form event code=On Load)
		Form.issuer:=""
		Form.clientID:=""
		Form.listenAddress:="127.0.0.1:42813"
		Form.scopes:="openid"
		Form.timeout:=180
		Form.includeTokens:=False
		Form.pageMode:="none"
		Form.successHtml:=""
		Form.failureHtml:=""
		Form.successFile:=""
		Form.failureFile:=""
		Form.task:=Null
		Form.busy:=0
		Form.status:=Localized string("Status_Ready")
		Form.resultIssuer:=""
		Form.resultSubject:=""
		Form.tokenInfo:=""
		OBJECT SET ENABLED(*; "btnLogin"; True)
		OBJECT SET ENABLED(*; "btnCancel"; False)
	: (Form event code=On Timer)
		Demo_PollTask(Form; True)
	: (Form event code=On Unload)
		// The owner is the 4D process, not the form: dispose() explicitly.
		If (Not(Form.task=Null))
			Form.task.dispose()
			Form.task:=Null
		End if
End case
