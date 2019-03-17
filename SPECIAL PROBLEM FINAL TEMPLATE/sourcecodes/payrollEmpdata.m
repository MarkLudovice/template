//Get_employee_data_for_
//Payroll.php
class EmployeeData {
public $name, $basic_salary,
 $gsis_contri, 
 $pagibig_contri, 
 $philhealth_contri, 
 $total_tax, 
 $total_deductions,
  $total_earnings, $absent,
   $d_loan, $handler;
public function __construct(){
$now = new DateTime(
	$_GET['date']);
$month_year = date(
	'Y-m', strtotime($_GET[
		'date']));
$this->handler = new PDO(
	'mysql:host=localhost;
	dbname=csc_rov', 'root',
	 'csc13');
$this->handler->setAttribute(
	PDO::ATTR_ERRMODE, 
	PDO::ERRMODE_EXCEPTION);

// Name
$this->name = strtoupper(
	$this->lname).', '
  .$this->fname. ' ' 
  .$this->mname[0]. '.';

// Basic Salary
$this->ch_date = new DateTime(
	$this->ch_date);
$years = ($now->diff(
	$this->ch_date)
  ->format('%Y'));
$months = ($now->diff(
	$this->ch_date)
  ->format('%m'));
/*$years = ($now->format(
'Y') - $this->ch_date
->format('Y'));
$month = ($now->format(
'm') - $this->ch_date
->format('m'));*/

if ($years == 0) {
$this->basic_salary
= $this->step1;
}
else if (($years > 0
	AND $years <= 3)) {
/* If the difference is
not greater or equal to
3 years, use the existing */
$this->basic_salary = 
$years == 3 ? $months >= 0
 ? $this->step2 : 0 : 
 $this->step1;
}
else if ($years > 3 
	AND $years <= 6) {
$this->basic_salary = 
$years == 6 ? $months >= 0
 ? $this->step3 : 0 : 
 $this->step2;
}
else if ($years > 6 
	AND $years <= 9) {
$this->basic_salary = 
$years == 9 ? $months >= 0 
 ? $this->step4 : 0 : 
  $this->step3;
}
else if ($years > 9 
	AND $years <= 12) {
$this->basic_salary = 
$years == 12 ? $months >= 0 
 ? $this->step5 : 0 : 
  $this->step4;
}
else if ($years > 12 
	AND $years <= 15) {
$this->basic_salary =
 $years == 15 ? $months >= 0
  ? $this->step6 : 0 :
   $this->step5;
}
else if ($years > 15
 AND $years <= 18) {
$this->basic_salary = 
$years == 18 ? $months >= 0
 ? $this->step7 : 0 : 
  $this->step6;
}	
else if ($years > 18
	AND $years <= 21) {
$this->basic_salary =
 $years == 21 ? $months >= 0
  ? $this->step8 : 0 :
   $this->step7;
}
else if ($years > 21) {
$this->basic_salary =
 $this->step8;
}

// GSIS
$this->gsis_contri = (
	$this->basic_salary *
	 $this->g_emp_share) +
	  ($this->basic_salary *
	   $this->g_empr_share);

// PAGIBIG
$this->pagibig_contri = (
	$this->basic_salary *
	 $this->p_emp_share) +
	  ($this->basic_salary *
	   $this->p_empr_share);

// PHILHEALTH
$query = $this->handler->
prepare("
SELECT `total_monthly_prem`
FROM `pay_philhealth_table`
WHERE `salary_range_from` <= 
:salary 
AND `salary_range_to` >= 
:salary ");
$query->bindValue(
	':salary', 
	 $this->basic_salary);
$query->execute();
$row = $query->fetch(
	PDO::FETCH_ASSOC);

$this->philhealth_contri =
 $row['total_monthly_prem'];

// DEPENDENCIES LOL
$query = $this->handler->prepare("
SELECT * FROM `emp_child`
WHERE `emp_id` = :badge_no ");
$query->execute(array(
	'badge_no'=>$this->
	Badge_no));

if ($query->rowCount() > 0) {
$dependent = 0;	
while ($child = $query->
	fetch(PDO::FETCH_ASSOC)) {
$birthday = new DateTime(
	$child['child_bday']);
$age = $now->diff($birthday);
if ($age->format('%Y') <= 21) {
$dependent += 1;
}
}
if( $dependent >= 4 ) {
$dependent = 4;
}
}
else {
$dependent = 0;
}
if ($dependent == 0) {
$e_tax_type = 2;
}
else if ($dependent == 1) {
$e_tax_type = 3;
}
else if ($dependent == 2) {
$e_tax_type = 4;
}
else if ($dependent == 3) {
$e_tax_type = 5;
}
else if ($dependent >= 4) {
$e_tax_type = 6;
}

$taxable =
 $this->basic_salary -
 ($this->gsis_contri +
  $this->pagibig_contri +
   $this->philhealth_contri) +
    ((50000 * $dependent)
     / 12 );
$holidays = 0;
// get Holidays
$query = $this->handler->
prepare("
SELECT `e_date`
FROM `special_event`
WHERE `e_date`
LIKE '$month_year%' ");
$query->execute();
$holiday_count = 0;


if( $query->rowCount() ) {
$holidays = $query->fetchAll(
	PDO::FETCH_ASSOC);
foreach( $holidays 
	as $key => $value ) {
if( date('w', strtotime($value[
	'e_date'])) != 0 &&
	date('w',
	 strtotime($value[
		'e_date']))
		 != 6 ) {
$holiday_count++;
}
}
}

// Absences
$day_count = 0;

$query = $this->handler->
prepare("
SELECT COUNT(*) as present
FROM `dtr_entry`
WHERE `date` LIKE '$month_year%'
AND badge_no = :badge_no ");
$query->bindValue(':badge_no',
	$this->Badge_no);
$query->execute();
$dates = $query->fetch(
	PDO::FETCH_ASSOC);

$month = date('m', strtotime(
	$month_year));
$year = date('Y', strtotime(
	$month_year));
$day_count = 0;

for ($i=1; $i <= date('t',
 strtotime($month_year));
  $i++) { 
$timestamp = mktime(0, 0, 0,
 $month, $i, $year);
if(date('n', $timestamp) ==
 $month) {
$day = date('N', $timestamp);
if( $day == 1 || $day <= 5 ) {
//$days[$day][] = date('j',
// $timestamp);
$day_count++;
}
}
}
$day_count -=
 $dates['present'] 
 + $holiday_count;

// COMPARING TAX
$query = $this->handler->
prepare("
SELECT MAX(`salary_base`)
 AS salary_base
FROM `pay_tax_salarybase`
 as pts,
 `pay_emp_tax_type` as pett,
  `emp_card` as ec
WHERE pts.`tax_table_id` =
 pett.`type`
AND pett.`tin` = ec.`tin`
AND pts.`salary_base` <=
 :taxable
AND ec.`badge_no` =
 :badge_no");
$query->bindValue('
	:taxable', $taxable);
$query->bindValue('
	:badge_no',
	 $this->Badge_no);
// $query->execute(array('
//taxable'=>$taxable,
// 'badge_no'=>
// $this->Badge_no));
$query->execute();
$row = $query->fetch(
	PDO::FETCH_ASSOC);
$salary_base = $row[
	'salary_base'];

// COMPUTED TAX
$ctax = $taxable -
 $salary_base;

// WITHOLDING TAX
$query = $this->handler->
prepare("
SELECT fixed_deduction,
 fixed_per, tax_rate
FROM pay_tax_rates ptr,
 pay_tax_salarybase pts
WHERE pts.salary_base = ?
 AND ptr.tax_rate_id =
  pts.tax_rate ");
$query->execute(array(
	$salary_base));
$row = $query->fetch(
	PDO::FETCH_ASSOC);

//echo $this->Badge_no .
// $row['fixed_per'] . ' ' .
// $row['fixed_deduction'] .
//'<br>';

$this->total_tax = (
 $row['fixed_deduction']
  + ($ctax * $row['
  	fixed_per']) );


// Absent Amount
$this->absent = $day_count
 * ($this->basic_salary
  / 20);

$this->total_deductions =
 $this->total_tax +
  $this->gsis_contri +
   $this->pagibig_contri +
    $this->philhealth_contri
     + $this->absent;

// LOAN
$query = $this->handler->
prepare("
SELECT * 
FROM `payroll_loan_deduc`
WHERE `badge_no` =
:badge_no ");
$query->execute(array(
	'badge_no'=>$this->
	 Badge_no));

$this->d_loan = 0;
while ($row = $query->fetch(
	PDO::FETCH_ASSOC)) {
if ($row['interest_type']
 == 0) {
$months = $row[
	'duration'];
}
else {
$months = $row[
	'duration'] * 12;
}
$start = new DateTime(
	$row['start_date']);
$end = $start->add(
	new DateInterval('P'.
		$months.'M'));
$end->format('Y-m-d');

if ($now < $end) {
$this->d_loan = ((int)$row[
	'total_amount'] + ((int)
	$row['total_amount'] *
	 (float)$row[
	 	'interest_rate'
	 	]))
	 	 / $months;
// $this->total_deductions
// += $d_loan;
}
}
$this->total_earnings =
 $this->basic_salary -
  $this->total_deductions;
}
}