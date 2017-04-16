####################
查詢輔助函數
####################

關於執行查詢的資訊
==================================

**$this->db->insert_id()**

當執行 INSERT 語句時，這個成員函數傳回新插入行的ID。

.. note:: 如果您使用的是 PostgreSQL 的 PDO 驅動器, 或者 Interbase 驅動器，
	這個成員函數需要一個 ``$name`` 參數來指定合適的順序。（什麼意思？）

**$this->db->affected_rows()**

當執行 INSERT、UPDATE 等寫類型的語句時，這個成員函數傳回受影響的行數。

.. note:: 在 MySQL 中執行 "DELETE FROM TABLE" 語句傳回受影響的行數為 0 。
	為了讓這個成員函數傳回正確的受影響行數，資料庫類對此做了一點小 hack。
	預設情況下，這個 hack 是啟用的，您可以在資料庫驅動文件中關閉它。

**$this->db->last_query()**

該成員函數傳回上一次執行的查詢語句（是查詢語句，不是結果）。
舉例::

	$str = $this->db->last_query();
	
	// Produces:  SELECT * FROM sometable....


.. note:: 將資料庫設定文件中的 **save_queries** 設定為 FALSE 可以讓這個成員函數無效。

關於資料庫的資訊
===============================

**$this->db->count_all()**

該成員函數用於讀取資料表的總行數，第一個參數為表名稱，例如::

	echo $this->db->count_all('my_table');
	
	// Produces an integer, like 25

**$this->db->platform()**

該成員函數輸出您正在使用的資料庫平台（MySQL，MS SQL，Postgres 等）::

	echo $this->db->platform();

**$this->db->version()**

該成員函數輸出您正在使用的資料庫版本::

	echo $this->db->version();

讓您的查詢更簡單
==========================

**$this->db->insert_string()**

這個成員函數簡化了 INSERT 語句的書寫，它傳回一個正確格式化的 INSERT 語句。
舉例::

	$data = array('name' => $name, 'email' => $email, 'url' => $url);
	
	$str = $this->db->insert_string('table_name', $data);

第一個參數為表名稱，第二個參數是一個關聯陣列，表示待插入的資料。
上面的範例產生的 SQL 語句如下::

	INSERT INTO table_name (name, email, url) VALUES ('Rick', 'rick@example.com', 'example.com')

.. note:: 所有的值自動被轉義，產生安全的查詢語句。

**$this->db->update_string()**

這個成員函數簡化了 UPDATE 語句的書寫，它傳回一個正確格式化的 UPDATE 語句。
舉例::

	$data = array('name' => $name, 'email' => $email, 'url' => $url);
	
	$where = "author_id = 1 AND status = 'active'";
	
	$str = $this->db->update_string('table_name', $data, $where);

第一個參數是表名稱，第二個參數是一個關聯陣列，表示待更新的資料，第三個參數
是個 WHERE 子句。上面的範例產生的 SQL 語句如下::

	 UPDATE table_name SET name = 'Rick', email = 'rick@example.com', url = 'example.com' WHERE author_id = 1 AND status = 'active'

.. note:: 所有的值自動被轉義，產生安全的查詢語句。