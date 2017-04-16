###########################
連接您的資料庫
###########################

有兩種成員函數連接資料庫：

自動連接
========================

「自動連接」 特性將在每一個頁面載入時自動執行緒化資料庫類。要啟用「自動連接」，
可在 ``application/config/autoload.php`` 中的 library 陣列裡加入 database::

$autoload['libraries'] = array('database');

手動連接
===================

如果您只有一部分頁面需要資料庫連接，您可以在那些有需要的函數里手工加入
如下程式碼來連接資料庫，或者寫在類的構造函數里，讓整個類都可以存取：

::

	$this->load->database();

如果 ``database()`` 函數沒有指定第一個參數，它將使用資料庫設定文件中
指定的組連接資料庫。對大多數人而言，這是首選方案。

可用的參數
--------------------

#. 資料庫連接值，用陣列或DSN字串傳遞；
#. TRUE/FALSE (boolean) - 是否傳回連接ID（參考下文的「連接多資料庫」）；
#. TRUE/FALSE (boolean) - 是否啟用查詢產生器類，預設為 TRUE 。

手動連接到資料庫
---------------------------------

這個函數的第一個參數是**可選的**，被用來從您的設定文件中
指定一個特定的資料庫組，甚至可以使用沒有在設定文件中定義的
資料庫連接值。下面是範例：

從您的設定文件中選擇一個特定分組::

	$this->load->database('group_name');

其中 ``group_name`` 是您的設定文件中連接組的名稱字。

連接一個完全手動指定的資料庫，可以傳一個陣列參數::

	$config['hostname'] = 'localhost';
	$config['username'] = 'myusername';
	$config['password'] = 'mypassword';
	$config['database'] = 'mydatabase';
	$config['dbdriver'] = 'mysqli';
	$config['dbprefix'] = '';
	$config['pconnect'] = FALSE;
	$config['db_debug'] = TRUE;
	$config['cache_on'] = FALSE;
	$config['cachedir'] = '';
	$config['char_set'] = 'utf8';
	$config['dbcollat'] = 'utf8_general_ci';
	$this->load->database($config);

這些值的詳細資訊請參考 :doc: `資料庫設定 <configuration>` 頁面。

.. note:: 對於 PDO 驅動，您應該使用 ``$config['dsn']`` 取代 'hostname' 和 'database' 參數：

	|
	| $config['dsn'] = 'mysql:host=localhost;dbname=mydatabase';

或者您可以使用資料源名稱（DSN，Data Source Name）作為參數，DSN 的格式必須類似於下面這樣::

	$dsn = 'dbdriver://username:password@hostname/database';  
	$this->load->database($dsn);

當用 DSN 字串連接時，要覆蓋預設設定，可以像加入查詢字串一樣加入設定變數。

::

	$dsn = 'dbdriver://username:password@hostname/database?char_set=utf8&dbcollat=utf8_general_ci&cache_on=true&cachedir=/path/to/cache';  
	$this->load->database($dsn);

連接到多個資料庫
================================

如果您需要同時連接到多個不同的資料庫，可以這樣::

	$DB1 = $this->load->database('group_one', TRUE); 
	$DB2 = $this->load->database('group_two', TRUE);

注意：將 "group_one" 和 "group_two" 修改為您要連接的組名稱
（或者像上面介紹的那樣傳入連接值陣列）

第二個參數 TRUE 表示函數將傳回資料庫物件。

.. note:: 當您使用這種方式連接資料庫時，您將通過您的物件名稱來執行資料庫命令，
	而不再是通過這份指南中通篇介紹的，就像下面這樣的語法了：
	
	|
	| $this->db->query();
	| $this->db->result();
	| etc...
	|
	| 取而代之的，您將這樣執行資料庫命令：
	|
	| $DB1->query();
	| $DB1->result();
	| etc...

.. note:: 如果您只是需要切換到同一個連接的另一個不同的資料庫，您沒必要建立
	獨立的資料庫設定，您可以像下面這樣切換到另一個資料庫：

	| $this->db->db_select($database2_name);

重新連接 / 保持連接有效
===========================================

當您在處理一些重量級的 PHP 操作時（例如處理圖片），如果超過了資料庫的超時值，
您應該考慮在執行後續查詢之前先呼叫 ``reconnect()`` 成員函數向資料庫發送 ping 命令，
這樣可以優雅的保持連接有效或者重新建立起連接。

::

	$this->db->reconnect();

手動關閉連接
===============================

雖然 CodeIgniter 可以智能的管理並自動關閉資料庫連接，您仍可以用下面的成員函數顯式的關閉連接：

::

	$this->db->close();