// Object method: ResultPages/btnFailureFile
If (Form event code=On Clicked)
	var $path : Text
	$path:=Select document(""; ""; Localized string("ResultPages_ChooseFile"); 0)
	If ($path#"")
		Form.failureFile:=$path
	End if
End if
