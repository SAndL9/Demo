<?php

/*
 �ļ�����Class_DBOperation.php
 ���ã����ݿ����������
  ���ߣ�����
 ���ڣ�2012-2-8
*/

/*
 * ��װ˵�����������������޸Ĵ��ļ������򽫵��·����������޷�ִ��
 */

class class_DBOperation{	
	private $host;
	private $user_name;
	private $user_pwd;
	private $dest_db;
	private $charset;

	//�����������ݿ����
	function class_DBOperation($host,$user,$pwd,$db,$charset){
	
		//��ȡ����
		$this->host = $host;
		$this->user_name = $user;
		$this->user_pwd = $pwd;
		$this->dest_db = $db;
		$this->charset = $charset;
			
		//����Ƿ������������ݿ���������
		if (!mysql_connect($this->host,$this->user_name,$this->user_pwd)){
			echo '�޷�����������';
			exit();
		}
	
		//�������ݿ�����
		$conn = mysql_connect($this->host,$this->user_name,$this->user_pwd) or die('������Ϣ'.mysql_error());
	
		//ѡ�����ݿ�
		mysql_select_db($this->dest_db,$conn)or die('������Ϣ'.mysql_error());
	
		//�����ַ���
		mysql_query("set names utf8") or die('������Ϣ'.mysql_error());
	}
	function __call($function_name, $args)
	{
		echo "<br><font color=#ff0000>�������õķ��� $function_name ������</font><br>\n";
	}
	//ִ��sql��䷽��
	function  query($sql){
		$result = mysql_query($sql)or die('������Ϣ'.mysql_error());
		return $result;
	} 
	function  fetch_array($sql){
		$result = mysql_query($sql) or die('������Ϣ'.mysql_error());
		$result_arry = mysql_fetch_array($result);
		return $result_arry;
	}
	function fetch_obj_arr($sql)
	{
		$obj_arr=array();
		$res=$this->query($sql);
		while($row=mysql_fetch_object($res))
		{
			$obj_arr[]=$row;
		}
		return $obj_arr;
	}
	function fetch_obj($result){
		return mysql_fetch_object($result);
	}
}
?>