<?php



//���ð�װ�����������Ҫ��Ϣ
define('DBHOST','localhost');//��װ�������������ڵ�λ�� һ��Ϊlocalhost   **�ǳ���Ҫ��������д**
define('DBUSER','root');//������ϵͳ���ݿ��û��˺�   **�ǳ���Ҫ��������д**
define('DBPWD','bjjtgl');//������ϵͳ���ݿ����� **�ǳ���Ҫ,������д�����û����Ĭ��Ϊû������**
define('DBNAME','demo');//��װ������ϵͳ�������ݿ� **�ǳ���Ҫ��������д**
define('DBCHARSET','utf8');//���Ӳ������ݿ���ʹ�õı���  **�ǳ���Ҫ��������д**

define('SYSTEM_ADMINID','admin');//������ϵͳĬ�Ϲ���Ա    ��װǰ���޸Ĵ˲������˲���������Ϊ��̨����Ա�˺�   **�ǳ���Ҫ��������д**
define('SYSTEM_ADMINPWD','admin');//������ϵͳĬ�Ϲ���Ա����  ��װǰ���޸Ĵ˲��� ���˲���������Ϊ��̨����Ա����  **�ǳ���Ҫ��������д**


//��¼ע��ģ��
define('LOGIN_SUCCESS',20010);//��¼�ɹ�
define('LOGIN_UNREGISTE_FAILD',20011);//��¼ʧ�ܣ��û���id������
define('LOGIN_FAILD',20013);//��¼ʧ�ܣ��������
define('REGISTE_SUCCESS',20014);//ע��ɹ�
define('REGISTE_FAILD',20015);//���֤id�Ѿ���ע��
define('REGISTE_FAILD_SERVER_BUSY',20016);//��������æ,ע��ʧ��

define('DING_PIAO_COUNT_FALSE_TYPE',30011);//���ݳ�ͻ
define('DING_PIAO_SERVER_FAILD_TYPE',30012);//�����������û���Ʊ��Ϣʧ��
define('DING_PIAO_SUCCESS',30013);//��Ʊ�ɹ�
define('DING_PIAO_UPDATE_FAILD',30014);//��Ʊʧ��

//��ѯ����
define('QUERY_ALL_RESULT',40009);//��������Ʊ����Ϣ
define('QUERY_BY_USER_ID',40010);//�����û�ID��ѯ�û����ж�Ʊ��Ϣ
define('QUERY_BY_TICKET_ID',40011);//����ƱID��ѯʣ��Ʊ��Ϣ
define('QUERY_BY_TICKET_TYPE',40012);//����Ʊ���Ͳ�ѯʣ��Ʊ��Ϣ
define('QUERY_BY_TICKET_PRICE',40013);//����Ʊ�۲�ѯʣ��Ʊ��Ϣ
define('QUERY_BY_TICKET_POSITION',40014);//����Ʊ��λ�ò�ѯʣ��Ʊ��Ϣ
define('QUERY_BY_USER_ID_AND_TICKET_ID',40015);//�����û�ID��ƱID��ѯ�û���Ʊ��Ϣ���ݲ�֧�֣�
define('QUERY_BY_USER_ID_AND_TICKET_TYPE',40016);//�����û�ID��Ʊ���Ͳ�ѯ�û���Ʊ��Ϣ���ݲ�֧�֣�
define('QUERY_BY_USER_ID_AND_TICKET_PRICE',40017);//�����û�ID��Ʊ�۸��ѯ�û���Ʊ��Ϣ���ݲ�֧�֣�
define('QUERY_BY_USER_ID_AND_TICKET_POSITION',40018);//�����û�ID��Ʊλ������ѯ�û���Ʊ��Ϣ���ݲ�֧�֣�
define('QUERY_BY_TICKET_TYPE_AND_TICKET_PRICE',40019);//����Ʊ���ͺ�Ʊ������ѯʣ��Ʊ��Ϣ���ݲ�֧�֣�
define('QUERY_BY_TICKET_TYPE_AND_TICKET_POSITION',40020);//����Ʊ���ͺ�Ʊλ������ѯʣ��Ʊ��Ϣ���ݲ�֧�֣�
define('QUERY_BY_TICKET_PRICE_AND_TICKET_POSITION',40021);//����ƱƱ�ۺ�Ʊλ������ѯʣ����Ϣ���ݲ�֧�֣�
define('QUERY_BY_TICKET_TYPE_AND_TICKET_PRICE_AND_TICKET_POSITION',40022);//���գ�Ʊ���ͣ�Ʊ�ۣ�Ʊλ������ѯʣ��Ʊ��Ϣ���ݲ�֧�֣�
define('QUERY_RESULT_IS_NULL',40024);//��ѯ���Ϊ��
define('QUERY_FAILD',40023);//��ѯʧ��
define('QUERY_USERINFO_BY_USER_ID',40033);//ʹ���û�ID��ѯ�û���Ϣ
define('QUERY_USERINFO_BY_USER_NAME',40034);//ʹ���û�����ѯ�û���Ϣ
define('QUERY_USERINFO_BY_USER_TYPE',40035);//ʹ���û����Ͳ�ѯ�û���Ϣ
define('QUERY_ALL_USERINFO',40036);//���������û���Ϣ
define('QUERY_NOTI_BY_NOTI_TYPE',56666);//����֪ͨ��������ѯ֪ͨ

define('QUERY_SERVER_NOTI_UPDATE_TIME',50003);//��ѯ������֪ͨ������ʱ��
define('SEVER_UPDATE_IS_EQUAL',50004);//�ͻ��˷���������ʱ��һ��
define('SEVER_UPDATE_IS_NEW',50005);//�ͻ�����Ҫ����
define('QUERY_NEW_NOTI_TYPE',50001);//��ѯ���¸��¹���֪ͨ
define('QUERY_NEW_NOTI_FAILD',50002);//��ѯ����֪ͨʧ��

//�˶�����
define('TUI_DING_SUCCESS',50010);//�˶��ɹ�
define('TUI_DING_SERVER_BUSY_FAILD',50011);//��������æ���˶�ʧ��
define('TUI_DING_FAILD',50012);//�˶�ʧ��

//����Ա¼����Ϣ
define('ADMIN_INPUT_SUCCESS',60010);//¼��ɹ�
define('ADMIN_INPUT_FAILD',60011);//¼��ʧ��

define('DELETE_BY_USER_ID',77700);//���û�IDɾ���û�
define('DELETE_BY_USER_NAME',77701);//���û���ɾ���û�
define('DELETE_BY_TICKET_ID',77702);//��ƱIDɾ��Ʊ��Ϣ
define('DELETE_BY_NOTI_ID',77703);//��֪ͨIDɾ��

define('UPDATE_WITH_USER_ID',88806);//ʹ���û�ID������
define('UPDATE_WITH_USER_NAME',88807);//ʹ���û���������
define('UPDATE_WITH_TICKET_ID',88808);//ʹ��ƱID������
define('UPDATE_USER_NAME',88800);//�����û���
define('UPDATE_TICKET_ID',88801);//����ƱID
define('UPDATE_TICKET_TYPE',88802);//����Ʊ����
define('UPDATE_TICKET_PRICE',88803);//����Ʊ�۸�
define('UPDATE_TICKET_POSITION',88804);//����Ʊλ��
define('UPDATE_TICKET_COUNT',88805);//����Ʊ����

define('NOTI_TYPE_NOTI',666000);//֪ͨ
define('NOTI_TYPE_MEETING',666003);//����
define('NOTI_TYPE_GONGGAO',666001);//����
define('NOTI_TYPE_GONGXI',666002);//��ϲ
define('NOTI_TYPE_JINJI',666005);//����
define('NOTI_TYPE_JINGGAO',666004);//����
define('NOTI_TYPE_QITA',666006);//����

//��֤��ΪZYProSoft�Ŷӳ�Ա
define('CHECK_BECOME_ZYPROSOFTER',88888);//��֤��ΪZYProSoft�Ŷӳ�Ա
define('CHECK_CODE_IS_FAULT',99997);//��֤�����
define('UPDATE_USERINFO_FAILD',99998);//�����û���Ϣʧ��
define('ZYPROSOFTER_CHECK_SUCCESS',99999);//��֤�ɹ�

//��������������
define('SERVER_UPDATE_INFO_FAILD',77771);//��ȡ����������ʱ���ʧ��


//��װ��Ϣ����
define('INSTALL_FAILD_CREATETABLE_USER',555885);//����user��ʧ��
define('INSTALL_FAILD_CREATETABLE_TICKET',555886);//����ticket��ʧ��
define('INSTALL_FAILD_CREATETABLE_OPERATION',555887);//����operation��ʧ��
define('INSTALL_FAILD_CREATETABLE_ADMIN',555888);//����admin��ʧ��
define('INSTALL_FAILD_CREATETABLE_ABOUT',555889);//����About��ʧ��
define('INSTALL_TICKET_SYSTEM_SERVER_SUCCESS',555890);//��װϵͳ�ɹ�

?>