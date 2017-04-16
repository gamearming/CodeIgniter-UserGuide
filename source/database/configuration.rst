######################
資料庫設定
######################

CodeIgniter 提供資料庫連線的組態設定檔，用來儲存用戶名稱、密碼、資料庫名稱等等，設定檔位於 application/config/database.php。

更可以在 **database.php** 為特定的資料庫的相應資料夾設定各自的連線設定。 

請參閱 :doc:`environments <../libraries/config>` 一節：


組態設定是以多維陣列類型儲存。

原型如下::

	$db['default'] = array(
		'dsn'	=> '',
		'hostname' => 'localhost',
		'username' => 'root',
		'password' => '',
		'database' => 'database_name',
		'dbdriver' => 'mysqli',
		'dbprefix' => '',
		'pconnect' => TRUE,
		'db_debug' => TRUE,
		'cache_on' => FALSE,
		'cachedir' => '',
		'char_set' => 'utf8',
		'dbcollat' => 'utf8_general_ci',
		'swap_pre' => '',
		'encrypt' => FALSE,
		'compress' => FALSE,
		'stricton' => FALSE,
		'failover' => array()
	);

有些資料庫驅動可能需要提供完整的 DSN 字串（例如： PDO、PostgreSQL、Oracle、ODBC），如此便需要設定 'dsn' 參數，等同使用該驅動在 PHP 原生擴展函數。

例如::

	// PDO
	$db['default']['dsn'] = 'pgsql:host=localhost;port=5432;dbname=database_name';

	// Oracle
	$db['default']['dsn'] = '//localhost/XE';

.. note:: 如果沒有為需要 DSN 參數的驅動指定 DSN 字串，CodeIgniter 則依其他設定資訊自動產生。

.. note:: 如果提供 DSN 字串，但缺少了某些設定（例如： 資料庫的字元集），CodeIgniter 則依其他設定資訊自動附加到 DSN 參數。

當主要資料庫發生未知原因無法連線時，您可以設定多個故障接管（failover）。

以下是連線故障接管設定範例::

	$db['default']['failover'] = array(
			array(
				'hostname' => 'localhost1',
				'username' => '',
				'password' => '',
				'database' => '',
				'dbdriver' => 'mysqli',
				'dbprefix' => '',
				'pconnect' => TRUE,
				'db_debug' => TRUE,
				'cache_on' => FALSE,
				'cachedir' => '',
				'char_set' => 'utf8',
				'dbcollat' => 'utf8_general_ci',
				'swap_pre' => '',
				'encrypt' => FALSE,
				'compress' => FALSE,
				'stricton' => FALSE
			),
			array(
				'hostname' => 'localhost2',
				'username' => '',
				'password' => '',
				'database' => '',
				'dbdriver' => 'mysqli',
				'dbprefix' => '',
				'pconnect' => TRUE,
				'db_debug' => TRUE,
				'cache_on' => FALSE,
				'cachedir' => '',
				'char_set' => 'utf8',
				'dbcollat' => 'utf8_general_ci',
				'swap_pre' => '',
				'encrypt' => FALSE,
				'compress' => FALSE,
				'stricton' => FALSE
			)
		);

我們使用多維陣列的原因是為了讓您在多個環境中（如： 開發、發佈、測試 等），能自由的切換設定。

例如要使用「test」環境，您可以這樣做::

	$db['test'] = array(
		'dsn'	=> '',
		'hostname' => 'localhost',
		'username' => 'root',
		'password' => '',
		'database' => 'database_name',
		'dbdriver' => 'mysqli',
		'dbprefix' => '',
		'pconnect' => TRUE,
		'db_debug' => TRUE,
		'cache_on' => FALSE,
		'cachedir' => '',
		'char_set' => 'utf8',
		'dbcollat' => 'utf8_general_ci',
		'swap_pre' => '',
		'compress' => FALSE,
		'encrypt' => FALSE,
		'stricton' => FALSE,
		'failover' => array()
	);

然後組態設定檔中的 ``$active_group`` 變數，告訴系統要使用「test」環境::

	$active_group = 'test';

.. note:: 環境名稱「test」是可以取任意名稱。主要連線預設值是使用「default」名稱，您當然也可以為專案取一個易於識別的名稱。

查詢產生器
-------------

資料庫組態設定檔裡的 ``$query_builder`` 變數對 :doc:`查詢產生器類別 <query_builder>` 進行全區的設定（啟用/停用 設成 TRUE/FALSE，預設是 TRUE）。

如果您不用這個類別，那麼這個變數值設定成 FALSE 來減少資料庫類別在初始化時對主機資源的消耗。

::

	$query_builder = TRUE;

.. note:: CodeIgniter 的類別，例如 Sessions，在執行相關函數的時，需要查詢產生器的支援。

參數解釋：
----------------------

======================  =======================================================================================================
 設定名稱                  描述
======================  =======================================================================================================
**dsn**                 DSN 連線字串（該字串包含了所有的資料庫設定資訊）。
**hostname**            資料庫的主機名稱，通常位於本機，可以表示為 "localhost"。
**username**            要連線資料庫的用戶名稱。
**password**            登入資料庫的密碼。
**database**            要連線的資料庫名稱。
**dbdriver**            資料庫類別驅動名稱。如：mysql、postgres、odbc 等。必須為小寫字母。
**dbprefix**            當使用 :doc:`查詢產生器 <query_builder>` 查詢時，可以選擇性的為資料表加前綴名稱，並允許在一個資料庫上安裝多個 CodeIgniter 框架。
**pconnect**            TRUE/FALSE (boolean) - 是否使用持續連線。
**db_debug**            TRUE/FALSE (boolean) - 是否顯示資料庫錯誤資訊。
**cache_on**            TRUE/FALSE (boolean) - 是否開啟資料庫查詢快取，詳情請參閱 :doc:`資料庫快取類別 <caching>`。
**cachedir**            資料庫查詢快取目錄所在伺服器的絕對路徑。
**char_set**            與資料庫通信時所使用的字元集。
**dbcollat**            與資料庫通信時所使用的字元規則。

                        .. note:: 僅適用於 'mysql' 和 'mysqli' 資料庫驅動程式。

**swap_pre**            取代預設的 ``dbprefix`` 表前綴，該項設定對於分佈式應用是非常有用的，您可以在查詢中使用由最終用戶定制的資料表前綴。
**schema**              資料庫模式，預設為 'public' 適用於 PostgreSQL 和 ODBC 驅動程式。
**encrypt**             是否使用加密連線。

                        - 'mysql' (deprecated), 'sqlsrv' 和 'pdo/sqlsrv' 驅動程式接受 TRUE/FALSE
                        - 'mysqli' 和 'pdo/mysql' 驅動程式接受以下陣列選項:

                        - 'ssl_key'    - 私密金鑰檔案的路徑。
                        - 'ssl_cert'   - 公開金鑰證書檔案的路徑。
                        - 'ssl_ca'     - 憑證授權單位檔案的路徑。
                        - 'ssl_capath' - 含 PEM 格式的受信任 CA 證書的路徑。
                        - 'ssl_cipher' - 用於加密的 *allowed* 密碼清單，以冒號 (':') 分隔。
                        - 'ssl_verify' - TRUE/FALSE; 是否驗證伺服器證書 (僅適用於 'mysqli')

**compress**            TRUE/FALSE (boolean) - 是否使用客戶端壓縮協議（僅適用於 MySQL）
**stricton**            TRUE/FALSE (boolean) - 是否強制使用 "Strict Mode" 連線，在開發程式時，使用 strict SQL 是一個好習慣。
**port**                資料庫連接埠編號，要使用這個值，您應該加入以下程式碼到資料庫設定陣列。
                        ::

                        $db['default']['port'] = 5432;
======================  =======================================================================================================

.. note:: 依據您使用的資料庫平台（MySQL, PostgreSQL 等），並非所有的參數都是必須的。例如： 使用 SQLite 時，無需指定用戶名稱和密碼，資料庫名稱是資料庫文件的路徑。以上內容假設您使用的是 MySQL 資料庫。
