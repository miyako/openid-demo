// Object method: ResultPages/dropMode
If (Form event code=On Data Change)
	If (Form.modeDrop.index>=0)
		Form.pageMode:=Form.modeKeys[Form.modeDrop.index]
	Else
		Form.pageMode:="none"
	End if
	OBJECT SET ENABLED(*; "txtSuccess"; (Form.pageMode="inline"))
	OBJECT SET ENABLED(*; "txtFailure"; (Form.pageMode="inline"))
	OBJECT SET ENABLED(*; "inpSuccessFile"; (Form.pageMode="file"))
	OBJECT SET ENABLED(*; "inpFailureFile"; (Form.pageMode="file"))
	OBJECT SET ENABLED(*; "btnSuccessFile"; (Form.pageMode="file"))
	OBJECT SET ENABLED(*; "btnFailureFile"; (Form.pageMode="file"))
End if
