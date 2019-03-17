//Leave_Credits.php
// DTR
$query = $handler->prepare("
SELECT dtr_ed_id,
timein_am_edit,
timeout_am_edit,
timein_pm_edit,
timeout_pm_edit, date
FROM dtr_edit
WHERE badge_no = ? ");
$query->execute(array(
  $_SESSION["user_session"]));

if( $query->rowCount() ){
$dtr = $query->fetchAll(
  PDO::FETCH_ASSOC);
}

$year = array();
$month = array();

if( !empty($dtr) ){
foreach( $dtr as
  $key => $value ) {
if(!in_array(date("Y",
  strtotime($value["date"])),
  $year)) {
$year[] = date("Y",
  strtotime($value
    ["date"]));
}
if(!in_array(date("F",
  strtotime($value["date"])),
  $month)) {
$month[date("m",
  strtotime($value["date"]))]
= date("F", strtotime($value
  ["date"]));
}
}
}
$query = $handler->prepare("
SELECT *
FROM `leave_credits`
WHERE emp_no = ?
");
$query->execute(array(
  $_SESSION['user_session']));

if( $query->rowCount() ){
$row = $query->fetch(
  PDO::FETCH_ASSOC);
$current_lc = $row['total_lc'];
}

function converter($seconds){
global $handler;

$hours = floor
 ($seconds / (60 * 60));
$minutes = floor
 ($seconds % (60 * 60) / 60);

$query = $handler->prepare("
SELECT `credit_equi_h`
FROM `leave_equi_hrs`
WHERE `hrs_id` = :hours
");
$query->bindValue(
  ':hours', $hours);
$query->execute();
$row = $query->fetch(
  PDO::FETCH_ASSOC);

$total_lc = $row[
  'credit_equi_h'];

$query = $handler->prepare("
SELECT `credit_equi_m`
FROM `leave_equi_mins`
WHERE `min_id` = :minutes
");
$query->bindValue(
  ':minutes', $minutes);
$query->execute();
$row = $query->fetch(
  PDO::FETCH_ASSOC);

$total_lc += $row[
  'credit_equi_m'];

return $total_lc;
}

// If `last_added`
// date is equal to
// current date or has passed
if( date('Y-m', strtotime(
  $row['last_added'])) < date(
  'Y-m') ) {
$previous_month = date('Y-m',
 strtotime('-1 month'));
$query = $handler->prepare("
SELECT SUM( late ) as late,
SUM(undertime) as undertime
FROM `dtr_entry`
WHERE badge_no = :badge_no 
AND date LIKE '$previous_month%'
");
$query->bindValue('
  :badge_no', $_SESSION[
    'user_session']);
$query->execute();

$row = $query->fetch(
  PDO::FETCH_ASSOC);

$late = $row['late'];
$undertime = $row['undertime'];

$credits = 1.25 - converter(
  $late + $undertime);

$query = $handler->prepare("
UPDATE `leave_credits`
SET total_lc = ?,
`last_added` = ?
WHERE `emp_no` = ?
");
$query->execute(array(
  $current_lc + $credits,
  date('Y-m-d'), $_SESSION[
    'user_session']));
}
else if( date('Y-m', strtotime(
  $row['last_added'])) > date(
  'Y-m') ) {
$previous_month = date('Y-m', 
  strtotime('-1 month'));
$query = $handler->prepare("
SELECT SUM( `late` ) 
as late, SUM( `undertime` ) 
as undertime
FROM `dtr_entry`
WHERE `badge_no` = :badge_no 
AND `date` LIKE '$previous_month%'
");
$query->bindValue(
  ':badge_no', $_SESSION['
    user_session']);
$query->execute();

$row = $query->fetch(
  PDO::FETCH_ASSOC);

$late = $row['late'];
$undertime = $row['undertime'];

$credits = 1.25 - converter(
  $late + $undertime);

$query = $handler->prepare("
UPDATE `leave_credits`
SET `total_lc` = ?,
`last_added` = ?
WHERE `emp_no` = ?
");
$query->execute(array(
  $current_lc - $credits, date(
    'Y-m-d'), $_SESSION['
    user_session']));
}
$query->execute();

if( date('Y-m-t') == date(
  'Y-m-d') ) {
if( $row['last_added'] !=
  date('Y-m-d') ) {
$date = date('Y-m');
$holidays = 0;
// get Holidays
$query = $handler->prepare("
SELECT `e_date`
FROM `special_event`
WHERE `e_date` LIKE '$date%'
");
$query->execute();

$holiday_count = 0;
if( $query->rowCount() ) {
$holidays = $query->fetchAll(
  PDO::FETCH_ASSOC);
foreach( $holidays 
  as $key => $value ) {
  if( date('w', strtotime($value
    ['e_date'])) != 0 && date(
    'w', strtotime($value['
      e_date']))
    != 6 )
{ $holiday_count++; }
}
}

// Absences
$day_count = 0;

$query = $handler->prepare("
SELECT COUNT(*) as present
FROM `dtr_entry`
WHERE `date` LIKE '$date%' 
AND badge_no = :badge_no
");
$query->bindValue('
  :badge_no', $_SESSION[
    'user_session']);
$query->execute();
$dates = $query->fetch(
  PDO::FETCH_ASSOC);

$month = date('m', strtotime($date));
$year = date('Y', strtotime($date));
$day_count = 0;

for ($i=1; $i <= date('t', strtotime(
  $date)); $i++) { 
$timestamp = mktime(0, 0, 0, $month,
  $i, $year);

if(date('n', $timestamp) == $month) {
  $day = date('N', $timestamp);

  if( $day == 1 || $day <= 5 ) {
    //$days[$day][] = date('j',
    //$timestamp);
    $day_count++;
  }
}
}

$day_count -= $dates['present']
 + $holiday_count;

$query = $handler->prepare("
  UPDATE `leave_credits`
  SET `total_lc` = ?,
  `last_added` = ?
  WHERE `emp_no` = ?
");
$query->execute(array(
  $current_lc - $day_count,
   date('Y-m-d'), 
  $_SESSION['user_session']));
}
}
