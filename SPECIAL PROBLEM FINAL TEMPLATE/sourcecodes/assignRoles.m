//Assigns_Roles.php
<?php
require $_SERVER[
	'DOCUMENT_ROOT']
.'/new/requirements.php';

if( !isset($_POST) ) {
header("Location: " .
	$directory .
	"index.php");
}

try {
$handler->beginTransaction();
$badge_no = '';
$pisadmin = 0;
$amsadmin = 0;
$psadmin = 0;

$badge_no = $_POST['badge_no']
 ? $_POST['badge_no'] : '';
$pisadmin = isset($_POST[
	'roles']) ? in_array(
    'pisadmin', $_POST[
 	'roles']) ? 1 : 0 : 0;
$amsadmin = isset($_POST[
	'roles']) ? in_array(
    'amsadmin', $_POST[
 	'roles']) ? 1 : 0 : 0;
$psadmin = isset($_POST[
	'roles']) ? in_array(
	'psadmin', $_POST[
 	'roles']) ? 1 : 0 : 0;

$query = $handler->prepare("
UPDATE `emp_account`
SET `is_pisadmin` = :pisadmin,
 `is_amsadmin` = :amsadmin,
  `is_psadmin` = :psadmin
WHERE `emp_id` = :badge_no ");
$query->bindValue(
  ':pisadmin', $pisadmin);
$query->bindValue(
  ':amsadmin', $amsadmin);
$query->bindValue(
  ':psadmin', $psadmin);
$query->bindValue(
  ':badge_no', $badge_no);
$query->execute();

$handler->commit();

//echo json_encode(array(
//$pisadmin, $amsadmin,
//$psadmin));
echo json_encode(array(
"success" => true
));
} catch (Exception $e) {
$e->rollBack();
echo json_encode($e);
}
