
	<html>
	<head>
	<title>Done</title>
	</head>
<h1>Wurde entsperrt siehe Log"</h1>
	<body>

<?php
$eingabe1 = $_POST['username']; 
echo  $eingabe1;


$parameter1=escapeshellcmd($eingabe1); 

 exec("C:\\Windows\\System32\\WindowsPowerShell\\v1.0\\powershell.exe -executionPolicy Unrestricted -ExecutionPolicy RemoteSigned C:\\xampp\\htdocs\\active\\test.ps1 $parameter1");



?>


<html>
<body>

<form method="post" action="log.txt">
	<input type="submit" value="Log anzeigen" >
</form>



</body>
<html>
