// Project Method: Demo_NativePath
// success_html_file/failure_html_file need an absolute native path.
// A 4D File from a filesystem path such as /RESOURCES/... is not native:
// convert on macOS, keep the platform path on Windows.
#DECLARE($platformPath : Text) -> $path : Text

If (Length($platformPath)=0)
	$path:=""
	return
End if

If (Is macOS) && (Position("/"; $platformPath)#1)
	// system syntax (e.g. "Macintosh HD:Users:…") needs conversion;
	// a path that already starts with "/" is POSIX already
	$path:=Convert path system to POSIX($platformPath)
Else
	$path:=$platformPath
End if
