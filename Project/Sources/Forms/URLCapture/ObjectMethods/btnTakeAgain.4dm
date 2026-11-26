// Object method: URLCapture/btnTakeAgain
// takeAuthorizationURL() is read-and-clear: a second call returns "".
If (Form event code=On Clicked)
	If (Not(Form.task=Null))
		Form.takeAgain:=Form.task.takeAuthorizationURL()
		Demo_AppendLog(Form; Localized string("URLCapture_LogTake")+" ["+Form.takeAgain+"]")
	Else
		Form.takeAgain:=""
		Demo_AppendLog(Form; Localized string("URLCapture_LogNoTask"))
	End if
End if
