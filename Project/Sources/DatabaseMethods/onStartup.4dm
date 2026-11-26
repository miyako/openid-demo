// Database Method: onStartup
// Follows the OS language, then opens the demo hub (no splash, no menu hunt).
var $language : Text

$language:=Get database localization(User system localization)
SET DATABASE LOCALIZATION(($language="ja@") ? "ja" : "en")

Start
