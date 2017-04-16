###################
資料庫驅動器參考
###################

這是一個平台無關的資料庫實現基類，該類不會被直接呼叫，
而是通過特定的資料庫適配器類來繼承和實現該類。

關於資料庫驅動器，已經在其他幾篇文件中介紹過，這篇文件將作為它們的一個參考。

.. important:: 並不是所有的成員函數都被所有的資料庫驅動器所支援，
	當不支援的時候，有些成員函數可能會失敗（傳回 FALSE）。

.. php:class:: CI_DB_driver

	.. php:method:: initialize()

		:returns:	TRUE on success, FALSE on failure
		:rtype:	bool

		初始化資料庫設定，建立對資料庫的連接。

	.. php:method:: db_connect($persistent = TRUE)

		:param	bool	$persistent: Whether to establish a persistent connection or a regular one
		:returns:	Database connection resource/object or FALSE on failure
		:rtype:	mixed

		建立對資料庫的連接。

		.. note:: 傳回值取決於目前使用的資料庫驅動器，例如 ``mysqli`` 執行緒將會傳回 'mysqli' 驅動器。

	.. php:method:: db_pconnect()

		:returns:	Database connection resource/object or FALSE on failure
		:rtype:	mixed

		建立對資料庫的連接，使用持久連接。

		.. note:: 該成員函數其實就是呼叫 ``db_connect(TRUE)`` 。

	.. php:method:: reconnect()

		:returns:	TRUE on success, FALSE on failure
		:rtype:	bool

		如果超過伺服器的超時時間都沒有發送任何查詢請求，
		使用該成員函數可以讓資料庫連接保持有效，或重新連接資料庫。

	.. php:method:: db_select([$database = ''])

		:param	string	$database: Database name
		:returns:	TRUE on success, FALSE on failure
		:rtype:	bool

		切換到某個資料庫。

	.. php:method:: db_set_charset($charset)

		:param	string	$charset: Character set name
		:returns:	TRUE on success, FALSE on failure
		:rtype:	bool

		設定客戶端字元集。

	.. php:method:: platform()

		:returns:	Platform name
		:rtype:	string

		目前使用的資料庫平台（mysql、mssql 等）。

	.. php:method:: version()

		:returns:	The version of the database being used
		:rtype:	string

		資料庫版本。

	.. php:method:: query($sql[, $binds = FALSE[, $return_object = NULL]])

		:param	string	$sql: The SQL statement to execute
		:param	array	$binds: An array of binding data
		:param	bool	$return_object: Whether to return a result object or not
		:returns:	TRUE for successful "write-type" queries, CI_DB_result instance (method chaining) on "query" success, FALSE on failure
		:rtype:	mixed

		執行一個 SQL 查詢。

		如果是讀類型的查詢，執行 SQL 成功後將傳回結果物件。

		有以下幾種可能的傳回值：

		   - 如果是寫類型的查詢，執行成功傳回 TRUE
		   - 執行失敗傳回 FALSE
		   - 如果是讀類型的查詢，執行成功傳回 ``CI_DB_result`` 物件

		.. note: 如果 'db_debug' 設定為 TRUE ，那麼查詢失敗時將顯示一個錯誤頁面，
			而不是傳回 FALSE ，並終止腳本的執行

	.. php:method:: simple_query($sql)

		:param	string	$sql: The SQL statement to execute
		:returns:	Whatever the underlying driver's "query" function returns
		:rtype:	mixed

		``query()`` 成員函數的簡化版，當您只需要簡單的執行一個查詢，並不關心查詢的結果時，
		可以使用該成員函數。

	.. php:method:: affected_rows()

		:returns:	Number of rows affected
		:rtype:	int

		Returns the number of rows *changed* by the last executed query.

		Useful for checking how much rows were created, updated or deleted
		during the last executed query.

	.. php:method:: trans_strict([$mode = TRUE])

		:param	bool	$mode: Strict mode flag
		:rtype:	void

		啟用或停用事務的嚴格模式。

		在嚴格模式下，如果您正在執行多組事務，只要有一組失敗，所有組都會被回滾。

		如果停用嚴格模式，那麼每一組都被視為獨立的組，這意味著其中一組失敗不會影響其他的組。

	.. php:method:: trans_off()

		:rtype:	void

		即時的停用事務。

	.. php:method:: trans_start([$test_mode = FALSE])

		:param	bool	$test_mode: Test mode flag
		:returns:	TRUE on success, FALSE on failure
		:rtype:	bool

		開啟一個事務。

	.. php:method:: trans_complete()

		:returns:	TRUE on success, FALSE on failure
		:rtype:	bool

		結束事務。

	.. php:method:: trans_status()

		:returns:	TRUE if the transaction succeeded, FALSE if it failed
		:rtype:	bool

		讀取事務的狀態，用來判斷事務是否執行成功。

	.. php:method:: compile_binds($sql, $binds)

		:param	string	$sql: The SQL statement
		:param	array	$binds: An array of binding data
		:returns:	The updated SQL statement
		:rtype:	string

		依據綁定的參數值編譯 SQL 查詢。

	.. php:method:: is_write_type($sql)

		:param	string	$sql: The SQL statement
		:returns:	TRUE if the SQL statement is of "write type", FALSE if not
		:rtype:	bool

		判斷查詢是寫類型（INSERT、UPDATE、DELETE），還是讀類型（SELECT）。

	.. php:method:: elapsed_time([$decimals = 6])

		:param	int	$decimals: The number of decimal places
		:returns:	The aggregate query elapsed time, in microseconds
		:rtype:	string

		計算查詢所消耗的時間。

	.. php:method:: total_queries()

		:returns:	The total number of queries executed
		:rtype:	int

		傳回目前已經執行了多少次查詢。

	.. php:method:: last_query()

		:returns:	The last query executed
		:rtype:	string

		傳回上一次執行的查詢。

	.. php:method:: escape($str)

		:param	mixed	$str: The value to escape, or an array of multiple ones
		:returns:	The escaped value(s)
		:rtype:	mixed

		依據輸入資料的類型進行資料轉義，包括布林值和空值。

	.. php:method:: escape_str($str[, $like = FALSE])

		:param	mixed	$str: A string value or array of multiple ones
		:param	bool	$like: Whether or not the string will be used in a LIKE condition
		:returns:	The escaped string(s)
		:rtype:	mixed

		轉義字串。

		.. warning:: 傳回的字串沒有用引號引起來。

	.. php:method:: escape_like_str($str)

		:param	mixed	$str: A string value or array of multiple ones
		:returns:	The escaped string(s)
		:rtype:	mixed

		轉義 LIKE 字串。

		和 ``escape_str()`` 成員函數類似，但同時也對 LIKE 語句中的 ``%`` 和 ``_``
		通配符進行轉義。

		.. important:: The ``escape_like_str()`` method uses '!' (exclamation mark)
			to escape special characters for *LIKE* conditions. Because this
			method escapes partial strings that you would wrap in quotes
			yourself, it cannot automatically add the ``ESCAPE '!'``
			condition for you, and so you'll have to manually do that.


	.. php:method:: primary($table)

		:param	string	$table: Table name
		:returns:	The primary key name, FALSE if none
		:rtype:	string

		讀取一個表的主鍵。

		.. note:: 如果資料庫不支援主鍵檢測，將假設第一列就是主鍵。

	.. php:method:: count_all([$table = ''])

		:param	string	$table: Table name
		:returns:	Row count for the specified table
		:rtype:	int

		傳回表中的總記錄數。

	.. php:method:: list_tables([$constrain_by_prefix = FALSE])

		:param	bool	$constrain_by_prefix: TRUE to match table names by the configured dbprefix
		:returns:	Array of table names or FALSE on failure
		:rtype:	array

		傳回目前資料庫的所有表。

	.. php:method:: table_exists($table_name)

		:param	string	$table_name: The table name
		:returns:	TRUE if that table exists, FALSE if not
		:rtype:	bool

		判斷某個資料庫表是否存在。

	.. php:method:: list_fields($table)

		:param	string	$table: The table name
		:returns:	Array of field names or FALSE on failure
		:rtype:	array

		傳回某個表的所有字段名稱。

	.. php:method:: field_exists($field_name, $table_name)

		:param	string	$table_name: The table name
		:param	string	$field_name: The field name
		:returns:	TRUE if that field exists in that table, FALSE if not
		:rtype:	bool

		判斷某個字段是否存在。

	.. php:method:: field_data($table)

		:param	string	$table: The table name
		:returns:	Array of field data items or FALSE on failure
		:rtype:	array

		讀取某個表的所有字段資訊。

	.. php:method:: escape_identifiers($item)

		:param	mixed	$item: The item or array of items to escape
		:returns:	The input item(s), escaped
		:rtype:	mixed

		對 SQL 標識符進行轉義，例如列名稱、表名稱、關鍵字。

	.. php:method:: insert_string($table, $data)

		:param	string	$table: The target table
		:param	array	$data: An associative array of key/value pairs
		:returns:	The SQL INSERT statement, as a string
		:rtype:	string

		產生 INSERT 語句。

	.. php:method:: update_string($table, $data, $where)

		:param	string	$table: The target table
		:param	array	$data: An associative array of key/value pairs
		:param	mixed	$where: The WHERE statement conditions
		:returns:	The SQL UPDATE statement, as a string
		:rtype:	string

		產生 UPDATE 語句。

	.. php:method:: call_function($function)

		:param	string	$function: Function name
		:returns:	The function result
		:rtype:	string

		使用一種平台無關的方式執行一個原生的 PHP 函數。

	.. php:method:: cache_set_path([$path = ''])

		:param	string	$path: Path to the cache directory
		:rtype:	void

		設定快取路徑。

	.. php:method:: cache_on()

		:returns:	TRUE if caching is on, FALSE if not
		:rtype:	bool

		啟用資料庫結果快取。

	.. php:method:: cache_off()

		:returns:	TRUE if caching is on, FALSE if not
		:rtype:	bool

		停用資料庫結果快取。

	.. php:method:: cache_delete([$segment_one = ''[, $segment_two = '']])

		:param	string	$segment_one: First URI segment
		:param	string	$segment_two: Second URI segment
		:returns:	TRUE on success, FALSE on failure
		:rtype:	bool

		刪除特定 URI 的快取檔案。

	.. php:method:: cache_delete_all()

		:returns:	TRUE on success, FALSE on failure
		:rtype:	bool

		刪除所有快取檔案。

	.. php:method:: close()

		:rtype:	void

		關閉資料庫的連接。

	.. php:method:: display_error([$error = ''[, $swap = ''[, $native = FALSE]]])

		:param	string	$error: The error message
		:param	string	$swap: Any "swap" values
		:param	bool	$native: Whether to localize the message
		:rtype:	void
		:returns:	Displays the DB error screensends the application/views/errors/error_db.php template

		顯示一個錯誤資訊，並終止腳本執行。

		錯誤資訊是使用 *application/views/errors/error_db.php* 文件中的模板來顯示。

	.. php:method:: protect_identifiers($item[, $prefix_single = FALSE[, $protect_identifiers = NULL[, $field_exists = TRUE]]])

		:param	string	$item: The item to work with
		:param	bool	$prefix_single: Whether to apply the dbprefix even if the input item is a single identifier
		:param	bool	$protect_identifiers: Whether to quote identifiers
		:param	bool	$field_exists: Whether the supplied item contains a field name or not
		:returns:	The modified item
		:rtype:	string

		依據設定的 *dbprefix* 參數，給列名稱或表名稱（可能是表別名）加入一個前綴。

		為了處理包含路徑的列名稱，必須要考慮一些邏輯。

		例如下面的查詢::

			SELECT * FROM hostname.database.table.column AS c FROM hostname.database.table

		或者下面這個查詢，使用了表別名::

			SELECT m.member_id, m.member_name FROM members AS m

		由於列名稱可以包含四段（主機、資料庫名稱、表名稱、字段名稱）或者有一個表別名的前綴，
		我們需要做點工作來判斷這一點，才能將 *dbprefix* 插入到正確的位置。

		該成員函數在查詢產生器類中被廣泛使用。
