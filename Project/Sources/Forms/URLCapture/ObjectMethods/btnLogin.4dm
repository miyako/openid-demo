// Object method: URLCapture/btnLogin
If (Form event code=On Clicked)
	If (Demo_StartLogin(Form; False))
		Demo_AppendLog(Form; Localized string("URLCapture_LogStarted"))
	End if
End if
