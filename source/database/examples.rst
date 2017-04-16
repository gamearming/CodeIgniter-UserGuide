##################################
資料庫快速入門: 範例程式碼
##################################

這個頁面包含的範例程式碼將簡單介紹如何使用資料庫類。更詳細的資訊請參考每個函數唯一的介紹頁面。

初始化資料庫類
===============================

下面的程式碼將依據您的 :doc:`資料庫設定 <configuration>` 載入並初始化資料庫類::

	$this->load->database();

資料庫類一旦載入，您就可以像下面介紹的那樣使用它。

注意：如果您所有的頁面都需要連接資料庫，您可以讓其自動載入。參見 :doc:`資料庫連接 <connecting>`。

多結果標準查詢（物件形式）
=====================================================

::

	$query = $this->db->query('SELECT name, title, email FROM my_table');
	
	foreach ($query->result() as $row)
	{
		echo $row->title;
		echo $row->name;
		echo $row->email;
	}
	
	echo 'Total Results: ' . $query->num_rows();

上面的 ``result()`` 函數傳回一個**物件陣列**。例如：``$row->title``

多結果標準查詢（陣列形式）
====================================================

::

	$query = $this->db->query('SELECT name, title, email FROM my_table');
	
	foreach ($query->result_array() as $row)
	{
		echo $row['title'];
		echo $row['name'];
		echo $row['email'];
	}

上面的 ``result_array()`` 函數傳回一個**陣列的陣列**。例如：``$row['title']``

單結果標準查詢（物件形式）
=================================

::

	$query = $this->db->query('SELECT name FROM my_table LIMIT 1'); 
	$row = $query->row();
	echo $row->name;

上面的 ``row()`` 函數傳回一個**物件**。例如：``$row->name``

單結果標準查詢（陣列形式）
=================================================

::

	$query = $this->db->query('SELECT name FROM my_table LIMIT 1');
	$row = $query->row_array();
	echo $row['name'];

上面的 ``row_array()`` 函數傳回一個**陣列**。例如：``$row['name']``

標準插入
===============

::

	$sql = "INSERT INTO mytable (title, name) VALUES (".$this->db->escape($title).", ".$this->db->escape($name).")";
	$this->db->query($sql);
	echo $this->db->affected_rows();

使用查詢產生器查詢資料
===========================

:doc:`查詢產生器模式 <query_builder>` 提供給我們一種簡單的查詢資料的途徑::

	$query = $this->db->get('table_name');
	
	foreach ($query->result() as $row)
	{
		echo $row->title;
	}

上面的 ``get()`` 函數從給定的表中查詢出所有的結果。:doc:`查詢產生器 <query_builder>` 提供了所有資料庫操作的快捷函數。

使用查詢產生器插入資料
===========================

::

	$data = array(
		'title' => $title,
		'name' => $name,
		'date' => $date
	);
	
	//
	// 產生這樣的SQL程式碼: 
	//   INSERT INTO mytable (title, name, date) VALUES ('{$title}', '{$name}', '{$date}')
	//
	$this->db->insert('mytable', $data);

