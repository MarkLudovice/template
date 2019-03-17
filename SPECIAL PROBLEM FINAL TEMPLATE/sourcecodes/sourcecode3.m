//Approving Requests

<?php
	date_default_timezone_set("Asia/Taipei");
    $date = date("Y-m-d");
	include "dbconnect.php";
	
	$ris_no = $_GET['id'];

	$sql = "UPDATE `supply_ris_t` SET `status`='approved',`date_approved`='$date' WHERE `ris_no`='$ris_no'";
	$q = mysql_query($sql) or die(mysql_error());
	
	header("location: supply_approved_requests.php");	
?>