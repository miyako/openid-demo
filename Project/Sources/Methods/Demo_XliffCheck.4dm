// Project Method: Demo_XliffCheck
// Temporary diagnostic: proves whether 4D loads the project XLIFF files
// and what the current database localization is. Writes a JSON report.
//
//   tool4d <project> --startup-method Demo_XliffCheck --dataless
#DECLARE($params : Object)

var $report : Object
var $blob : Blob
var $path : Text

$report:=New object
$report.currentLocalization:=Get database localization(Current localization)
$report.userSystemLocalization:=Get database localization(User system localization)
$report.mainWindowTitle:=Localized string("Main_WindowTitle")
$report.loginStarting:=Localized string("Login_Starting")
$report.menuFile:=Localized string("Demo_MenuFile")

$path:=Get 4D folder(Database folder)+"openid-demo-xliff.json"
TEXT TO BLOB(JSON Stringify($report); $blob; UTF8 text without length)
BLOB TO DOCUMENT($path; $blob)
LOG EVENT(Into system standard outputs; "xliff "+JSON Stringify($report))

QUIT 4D
