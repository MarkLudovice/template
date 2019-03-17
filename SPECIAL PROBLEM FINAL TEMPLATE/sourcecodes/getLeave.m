//get_Leave.php
<?php
require $_SERVER['DOCUMENT_ROOT']
."/new/requirements.php";
if (isset($_GET['id'])) {
$query = $handler->prepare(
"SELECT la.`leave_id`,
la.`date_of_filing`,
la.`working_days`,
la.`vl_location`,
la.`sl_hospital_type`,
la.`sl_hospital_name`,
la.`leave_date`,
lt.`leave_disc`,
la.`leave_status`
FROM `leave_app` AS la
LEFT OUTER JOIN `leave_type`
AS lt
ON la.`leave_type` 
= lt.`leave_type`
WHERE `badge_no` = :badge_no");
$query->bindValue(
':badge_no', $_GET['id']);
$query->execute();
$events = [];
while ($row =
	$query->fetch
	(PDO::FETCH_ASSOC)) {
switch ($row['leave_disc'])
{ // color
case 'vacation':
	$color = '#4CAF50';
	break;
case 'sick':
	$color = '#CDDC39';
	break;
case 'maternity':
$color = '#F06292';
break;
case 'paternity':
$color = '#3F51B5';
break;
case 'special_privilege':
$color = '#B71C1C';
break;
}

$date = explode
(',', $row['leave_date']);
foreach ($date as $i){
	$events[] = array (
'id'=> $row['leave_id'],
'type'	=> 'leave',
'title'	=> ucfirst(
	$row['leave_disc']),
'color' => $color,
'start'=> $i,
'end'=> date('Y-m-d',
	strtotime($i . ' +1 day')),
'leave_type'=>
ucwords($row['leave_disc']),
'date_of_filing'
=> $row['date_of_filing'],
'working_days'
=>$row['working_days'],
'vl_location'
=> $row['vl_location'],
'sl_hospital_type'
=> $row['sl_hospital_type'],
'sl_hospital_name'
=> $row['sl_hospital_name'],
'leave_status'
=> $row['leave_status']	);
}
}
echo json_encode($events);
}
?>
