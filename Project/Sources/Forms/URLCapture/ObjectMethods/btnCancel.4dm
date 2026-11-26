// Object method: URLCapture/btnCancel
If (Form event code=On Clicked)
	If (Not(Form.task=Null))
		Form.task.cancel()
		Form.task.dispose()
		Form.task:=Null
		SET TIMER(0)
		Form.busy:=0
		Form.status:=Localized string("Login_Cancelled")
		OBJECT SET ENABLED(*; "btnLogin"; True)
		OBJECT SET ENABLED(*; "btnCancel"; False)
	End if
End if
