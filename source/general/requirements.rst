###################
伺服器要求
###################

推薦使用 `PHP <http://php.net/>`_ 5.6 或更新版本。

雖然 CodeIgniter 也可以在 PHP 5.3.7 上執行，但是出於潛在的安全和性能問題，
我們強烈建議您不要使用這麼老版本的 PHP，而且老版本的 PHP 也會缺少很多特性。

大多數的 Web 應用程式應該都需要一個資料庫。目前 CodeIgniter 支援下列資料庫：

  - MySQL (5.1+)，驅動有：*mysql* （已廢棄），*mysqli* 和 *pdo*
  - Oracle，驅動有：*oci8* 和 *pdo*
  - PostgreSQL，驅動有：*postgre* 和 *pdo*
  - MS SQL，驅動有：*mssql*，*sqlsrv* （2005及以上版本）和 *pdo*
  - SQLite，驅動有：*sqlite* （版本2），*sqlite3* （版本3）和 *pdo*
  - CUBRID，驅動有：*cubrid* 和 *pdo*
  - Interbase/Firebird，驅動有：*ibase* 和 *pdo*
  - ODBC：驅動有：*odbc* 和 *pdo* （需要知道的是，ODBC 其實只是資料庫抽像層）
