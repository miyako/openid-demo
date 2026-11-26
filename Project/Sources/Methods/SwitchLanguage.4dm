// Project Method: SwitchLanguage
// In-app language switch (4dlocalise verified pattern, 4D 21 R5).
// Called by the hub language drop-down; reopens the hub in the new language.
#DECLARE($code : Text)

If ($code=Get database localization(Current localization))
	return
End if

SET DATABASE LOCALIZATION($code)
CANCEL  // closes the current DIALOG(...; *)
CALL WORKER(1; "Start"; {})
