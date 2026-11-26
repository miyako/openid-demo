// Form method: Main
Case of
	: (Form event code=On Load)
		Form.status:=Localized string("Status_Ready")
		// In-app language switch: name the languages in their own language.
		Form.languageDrop:=New object
		Form.languageDrop.values:=New collection("English"; "日本語")
		Form.languageDrop.index:=((Get database localization(Current localization)="ja") ? 1 : 0)
End case
