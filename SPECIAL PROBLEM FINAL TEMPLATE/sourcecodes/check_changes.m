//Check_changes.php
<?php 
require $_SERVER['DOCUMENT_ROOT']
."/new/requirements.php";
if( isset($_GET['id']) ) {
$query = $handler->prepare("
SELECT * FROM `dlp_checker`
WHERE `badge_no` = badge_no
AND `e_status` = 1");
$query->bindValue(
	':badge_no', $_GET['id']);
$query->execute();
$rc = $query->rowCount();
	if( $query->rowCount() ){
$query = $handler->prepare(
	"UPDATE `dlp_checker`
	SET `e_status` = 0
WHERE `badge_no` = :badge_no");
$query->bindValue(
  ':badge_no', $_GET['id']);
$query->execute();
}
echo json_encode($rc);
}
 ?>
