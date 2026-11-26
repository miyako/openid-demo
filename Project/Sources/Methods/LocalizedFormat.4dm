//%attributes = {"invisible":true}
// Project Method: LocalizedFormat
// Expands {1}, {2}, ... placeholders in a localised string.
#DECLARE($id : Text; $values : Collection) : Text

var $text := Localized string($id)
If ($text="")
	$text:=$id  // a missing entry stays visible instead of blank
End if
var $i : Integer
For ($i; 1; ($values=Null) ? 0 : $values.length)
	$text:=Replace string($text; "{"+String($i)+"}"; String($values[$i-1]))
End for
return $text
