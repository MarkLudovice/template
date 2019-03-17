//Add_Employee.php
<?php
require $_SERVER['DOCUMENT_ROOT']
.'/new/requirements.php';

if( !empty($_POST) ) {
$id = explode("-", $_POST[
	"date_birth"]);
$badge_no = $id[0][2] 
.$id[0][3]; // Year
$badge_no .= $id[1][0]
. $id[1][1]; // Month
$badge_no .= $id[2][0];// Day

$query = $handler->prepare("
SELECT *
FROM employee
WHERE Badge_no = ?");
$query->execute(array(
	$badge_no));

if( $query->rowCount() ){
$flag = 0;
while( $flag == 0 ) {
$query = $handler->prepare("
SELECT * FROM employee
WHERE Badge_no = ?");
$query->execute(array(
	$badge_no));
if( $query->rowCount() ){
$badge_no++;
}
else {
$flag = 1;
}
}
}

try {
$handler->beginTransaction();
// Employee
$query = $handler->prepare("
INSERT INTO `employee`(
	`Badge_no`, `fname`, 
	`mname`, `lname`, 
	`name_extension`, `sex`,
	`date_birth`, 
	`position`, `department`,
	 `start_employment`)
VALUES(:badge_no, :fname, 
	:mname, :lname, 
	:name_extension, :sex, 
	:date_birth, :position, 
	:department, 
	:start_employment) ");
$query->bindValue("
	:badge_no", $badge_no);
$query->bindValue("
	:fname", $_POST["
		fname"]);
$query->bindValue("
	:mname", $_POST["
		mname"]);
$query->bindValue("
	:lname", $_POST["
		lname"]);
$query->bindValue("
	:name_extension", $_POST["
	name_extension"]);
$query->bindValue("
	:sex", $_POST["sex"]);
$query->bindValue("
	:date_birth", $_POST["
		date_birth"]);
$query->bindValue("
	:position", $_POST["
		position"]);
$query->bindValue("
	:department", $_POST["
		department"]);
$query->bindValue("
	:start_employment",
	$_POST["
	start_employment"]);
$query->execute();

// Emp account
$query = $handler->prepare("
INSERT INTO `emp_account`(
	`emp_id`,
	`is_superadmin`,
	 `is_pisadmin`,
	 `is_amsadmin`,
	  `is_psadmin`)
VALUES(:emp_id,
	:is_superadmin, 
	:is_pisadmin,
	:is_amsadmin, 
	:is_psadmin) ");
$query->bindValue("
	:emp_id", $badge_no);
$query->bindValue("
	:is_superadmin", 0);
$query->bindValue("
	:is_pisadmin", 0);
$query->bindValue("
	:is_amsadmin", 0);
$query->bindValue("
	:is_psadmin", 0);
$query->execute();

// Leave credits
$query = $handler->prepare("
INSERT INTO `leave_credits`(
	`total_lc`, `emp_no`, 
	`last_added`)
VALUES(1.25, :badge_no, :date) ");
$query->bindValue('
	:badge_no', $badge_no);
$query->bindValue('
	:date', date('Y-m-d'));
$query->execute();

// Emp Card
$query = $handler->prepare("
INSERT INTO `emp_card`(`CS_id`,
 `badge_no`)
VALUES(:badge_no, :badge_no) ");
$query->bindValue(':
	badge_no', $badge_no);
$query->execute();

/* Basic Salary
$query = $handler->prepare("
INSERT INTO `pay_payroll`(`
employee_no_id`, )
");*/

// Emp Address

$query = $handler->prepare("
INSERT INTO `emp_address`(`
	add_street`, 
	`add_brgy`,
	 `add_muni`,
	 `add_province`,
	  `zip_code`, `tel_no`, 
	  `badge_no`,
	  `address_type`)
VALUES(NULL, NULL, NULL, NULL,
 NULL, NULL, :badge_no, 
 'residential') ");
$query->bindValue('
	:badge_no', $badge_no);
$query->execute();

$query = $handler->prepare("
INSERT INTO `emp_address`(
	`add_street`, `add_brgy`,
	 `add_muni`,
	 `add_province`,
	  `zip_code`, `tel_no`, 
	  `badge_no`,
	  `address_type`)
VALUES(NULL, NULL, NULL, NULL,
 NULL, NULL, :badge_no,
 'residential') ");
$query->bindValue('
	:badge_no', $badge_no);
$query->execute();

// Leave Credits
$query = $handler->prepare("
INSERT INTO `leave_credits`(`
	total_lc`, `emp_no`, 
	`last_added`)
VALUES(1.25, :badge_no, 
	:date) ");
$query->bindValue('
	:badge_no', $badge_no);
$query->bindValue('
	:date', date('Y-m-d'));

// Change History
$query = $handler->prepare("
INSERT INTO `change_history`(
	`date`, `badge_no`, 
	`position_id`, 
	`admin_badge_no`)
VALUES(:date, :badge_no, 
	:position_id, 
	:admin_badge_no) ");
$query->bindValue('
	:date', date('Y-m-d'));
$query->bindValue('
	:badge_no', $badge_no);
$query->bindValue('
	:position_id', $_POST['
		position']);
$query->bindValue('
	:admin_badge_no', $_SESSION['
		user_session']);
$query->execute();

$handler->commit();

// If successful, reload page
header("Location: ". $directory
	. "admin/pisadmin/
	manage_personnel_info.php
	#employees_box");
} catch (Exception $e) {
echo json_encode($e);
$handler->rollBack();
}
}
