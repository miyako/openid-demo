// Project Method: Demo_FormLoadCheck
// Headless done-gate extra: FORM LOAD every demo form inside an error
// handler. A green run proves 4D accepted each form definition, which
// schema validation cannot show. Writes a JSON report and quits.
//
//   tool4d <project> --startup-method Demo_FormLoadCheck --dataless
#DECLARE($params : Object)

var $report : Object
var $forms : Collection
var $name : Text
ARRAY TEXT(objectNames; 0)
ARRAY LONGINT(objectTypes; 0)
var $path : Text
var $blob : Blob

var formLoadError : Text  // process variable, shared with the error handler

ON ERR CALL("Demo_SelfTestErrorHandler")

$report:=New object
$forms:=New collection("Main"; "Login"; "VersionLab"; "ResultPages"; "URLCapture")
$report.forms:=New collection

For each ($name; $forms)
	formLoadError:=""
	FORM LOAD($name; *)
	If (formLoadError="")
		FORM GET OBJECTS(objectNames; objectTypes)
		$report.forms.push(New object("form"; $name; "ok"; True; "objects"; Size of array(objectNames)))
		FORM UNLOAD
	Else
		$report.forms.push(New object("form"; $name; "ok"; False; "error"; formLoadError))
	End if
End for each

$report.ok:=True
var $entry : Object
For each ($entry; $report.forms)
	If ($entry.ok=False)
		$report.ok:=False
	End if
End for each

$path:=Get 4D folder(Database folder)+"openid-demo-formload.json"
TEXT TO BLOB(JSON Stringify($report); $blob; UTF8 text without length)
BLOB TO DOCUMENT($path; $blob)
LOG EVENT(Into system standard outputs; "formload ok="+String($report.ok)+" "+JSON Stringify($report))

QUIT 4D
