#####################
自定義函數呼叫
#####################

$this->db->call_function();
============================

這個成員函數用於執行 CodeIgniter 中未定義的 PHP 資料庫原生函數，且使用的是獨立平台的方式。

舉個範例，假設要呼叫 mysql_get_client_info() 函數，因為它在 CodeIgniter 中是未定義的 PHP 原生函式。

您可以這樣做::

  $this->db->call_function('get_client_info');

- 提供一個 mysql\_ 沒有前綴名稱的函數作為第一個參數，而這個參數的前綴名稱會依據所使用的資料庫驅動自動加入。
- 如此便能在不同的資料庫平台執行相同的函數，但並非所有的資料庫平台函數都是相同，所以可移植性是非常有限的。

任何您需要的其它參數都放在第一個參數後面。

::

  $this->db->call_function('some_function', $param1, $param2, etc..);

您經常需要提供資料庫的 connection ID 或 result ID。

connection ID 可以這樣來獲得::

  $this->db->conn_id;

result ID 可以從查詢傳回的結果物件讀取。

像這樣::

  $query = $this->db->query("SOME QUERY");
  $query->result_id;
