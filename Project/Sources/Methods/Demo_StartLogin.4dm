// Project Method: Demo_StartLogin
// Shared login start for the demo lab forms. Returns immediately: the
// wrapper hands back a Task, the UI polls it with a timer.
#DECLARE($form : Object; $openBrowser : Boolean) -> $started : Boolean

var $built : Object
var $config : Object

$started:=False

$built:=Demo_BuildConfig($form)
If (Not($built.ok))
	$form.status:=$built.error
	return
End if

$config:=$built.config
If (Not($openBrowser))
	$config.open_browser:=False
End if

$form.task:=cs.OpenID.Client.new($config; Demo_TargetPlatform()).authenticate()
$form.busy:=1
$form.status:=Localized string(($openBrowser) ? "Login_Starting" : "URLCapture_StartedNoBrowser")
OBJECT SET ENABLED(*; "btnLogin"; False)
OBJECT SET ENABLED(*; "btnCancel"; True)
SET TIMER(6)
$started:=True
