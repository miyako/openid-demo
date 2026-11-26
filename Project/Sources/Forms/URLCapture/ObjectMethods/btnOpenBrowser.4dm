// Object method: URLCapture/btnOpenBrowser
// The user, not the component, decides when the browser opens.
If (Form event code=On Clicked)
	If (Length(Form.url)>0)
		OPEN URL(Form.url)
	End if
End if
