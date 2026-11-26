// Project Method: Start
// Opens the demo hub. Called without arguments from On Startup (or the
// language switch, through worker 1); with arguments it runs inside worker 1.
#DECLARE($params : Object)

var $title : Text
var $window : Integer
var $left; $top; $right; $bottom : Integer
var $i : Integer

$title:=Localized string("Main_WindowTitle")

If (Count parameters=0)

	// Reuse an already open hub window instead of stacking a second one.
	ARRAY LONGINT($windows; 0)
	WINDOW LIST($windows)
	For ($i; 1; Size of array($windows))
		$window:=$windows{$i}
		If (Window process($window)=1) && (Get window title($window)=$title)
			GET WINDOW RECT($left; $top; $right; $bottom; $window)
			CALL FORM($window; Formula(SET WINDOW RECT($left; $top; $right; $bottom; $window)))
			return
		End if
	End for

	CALL WORKER(1; Current method name; {})

Else

	SET MENU BAR(1)
	$window:=Open form window("Main"; Plain form window; Horizontally centered; Vertically centered)
	SET WINDOW TITLE($title; $window)
	DIALOG("Main"; $params; *)

End if
