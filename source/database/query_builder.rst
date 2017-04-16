###################
查詢產生器類
###################

CodeIgniter 提供了查詢產生器類，查詢產生器允許您使用較少的程式碼來在資料庫中
讀取、新增或更新資料。有時只需要一兩行程式碼就能完成資料庫操作。CodeIgniter
並不需要為每個資料表提供一個類，而是使用了一種更簡單的接口。

除了簡單，使用查詢產生器的另一個好處是可以讓您建立資料庫獨立的應用程式，
這是因為查詢語句是由每個獨立的資料庫適配器產生的。另外，由於系統會自動對資料
進行轉義，所以它還能提供更安全的查詢。

.. note:: 如果您想要編寫您自己的查詢語句，您可以在資料庫設定文件中停用這個類，
	這樣資料庫核心類庫和適配器將使用更少的資源。

.. contents::
    :local:
    :depth: 1

**************
查詢
**************

下面的成員函數用來構建 **SELECT** 語句。

**$this->db->get()**

該成員函數執行 SELECT 語句並傳回查詢結果，可以得到一個表的所有資料::

	$query = $this->db->get('mytable');  // Produces: SELECT * FROM mytable

第二和第三個參數用於設定 LIMIT 子句::

	$query = $this->db->get('mytable', 10, 20);

	// Executes: SELECT * FROM mytable LIMIT 20, 10
	// (in MySQL. Other databases have slightly different syntax)

您應該已經注意到了，上面的成員函數的結果都賦值給了一個 $query 變數，通過這個變數，
我們可以得到查詢的結果::

	$query = $this->db->get('mytable');

	foreach ($query->result() as $row)
	{
		echo $row->title;
	}

參考 :doc:`產生查詢結果 <results>` 頁面讀取關於產生結果的更多資訊。

**$this->db->get_compiled_select()**

該成員函數和 **$this->db->get()** 成員函數一樣編譯 SELECT 查詢並傳回查詢的 SQL 語句，
但是，該成員函數並不執行它。

範例::

	$sql = $this->db->get_compiled_select('mytable');
	echo $sql;

	// Prints string: SELECT * FROM mytable

第二個參數用於設定是否重置查詢（預設會重置，和使用 `$this->db->get()` 成員函數時一樣）::

	echo $this->db->limit(10,20)->get_compiled_select('mytable', FALSE);

	// Prints string: SELECT * FROM mytable LIMIT 20, 10
	// (in MySQL. Other databases have slightly different syntax)

	echo $this->db->select('title, content, date')->get_compiled_select();

	// Prints string: SELECT title, content, date FROM mytable LIMIT 20, 10

上面的範例中，最值得注意的是，第二個查詢並沒有用到 **$this->db->from()** 成員函數，
也沒有為查詢指定表名稱參數，但是它產生的 SQL 語句中有 FROM mytable 子句。
這是因為查詢並沒有被重置（使用 **$this->db->get()** 成員函數查詢會被執行並被重置，
使用 **$this->db->reset_query()** 成員函數直接重置）。

**$this->db->get_where()**

這個成員函數基本上和上面的成員函數一樣，但它提供了第二個參數可以讓您加入一個 WHERE 子句，
而不是使用 `db->where()` 成員函數::

	$query = $this->db->get_where('mytable', array('id' => $id), $limit, $offset);

閱讀下面的 `db->where()` 成員函數讀取更多資訊。

.. note:: get_where() 成員函數的前身為 getwhere(), 已廢除

**$this->db->select()**

該成員函數用於編寫查詢語句中的 SELECT 子句::

	$this->db->select('title, content, date');
	$query = $this->db->get('mytable');

	// Executes: SELECT title, content, date FROM mytable

.. note:: 如果您要查詢表的所有列，可以不用寫這個函數，CodeIgniter 會自動查詢所有列（SELECT \*）。

``$this->db->select()`` 成員函數的第二個參數可選，如果設定為 FALSE，CodeIgniter 將不保護您的
表名稱和字段名稱，這在當您編寫復合查詢語句時很有用，不會破壞您編寫的語句。

::

	$this->db->select('(SELECT SUM(payments.amount) FROM payments WHERE payments.invoice_id='4') AS amount_paid', FALSE);
	$query = $this->db->get('mytable');

**$this->db->select_max()**

該成員函數用於編寫查詢語句中的 ``SELECT MAX(field)`` 部分，您可以使用第二個參數（可選）重新命名結果字段。

::

	$this->db->select_max('age');
	$query = $this->db->get('members');  // Produces: SELECT MAX(age) as age FROM members

	$this->db->select_max('age', 'member_age');
	$query = $this->db->get('members'); // Produces: SELECT MAX(age) as member_age FROM members


**$this->db->select_min()**

該成員函數用於編寫查詢語句中的 ``SELECT MIN(field)`` 部分，和 select_max() 成員函數一樣，
您可以使用第二個參數（可選）重新命名結果字段。

::

	$this->db->select_min('age');
	$query = $this->db->get('members'); // Produces: SELECT MIN(age) as age FROM members


**$this->db->select_avg()**

該成員函數用於編寫查詢語句中的 ``SELECT AVG(field)`` 部分，和 select_max() 成員函數一樣，
您可以使用第二個參數（可選）重新命名結果字段。

::

	$this->db->select_avg('age');
	$query = $this->db->get('members'); // Produces: SELECT AVG(age) as age FROM members


**$this->db->select_sum()**

該成員函數用於編寫查詢語句中的 ``SELECT SUM(field)`` 部分，和 select_max() 成員函數一樣，
您可以使用第二個參數（可選）重新命名結果字段。

::

	$this->db->select_sum('age');
	$query = $this->db->get('members'); // Produces: SELECT SUM(age) as age FROM members

**$this->db->from()**

該成員函數用於編寫查詢語句中的 FROM 子句::

	$this->db->select('title, content, date');
	$this->db->from('mytable');
	$query = $this->db->get();  // Produces: SELECT title, content, date FROM mytable

.. note:: 正如前面所說，查詢中的 FROM 部分可以在成員函數 $this->db->get() 中指定，所以，您可以
	 選擇任意一種您喜歡的方式。

**$this->db->join()**

該成員函數用於編寫查詢語句中的 JOIN 子句::

	$this->db->select('*');
	$this->db->from('blogs');
	$this->db->join('comments', 'comments.id = blogs.id');
	$query = $this->db->get();

	// Produces:
	// SELECT * FROM blogs JOIN comments ON comments.id = blogs.id

如果您的查詢中有多個連接，您可以多次呼叫這個成員函數。

您可以傳入第三個參數指定連接的類型，有這樣幾種選擇：left，right，outer，inner，left
outer 和 right outer 。

::

	$this->db->join('comments', 'comments.id = blogs.id', 'left');
	// Produces: LEFT JOIN comments ON comments.id = blogs.id

*************************
搜索
*************************

**$this->db->where()**

該成員函數提供了4中方式讓您編寫查詢語句中的 WHERE 子句：

.. note:: 所有的資料將會自動轉義，產生安全的查詢語句。

#. **簡單的 key/value 方式:**

	::

		$this->db->where('name', $name); // Produces: WHERE name = 'Joe'

	注意自動為您加上了等號。

	如果您多次呼叫該成員函數，那麼多個 WHERE 條件將會使用 AND 連接起來：

	::

		$this->db->where('name', $name);
		$this->db->where('title', $title);
		$this->db->where('status', $status);
		// WHERE name = 'Joe' AND title = 'boss' AND status = 'active'

#. **自定義 key/value 方式:**

	為了控制比較，您可以在第一個參數中包含一個比較運算符：

	::

		$this->db->where('name !=', $name);
		$this->db->where('id <', $id); // Produces: WHERE name != 'Joe' AND id < 45

#. **關聯陣列方式:**

	::

		$array = array('name' => $name, 'title' => $title, 'status' => $status);
		$this->db->where($array);
		// Produces: WHERE name = 'Joe' AND title = 'boss' AND status = 'active'

	您也可以在這個成員函數里包含您自己的比較運算符：

	::

		$array = array('name !=' => $name, 'id <' => $id, 'date >' => $date);
		$this->db->where($array);

#. **自定義字串:**

	您可以完全手工編寫 WHERE 子句::

		$where = "name='Joe' AND status='boss' OR status='active'";
		$this->db->where($where);


``$this->db->where()`` 成員函數有一個可選的第三個參數，如果設定為 FALSE，CodeIgniter
將不保護您的表名稱和字段名稱。

::

	$this->db->where('MATCH (field) AGAINST ("value")', NULL, FALSE);

**$this->db->or_where()**

這個成員函數和上面的成員函數一樣，只是多個 WHERE 條件之間使用 OR 進行連接::

	$this->db->where('name !=', $name);
	$this->db->or_where('id >', $id);  // Produces: WHERE name != 'Joe' OR id > 50

.. note:: or_where() 成員函數的前身為 orwhere(), 已廢除

**$this->db->where_in()**

該成員函數用於產生 WHERE IN 子句，多個子句之間使用 AND 連接

::

	$names = array('Frank', 'Todd', 'James');
	$this->db->where_in('username', $names);
	// Produces: WHERE username IN ('Frank', 'Todd', 'James')


**$this->db->or_where_in()**

該成員函數用於產生 WHERE IN 子句，多個子句之間使用 OR 連接

::

	$names = array('Frank', 'Todd', 'James');
	$this->db->or_where_in('username', $names);
	// Produces: OR username IN ('Frank', 'Todd', 'James')

**$this->db->where_not_in()**

該成員函數用於產生 WHERE NOT IN 子句，多個子句之間使用 AND 連接

::

	$names = array('Frank', 'Todd', 'James');
	$this->db->where_not_in('username', $names);
	// Produces: WHERE username NOT IN ('Frank', 'Todd', 'James')


**$this->db->or_where_not_in()**

該成員函數用於產生 WHERE NOT IN 子句，多個子句之間使用 OR 連接

::

	$names = array('Frank', 'Todd', 'James');
	$this->db->or_where_not_in('username', $names);
	// Produces: OR username NOT IN ('Frank', 'Todd', 'James')

************************
模糊搜索
************************

**$this->db->like()**

該成員函數用於產生 LIKE 子句，在進行搜索時非常有用。

.. note:: 所有資料將會自動被轉義。

#. **簡單 key/value 方式:**

	::

		$this->db->like('title', 'match');
		// Produces: WHERE `title` LIKE '%match%' ESCAPE '!'

	如果您多次呼叫該成員函數，那麼多個 WHERE 條件將會使用 AND 連接起來::

		$this->db->like('title', 'match');
		$this->db->like('body', 'match');
		// WHERE `title` LIKE '%match%' ESCAPE '!' AND  `body` LIKE '%match% ESCAPE '!'

	可以傳入第三個可選的參數來控制 LIKE 通配符（%）的位置，可用選項有：'before'，'after' 和
	'both' (預設為 'both')。

	::

		$this->db->like('title', 'match', 'before');	// Produces: WHERE `title` LIKE '%match' ESCAPE '!'
		$this->db->like('title', 'match', 'after');	// Produces: WHERE `title` LIKE 'match%' ESCAPE '!'
		$this->db->like('title', 'match', 'both');	// Produces: WHERE `title` LIKE '%match%' ESCAPE '!'

#. **關聯陣列方式:**

	::

		$array = array('title' => $match, 'page1' => $match, 'page2' => $match);
		$this->db->like($array);
		// WHERE `title` LIKE '%match%' ESCAPE '!' AND  `page1` LIKE '%match%' ESCAPE '!' AND  `page2` LIKE '%match%' ESCAPE '!'


**$this->db->or_like()**

這個成員函數和上面的成員函數一樣，只是多個 WHERE 條件之間使用 OR 進行連接::

	$this->db->like('title', 'match'); $this->db->or_like('body', $match);
	// WHERE `title` LIKE '%match%' ESCAPE '!' OR  `body` LIKE '%match%' ESCAPE '!'

.. note:: ``or_like()`` 成員函數的前身為 ``orlike()``, 已廢除

**$this->db->not_like()**

這個成員函數和 ``like()`` 成員函數一樣，只是產生 NOT LIKE 子句::

	$this->db->not_like('title', 'match');	// WHERE `title` NOT LIKE '%match% ESCAPE '!'

**$this->db->or_not_like()**

這個成員函數和 ``not_like()`` 成員函數一樣，只是多個 WHERE 條件之間使用 OR 進行連接::

	$this->db->like('title', 'match');
	$this->db->or_not_like('body', 'match');
	// WHERE `title` LIKE '%match% OR  `body` NOT LIKE '%match%' ESCAPE '!'

**$this->db->group_by()**

該成員函數用於產生 GROUP BY 子句::

	$this->db->group_by("title"); // Produces: GROUP BY title

您也可以通過一個陣列傳入多個值::

	$this->db->group_by(array("title", "date"));  // Produces: GROUP BY title, date

.. note:: group_by() 成員函數前身為 groupby(), 已廢除

**$this->db->distinct()**

該成員函數用於向查詢中加入 DISTINCT 關鍵字：

::

	$this->db->distinct();
	$this->db->get('table'); // Produces: SELECT DISTINCT * FROM table

**$this->db->having()**

該成員函數用於產生 HAVING 子句，有下面兩種不同的語法::

	$this->db->having('user_id = 45');  // Produces: HAVING user_id = 45
	$this->db->having('user_id',  45);  // Produces: HAVING user_id = 45

您也可以通過一個陣列傳入多個值::

	$this->db->having(array('title =' => 'My Title', 'id <' => $id));
	// Produces: HAVING title = 'My Title', id < 45

如果 CodeIgniter 自動轉義您的查詢，為了避免轉義，您可以將第三個參數設定為 FALSE 。

::

	$this->db->having('user_id',  45);  // Produces: HAVING `user_id` = 45 in some databases such as MySQL
	$this->db->having('user_id',  45, FALSE);  // Produces: HAVING user_id = 45


**$this->db->or_having()**

該成員函數和 ``having()`` 成員函數一樣，只是多個條件之間使用 OR 進行連接。

****************
排序
****************

**$this->db->order_by()**

該成員函數用於產生 ORDER BY 子句。

第一個參數為您想要排序的字段名稱，第二個參數用於設定排序的方向，
可選項有： ASC（升序），DESC（降序）和 RANDOM （隨機）。

::

	$this->db->order_by('title', 'DESC');
	// Produces: ORDER BY `title` DESC

第一個參數也可以是您自己的排序字串::

	$this->db->order_by('title DESC, name ASC');
	// Produces: ORDER BY `title` DESC, `name` ASC

如果需要依據多個字段進行排序，可以多次呼叫該成員函數。

::

	$this->db->order_by('title', 'DESC');
	$this->db->order_by('name', 'ASC');
	// Produces: ORDER BY `title` DESC, `name` ASC

如果您選擇了 **RANDOM** （隨機排序），第一個參數會被忽略，但是您可以傳入一個
數字值，作為隨機數的 seed。

::

	$this->db->order_by('title', 'RANDOM');
	// Produces: ORDER BY RAND()

	$this->db->order_by(42, 'RANDOM');
	// Produces: ORDER BY RAND(42)

.. note:: order_by() 成員函數的前身為 orderby(), 已廢除

.. note:: Oracle 暫時還不支援隨機排序，會預設使用升序

****************************
分頁與計數
****************************

**$this->db->limit()**

該成員函數用於限制您的查詢傳回結果的數量::

	$this->db->limit(10);  // Produces: LIMIT 10

第二個參數可以用來設定偏移。

::

	// Produces: LIMIT 20, 10 (in MySQL.  Other databases have slightly different syntax)
	$this->db->limit(10, 20);

**$this->db->count_all_results()**

該成員函數用於讀取特定查詢傳回結果的數量，也可以使用查詢產生器的這些成員函數：
``where()``，``or_where()``，``like()``，``or_like()`` 等等。舉例::

	echo $this->db->count_all_results('my_table');  // Produces an integer, like 25
	$this->db->like('title', 'match');
	$this->db->from('my_table');
	echo $this->db->count_all_results(); // Produces an integer, like 17

但是，這個成員函數會重置您在 ``select()`` 成員函數里設定的所有值，如果您希望保留它們，可以將
第二個參數設定為 FALSE ::

	echo $this->db->count_all_results('my_table', FALSE);

**$this->db->count_all()**

該成員函數用於讀取某個表的總行數，第一個參數為表名稱::

	echo $this->db->count_all('my_table');  // Produces an integer, like 25

**************
查詢條件組
**************

查詢條件組可以讓您產生用括號括起來的一組 WHERE 條件，這能創造出非常複雜的 WHERE 子句，
支援嵌套的條件組。例如::

	$this->db->select('*')->from('my_table')
		->group_start()
			->where('a', 'a')
			->or_group_start()
				->where('b', 'b')
				->where('c', 'c')
			->group_end()
		->group_end()
		->where('d', 'd')
	->get();

	// Generates:
	// SELECT * FROM (`my_table`) WHERE ( `a` = 'a' OR ( `b` = 'b' AND `c` = 'c' ) ) AND `d` = 'd'

.. note:: 條件組必須要配對，確保每個 group_start() 成員函數都有一個 group_end() 成員函數與之配對。

**$this->db->group_start()**

開始一個新的條件組，為查詢中的 WHERE 條件加入一個左括號。

**$this->db->or_group_start()**

開始一個新的條件組，為查詢中的 WHERE 條件加入一個左括號，並在前面加上 OR 。

**$this->db->not_group_start()**

開始一個新的條件組，為查詢中的 WHERE 條件加入一個左括號，並在前面加上 NOT 。

**$this->db->or_not_group_start()**

開始一個新的條件組，為查詢中的 WHERE 條件加入一個左括號，並在前面加上 OR NOT 。

**$this->db->group_end()**

結束目前的條件組，為查詢中的 WHERE 條件加入一個右括號。

**************
插入資料
**************

**$this->db->insert()**

該成員函數依據您提供的資料產生一條 INSERT 語句並執行，它的參數是一個**陣列**
或一個**物件**，下面是使用陣列的範例::

	$data = array(
		'title' => 'My title',
		'name' => 'My Name',
		'date' => 'My date'
	);

	$this->db->insert('mytable', $data);
	// Produces: INSERT INTO mytable (title, name, date) VALUES ('My title', 'My name', 'My date')

第一個參數為要插入的表名稱，第二個參數為要插入的資料，是個關聯陣列。

下面是使用物件的範例::

	/*
	class Myclass {
		public $title = 'My Title';
		public $content = 'My Content';
		public $date = 'My Date';
	}
	*/

	$object = new Myclass;
	$this->db->insert('mytable', $object);
	// Produces: INSERT INTO mytable (title, content, date) VALUES ('My Title', 'My Content', 'My Date')

第一個參數為要插入的表名稱，第二個參數為要插入的資料，是個物件。

.. note:: 所有資料會被自動轉義，產生安全的查詢語句。

**$this->db->get_compiled_insert()**

該成員函數和 $this->db->insert() 成員函數一樣依據您提供的資料產生一條 INSERT 語句，但是並不執行。

例如::

	$data = array(
		'title' => 'My title',
		'name'  => 'My Name',
		'date'  => 'My date'
	);

	$sql = $this->db->set($data)->get_compiled_insert('mytable');
	echo $sql;

	// Produces string: INSERT INTO mytable (`title`, `name`, `date`) VALUES ('My title', 'My name', 'My date')

第二個參數用於設定是否重置查詢（預設情況下會重置，正如 $this->db->insert() 成員函數一樣）::

	echo $this->db->set('title', 'My Title')->get_compiled_insert('mytable', FALSE);

	// Produces string: INSERT INTO mytable (`title`) VALUES ('My Title')

	echo $this->db->set('content', 'My Content')->get_compiled_insert();

	// Produces string: INSERT INTO mytable (`title`, `content`) VALUES ('My Title', 'My Content')

上面的範例中，最值得注意的是，第二個查詢並沒有用到 **$this->db->from()** 成員函數，
也沒有為查詢指定表名稱參數，但是它產生的 SQL 語句中有 INTO mytable 子句。
這是因為查詢並沒有被重置（使用 **$this->db->insert()** 成員函數會被執行並被重置，
使用 **$this->db->reset_query()** 成員函數直接重置）。

.. note:: 這個成員函數不支援批量插入。

**$this->db->insert_batch()**

該成員函數依據您提供的資料產生一條 INSERT 語句並執行，它的參數是一個**陣列**
或一個**物件**，下面是使用陣列的範例::

	$data = array(
		array(
			'title' => 'My title',
			'name' => 'My Name',
			'date' => 'My date'
		),
		array(
			'title' => 'Another title',
			'name' => 'Another Name',
			'date' => 'Another date'
		)
	);

	$this->db->insert_batch('mytable', $data);
	// Produces: INSERT INTO mytable (title, name, date) VALUES ('My title', 'My name', 'My date'),  ('Another title', 'Another name', 'Another date')

第一個參數為要插入的表名稱，第二個參數為要插入的資料，是個二維陣列。

.. note:: 所有資料會被自動轉義，產生安全的查詢語句。

*************
更新資料
*************

**$this->db->replace()**

該成員函數用於執行一條 REPLACE 語句，REPLACE 語句依據表的**主鍵**和**唯一索引**
來執行，類似於標準的 DELETE + INSERT 。
使用這個成員函數，您不用再手工去實現 ``select()``，``update()``，``delete()``
以及 ``insert()`` 這些成員函數的不同組合，為您節約大量時間。

例如::

	$data = array(
		'title' => 'My title',
		'name'  => 'My Name',
		'date'  => 'My date'
	);

	$this->db->replace('table', $data);

	// Executes: REPLACE INTO mytable (title, name, date) VALUES ('My title', 'My name', 'My date')

上面的範例中，我們假設 *title* 字段是我們的主鍵，那麼如果我們資料庫裡有一行
的 *title* 列的值為 'My title'，這一行將會被刪除並被我們的新資料所取代。

也可以使用 ``set()`` 成員函數，而且所有字段都被自動轉義，正如 ``insert()`` 成員函數一樣。

**$this->db->set()**

該成員函數用於設定新增或更新的資料。

**該成員函數可以取代直接傳遞資料陣列到 insert 或 update 成員函數：**

::

	$this->db->set('name', $name);
	$this->db->insert('mytable');  // Produces: INSERT INTO mytable (`name`) VALUES ('{$name}')

如果您多次呼叫該成員函數，它會正確組裝出 INSERT 或 UPDATE 語句來::

	$this->db->set('name', $name);
	$this->db->set('title', $title);
	$this->db->set('status', $status);
	$this->db->insert('mytable');

**set()** 成員函數也接受可選的第三個參數（``$escape``），如果設定為 FALSE，資料將不會自動轉義。為了說明兩者之間的區別，這裡有一個帶轉義的 ``set()`` 成員函數和不帶轉義的範例。

::

	$this->db->set('field', 'field+1', FALSE);
	$this->db->where('id', 2);
	$this->db->update('mytable'); // gives UPDATE mytable SET field = field+1 WHERE id = 2

	$this->db->set('field', 'field+1');
	$this->db->where('id', 2);
	$this->db->update('mytable'); // gives UPDATE `mytable` SET `field` = 'field+1' WHERE `id` = 2

您也可以傳一個關聯陣列作為參數::

	$array = array(
		'name' => $name,
		'title' => $title,
		'status' => $status
	);

	$this->db->set($array);
	$this->db->insert('mytable');

或者一個物件::

	/*
	class Myclass {
		public $title = 'My Title';
		public $content = 'My Content';
		public $date = 'My Date';
	}
	*/

	$object = new Myclass;
	$this->db->set($object);
	$this->db->insert('mytable');

**$this->db->update()**

該成員函數依據您提供的資料產生一條 UPDATE 語句並執行，它的參數是一個 **陣列** 或一個 **物件** ，下面是使用陣列的範例::

	$data = array(
		'title' => $title,
		'name' => $name,
		'date' => $date
	);

	$this->db->where('id', $id);
	$this->db->update('mytable', $data);
	// Produces:
	//
	//	UPDATE mytable
	//	SET title = '{$title}', name = '{$name}', date = '{$date}'
	//	WHERE id = $id

或者您可以使用一個物件::

	/*
	class Myclass {
		public $title = 'My Title';
		public $content = 'My Content';
		public $date = 'My Date';
	}
	*/

	$object = new Myclass;
	$this->db->where('id', $id);
	$this->db->update('mytable', $object);
	// Produces:
	//
	// UPDATE `mytable`
	// SET `title` = '{$title}', `name` = '{$name}', `date` = '{$date}'
	// WHERE id = `$id`

.. note:: 所有資料會被自動轉義，產生安全的查詢語句。

您應該注意到 $this->db->where() 成員函數的使用，它可以為您設定 WHERE 子句。
您也可以直接使用字串形式設定 WHERE 子句::

	$this->db->update('mytable', $data, "id = 4");

或者使用一個陣列::

	$this->db->update('mytable', $data, array('id' => $id));

當執行 UPDATE 操作時，您還可以使用上面介紹的 $this->db->set() 成員函數。

**$this->db->update_batch()**

該成員函數依據您提供的資料產生一條 UPDATE 語句並執行，它的參數是一個**陣列**
或一個**物件**，下面是使用陣列的範例::

	$data = array(
	   array(
	      'title' => 'My title' ,
	      'name' => 'My Name 2' ,
	      'date' => 'My date 2'
	   ),
	   array(
	      'title' => 'Another title' ,
	      'name' => 'Another Name 2' ,
	      'date' => 'Another date 2'
	   )
	);

	$this->db->update_batch('mytable', $data, 'title');

	// Produces:
	// UPDATE `mytable` SET `name` = CASE
	// WHEN `title` = 'My title' THEN 'My Name 2'
	// WHEN `title` = 'Another title' THEN 'Another Name 2'
	// ELSE `name` END,
	// `date` = CASE
	// WHEN `title` = 'My title' THEN 'My date 2'
	// WHEN `title` = 'Another title' THEN 'Another date 2'
	// ELSE `date` END
	// WHERE `title` IN ('My title','Another title')

第一個參數為要更新的表名稱，第二個參數為要更新的資料，是個二維陣列，第三個
參數是 WHERE 語句的鍵。

.. note:: 所有資料會被自動轉義，產生安全的查詢語句。

.. note:: 取決於該成員函數的內部實現，在這個成員函數之後呼叫 ``affected_rows()`` 成員函數
	傳回的結果可能會不正確。但是您可以直接使用該成員函數的傳回值，代表了受影響的行數。

**$this->db->get_compiled_update()**

該成員函數和 ``$this->db->get_compiled_insert()`` 成員函數完全一樣，除了產生的 SQL 語句是
UPDATE 而不是 INSERT。

查看 `$this->db->get_compiled_insert()` 成員函數的文件讀取更多資訊。

.. note:: 該成員函數不支援批量更新。

*************
刪除資料
*************

**$this->db->delete()**

該成員函數產生 DELETE 語句並執行。

::

	$this->db->delete('mytable', array('id' => $id));  // Produces: // DELETE FROM mytable  // WHERE id = $id

第一個參數為表名稱，第二個參數為 WHERE 條件。您也可以不用第二個參數，
使用 where() 或者 or_where() 函數來替代它::

	$this->db->where('id', $id);
	$this->db->delete('mytable');

	// Produces:
	// DELETE FROM mytable
	// WHERE id = $id

如果您想要從多個表中刪除資料，您也可以將由多個表名稱構成的陣列傳給 delete() 成員函數。

::

	$tables = array('table1', 'table2', 'table3');
	$this->db->where('id', '5');
	$this->db->delete($tables);

如果您想要刪除一個表中的所有資料，可以使用 truncate() 或 empty_table() 成員函數。

**$this->db->empty_table()**

該成員函數產生 DELETE 語句並執行::

	  $this->db->empty_table('mytable'); // Produces: DELETE FROM mytable

**$this->db->truncate()**

該成員函數產生 TRUNCATE 語句並執行。

::

	$this->db->from('mytable');
	$this->db->truncate();

	// or

	$this->db->truncate('mytable');

	// Produce:
	// TRUNCATE mytable

.. note:: 如果 TRUNCATE 語句不可用，truncate() 成員函數將執行 "DELETE FROM table"。

**$this->db->get_compiled_delete()**

該成員函數和 ``$this->db->get_compiled_insert()`` 成員函數完全一樣，除了產生的 SQL 語句是
DELETE 而不是 INSERT。

查看 `$this->db->get_compiled_insert()` 成員函數的文件讀取更多資訊。

***************
鏈式成員函數
***************

通過將多個成員函數連接在一起，鏈式成員函數可以大大的簡化您的語法。感受一下這個範例::

	$query = $this->db->select('title')
			->where('id', $id)
			->limit(10, 20)
			->get('mytable');

.. _ar-caching:

*********************
查詢產生器快取
*********************

儘管不是 "真正的" 快取，查詢產生器允許您將查詢的某個特定部分儲存（或 "快取"）起來，
以便在您的腳本執行之後重用。一般情況下，當查詢產生器的一次呼叫結束後，所有已儲存的資訊
都會被重置，以便下一次呼叫。如果開啟快取，您就可以使資訊避免被重置，方便您進行重用。

快取呼叫是累加的。如果您呼叫了兩次有快取的 select()，然後再呼叫兩次沒有快取的 select()，
這會導致 select() 被呼叫4次。

有三個可用的快取成員函數成員函數:

**$this->db->start_cache()**

如需開啟快取必須先呼叫此成員函數，所有支援的查詢類型（見下文）都會被儲存起來供以後使用。

**$this->db->stop_cache()**

此成員函數用於停止快取。

**$this->db->flush_cache()**

此成員函數用於清空快取。

這裡是一個使用快取的範例::

	$this->db->start_cache();
	$this->db->select('field1');
	$this->db->stop_cache();
	$this->db->get('tablename');
	//Generates: SELECT `field1` FROM (`tablename`)

	$this->db->select('field2');
	$this->db->get('tablename');
	//Generates:  SELECT `field1`, `field2` FROM (`tablename`)

	$this->db->flush_cache();
	$this->db->select('field2');
	$this->db->get('tablename');
	//Generates:  SELECT `field2` FROM (`tablename`)


.. note:: 支援快取的語句有: select, from, join, where, like, group_by, having, order_by


***********************
重置查詢產生器
***********************

**$this->db->reset_query()**

該成員函數無需執行就能重置查詢產生器中的查詢，$this->db->get() 和 $this->db->insert()
成員函數也可以用於重置查詢，但是必須要先執行它。和這兩個成員函數一樣，使用`查詢產生器快取`_
快取下來的查詢不會被重置。

當您在使用查詢產生器產生 SQL 語句（如：``$this->db->get_compiled_select()``），
之後再執行它。這種情況下，不重置查詢快取將非常有用::

	// Note that the second parameter of the get_compiled_select method is FALSE
	$sql = $this->db->select(array('field1','field2'))
					->where('field3',5)
					->get_compiled_select('mytable', FALSE);

	// ...
	// Do something crazy with the SQL code... like add it to a cron script for
	// later execution or something...
	// ...

	$data = $this->db->get()->result_array();

	// Would execute and return an array of results of the following query:
	// SELECT field1, field1 from mytable where field3 = 5;

.. note:: 如果您正在使用查詢產生器快取功能，連續兩次呼叫 ``get_compiled_select()`` 成員函數
	並且不重置您的查詢，這將會導致快取被合併兩次。舉例來說，例如您正在快取 ``select()``
	成員函數，那麼會查詢兩個相同的字段。

***************
Class Reference
***************

.. php:class:: CI_DB_query_builder

	.. php:method:: reset_query()

		:returns:	CI_DB_query_builder instance (method chaining)
		:rtype:	CI_DB_query_builder

		Resets the current Query Builder state.  Useful when you want
		to build a query that can be cancelled under certain conditions.

	.. php:method:: start_cache()

		:returns:	CI_DB_query_builder instance (method chaining)
		:rtype:	CI_DB_query_builder

		Starts the Query Builder cache.

	.. php:method:: stop_cache()

		:returns:	CI_DB_query_builder instance (method chaining)
		:rtype:	CI_DB_query_builder

		Stops the Query Builder cache.

	.. php:method:: flush_cache()

		:returns:	CI_DB_query_builder instance (method chaining)
		:rtype:	CI_DB_query_builder

		Empties the Query Builder cache.

	.. php:method:: set_dbprefix([$prefix = ''])

		:param	string	$prefix: The new prefix to use
		:returns:	The DB prefix in use
		:rtype:	string

		Sets the database prefix, without having to reconnect.

	.. php:method:: dbprefix([$table = ''])

		:param	string	$table: The table name to prefix
		:returns:	The prefixed table name
		:rtype:	string

		Prepends a database prefix, if one exists in configuration.

	.. php:method:: count_all_results([$table = '', [$reset = TRUE]])

		:param	string	$table: Table name
		:param	bool	$reset: Whether to reset values for SELECTs
		:returns:	Number of rows in the query result
		:rtype:	int

		Generates a platform-specific query string that counts
		all records returned by an Query Builder query.

	.. php:method:: get([$table = ''[, $limit = NULL[, $offset = NULL]]])

		:param	string	$table: The table to query
		:param	int	$limit: The LIMIT clause
		:param	int	$offset: The OFFSET clause
		:returns:	CI_DB_result instance (method chaining)
		:rtype:	CI_DB_result

		Compiles and runs SELECT statement based on the already
		called Query Builder methods.

	.. php:method:: get_where([$table = ''[, $where = NULL[, $limit = NULL[, $offset = NULL]]]])

		:param	mixed	$table: The table(s) to fetch data from; string or array
		:param	string	$where: The WHERE clause
		:param	int	$limit: The LIMIT clause
		:param	int	$offset: The OFFSET clause
		:returns:	CI_DB_result instance (method chaining)
		:rtype:	CI_DB_result

		Same as ``get()``, but also allows the WHERE to be added directly.

	.. php:method:: select([$select = '*'[, $escape = NULL]])

		:param	string	$select: The SELECT portion of a query
		:param	bool	$escape: Whether to escape values and identifiers
		:returns:	CI_DB_query_builder instance (method chaining)
		:rtype:	CI_DB_query_builder

		Adds a SELECT clause to a query.

	.. php:method:: select_avg([$select = ''[, $alias = '']])

		:param	string	$select: Field to compute the average of
		:param	string	$alias: Alias for the resulting value name
		:returns:	CI_DB_query_builder instance (method chaining)
		:rtype:	CI_DB_query_builder

		Adds a SELECT AVG(field) clause to a query.

	.. php:method:: select_max([$select = ''[, $alias = '']])

		:param	string	$select: Field to compute the maximum of
		:param	string	$alias: Alias for the resulting value name
		:returns:	CI_DB_query_builder instance (method chaining)
		:rtype:	CI_DB_query_builder

		Adds a SELECT MAX(field) clause to a query.

	.. php:method:: select_min([$select = ''[, $alias = '']])

		:param	string	$select: Field to compute the minimum of
		:param	string	$alias: Alias for the resulting value name
		:returns:	CI_DB_query_builder instance (method chaining)
		:rtype:	CI_DB_query_builder

		Adds a SELECT MIN(field) clause to a query.

	.. php:method:: select_sum([$select = ''[, $alias = '']])

		:param	string	$select: Field to compute the sum of
		:param	string	$alias: Alias for the resulting value name
		:returns:	CI_DB_query_builder instance (method chaining)
		:rtype:	CI_DB_query_builder

		Adds a SELECT SUM(field) clause to a query.

	.. php:method:: distinct([$val = TRUE])

		:param	bool	$val: Desired value of the "distinct" flag
		:returns:	CI_DB_query_builder instance (method chaining)
		:rtype:	CI_DB_query_builder

		Sets a flag which tells the query builder to add
		a DISTINCT clause to the SELECT portion of the query.

	.. php:method:: from($from)

		:param	mixed	$from: Table name(s); string or array
		:returns:	CI_DB_query_builder instance (method chaining)
		:rtype:	CI_DB_query_builder

		Specifies the FROM clause of a query.

	.. php:method:: join($table, $cond[, $type = ''[, $escape = NULL]])

		:param	string	$table: Table name to join
		:param	string	$cond: The JOIN ON condition
		:param	string	$type: The JOIN type
		:param	bool	$escape: Whether to escape values and identifiers
		:returns:	CI_DB_query_builder instance (method chaining)
		:rtype:	CI_DB_query_builder

		Adds a JOIN clause to a query.

	.. php:method:: where($key[, $value = NULL[, $escape = NULL]])

		:param	mixed	$key: Name of field to compare, or associative array
		:param	mixed	$value: If a single key, compared to this value
		:param	bool	$escape: Whether to escape values and identifiers
		:returns:	DB_query_builder instance
		:rtype:	object

		Generates the WHERE portion of the query.
                Separates multiple calls with 'AND'.

	.. php:method:: or_where($key[, $value = NULL[, $escape = NULL]])

		:param	mixed	$key: Name of field to compare, or associative array
		:param	mixed	$value: If a single key, compared to this value
		:param	bool	$escape: Whether to escape values and identifiers
		:returns:	DB_query_builder instance
		:rtype:	object

		Generates the WHERE portion of the query.
                Separates multiple calls with 'OR'.

	.. php:method:: or_where_in([$key = NULL[, $values = NULL[, $escape = NULL]]])

		:param	string	$key: The field to search
		:param	array	$values: The values searched on
		:param	bool	$escape: Whether to escape identifiers
		:returns:	DB_query_builder instance
		:rtype:	object

		Generates a WHERE field IN('item', 'item') SQL query,
                joined with 'OR' if appropriate.

	.. php:method:: or_where_not_in([$key = NULL[, $values = NULL[, $escape = NULL]]])

		:param	string	$key: The field to search
		:param	array	$values: The values searched on
		:param	bool	$escape: Whether to escape identifiers
		:returns:	DB_query_builder instance
		:rtype:	object

		Generates a WHERE field NOT IN('item', 'item') SQL query,
                joined with 'OR' if appropriate.

	.. php:method:: where_in([$key = NULL[, $values = NULL[, $escape = NULL]]])

		:param	string	$key: Name of field to examine
		:param	array	$values: Array of target values
		:param	bool	$escape: Whether to escape identifiers
		:returns:	DB_query_builder instance
		:rtype:	object

		Generates a WHERE field IN('item', 'item') SQL query,
                joined with 'AND' if appropriate.

	.. php:method:: where_not_in([$key = NULL[, $values = NULL[, $escape = NULL]]])

		:param	string	$key: Name of field to examine
		:param	array	$values: Array of target values
		:param	bool	$escape: Whether to escape identifiers
		:returns:	DB_query_builder instance
		:rtype:	object

		Generates a WHERE field NOT IN('item', 'item') SQL query,
                joined with 'AND' if appropriate.

	.. php:method:: group_start()

		:returns:	CI_DB_query_builder instance (method chaining)
		:rtype:	CI_DB_query_builder

		Starts a group expression, using ANDs for the conditions inside it.

	.. php:method:: or_group_start()

		:returns:	CI_DB_query_builder instance (method chaining)
		:rtype:	CI_DB_query_builder

		Starts a group expression, using ORs for the conditions inside it.

	.. php:method:: not_group_start()

		:returns:	CI_DB_query_builder instance (method chaining)
		:rtype:	CI_DB_query_builder

		Starts a group expression, using AND NOTs for the conditions inside it.

	.. php:method:: or_not_group_start()

		:returns:	CI_DB_query_builder instance (method chaining)
		:rtype:	CI_DB_query_builder

		Starts a group expression, using OR NOTs for the conditions inside it.

	.. php:method:: group_end()

		:returns:	DB_query_builder instance
		:rtype:	object

		Ends a group expression.

	.. php:method:: like($field[, $match = ''[, $side = 'both'[, $escape = NULL]]])

		:param	string	$field: Field name
		:param	string	$match: Text portion to match
		:param	string	$side: Which side of the expression to put the '%' wildcard on
		:param	bool	$escape: Whether to escape values and identifiers
		:returns:	CI_DB_query_builder instance (method chaining)
		:rtype:	CI_DB_query_builder

		Adds a LIKE clause to a query, separating multiple calls with AND.

	.. php:method:: or_like($field[, $match = ''[, $side = 'both'[, $escape = NULL]]])

		:param	string	$field: Field name
		:param	string	$match: Text portion to match
		:param	string	$side: Which side of the expression to put the '%' wildcard on
		:param	bool	$escape: Whether to escape values and identifiers
		:returns:	CI_DB_query_builder instance (method chaining)
		:rtype:	CI_DB_query_builder

		Adds a LIKE clause to a query, separating multiple class with OR.

	.. php:method:: not_like($field[, $match = ''[, $side = 'both'[, $escape = NULL]]])

		:param	string	$field: Field name
		:param	string	$match: Text portion to match
		:param	string	$side: Which side of the expression to put the '%' wildcard on
		:param	bool	$escape: Whether to escape values and identifiers
		:returns:	CI_DB_query_builder instance (method chaining)
		:rtype:	CI_DB_query_builder

		Adds a NOT LIKE clause to a query, separating multiple calls with AND.

	.. php:method:: or_not_like($field[, $match = ''[, $side = 'both'[, $escape = NULL]]])

		:param	string	$field: Field name
		:param	string	$match: Text portion to match
		:param	string	$side: Which side of the expression to put the '%' wildcard on
		:param	bool	$escape: Whether to escape values and identifiers
		:returns:	CI_DB_query_builder instance (method chaining)
		:rtype:	CI_DB_query_builder

		Adds a NOT LIKE clause to a query, separating multiple calls with OR.

	.. php:method:: having($key[, $value = NULL[, $escape = NULL]])

		:param	mixed	$key: Identifier (string) or associative array of field/value pairs
		:param	string	$value: Value sought if $key is an identifier
		:param	string	$escape: Whether to escape values and identifiers
		:returns:	CI_DB_query_builder instance (method chaining)
		:rtype:	CI_DB_query_builder

		Adds a HAVING clause to a query, separating multiple calls with AND.

	.. php:method:: or_having($key[, $value = NULL[, $escape = NULL]])

		:param	mixed	$key: Identifier (string) or associative array of field/value pairs
		:param	string	$value: Value sought if $key is an identifier
		:param	string	$escape: Whether to escape values and identifiers
		:returns:	CI_DB_query_builder instance (method chaining)
		:rtype:	CI_DB_query_builder

		Adds a HAVING clause to a query, separating multiple calls with OR.

	.. php:method:: group_by($by[, $escape = NULL])

		:param	mixed	$by: Field(s) to group by; string or array
		:returns:	CI_DB_query_builder instance (method chaining)
		:rtype:	CI_DB_query_builder

		Adds a GROUP BY clause to a query.

	.. php:method:: order_by($orderby[, $direction = ''[, $escape = NULL]])

		:param	string	$orderby: Field to order by
		:param	string	$direction: The order requested - ASC, DESC or random
		:param	bool	$escape: Whether to escape values and identifiers
		:returns:	CI_DB_query_builder instance (method chaining)
		:rtype:	CI_DB_query_builder

		Adds an ORDER BY clause to a query.

	.. php:method:: limit($value[, $offset = 0])

		:param	int	$value: Number of rows to limit the results to
		:param	int	$offset: Number of rows to skip
		:returns:	CI_DB_query_builder instance (method chaining)
		:rtype:	CI_DB_query_builder

		Adds LIMIT and OFFSET clauses to a query.

	.. php:method:: offset($offset)

		:param	int	$offset: Number of rows to skip
		:returns:	CI_DB_query_builder instance (method chaining)
		:rtype:	CI_DB_query_builder

		Adds an OFFSET clause to a query.

	.. php:method:: set($key[, $value = ''[, $escape = NULL]])

		:param	mixed	$key: Field name, or an array of field/value pairs
		:param	string	$value: Field value, if $key is a single field
		:param	bool	$escape: Whether to escape values and identifiers
		:returns:	CI_DB_query_builder instance (method chaining)
		:rtype:	CI_DB_query_builder

		Adds field/value pairs to be passed later to ``insert()``,
		``update()`` or ``replace()``.

	.. php:method:: insert([$table = ''[, $set = NULL[, $escape = NULL]]])

		:param	string	$table: Table name
		:param	array	$set: An associative array of field/value pairs
		:param	bool	$escape: Whether to escape values and identifiers
		:returns:	TRUE on success, FALSE on failure
		:rtype:	bool

		Compiles and executes an INSERT statement.

	.. php:method:: insert_batch($table[, $set = NULL[, $escape = NULL[, $batch_size = 100]]])

		:param	string	$table: Table name
		:param	array	$set: Data to insert
		:param	bool	$escape: Whether to escape values and identifiers
		:param	int	$batch_size: Count of rows to insert at once
		:returns:	Number of rows inserted or FALSE on failure
		:rtype:	mixed

		Compiles and executes batch ``INSERT`` statements.

		.. note:: When more than ``$batch_size`` rows are provided, multiple
			``INSERT`` queries will be executed, each trying to insert
			up to ``$batch_size`` rows.

	.. php:method:: set_insert_batch($key[, $value = ''[, $escape = NULL]])

		:param	mixed	$key: Field name or an array of field/value pairs
		:param	string	$value: Field value, if $key is a single field
		:param	bool	$escape: Whether to escape values and identifiers
		:returns:	CI_DB_query_builder instance (method chaining)
		:rtype:	CI_DB_query_builder

		Adds field/value pairs to be inserted in a table later via ``insert_batch()``.

	.. php:method:: update([$table = ''[, $set = NULL[, $where = NULL[, $limit = NULL]]]])

		:param	string	$table: Table name
		:param	array	$set: An associative array of field/value pairs
		:param	string	$where: The WHERE clause
		:param	int	$limit: The LIMIT clause
		:returns:	TRUE on success, FALSE on failure
		:rtype:	bool

		Compiles and executes an UPDATE statement.

	.. php:method:: update_batch($table[, $set = NULL[, $value = NULL[, $batch_size = 100]]])

		:param	string	$table: Table name
		:param	array	$set: Field name, or an associative array of field/value pairs
		:param	string	$value: Field value, if $set is a single field
		:param	int	$batch_size: Count of conditions to group in a single query
		:returns:	Number of rows updated or FALSE on failure
		:rtype:	mixed

		Compiles and executes batch ``UPDATE`` statements.

		.. note:: When more than ``$batch_size`` field/value pairs are provided,
			multiple queries will be executed, each handling up to
			``$batch_size`` field/value pairs.

	.. php:method:: set_update_batch($key[, $value = ''[, $escape = NULL]])

		:param	mixed	$key: Field name or an array of field/value pairs
		:param	string	$value: Field value, if $key is a single field
		:param	bool	$escape: Whether to escape values and identifiers
		:returns:	CI_DB_query_builder instance (method chaining)
		:rtype:	CI_DB_query_builder

		Adds field/value pairs to be updated in a table later via ``update_batch()``.

	.. php:method:: replace([$table = ''[, $set = NULL]])

		:param	string	$table: Table name
		:param	array	$set: An associative array of field/value pairs
		:returns:	TRUE on success, FALSE on failure
		:rtype:	bool

		Compiles and executes a REPLACE statement.

	.. php:method:: delete([$table = ''[, $where = ''[, $limit = NULL[, $reset_data = TRUE]]]])

		:param	mixed	$table: The table(s) to delete from; string or array
		:param	string	$where: The WHERE clause
		:param	int	$limit: The LIMIT clause
		:param	bool	$reset_data: TRUE to reset the query "write" clause
		:returns:	CI_DB_query_builder instance (method chaining) or FALSE on failure
		:rtype:	mixed

		Compiles and executes a DELETE query.

	.. php:method:: truncate([$table = ''])

		:param	string	$table: Table name
		:returns:	TRUE on success, FALSE on failure
		:rtype:	bool

		Executes a TRUNCATE statement on a table.

		.. note:: If the database platform in use doesn't support TRUNCATE,
			a DELETE statement will be used instead.

	.. php:method:: empty_table([$table = ''])

		:param	string	$table: Table name
		:returns:	TRUE on success, FALSE on failure
		:rtype:	bool

		Deletes all records from a table via a DELETE statement.

	.. php:method:: get_compiled_select([$table = ''[, $reset = TRUE]])

		:param	string	$table: Table name
		:param	bool	$reset: Whether to reset the current QB values or not
		:returns:	The compiled SQL statement as a string
		:rtype:	string

		Compiles a SELECT statement and returns it as a string.

	.. php:method:: get_compiled_insert([$table = ''[, $reset = TRUE]])

		:param	string	$table: Table name
		:param	bool	$reset: Whether to reset the current QB values or not
		:returns:	The compiled SQL statement as a string
		:rtype:	string

		Compiles an INSERT statement and returns it as a string.

	.. php:method:: get_compiled_update([$table = ''[, $reset = TRUE]])

		:param	string	$table: Table name
		:param	bool	$reset: Whether to reset the current QB values or not
		:returns:	The compiled SQL statement as a string
		:rtype:	string

		Compiles an UPDATE statement and returns it as a string.

	.. php:method:: get_compiled_delete([$table = ''[, $reset = TRUE]])

		:param	string	$table: Table name
		:param	bool	$reset: Whether to reset the current QB values or not
		:returns:	The compiled SQL statement as a string
		:rtype:	string

		Compiles a DELETE statement and returns it as a string.
