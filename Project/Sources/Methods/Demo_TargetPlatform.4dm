// Project Method: Demo_TargetPlatform
// The wrapper requires an explicit, supported execution target.
#DECLARE -> $target : Text

If (Is macOS)
	$target:="macOS-universal"
Else
	$target:="Windows-x64"
End if
