<?php
require 'Class_DBOperation.php';
require 'global.php';

//�������ݿ�����
$dbOperation = new class_DBOperation(DBHOST,DBUSER,DBPWD,DBNAME,DBCHARSET);

//���տͻ��˲���
$userid = $_GET['u'];
$flag = $_GET['flag'];//0 ��ע 1��˿
$order = $_GET['order'];//0 λ�þ��� 1��¼ʱ�� 2���˳��


if($flag==0){
$sql = "select a.*,b.username as fname,b.pic as friend_pic,getDistance(a.userid,a.fid) as distance ,
	b.sex,b.qianming 
	from lbs_myfriends a,lbs_member b where a.userid = '$userid' and a.fid=b.userid  ";
}else{
$sql = "select a.*,b.username as fname,b.pic as friend_pic,getDistance(a.userid,a.fid) as distance ,
	b.sex,b.qianming 
	from lbs_myfriends a,lbs_member b where a.fid = '$userid' and a.fid=b.userid  ";

}
if($order==0){
	$sql = $sql ." order by distance "; 
}else if($order==1){
  $sql = $sql ." order by b.update_time ";
}else if($order==2){
  $sql = $sql ." order by a.id ";
}
$resultArr = $dbOperation->fetch_obj_arr($sql);
if (!$resultArr){
	$resultString = json_encode(QUERY_FAILD);
	echo $resultString;
	return ;
}
if (count($resultArr)==0){
	$resultString = json_encode(QUERY_RESULT_IS_NULL);
	echo $resultString;
	return ;
}else{
	$resultJson = json_encode($resultArr);
	echo $resultJson;
}


?>