//getDTR.php
<?php
require $_SERVER['DOCUMENT_ROOT']
."/new/requirements.php";
if (isset($_GET['id'])) {
$events = [];
$dtr_dates = [];
$leave_dates = [];

$query = $handler->prepare(
"SELECT `dtr_id`, `date`,
`timein_am`, 
`timeout_am`, timein_pm`,
`timeout_pm`, 
`late`, `undertime`, `absent`
FROM `dtr_entry`
WHERE `badge_no` = :badge_no ");

$query->bindValue
(':badge_no', $_GET['id']);
$query->execute();

if( $query->rowCount() ) {
$row = $query->fetchAll
(PDO::FETCH_ASSOC);

foreach($row as $key => $value){
$dtr_dates[$value
['date']]['dtr_id']
= $value['dtr_id'];
$dtr_dates[$value
['date']]['date']
= $value['date'];
$dtr_dates[$value
['date']]['timein_am']
= $value['timein_am'];

$dtr_dates[$value
['date']]['timeout_am']
= $value['timeout_am'];
$dtr_dates[$value
['date']]['timein_pm']	
= $value['timein_pm'];
$dtr_dates[$value
['date']]['timeout_pm'] 
= $value['timeout_pm'];
$dtr_dates[$value
['date']]['late'] 
= $value['late'];
$dtr_dates[$value
['date']]['undertime']	
= $value['undertime'];
$dtr_dates[$value
['date']]['absent']
= $value['absent'];
}
}
else {
$dtr_dates = [];
}

$query = $handler->prepare(
"SELECT la.`leave_id`, 
la.`leave_date`
FROM `leave_app` AS la
WHERE `badge_no` = :badge_no
AND `leave_status` = 1 ");
$query->bindValue
(':badge_no', $_GET['id']);
$query->execute();

if( $query->rowCount() ) {
while( $row = $query->fetch
(PDO::FETCH_ASSOC) ) {
if( strpos($row
['leave_date'], ',')
!== false ) { 
// If explodable $leave_date
// = explode
// (',', $row['leave_date']);
foreach( $leave_date as $i ) {
array_push($leave_dates, $i);
}
}
else { // If not
//foreach(
// $dtr_dates as
// $key => $value){
if( $key ==
$row['leave_date'] ) {
unset($dtr_dates[$key]);
}
}
}
}
}
foreach( $dtr_dates as
$key => $value ) {
$events[] = array
('type'	=> 'dtr',
'title'=> 'DTR',
'start'=> $value['date'],
'end'=> date('Y-m-d', strtotime
($value['date'].' +1 day')),
'id'=> $value['dtr_id'],
'timein_am'=>
	$value['timein_am'],
'timeout_am'=>
	$value['timeout_am'],
'timein_pm'=>
	$value['timein_pm'],
'timeout_pm'=>
	$value['timeout_pm'],
'late'=>
	$value['late'],
'undertime'=>
	$value['undertime'],
'absent'
	=> $value['absent']
);
}
echo json_encode($events);
}
?>
