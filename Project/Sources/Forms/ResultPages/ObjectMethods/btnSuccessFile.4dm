// Object method: ResultPages/btnSuccessFile
If (Form event code=On Clicked)
	var $path : Text
	$path:=Select document(""; ""; Localized string("ResultPages_ChooseFile"); 0)
	If ($path#"")
		Form.successFile:=$path
	End if
End if
