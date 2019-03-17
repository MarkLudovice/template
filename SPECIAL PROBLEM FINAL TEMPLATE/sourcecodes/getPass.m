//Get_Pass.php
<?php
require $_SERVER['DOCUMENT_ROOT']
."/new/requirements.php";
if (isset($_GET['id'])) {
$query = $handler->prepare(
"SELECT `pass_slip_id`,
`date`, `departure`,
`arrival`, `purpose`,
`reason`, `pass_status`
FROM `pass_slip`
WHERE `badge_no` = :badge_no");
$query->bindValue(
':badge_no', $_GET['id']);
$query->execute();
$events = [];

while ($row =
$query->fetch(
PDO::FETCH_ASSOC)) {
switch ($row['purpose']) {
// color
case 0:
	$color = '#9C27B0';
	$title = 'Official';
	break;
case 1:
	$color = '#FF9800';
	$title = 'Personal';
	break;
}
	$events[] = array(
'id' => $row['pass_slip_id'],
'type'=> 'pass',
'title' => $title,
'color'=> $color,
'start'=> $row['date'],
'end'=> date('Y-m-d', strtotime
  ($row['date'].' +1 day')),
'departure'=> $row['departure'],
'arrival'=> $row['arrival'],
'reason'=> $row['reason'],
'purpose'=> $row['purpose'],
'pass_status' => $row[
	'pass_status']);
	}
echo json_encode($events);
}
?>
