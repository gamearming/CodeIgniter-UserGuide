#################
資料庫元資料
#################

**************
表元資料
**************

下面這些成員函數用於讀取表資訊：

列出資料庫的所有表
================================

**$this->db->list_tables();**

該成員函數傳回一個包含您目前連接的資料庫的所有表名稱的陣列。例如::

	$tables = $this->db->list_tables();

	foreach ($tables as $table)
	{
		echo $table;
	}


檢測表是否存在
===========================

**$this->db->table_exists();**

有時候，在對某個表執行操作之前先判斷該表是否存在將是很有用的。
該函數傳回一個布林值：TRUE / FALSE。使用範例::

	if ($this->db->table_exists('table_name'))
	{
		// some code...
	}

.. note:: 使用您要查找的表名稱取代掉 *table_name*


**************
字段元資料
**************

列出表的所有列
==========================

**$this->db->list_fields()**

該成員函數傳回一個包含字段名稱的陣列。有兩種不同的呼叫方式：

1. 將表名稱作為參數傳入 $this->db->list_fields()::

	$fields = $this->db->list_fields('table_name');

	foreach ($fields as $field)
	{
		echo $field;
	}

2. 您可以從任何查詢結果物件上呼叫該成員函數，讀取查詢傳回的所有字段::

	$query = $this->db->query('SELECT * FROM some_table');

	foreach ($query->list_fields() as $field)
	{
		echo $field;
	}


檢測表中是否存在某字段
==========================================

**$this->db->field_exists()**

有時候，在執行一個操作之前先確定某個字段是否存在將會有很用。
該成員函數傳回一個布林值：TRUE / FALSE。使用範例::

	if ($this->db->field_exists('field_name', 'table_name'))
	{
		// some code...
	}

.. note:: 使用您要查找的字段名稱取代掉 *field_name* ，然後使用
	您要查找的表名稱取代掉 *table_name* 。


讀取字段的元資料
=======================

**$this->db->field_data()**

該成員函數傳回一個包含了字段資訊的物件陣列。

讀取字段名稱或相關的元資料，如資料類型，最大長度等等，
在有些時候也是非常有用的。

.. note:: 並不是所有的資料庫都支援元資料。

使用範例::

	$fields = $this->db->field_data('table_name');

	foreach ($fields as $field)
	{
		echo $field->name;
		echo $field->type;
		echo $field->max_length;
		echo $field->primary_key;
	}

如果您已經執行了一個查詢，您也可以在查詢結果物件上呼叫該成員函數讀取
傳回結果中的所有字段的元資料::

	$query = $this->db->query("YOUR QUERY");
	$fields = $query->field_data();

如果您的資料庫支援，該函數讀取的字段資訊將包括下面這些：

-  name - 列名稱
-  max_length - 列的最大長度
-  primary_key - 等於1的話表示此列是主鍵
-  type - 列的資料類型
