// Project Method: Demo_HeadlessSelfTest
// Headless acceptance for tool4d: proves the declared dependency loads,
// creates a real client and completes a real version() task against the
// bundled CLI. Writes a JSON report inside the project scope and quits.
//
//   tool4d <project> --startup-method Demo_HeadlessSelfTest --dataless
//
// The version task never touches the network or any provider.
#DECLARE($params : Object)

var $report : Object
var $client : cs.OpenID.Client
var $task : cs.OpenID.Task
var $result : Object
var $t0 : Integer
var $path : Text
var $blob : Blob

var selfTestError : Text  // process variable, shared with the error handler

ON ERR CALL("Demo_SelfTestErrorHandler")

$report:=New object
$report.target:=Demo_TargetPlatform()
$report.compiled:=Is compiled mode

$t0:=Tickcount
$client:=cs.OpenID.Client.new(New object; Demo_TargetPlatform())
$report.clientCreated:=($client#Null)

If (selfTestError="")
	$task:=$client.version()
	While (Not($task.done)) && ((Tickcount-$t0)<900)  // caller deadline for version is ~10s + margin
		DELAY PROCESS(Current process; 10)
	End while
	$report.elapsedTicks:=(Tickcount-$t0)

	$result:=$task.result()  // read before dispose(): dispose() discards it
	$task.dispose()

	$report.versionResult:=$result
	$report.ok:=($result.ok=True)
Else
	$report.ok:=False
	$report.error:=selfTestError
End if

$path:=Get 4D folder(Database folder)+"openid-demo-selftest.json"
TEXT TO BLOB(JSON Stringify($report); $blob; UTF8 text without length)
BLOB TO DOCUMENT($path; $blob)
LOG EVENT(Into system standard outputs; "selftest ok="+String($report.ok)+" report="+JSON Stringify($report))

QUIT 4D
