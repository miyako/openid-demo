// Project Method: Demo_AppendLog
// Appends a timestamped line to a Form.log multiline display (CR-separated).
#DECLARE($form : Object; $line : Text)

$form.log:=(($form.log="") ? "" : $form.log+Char(Carriage return))+String(Current time; HH MM SS)+"  "+$line
