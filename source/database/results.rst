########################
產生查詢結果
########################

有幾種不同成員函數可以產生查詢結果：

.. contents::
    :local:
    :depth: 2

*************
結果陣列
*************

**result()** 成員函數

該成員函數以**物件陣列**形式傳回查詢結果，如果查詢失敗傳回**空陣列**。
一般情況下，您會像下面這樣在一個 foreach 循環中使用它::

	$query = $this->db->query("YOUR QUERY");
	
	foreach ($query->result() as $row)
	{
		echo $row->title;
		echo $row->name;
		echo $row->body;
	}

該成員函數是 ``result_object()`` 成員函數的別名。

您還可以傳一個字串參數給 ``result()`` 成員函數，這個字串參數代表您想要把每個結果轉換成某個類的類名稱（這個類必須已經載入）

::

	$query = $this->db->query("SELECT * FROM users;");

	foreach ($query->result('User') as $user)
	{
		echo $user->name; // access attributes
		echo $user->reverse_name(); // or methods defined on the 'User' class
	}

**result_array()** 成員函數

這個成員函數以 **一個純粹的陣列** 形式傳回查詢結果，如果無結果，則傳回一個空陣列。一般情況下，您會像下面這樣在一個 foreach 循環中使用它::

	$query = $this->db->query("YOUR QUERY");
	
	foreach ($query->result_array() as $row)
	{
		echo $row['title'];
		echo $row['name'];
		echo $row['body'];
	}

***********
結果行
***********

**row()** 成員函數

這個成員函數傳回唯一一行結果。如果您的查詢不止一行結果，它只傳回第一行。傳回的結果是 **物件** 形式，這裡是用例::

	$query = $this->db->query("YOUR QUERY");

	$row = $query->row();

	if (isset($row))
	{
		echo $row->title;
		echo $row->name;
		echo $row->body;
	}

如果您要傳回特定行的資料，您可以將行號作為第一個參數傳給這個成員函數::

	$row = $query->row(5);

您還可以加上第二個參數，該參數為字串類型，代表您想要把結果轉換成某個類的類名稱::

	$query = $this->db->query("SELECT * FROM users LIMIT 1;");
	$row = $query->row(0, 'User');
	
	echo $row->name; // access attributes
	echo $row->reverse_name(); // or methods defined on the 'User' class

**row_array()** 成員函數

這個成員函數除了傳回結果是一個陣列而不是一個物件之外，其他的和上面的 ``row()`` 成員函數完全一樣。舉例::

	$query = $this->db->query("YOUR QUERY");

	$row = $query->row_array();

	if (isset($row))
	{
		echo $row['title'];
		echo $row['name'];
		echo $row['body'];
	}

如果您要傳回特定行的資料，您可以將行號作為第一個參數傳給這個成員函數::

	$row = $query->row_array(5);

另外，您可以使用下面這些成員函數從您的結果集中讀取前一個、後一個、
第一個或者最後一個結果：

	| **$row = $query->first_row()**
	| **$row = $query->last_row()**
	| **$row = $query->next_row()**
	| **$row = $query->previous_row()**

這些成員函數預設傳回物件，如果需要傳回陣列形式，將單詞 "array" 作為參數傳入成員函數即可：

	| **$row = $query->first_row('array')**
	| **$row = $query->last_row('array')**
	| **$row = $query->next_row('array')**
	| **$row = $query->previous_row('array')**

.. note:: 上面所有的這些成員函數都會把所有的結果載入到記憶體裡（預讀取），
	當處理大結果集時最好使用 ``unbuffered_row()`` 成員函數。

**unbuffered_row()** 成員函數

這個成員函數和 ``row()`` 成員函數一樣傳回唯一一行結果，但是它不會預讀取所有的結果資料到記憶體中。
如果您的查詢結果不止一行，它將傳回目前一行，並通過內部實現的指針來移動到下一行。

::

	$query = $this->db->query("YOUR QUERY");
	
	while ($row = $query->unbuffered_row())
	{	
		echo $row->title;
		echo $row->name;
		echo $row->body;
	}

為了指定傳回值的類型，可以傳一個字串參數 'object'（預設值） 或者 'array' 給這個成員函數::

	$query->unbuffered_row();		// object
	$query->unbuffered_row('object');	// object
	$query->unbuffered_row('array');	// associative array

*********************
自定義結果物件
*********************

You can have the results returned as an instance of a custom class instead
of a ``stdClass`` or array, as the ``result()`` and ``result_array()``
methods allow. This requires that the class is already loaded into memory.
The object will have all values returned from the database set as properties.
If these have been declared and are non-public then you should provide a
``__set()`` method to allow them to be set.

Example::

	class User {

		public $id;
		public $email;
		public $username;

		protected $last_login;

		public function last_login($format)
		{
			return $this->last_login->format($format);
		}

		public function __set($name, $value)
		{
			if ($name === 'last_login')
			{
				$this->last_login = DateTime::createFromFormat('U', $value);
			}
		}

		public function __get($name)
		{
			if (isset($this->$name))
			{
				return $this->$name;
			}
		}
	}

In addition to the two methods listed below, the following methods also can
take a class name to return the results as: ``first_row()``, ``last_row()``,
``next_row()``, and ``previous_row()``.

**custom_result_object()**

Returns the entire result set as an array of instances of the class requested.
The only parameter is the name of the class to instantiate.

Example::

	$query = $this->db->query("YOUR QUERY");

	$rows = $query->custom_result_object('User');

	foreach ($rows as $row)
	{
		echo $row->id;
		echo $row->email;
		echo $row->last_login('Y-m-d');
	}

**custom_row_object()**

Returns a single row from your query results. The first parameter is the row
number of the results. The second parameter is the class name to instantiate.

Example::

	$query = $this->db->query("YOUR QUERY");

	$row = $query->custom_row_object(0, 'User');

	if (isset($row))
	{
		echo $row->email;   // access attributes
		echo $row->last_login('Y-m-d');   // access class methods
	}

You can also use the ``row()`` method in exactly the same way.

Example::

	$row = $query->custom_row_object(0, 'User');

*********************
結果輔助成員函數
*********************

**num_rows()** 成員函數

該成員函數傳回查詢結果的行數。注意：在這個範例中，``$query`` 變數為查詢結果物件::

	$query = $this->db->query('SELECT * FROM my_table');
	
	echo $query->num_rows();

.. note:: 並不是所有的資料庫驅動器都有原生的成員函數來讀取查詢結果的總行數。
	當遇到這種情況時，所有的資料會被預讀取到記憶體中，並呼叫 ``count()`` 函數
	來取得總行數。
	
**num_fields()** 成員函數

該成員函數傳回查詢結果的字段數（列數）。在您的查詢結果物件上呼叫該成員函數::

	$query = $this->db->query('SELECT * FROM my_table');
	
	echo $query->num_fields();

**free_result()** 成員函數

該成員函數釋放掉查詢結果所佔的記憶體，並刪除結果的資源標識。通常來說，
PHP 會在腳本執行結束後自動釋放記憶體。但是，如果您在某個腳本中執行大量的查詢，
您可能需要在每次查詢之後釋放掉查詢結果，以此來降低記憶體消耗。

舉例::

	$query = $this->db->query('SELECT title FROM my_table');
	
	foreach ($query->result() as $row)
	{
		echo $row->title;
	}

	$query->free_result();  // The $query result object will no longer be available

	$query2 = $this->db->query('SELECT name FROM some_table');

	$row = $query2->row();
	echo $row->name;
	$query2->free_result(); // The $query2 result object will no longer be available

**data_seek()** 成員函數

這個成員函數用來設定下一個結果行的內部指針，它只有在和 ``unbuffered_row()`` 成員函數一起使用才有效果。

它接受一個正整數參數（預設值為0）表示想要讀取的下一行，傳回值為 TRUE 或 FALSE 表示成功或失敗。

::

	$query = $this->db->query('SELECT `field_name` FROM `table_name`');
	$query->data_seek(5); // Skip the first 5 rows
	$row = $query->unbuffered_row();

.. note:: 並不是所有的資料庫驅動器都支援這一特性，呼叫這個成員函數將會傳回 FALSE，
	例如您無法在 PDO 上使用它。

***************
Class Reference
***************

.. php:class:: CI_DB_result

	.. php:method:: result([$type = 'object'])

		:param	string	$type: Type of requested results - array, object, or class name
		:returns:	Array containing the fetched rows
		:rtype:	array

		A wrapper for the ``result_array()``, ``result_object()``
		and ``custom_result_object()`` methods.

		Usage: see `結果陣列`_.

	.. php:method:: result_array()

		:returns:	Array containing the fetched rows
		:rtype:	array

		Returns the query results as an array of rows, where each
		row is itself an associative array.

		Usage: see `結果陣列`_.

	.. php:method:: result_object()

		:returns:	Array containing the fetched rows
		:rtype:	array

		Returns the query results as an array of rows, where each
		row is an object of type ``stdClass``.

		Usage: see `結果陣列`_.

	.. php:method:: custom_result_object($class_name)

		:param	string	$class_name: Class name for the resulting rows
		:returns:	Array containing the fetched rows
		:rtype:	array

		Returns the query results as an array of rows, where each
		row is an instance of the specified class.

	.. php:method:: row([$n = 0[, $type = 'object']])

		:param	int	$n: Index of the query results row to be returned
		:param	string	$type: Type of the requested result - array, object, or class name
		:returns:	The requested row or NULL if it doesn't exist
		:rtype:	mixed

		A wrapper for the ``row_array()``, ``row_object() and 
		``custom_row_object()`` methods.

		Usage: see `結果行`_.

	.. php:method:: unbuffered_row([$type = 'object'])

		:param	string	$type: Type of the requested result - array, object, or class name
		:returns:	Next row from the result set or NULL if it doesn't exist
		:rtype:	mixed

		Fetches the next result row and returns it in the
		requested form.

		Usage: see `結果行`_.

	.. php:method:: row_array([$n = 0])

		:param	int	$n: Index of the query results row to be returned
		:returns:	The requested row or NULL if it doesn't exist
		:rtype:	array

		Returns the requested result row as an associative array.

		Usage: see `結果行`_.

	.. php:method:: row_object([$n = 0])

		:param	int	$n: Index of the query results row to be returned
                :returns:	The requested row or NULL if it doesn't exist
		:rtype:	stdClass

		Returns the requested result row as an object of type
		``stdClass``.

		Usage: see `結果行`_.

	.. php:method:: custom_row_object($n, $type)

		:param	int	$n: Index of the results row to return
		:param	string	$class_name: Class name for the resulting row
		:returns:	The requested row or NULL if it doesn't exist
		:rtype:	$type

		Returns the requested result row as an instance of the
		requested class.

	.. php:method:: data_seek([$n = 0])

		:param	int	$n: Index of the results row to be returned next
		:returns:	TRUE on success, FALSE on failure
		:rtype:	bool

		Moves the internal results row pointer to the desired offset.

		Usage: see `結果輔助成員函數`_.

	.. php:method:: set_row($key[, $value = NULL])

		:param	mixed	$key: Column name or array of key/value pairs
		:param	mixed	$value: Value to assign to the column, $key is a single field name
		:rtype:	void

		Assigns a value to a particular column.

	.. php:method:: next_row([$type = 'object'])

		:param	string	$type: Type of the requested result - array, object, or class name
		:returns:	Next row of result set, or NULL if it doesn't exist
		:rtype:	mixed

		Returns the next row from the result set.

	.. php:method:: previous_row([$type = 'object'])

		:param	string	$type: Type of the requested result - array, object, or class name
		:returns:	Previous row of result set, or NULL if it doesn't exist
		:rtype:	mixed

		Returns the previous row from the result set.

	.. php:method:: first_row([$type = 'object'])

		:param	string	$type: Type of the requested result - array, object, or class name
		:returns:	First row of result set, or NULL if it doesn't exist
		:rtype:	mixed

		Returns the first row from the result set.

	.. php:method:: last_row([$type = 'object'])

		:param	string	$type: Type of the requested result - array, object, or class name
		:returns:	Last row of result set, or NULL if it doesn't exist
		:rtype:	mixed

		Returns the last row from the result set.

	.. php:method:: num_rows()

		:returns:	Number of rows in the result set
		:rtype:	int

		Returns the number of rows in the result set.

		Usage: see `結果輔助成員函數`_.

	.. php:method:: num_fields()

		:returns:	Number of fields in the result set
		:rtype:	int

		Returns the number of fields in the result set.

		Usage: see `結果輔助成員函數`_.

	.. php:method:: field_data()

		:returns:	Array containing field meta-data
		:rtype:	array

		Generates an array of ``stdClass`` objects containing
		field meta-data.

	.. php:method:: free_result()

		:rtype:	void

		Frees a result set.

		Usage: see `結果輔助成員函數`_.

	.. php:method:: list_fields()

		:returns:	Array of column names
		:rtype:	array

		Returns an array containing the field names in the
		result set.
