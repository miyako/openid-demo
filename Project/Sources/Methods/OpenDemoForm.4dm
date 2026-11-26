// Project Method: OpenDemoForm
// Opens a demo lab form as a second non-blocking window in the current
// process, reusing an existing window of the same localised title.
#DECLARE($formName : Text; $titleId : Text)

var $title : Text
var $window : Integer
var $i : Integer

$title:=Localized string($titleId)
If ($title="")
	$title:=$titleId
End if

ARRAY LONGINT($windows; 0)
WINDOW LIST($windows)
For ($i; 1; Size of array($windows))
	$window:=$windows{$i}
	If (Window process($window)=Current process) && (Get window title($window)=$title)
		BRING TO FRONT(Current process)
		return
	End if
End for

$window:=Open form window($formName; Plain form window; Horizontally centered; Vertically centered)
SET WINDOW TITLE($title; $window)
DIALOG($formName; *)
