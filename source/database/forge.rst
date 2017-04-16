####################
資料庫工廠類
####################

資料庫工廠類提供了一些成員函數來幫助您管理您的資料庫。

.. contents:: Table of Contents
    :depth: 3

****************************
初始化資料庫工廠類
****************************

.. important:: 由於資料庫工廠類相依於資料庫驅動器，為了初始化該類，您的資料庫驅動器必須已經執行。

載入資料庫工廠類的程式碼如下::

	$this->load->dbforge()

如果您想管理的不是您正在使用的資料庫，您還可以傳另一個資料庫物件到資料庫工具類的載入成員函數::

	$this->myforge = $this->load->dbforge($this->other_db, TRUE);

上例中，我們通過第一個參數傳遞了一個自定義的資料庫物件，第二個參數表示成員函數將傳回 dbforge 物件，
而不是直接賦值給 ``$this->dbforge`` 。

.. note:: 兩個參數都可以獨立使用，如果您只想傳第二個參數，可以將第一個參數置空。

一旦初始化結束，您就可以使用 ``$this->dbforge`` 物件來存取它的成員函數::

	$this->dbforge->some_method();

*******************************
建立和刪除資料庫
*******************************

**$this->dbforge->create_database('db_name')**

用於建立指定資料庫，依據成敗傳回 TRUE 或 FALSE ::

	if ($this->dbforge->create_database('my_db'))
	{
		echo 'Database created!';
	}

**$this->dbforge->drop_database('db_name')**

用於刪除指定資料庫，依據成敗傳回 TRUE 或 FALSE ::

	if ($this->dbforge->drop_database('my_db'))
	{
		echo 'Database deleted!';
	}


****************************
建立和刪除資料表
****************************

建立表涉及到這樣幾件事：加入字段、加入鍵、修改字段。CodeIgniter 提供了這幾個成員函數。

加入字段
=============

字段通過一個關聯陣列來建立，陣列中必須包含一個 'type' 索引，代表字段的資料類型。
例如，INT、VARCHAR、TEXT 等，有些資料類型（例如 VARCHAR）還需要加一個 'constraint' 索引。

::

	$fields = array(
		'users' => array(
			'type' => 'VARCHAR',
			'constraint' => '100',
		),
	);
	// will translate to "users VARCHAR(100)" when the field is added.


另外，還可以使用下面的鍵值對：

-  unsigned/true : 在字段定義中產生 "UNSIGNED"
-  default/value : 在字段定義中產生一個預設值
-  null/true : 在字段定義中產生 "NULL" ，如果沒有這個，字段預設為 "NOT NULL"
-  auto_increment/true : 在字段定義中產生自增標識，注意資料類型必須支援這個，例如整型
-  unique/true : to generate a unique key for the field definition.

::

	$fields = array(
		'blog_id' => array(
			'type' => 'INT',
			'constraint' => 5,
			'unsigned' => TRUE,
			'auto_increment' => TRUE
		),
		'blog_title' => array(
			'type' => 'VARCHAR',
			'constraint' => '100',
      'unique' => TRUE,
		),
		'blog_author' => array(
			'type' =>'VARCHAR',
			'constraint' => '100',
			'default' => 'King of Town',
		),
		'blog_description' => array(
			'type' => 'TEXT',
			'null' => TRUE,
		),
	);


字段定義好了之後，就可以在呼叫 ``create_table()`` 成員函數的後面使用
``$this->dbforge->add_field($fields);`` 成員函數來加入字段了。

**$this->dbforge->add_field()**

加入字段成員函數的參數就是上面介紹的陣列。


使用字串參數加入字段
---------------------------------

如果您非常清楚的知道您要加入的字段，您可以使用字段的定義字串來傳給 add_field() 成員函數

::

	$this->dbforge->add_field("label varchar(100) NOT NULL DEFAULT 'default label'");

.. note:: Passing raw strings as fields cannot be followed by ``add_key()`` calls on those fields.

.. note:: 多次呼叫 add_field() 將會累積。

建立 id 字段
--------------------

建立 id 字段和建立其他字段非常不一樣，id 字段將會自動定義成類型為 INT(9) 的自增主鍵。

::

	$this->dbforge->add_field('id');
	// gives id INT(9) NOT NULL AUTO_INCREMENT


加入鍵
===========

通常來說，表都會有鍵。這可以使用 $this->dbforge->add_key('field') 成員函數來實現。
第二個參數可選，可以將其設定為主鍵。注意 add_key() 成員函數必須緊跟在 create_table() 成員函數的後面。

包含多列的非主鍵必須使用陣列來加入，下面是 MySQL 的範例。

::

	$this->dbforge->add_key('blog_id', TRUE);
	// gives PRIMARY KEY `blog_id` (`blog_id`)

	$this->dbforge->add_key('blog_id', TRUE);
	$this->dbforge->add_key('site_id', TRUE);
	// gives PRIMARY KEY `blog_id_site_id` (`blog_id`, `site_id`)

	$this->dbforge->add_key('blog_name');
	// gives KEY `blog_name` (`blog_name`)

	$this->dbforge->add_key(array('blog_name', 'blog_label'));
	// gives KEY `blog_name_blog_label` (`blog_name`, `blog_label`)


建立表
================

字段和鍵都定義好了之後，您可以使用下面的成員函數來建立表::

	$this->dbforge->create_table('table_name');
	// gives CREATE TABLE table_name

第二個參數設定為 TRUE ，可以在定義中加入 "IF NOT EXISTS" 子句。

::

	$this->dbforge->create_table('table_name', TRUE);
	// gives CREATE TABLE IF NOT EXISTS table_name

您還可以指定表的屬性，例如 MySQL 的 ``ENGINE`` ::

	$attributes = array('ENGINE' => 'InnoDB');
	$this->dbforge->create_table('table_name', FALSE, $attributes);
	// produces: CREATE TABLE `table_name` (...) ENGINE = InnoDB DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci

.. note:: 除非您指定了 ``CHARACTER SET`` 或 ``COLLATE`` 屬性，``create_table()`` 成員函數
	預設會使用設定文件中 *char_set* 和 *dbcollat* 的值（僅針對 MySQL）。

刪除表
================

執行一個 DROP TABLE 語句，可以選擇加入 IF EXISTS 子句。

::

	// Produces: DROP TABLE table_name
	$this->dbforge->drop_table('table_name');

	// Produces: DROP TABLE IF EXISTS table_name
	$this->dbforge->drop_table('table_name',TRUE);


重新命名表
================

執行一個重新命名表語句。

::

	$this->dbforge->rename_table('old_table_name', 'new_table_name');
	// gives ALTER TABLE old_table_name RENAME TO new_table_name


****************
修改表
****************

給表加入列
==========================

**$this->dbforge->add_column()**

``add_column()`` 成員函數用於對現有資料表進行修改，它的參數和上面介紹的
字段陣列一樣。

::

	$fields = array(
		'preferences' => array('type' => 'TEXT')
	);
	$this->dbforge->add_column('table_name', $fields);
	// Executes: ALTER TABLE table_name ADD preferences TEXT

如果您使用 MySQL 或 CUBIRD ，您可以使用 AFTER 和 FIRST 語句來為新加入的列指定位置。

例如::

	// Will place the new column after the `another_field` column:
	$fields = array(
		'preferences' => array('type' => 'TEXT', 'after' => 'another_field')
	);

	// Will place the new column at the start of the table definition:
	$fields = array(
		'preferences' => array('type' => 'TEXT', 'first' => TRUE)
	);

從表中刪除列
==============================

**$this->dbforge->drop_column()**

用於從表中刪除指定列。

::

	$this->dbforge->drop_column('table_name', 'column_to_drop');


修改表中的某個列
=============================

**$this->dbforge->modify_column()**

該成員函數的用法和 ``add_column()`` 一樣，只是它用於對現有的列進行修改，而不是加入新列。
如果要修改列的名稱，您可以在列的定義陣列中加入一個 "name" 索引。

::

	$fields = array(
		'old_name' => array(
			'name' => 'new_name',
			'type' => 'TEXT',
		),
	);
	$this->dbforge->modify_column('table_name', $fields);
	// gives ALTER TABLE table_name CHANGE old_name new_name TEXT


***************
類參考
***************

.. php:class:: CI_DB_forge

	.. php:method:: add_column($table[, $field = array()[, $_after = NULL]])

		:param	string	$table: Table name to add the column to
		:param	array	$field: Column definition(s)
		:param	string	$_after: Column for AFTER clause (deprecated)
		:returns:	TRUE on success, FALSE on failure
		:rtype:	bool

		給表加入列。用法參見 `給表加入列`_ 。

	.. php:method:: add_field($field)

		:param	array	$field: Field definition to add
		:returns:	CI_DB_forge instance (method chaining)
		:rtype:	CI_DB_forge

                	加入字段到集合，用於建立一個表。用法參見 `加入字段`_ 。

	.. php:method:: add_key($key[, $primary = FALSE])

		:param	array	$key: Name of a key field
		:param	bool	$primary: Set to TRUE if it should be a primary key or a regular one
		:returns:	CI_DB_forge instance (method chaining)
		:rtype:	CI_DB_forge

		加入鍵到集合，用於建立一個表。用法參見：`加入鍵`_ 。

	.. php:method:: create_database($db_name)

		:param	string	$db_name: Name of the database to create
		:returns:	TRUE on success, FALSE on failure
		:rtype:	bool

		建立資料庫。用法參見：`建立和刪除資料庫`_ 。

	.. php:method:: create_table($table[, $if_not_exists = FALSE[, array $attributes = array()]])

		:param	string	$table: Name of the table to create
		:param	string	$if_not_exists: Set to TRUE to add an 'IF NOT EXISTS' clause
		:param	string	$attributes: An associative array of table attributes
		:returns:  TRUE on success, FALSE on failure
		:rtype:	bool

		建立表。用法參見：`建立表`_ 。

	.. php:method:: drop_column($table, $column_name)

		:param	string	$table: Table name
		:param	array	$column_name: The column name to drop
		:returns:	TRUE on success, FALSE on failure
		:rtype:	bool

		刪除某個表的字段。用法參見：`從表中刪除列`_ 。

	.. php:method:: drop_database($db_name)

		:param	string	$db_name: Name of the database to drop
		:returns:	TRUE on success, FALSE on failure
		:rtype:	bool

		刪除資料庫。用法參見：`建立和刪除資料庫`_ 。

	.. php:method:: drop_table($table_name[, $if_exists = FALSE])

		:param	string	$table: Name of the table to drop
		:param	string	$if_exists: Set to TRUE to add an 'IF EXISTS' clause
		:returns:	TRUE on success, FALSE on failure
		:rtype:	bool

		刪除表。用法參見：`刪除表`_ 。

	.. php:method:: modify_column($table, $field)

		:param	string	$table: Table name
		:param	array	$field: Column definition(s)
		:returns:	TRUE on success, FALSE on failure
		:rtype:	bool

		修改表的某個列。用法參見：`修改表中的某個列`_ 。

	.. php:method:: rename_table($table_name, $new_table_name)

		:param	string	$table: Current of the table
		:param	string	$new_table_name: New name of the table
		:returns:	TRUE on success, FALSE on failure
		:rtype:	bool

		重新命名表。用法參見：`重新命名表`_ 。
