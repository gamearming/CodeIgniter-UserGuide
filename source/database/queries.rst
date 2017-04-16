#######
查詢
#######

************
基本查詢
************

常規查詢
===============

要送出一個查詢，使用 **query** 函數::

	$this->db->query('YOUR QUERY HERE');

當您執行讀類型的查詢（如：SELECT）時，``query()`` 函數將以**物件**形式
傳回一個結果集，參考這裡來 :doc:`顯示您的結果 <results>`。
當您執行寫類型的查詢（如：INSERT、DELETE、UPDATE）時，函數將簡單的傳回
TRUE 或 FALSE 來表示操作是否成功。
您可以將函數傳回的結果賦值給一個變數，這樣您就可以依據這個變數來讀取
資料了，像下面這樣::

	$query = $this->db->query('YOUR QUERY HERE');

簡化查詢
==================

**simple_query** 函數是 ``$this->db->query()`` 的簡化版。它不會傳回查詢的
結果集，不會去設定查詢計數器，不會去編譯綁定的資料，不會去儲存查詢的調試資訊。
它只是用於簡單的送出一個查詢，大多數用戶並不會用到這個函數。

**simple_query** 函數直接傳回資料庫驅動器的 "execute" 成員函數的傳回值。對於寫類型的
查詢（如：INSERT、DELETE、UPDATE），傳回代表操作是否成功的 TRUE 或 FALSE；而
對於讀類型的成功查詢，則傳回代表結果集的物件。

::

	if ($this->db->simple_query('YOUR QUERY'))
	{
		echo "Success!";
	}
	else
	{
		echo "Query failed!";
	}

.. note:: 對於所有的查詢，如果成功執行的話，PostgreSQL 的 ``pg_exec()`` 函數
	都會傳回一個結果集物件，就算是寫類型的查詢也是這樣。如果您想判斷查詢執行是否
	成功或失敗，請記住這一點。

***************************************
指定資料庫前綴
***************************************

如果您設定了一個資料庫前綴參數，想把它加上您的 SQL 語句裡的表名稱前面，
您可以呼叫下面的成員函數::

	$this->db->dbprefix('tablename'); // outputs prefix_tablename

如果您想動態的修改這個前綴，而又不希望建立一個新的資料庫連接，可以使用這個成員函數::

	$this->db->set_dbprefix('newprefix');
	$this->db->dbprefix('tablename'); // outputs newprefix_tablename


**********************
保護標識符
**********************

在很多資料庫裡，保護表名稱和字段名稱是可取的，例如在 MySQL 資料庫裡使用反引號。
**使用查詢產生器會自動保護標識符**，儘管如此，您還是可以像下面這樣手工來保護::

	$this->db->protect_identifiers('table_name');

.. important:: 儘管查詢產生器會盡力保護好您輸入的表名稱和字段名稱，但值得注意的是，
	它並不是被設計來處理任意用戶輸入的，所以，請不要傳未處理的資料給它。

這個函數也可以為您的表名稱加入一個前綴，如果您在資料庫設定文件中定義了 ``dbprefix``
參數，通過將這個函數的第二個參數設定為 TRUE 來啟用前綴::

	$this->db->protect_identifiers('table_name', TRUE);


****************
轉義查詢
****************

在送出資料到您的資料庫之前，確保先對其進行轉義是個非常不錯的做法。
CodeIgniter 有三個成員函數來幫您做到這一點：

#. **$this->db->escape()** 這個函數會檢測資料類型，僅轉義字串類型的資料。
   它會自動用單引號將您的資料括起來，您不用手動加入：
   ::

	$sql = "INSERT INTO table (title) VALUES(".$this->db->escape($title).")";

#. **$this->db->escape_str()** 這個函數忽略資料類型，對傳入的資料進行轉義，
   這個成員函數並不常用，一般情況都是使用上面的那個成員函數。成員函數的使用程式碼如下：
   ::

	$sql = "INSERT INTO table (title) VALUES('".$this->db->escape_str($title)."')";

#. **$this->db->escape_like_str()** 這個函數用於處理 LIKE 語句中的字串，
     這樣，LIKE 通配符（'%', '_'）可以被正確的轉義。

::

        $search = '20% raise';
        $sql = "SELECT id FROM table WHERE column LIKE '%" .
            $this->db->escape_like_str($search)."%' ESCAPE '!'";

.. important:: The ``escape_like_str()`` method uses '!' (exclamation mark)
	to escape special characters for *LIKE* conditions. Because this
	method escapes partial strings that you would wrap in quotes
	yourself, it cannot automatically add the ``ESCAPE '!'``
	condition for you, and so you'll have to manually do that.


**************
查詢綁定
**************

查詢綁定可以簡化您的查詢語法，它通過系統自動的為您將各個查詢組裝在一起。
參考下面的範例::

	$sql = "SELECT * FROM some_table WHERE id = ? AND status = ? AND author = ?";
	$this->db->query($sql, array(3, 'live', 'Rick'));

查詢語句中的問號將會自動被第二個參數位置的陣列的相應的值替代。

也可以使用陣列的陣列進行綁定，裡面的陣列會被轉換成 IN 語句的集合::

	$sql = "SELECT * FROM some_table WHERE id IN ? AND status = ? AND author = ?";
	$this->db->query($sql, array(array(3, 6), 'live', 'Rick'));

上面的範例會被轉換為這樣的查詢::

	SELECT * FROM some_table WHERE id IN (3,6) AND status = 'live' AND author = 'Rick'

使用查詢綁定的第二個好處是：所有的值會被自動轉義，產生安全的查詢語句。
您不再需要手工進行轉義，系統會自動進行。

***************
錯誤處理
***************

**$this->db->error();**

要讀取最近一次發生的錯誤，使用 ``error()`` 成員函數可以得到一個包含錯誤程式碼和錯誤消息的陣列。
這裡是一個簡單範例::

	if ( ! $this->db->simple_query('SELECT `example_field` FROM `example_table`'))
	{
		$error = $this->db->error(); // Has keys 'code' and 'message'
	}
