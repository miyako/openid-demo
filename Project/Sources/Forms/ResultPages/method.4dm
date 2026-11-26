// Form method: ResultPages
// The browser page is display only: Task.result() stays authoritative.
// A slow idle timer keeps the UTF-8 byte counters live while typing.
Case of
	: (Form event code=On Load)
		Form.issuer:=""
		Form.clientID:=""
		Form.listenAddress:="127.0.0.1:42813"
		Form.scopes:="openid"
		Form.timeout:=180
		Form.includeTokens:=False
		Form.task:=Null
		Form.busy:=0
		Form.status:=Localized string("Status_Ready")
		Form.resultIssuer:=""
		Form.resultSubject:=""
		Form.tokenInfo:=""
		Form.modeKeys:=New collection("none"; "inline"; "file")
		Form.modeDrop:=New object
		Form.modeDrop.values:=New collection(Localized string("ResultPages_ModeNone"); Localized string("ResultPages_ModeInline"); Localized string("ResultPages_ModeFile"))
		Form.modeDrop.index:=0
		Form.pageMode:="none"
		Form.successHtml:="<html><body><h1>OK</h1></body></html>"
		Form.failureHtml:=""
		Form.successFile:=""
		Form.failureFile:=""
		Demo_UpdatePageCounters(Form)
		OBJECT SET ENABLED(*; "btnLogin"; True)
		OBJECT SET ENABLED(*; "btnCancel"; False)
		SET TIMER(30)
	: (Form event code=On Timer)
		Demo_UpdatePageCounters(Form)
		Demo_PollTask(Form; True)
		// the byte counters keep running while the form is idle
		If (Form.task=Null)
			SET TIMER(30)
		End if
	: (Form event code=On Unload)
		If (Not(Form.task=Null))
			Form.task.dispose()
			Form.task:=Null
		End if
End case
