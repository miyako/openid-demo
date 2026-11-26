// Object method: URLCapture/btnDispose
If (Form event code=On Clicked)
	If (Not(Form.task=Null))
		Form.task.dispose()
		Form.task:=Null
		Form.busy:=0
		SET TIMER(0)
		Form.status:=Localized string("URLCapture_Disposed")
		OBJECT SET ENABLED(*; "btnLogin"; True)
		OBJECT SET ENABLED(*; "btnCancel"; False)
	End if
End if
