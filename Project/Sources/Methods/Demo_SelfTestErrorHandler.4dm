// Project Method: Demo_SelfTestErrorHandler
// ON ERR CALL handler for the headless self-test: records the error in a
// process variable instead of blocking headless tool4d with a dialog.
#DECLARE($code : Integer; $message : Text; $method : Text; $line : Integer)

var selfTestError : Text  // process variable, shared with Demo_HeadlessSelfTest

If (selfTestError="")
	selfTestError:="[" + String($code) + "] " + $message + " (" + $method + " line " + String($line) + ")"
End if
