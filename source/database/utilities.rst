######################
資料庫工具類別
######################

資料庫工具類別相關的成員函數。

.. contents::
    :local:
    :depth: 2

******************************
初始化工具類
******************************
.. important:: 由於工具類相依於資料庫驅動器，在初始化工具類前，您必須先執行資料庫驅動器。

載入工具類的程式碼如下::

  $this->load->dbutil();

如果您想管理的不是正在使用的資料庫，可以傳入相關的資料庫物件到資料庫工具類別。

載入成員函數如下::

  $this->myutil = $this->load->dbutil($this->other_db, TRUE);

上例中第一個參數是自定義的資料庫物件，第二個參數表示傳回 dbutil 物件，
而不是直接賦值給 ``$this->dbutil``。

.. note:: 兩個參數都可以獨立使用，如果只想傳第二個參數，將第一個參數留空。

初始化完成，就可以使用 ``$this->dbutil`` 物件並存取它的成員函數::

  $this->dbutil->some_method();

****************************
使用資料庫工具類
****************************

讀取資料庫名稱清單
================================
傳回所有資料庫名稱的清單::

  $dbs = $this->dbutil->list_databases();
  foreach($dbs as $db) {
    echo $db;
  }

判斷資料庫是否存在
==============================
如果需要判斷某個資料庫是否存在，使用以下成員函數，傳回 TRUE/FALSE。

例如::

  if($this->dbutil->database_exists('database_name')) {
    // some code...
  }

.. note:: *database_name* = 資料庫名稱，區分大小寫。

最佳化資料表
================
依據指定的名稱來最佳化資料表，傳回 TRUE/FALSE 。

例如::

  if($this->dbutil->optimize_table('table_name')) {
    echo 'Success!';
  }

.. note:: 不是所有的資料庫平台都支援最佳化資料表，通常使用在 MySQL 資料庫上。

修復資料表
==============
依據指定的名稱來修復資料表，傳回 TRUE/FALSE 

例如::

  if($this->dbutil->repair_table('table_name')) {
    echo 'Success!';
  }

.. note:: 不是所有的資料庫平台都支援修復資料表。

最佳化資料庫
===================
允許最佳化正在使用中的資料庫，傳回陣列，包含資料庫狀態資訊，失敗時傳回 FALSE。

例如::

  $result = $this->dbutil->optimize_database();
  if($result !== FALSE) {
    print_r($result);
  }

.. note:: 不是所有的資料庫平台都支援最佳化資料庫，通常使用在 MySQL 資料庫上。

將查詢結果匯出到 CSV 文件
===================================

允許將查詢結果產生 CSV 文件，第一個參數必須是查詢的結果物件。

例如::

  $this->load->dbutil();
  $query = $this->db->query("SELECT * FROM mytable");
  echo $this->dbutil->csv_from_result($query);

第二、三、四個參數分別為分隔字元、換行字元和每個字段包圍字元，預設值為分隔字元為逗號，換行字元為 "\\n" ，
包圍字元為雙引號。

例如::

  $delimiter = ",";
  $newline = "\r\n";
  $enclosure = '"';
  echo $this->dbutil->csv_from_result($query, $delimiter, $newline, $enclosure);

.. important:: 該成員函數只傳回 CSV 內容，如果需寫入檔案中，可以使用 :doc:`文件輔助函數 <../helpers/file_helper>`。

將查詢結果匯出到 XML 文件
========================================

允許將查詢結果產生 XML 文件，第一個參數為查詢的結果物件，第二個參數可選，可以包含一些的設定參數。

例如::

  $this->load->dbutil();
  $query = $this->db->query("SELECT * FROM mytable");
  $config = array (
    'root'    => 'root',
    'element' => 'element',
    'newline' => "\n",
    'tab'   => "\t"
  );
  echo $this->dbutil->xml_from_result($query, $config);

.. important:: 該成員函數只傳回 XML 內容，如果需寫入檔案中，可以使用 :doc:`文件輔助函數 <../helpers/file_helper>`。

********************
備份您的資料庫
********************

資料備份說明
=====================

允許備份完整的資料庫或資料表。備份的資料可以壓縮成 Zip 或 Gzip 格式。

.. note:: 該功能只支援 MySQL 和 Interbase/Firebird 資料庫。

.. note:: 對於 Interbase/Firebird 資料庫，只能提供一個備份檔案名稱參數。

    $this->dbutil->backup('db_backup_filename');

.. note:: 由於 PHP 的執行時間和限制，如果資料庫非常大，建議使用命令列方式進行備份，如果沒有 root 權限，讓您的管理員來幫您備份。

使用範例
=============
例如::

  // Load the DB utility class
  $this->load->dbutil();

  // Backup your entire database and assign it to a variable
  $backup = $this->dbutil->backup();

  // Load the file helper and write the file to your server
  $this->load->helper('file');
  write_file('/path/to/mybackup.gz', $backup);

  // Load the download helper and send the file to your desktop
  $this->load->helper('download');
  force_download('mybackup.gz', $backup);

設定備份參數
==========================
備份參數為一個陣列，通過第一個參數傳遞給 ``backup()`` 成員函數。

例如::

  $prefs = array(
    'tables'  => array('table1', 'table2'), // Array of tables to backup.
    'ignore'  => array(),                   // List of tables to omit from the backup
    'format'  => 'txt',                     // gzip, zip, txt
    'filename'  => 'mybackup.sql',          // File name - NEEDED ONLY WITH ZIP FILES
    'add_drop'  => TRUE,                    // Whether to add DROP TABLE statements to backup file
    'add_insert'  => TRUE,                  // Whether to add INSERT data to backup file
    'newline' => "\n"                       // Newline character used in backup file     
  );
  $this->dbutil->backup($prefs);

備份參數說明
=================================

======================= ======================= ======================= ========================================================================
參數                      預設值           選項                 描述
======================= ======================= ======================= ========================================================================
**tables**               empty array             None                    要備份的資料表，如果留空將備份所有的資料表。
**ignore**               empty array             None                    要忽略備份的資料表。
**format**               gzip                    gzip, zip, txt          匯出文件的格式。
**filename**             the current date/time   None                    備份檔案名稱。如果使用 zip 壓縮這個參數是必填。
**add_drop**             TRUE                    TRUE/FALSE              是否在匯出的 SQL 文件裡加入 DROP TABLE 語句。
**add_insert**           TRUE                    TRUE/FALSE              是否在匯出的 SQL 文件裡加入 INSERT 語句。
**newline**              "\\n"                   "\\n", "\\r", "\\r\\n"  匯出的 SQL 文件要使用的換行字元。
**foreign_key_checks**   TRUE                    TRUE/FALSE              匯出的 SQL 文件中是否繼續保持外鍵約束。
======================= ======================= ======================= ========================================================================

***************
類別參考
***************

.. php:class:: CI_DB_utility

  .. php:method:: backup([$params = array()])

    :param  array $params: An associative array of options
    :returns: raw/(g)zipped SQL query string
    :rtype: string

    依據用戶參數執行資料庫備份。

  .. php:method:: database_exists($database_name)

    :param  string  $database_name: Database name
    :returns: TRUE if the database exists, FALSE otherwise
    :rtype: bool

    判斷資料庫是否存在。

  .. php:method:: list_databases()

    :returns: Array of database names found
    :rtype: array

    讀取資料庫所有的名稱清單。

  .. php:method:: optimize_database()

    :returns: Array of optimization messages or FALSE on failure
    :rtype: array

    最佳化資料庫。

  .. php:method:: optimize_table($table_name)

    :param  string  $table_name:  Name of the table to optimize
    :returns: Array of optimization messages or FALSE on failure
    :rtype: array

    最佳化資料表。

  .. php:method:: repair_table($table_name)

    :param  string  $table_name:  Name of the table to repair
    :returns: Array of repair messages or FALSE on failure
    :rtype: array

    修復資料表。

  .. php:method:: csv_from_result($query[, $delim = ','[, $newline = "\n"[, $enclosure = '"']]])

    :param  object  $query: A database result object
    :param  string  $delim: The CSV field delimiter to use
    :param  string  $newline: The newline character to use
    :param  string  $enclosure: The enclosure delimiter to use
    :returns: The generated CSV file as a string
    :rtype: string

    將資料庫結果物件轉換為 CSV 文件。

  .. php:method:: xml_from_result($query[, $params = array()])

    :param  object  $query: A database result object
    :param  array $params: An associative array of preferences
    :returns: The generated XML document as a string
    :rtype: string

    將資料庫結果物件轉換為 XML 文件。
