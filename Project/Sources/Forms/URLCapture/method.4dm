// Form method: URLCapture
// open_browser:false keeps the browser closed; the authorization URL is
// available in memory through takeAuthorizationURL() and is cleared on
// completion or disposal. The URL contains state/nonce/PKCE material:
// display it, never log or persist it.
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
		Form.url:=""
		Form.takeAgain:=""
		Form.log:=""
		OBJECT SET ENABLED(*; "btnLogin"; True)
		OBJECT SET ENABLED(*; "btnCancel"; False)
	: (Form event code=On Timer)
		Demo_PollURLTask(Form)
	: (Form event code=On Unload)
		If (Not(Form.task=Null))
			Form.task.dispose()
			Form.task:=Null
		End if
End case
