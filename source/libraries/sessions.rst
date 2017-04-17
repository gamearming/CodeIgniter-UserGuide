###############
Session 類
###############

Session（會話）類可以讓您保持一個用戶的 "狀態" ，並跟蹤他在瀏覽您的網站時的活動。

CodeIgniter 自帶了幾個儲存 session 的驅動：

  - 文件（預設的，基於檔案系統）
  - 資料庫
  - Redis
  - Memcached

另外，您也可以基於其他的儲存機制來建立您自己的自定義 session 儲存驅動，
使用自定義的驅動，同樣也可以使用 Session 類提供的那些功能。

.. contents::
  :local:

.. raw:: html

  <div class="custom-index container"></div>

***********************
使用 Session 類
***********************

初始化 Session 類
======================

Session 通常會在每個頁面載入的時候全區執行，所以 Session 類必須首先被初始化。
您可以在 :doc:`控制器 <../general/controllers>` 的構造函數中初始化它，
也可以在系統中 :doc:`自動載入 <../general/autoloader>`。Session 類基本上都是在後台執行，
您不會注意到。所以當初始化 session 之後，系統會自動讀取、建立和更新 session 資料 。

要手動初始化 Session 類，您可以在控制器的構造函數中使用 ``$this->load->library()``
成員函數::

	$this->load->library('session');

初始化之後，就可以使用下面的成員函數來存取 Session 物件了::

	$this->session

.. important:: 由於 :doc:`載入類 </libraries/loader>` 是在 CodeIgniter 的控制器基類中執行緒化的，
	所以如果要在您的控制器構造函數中載入類庫的話，確保先呼叫 ``parent::__construct()`` 成員函數。

Session 是如何工作的？
=======================

當頁面載入後，Session 類就會檢查用戶的 cookie 中是否存在有效的 session 資料。
如果 session 資料不存在（或者與服務端不匹配，或者已經過期），
那麼就會建立一個新的 session 並儲存起來。

如果 session 資料存在並且有效，那麼就會更新 session 的資訊。
依據您的設定，每一次更新都會產生一個新的 Session ID 。

有一點非常重要，您需要瞭解一下，Session 類一旦被初始化，它就會自動執行。
上面所說的那些，您完全不用做任何操作。正如接下來您將看到的那樣，
您可以正常的使用 session 資料，至於讀、寫和更新 session 的操作都是自動完成的。

.. note:: 在 CLI 模式下，Session 類將自動關閉，這種做法完全是基於 HTTP 協議的。

關於並發的注意事項
----------------------------------

如果您開發的網站並不是大量的使用 AJAX 技術，那麼您可以跳過這一節。
如果您的網站是大量的使用了 AJAX，並且遇到了性能問題，那麼下面的注意事項，
可能正是您需要的。

在 CodeIgniter 之前的版本中，Session 類並沒有實現鎖機制，這也就意味著，
兩個 HTTP 請求可能會同時使用同一個 session 。說的更專業點就是，
請求是非阻塞的。（requests were non-blocking）

在處理 session 時使用非阻塞的請求同樣意味著不安全，因為在一個請求中修改 session
資料（或重新產生 Session ID）會對並發的第二個請求造成影響。這是導致很多問題的根源，
同時也是為什麼 CodeIgniter 3.0 對 Session 類完全重寫的原因。

那麼為什麼要告訴您這些呢？這是因為在您查找性能問題的原因時，
可能會發現加鎖機制正是導致性能問題的罪魁禍首，因此就想著如何去掉鎖 ...

**請不要這樣做！** 去掉加鎖機制是完全錯誤的，它會給您帶來更多的問題！

鎖並不是問題，它是一種解決方案。您的問題是當 session 已經處理完畢不再需要時，
您還將 session 保持是打開的狀態。所以，您需要做的其實是，當結束目前請求時，
將不再需要的 session 關閉掉。

簡單來說就是：當您不再需要使用某個 session 變數時，就使用 ``session_write_close()`` 成員函數來關閉它。

什麼是 Session 資料？
=====================

Session 資料是個簡單的陣列，帶有一個特定的 session ID （cookie）。

如果您之前在 PHP 裡使用過 session ，您應該對 PHP 的 `$_SESSION 全區變數 <http://php.net/manual/en/reserved.variables.session.php>`_
很熟悉（如果沒有，請閱讀下鏈接中的內容）。

CodeIgniter 使用了相同的方式來存取 session 資料，同時使用了 PHP 自帶的 session 處理機制，
使用 session 資料和操作 ``$_SESSION`` 陣列一樣簡單（包括讀取，設定，取消設定）。

另外，CodeIgniter 還提供了兩種特殊類型的 session 資料：flashdata 和 tempdata ，在下面將有介紹。

.. note:: 在之前的 CodeIgniter 版本中，一般的 session 資料被稱之為 'userdata' ，當文件中出現這個詞時請記住這一點。
	大部分都是用於解釋自定義 'userdata' 成員函數是如何工作的。

讀取 Session 資料
=======================

session 陣列中的任何資訊都可以通過 ``$_SESSION`` 全區變數讀取::

	$_SESSION['item']

或使用下面的成員函數（magic getter）::

	$this->session->item

同時，為了和之前的版本相容，也可以使用 ``userdata()`` 成員函數::

	$this->session->userdata('item');

其中，item 是您想讀取的陣列的鍵值。例如，將 'name' 鍵值對應的項賦值給 ``$name`` 變數，
您可以這樣::

	$name = $_SESSION['name'];

	// or:

	$name = $this->session->name

	// or:

	$name = $this->session->userdata('name');

.. note:: 如果您存取的項不存在，``userdata()`` 成員函數傳回 NULL 。

如果您想讀取所有已存在的 userdata ，您可以忽略 item 參數::

	$_SESSION

	// or:

	$this->session->userdata();

加入 Session 資料
===================

假設某個用戶存取您的網站，當他完成認證之後，您可以將他的用戶名和 email 地址加入到 session 中，
這樣當您需要的時候您就可以直接存取這些資料，而不用查詢資料庫了。

您可以簡單的將資料賦值給 ``$_SESSION`` 陣列，或賦值給 ``$this->session`` 的某個屬性。

同時，老版本中的通過 "userdata" 來賦值的成員函數也還可以用，只不過是需要傳遞一個包含您的資料的陣列
給 ``set_userdata()`` 成員函數::

	$this->session->set_userdata($array);

其中，``$array`` 是包含新增資料的一個關聯陣列，下面是個範例::

	$newdata = array(
		'username'  => 'johndoe',
		'email'     => 'johndoe@some-site.com',
		'logged_in' => TRUE
	);

	$this->session->set_userdata($newdata);

如果您想一次只加入一個值，``set_userdata()`` 也支援這種語法::

	$this->session->set_userdata('some_name', 'some_value');

如果您想檢查某個 session 值是否存在，可以使用 ``isset()``::

	// returns FALSE if the 'some_name' item doesn't exist or is NULL,
	// TRUE otherwise:
	isset($_SESSION['some_name'])

或者，您也可以使用 ``has_userdata()``::

	$this->session->has_userdata('some_name');

刪除 Session 資料
=====================

和其他的變數一樣，可以使用 ``unset()`` 成員函數來刪除 ``$_SESSION`` 陣列中的某個值::

	unset($_SESSION['some_name']);

	// or multiple values:

	unset(
		$_SESSION['some_name'],
		$_SESSION['another_name']
	);

同時，正如 ``set_userdata()`` 成員函數可用於向 session 中加入資料，``unset_userdata()``
成員函數可用於刪除指定鍵值的資料。例如，如果您想從您的 session 陣列中刪除 'some_name'::

	$this->session->unset_userdata('some_name');

這個成員函數也可以使用一個陣列來同時刪除多個值::

	$array_items = array('username', 'email');

	$this->session->unset_userdata($array_items);

.. note:: 在 CodeIgniter 之前的版本中，``unset_userdata()`` 成員函數接受一個關聯陣列，
	包含 ``key => 'dummy value'`` 這樣的鍵值對，這種方式不再支援。

Flashdata
=========

CodeIgniter 支援 "flashdata" ，它指的是一種只對下一次請求有效的 session 資料，
之後將會自動被清除。

這用於一次性的資訊時特別有用，例如錯誤或狀態資訊（諸如 "第二條記錄刪除成功" 這樣的資訊）。

要注意的是，flashdata 就是一般的 session 變數，只不過以特殊的方式儲存在 '__ci_vars' 鍵下
（警告：請不要亂動這個值）。

將已有的值標記為 "flashdata"::

	$this->session->mark_as_flash('item');

通過傳一個陣列，同時標記多個值為 flashdata::

	$this->session->mark_as_flash(array('item', 'item2'));

使用下面的成員函數來加入 flashdata::

	$_SESSION['item'] = 'value';
	$this->session->mark_as_flash('item');

或者，也可以使用 ``set_flashdata()`` 成員函數::

	$this->session->set_flashdata('item', 'value');

您還可以傳一個陣列給 ``set_flashdata()`` 成員函數，和 ``set_userdata()`` 成員函數一樣。

讀取 flashdata 和讀取一般的 session 資料一樣，通過 ``$_SESSION`` 陣列::

	$_SESSION['item']

.. important:: ``userdata()`` 成員函數不會傳回 flashdata 資料。

如果您要確保您讀取的就是 "flashdata" 資料，而不是其他類型的資料，可以使用 ``flashdata()`` 成員函數::

	$this->session->flashdata('item');

或者不傳參數，直接傳回所有的 flashdata 陣列::

	$this->session->flashdata();

.. note:: 如果讀取的值不存在，``flashdata()`` 成員函數傳回 NULL 。

如果您需要在另一個請求中還繼續保持 flashdata 變數，您可以使用 ``keep_flashdata()`` 成員函數。
可以傳一個值，或包含多個值的一個陣列。

::

	$this->session->keep_flashdata('item');
	$this->session->keep_flashdata(array('item1', 'item2', 'item3'));

Tempdata
========

CodeIgniter 還支援 "tempdata" ，它指的是一種帶有有效時間的 session 資料，
當它的有效時間已過期，或在有效時間內被刪除，都會自動被清除。

和 flashdata 一樣， tempdata 也是一般的 session 變數，只不過以特殊的方式儲存在 '__ci_vars' 鍵下
（再次警告：請不要亂動這個值）。

將已有的值標記為 "tempdata" ，只需簡單的將要標記的鍵值和過期時間（單位為秒）傳給
``mark_as_temp()`` 成員函數即可::

	// 'item' will be erased after 300 seconds
	$this->session->mark_as_temp('item', 300);

您也可以同時標記多個值為 tempdata ，有下面兩種不同的方式，
這取決於您是否要將所有的值都設定成相同的過期時間::

	// Both 'item' and 'item2' will expire after 300 seconds
	$this->session->mark_as_temp(array('item', 'item2'), 300);

	// 'item' will be erased after 300 seconds, while 'item2'
	// will do so after only 240 seconds
	$this->session->mark_as_temp(array(
		'item'	=> 300,
		'item2'	=> 240
	));

使用下面的成員函數來加入 tempdata::

	$_SESSION['item'] = 'value';
	$this->session->mark_as_temp('item', 300); // Expire in 5 minutes

或者，也可以使用 ``set_tempdata()`` 成員函數::

	$this->session->set_tempdata('item', 'value', 300);

您還可以傳一個陣列給 ``set_tempdata()`` 成員函數::

	$tempdata = array('newuser' => TRUE, 'message' => 'Thanks for joining!');

	$this->session->set_tempdata($tempdata, NULL, $expire);

.. note:: 如果沒有設定 expiration 參數，或者設定為 0 ，將預設使用 300秒（5分鐘）作為生存時間（time-to-live）。

要讀取 tempdata 資料，您可以再一次通過 ``$_SESSION`` 陣列::

	$_SESSION['item']

.. important:: ``userdata()`` 成員函數不會傳回 tempdata 資料。

如果您要確保您讀取的就是 "tempdata" 資料，而不是其他類型的資料，可以使用 ``tempdata()`` 成員函數::

	$this->session->tempdata('item');

或者不傳參數，直接傳回所有的 tempdata 陣列::

	$this->session->tempdata();

.. note:: 如果讀取的值不存在，``tempdata()`` 成員函數傳回 NULL 。

如果您需要在某個 tempdata 過期之前刪除它，您可以直接通過 ``$_SESSION`` 陣列來刪除::

	unset($_SESSION['item']);

但是，這不會刪除這個值的 tempdata 標記（會在下一次 HTTP 請求時失效），所以，
如果您打算在相同的請求中重用這個值，您可以使用 ``unset_tempdata()``::

	$this->session->unset_tempdata('item');

銷毀 Session
====================

要清除目前的 session（例如：退出登入時），您可以簡單的使用 PHP 自帶的
`session_destroy() <http://php.net/session_destroy>`_ 函數或者 ``sess_destroy()`` 成員函數。
兩種方式效果完全一樣::

	session_destroy();

	// or

	$this->session->sess_destroy();

.. note:: 這必須是同一個請求中關於 session 的最後一次操作，所有的 session 資料（包括 flashdata
	和 tempdata）都被永久性銷毀，銷毀之後，關於 session 的成員函數將不可用。

存取 session 元資料
==========================

在之前的 CodeIgniter 版本中，session 資料預設包含 4 項：'session_id' 、 'ip_address' 、 'user_agent' 、 'last_activity' 。

這是由 session 具體的工作方式決定的，但是我們現在的實現沒必要這樣做了。
儘管如此，您的應用程式可能還相依於這些值，所以下面提供了存取這些值的替代成員函數：

  - session_id: ``session_id()``
  - ip_address: ``$_SERVER['REMOTE_ADDR']``
  - user_agent: ``$this->input->user_agent()`` (unused by sessions)
  - last_activity: 取決於 session 的儲存方式，沒有直接的成員函數，抱歉！

Session 參數
===================

在 CodeIgniter 中通常所有的東西都是拿來直接就可以用的，儘管如此，session 對於所有的程序來說，
都是一個非常敏感的部分，所以必須要小心的設定它。請花點時間研究下下面所有的選項以及每個選項的作用。

您可以在您的設定文件 **application/config/config.php** 中找到下面的關於 session 的設定參數：

============================ =============== ======================================== ============================================================================================
參數                               預設值         選項                                  描述
============================ =============== ======================================== ============================================================================================
**sess_driver**              files           files/database/redis/memcached/*custom*  使用的儲存 session 的驅動
**sess_cookie_name**         ci_session      [A-Za-z\_-] characters only              session cookie 的名稱
**sess_expiration**          7200 (2 hours)  Time in seconds (integer)                您希望 session 持續的秒數
                                                                                      如果您希望 session 不過期（直到瀏覽器關閉），將其設定為 0
**sess_save_path**           NULL            None                                     指定儲存位置，取決於使用的儲存 session 的驅動
**sess_match_ip**            FALSE           TRUE/FALSE (boolean)                     讀取 session cookie 時，是否驗證用戶的 IP 地址
                                                                                      注意有些 ISP 會動態的修改 IP ，所以如果您想要一個不過期的 session，將其設定為 FALSE
**sess_time_to_update**      300             Time in seconds (integer)                該選項用於控制過多久將重新產生一個新 session ID
                                                                                      設定為 0 將停用 session ID 的重新產生
**sess_regenerate_destroy**  FALSE           TRUE/FALSE (boolean)                     當自動重新產生 session ID 時，是否銷毀老的 session ID 對應的資料
                                                                                      如果設定為 FALSE ，資料之後將自動被垃圾回收器刪除
============================ =============== ======================================== ============================================================================================

.. note:: 如果上面的某個參數沒有設定，Session 類將會試圖讀取 php.ini 設定文件中的 session 相關的設定
	（例如 'sess_expire_on_close'）。但是，請不要相依於這個行為，因為這可能會導致不可預期的結果，而且
	這也有可能在未來的版本中修改。請合理的設定每一個參數。

除了上面的這些參數之外，cookie 和 session 原生的驅動還會公用下面這些
由 :doc:`輸入類 <input>` 和 :doc:`安全類 <security>` 提供的設定參數。

================== =============== ===========================================================================
參數                 預設值         描述
================== =============== ===========================================================================
**cookie_domain**  ''              session 可用的域
**cookie_path**    /               session 可用的路徑
**cookie_secure**  FALSE           是否只在加密連接（HTTPS）時建立 session cookie
================== =============== ===========================================================================

.. note:: 'cookie_httponly' 設定對 session 沒有影響。出於安全原因，HttpOnly 參數將一直啟用。
	另外，'cookie_prefix' 參數完全可以忽略。

Session 驅動
===============

正如上面提到的，Session 類自帶了 4 種不同的驅動（或叫做儲存引擎）可供使用：

  - files
  - database
  - redis
  - memcached

預設情況下，初始化 session 時將使用 `文件驅動`_ ，因為這是最安全的選擇，可以在所有地方按預期工作
（幾乎所有的環境下都有檔案系統）。

但是，您也可以通過 **application/config/config.php** 設定文件中的 ``$config['sess_driver']``
參數來使用任何其他的驅動。特別提醒的是，每一種驅動都有它自己的注意事項，所以在您選擇之前，
確定您熟悉它們。

另外，如果預設提供的這些不能滿足您的需求，您也可以建立和使用 `自定義驅動`_ 。

.. note:: 在之前版本的 CodeIgniter 中，只有 "cookie 驅動" 這唯一的一種選擇，
	因為這個我們收到了大量的負面的反饋。因此，我們吸取了社區的反饋意見，同時也要提醒您，
	因為它**不安全**，所以已經被廢棄了，建議您不要試著通過 自定義驅動 來重新實現它。

文件驅動
------------

文件驅動利用您的檔案系統來儲存 session 資料。

可以說，文件驅動和 PHP 自帶的預設 session 實現非常類似，但是有一個很重要的細節要注意的是，
實際上它們的程式碼並不相同，而且有一些局限性（以及優勢）。

說的更具體點，它不支援 PHP 的 `session.save_path 參數的 資料夾分級（directory level）和 mode 格式
<http://php.net/manual/en/session.configuration.php#ini.session.save-path>`_ ，
另外為了安全性大多數的參數都被硬編碼。只提供了 ``$config['sess_save_path']`` 參數用於設定絕對路徑。

另一個很重要的事情是，確儲存儲 session 文件的資料夾不能被公開存取到或者是共享資料夾，確保 **只有您**
能存取並查看設定的 *sess_save_path* 資料夾中的內容。否則，如果任何人都能存取，
他們就可以從中竊取到目前的 session （這也被稱為 session 固定（session fixation）攻擊）

在類 UNIX 操作系統中，這可以通過在該資料夾上執行 `chmod` 命令，將權限設定為 0700 來實現，
這樣就可以只允許資料夾的所有者執行讀取和寫入操作。但是要注意的是，腳本的執行者通常不是您自己，
而是類似於 'www-data' 這樣的用戶，所以只設定權限可能會破壞您的程序。

依據您的環境，您應該像下面這樣來操作。
::

	mkdir /<path to your application directory>/sessions/
	chmod 0700 /<path to your application directory>/sessions/
	chown www-data /<path to your application directory>/sessions/

小提示
^^^^^^^^^

有些人可能會選擇使用其他的 session 驅動，他們認為文件儲存通常比較慢。其實這並不總是對的。

執行一些簡單的測試可能會讓您真的相信 SQL 資料庫更快一點，但是在 99% 的情況下，這只是當您的
session 並發非常少的時候是對的。當 session 的並發數越來越大，伺服器的負載越來越高，
這時就不一樣了，檔案系統將會勝過幾乎所有的關係型資料庫。

另外，如果性能是您唯一關心的，您可以看下 `tmpfs <http://eddmann.com/posts/storing-php-sessions-file-caches-in-memory-using-tmpfs/>`_
（注意：外部資源），它可以讓您的 session 非常快。

資料庫驅動
---------------

資料庫驅動使用諸如 MySQL 或 PostgreSQL 這樣的關係型資料庫來儲存 session ，
這是一個非常常見的選擇，因為它可以讓開發者非常方便的存取應用中的 session 資料，
因為它只是您的資料庫中的一個表而已。

但是，還是有幾點要求必須滿足：

  - 只有設定為 **default** 的資料庫連接可以使用（或者在控制器中使用 ``$this->db`` 來存取的連接）
  - 您必須啟用 :doc:`查詢產生器 </database/query_builder>`
  - 不能使用持久連接
  - 使用的資料庫連接不能啟用 *cache_on* 參數

為了使用資料庫驅動，您還需要建立一個我們剛剛已經提到的資料表，然後將 ``$config['sess_save_path']``
參數設定為表名。例如，如果您想使用 'ci_sessions' 這個表名，您可以這樣::

	$config['sess_driver'] = 'database';
	$config['sess_save_path'] = 'ci_sessions';

.. note:: 如果您從 CodeIgniter 之前的版本中升級過來的，並且沒有設定 'sess_save_path' 參數，
	Session 類將查找並使用老的 'sess_table_name' 參數替代。請不要相依這個行為，
	因為它可能會在以後的版本中移除。

然後，新建資料表 。

對於 MySQL::

	CREATE TABLE IF NOT EXISTS `ci_sessions` (
		`id` varchar(128) NOT NULL,
		`ip_address` varchar(45) NOT NULL,
		`timestamp` int(10) unsigned DEFAULT 0 NOT NULL,
		`data` blob NOT NULL,
		KEY `ci_sessions_timestamp` (`timestamp`)
	);

對於 PostgreSQL::

	CREATE TABLE "ci_sessions" (
		"id" varchar(128) NOT NULL,
		"ip_address" varchar(45) NOT NULL,
		"timestamp" bigint DEFAULT 0 NOT NULL,
		"data" text DEFAULT '' NOT NULL
	);

	CREATE INDEX "ci_sessions_timestamp" ON "ci_sessions" ("timestamp");

You will also need to add a PRIMARY KEY **depending on your 'sess_match_ip'
setting**. The examples below work both on MySQL and PostgreSQL::

	// When sess_match_ip = TRUE
	ALTER TABLE ci_sessions ADD PRIMARY KEY (id, ip_address);

	// When sess_match_ip = FALSE
	ALTER TABLE ci_sessions ADD PRIMARY KEY (id);

	// To drop a previously created primary key (use when changing the setting)
	ALTER TABLE ci_sessions DROP PRIMARY KEY;


.. important:: 只有 MySQL 和 PostgreSQL 資料庫是被正式支援的，因為其他資料庫平台都缺乏合適的鎖機制。
	在沒鎖的情況下使用 session 可能會導致大量的問題，特別是使用了大量的 AJAX ，
	所以我們並不打算支援這種情況。如果您遇到了性能問題，請您在完成 session 資料的處理之後，
	呼叫 ``session_write_close()`` 成員函數。

Redis 驅動
------------

.. note:: 由於 Redis 沒有鎖機制，這個驅動的鎖是通過一個保持 300 秒的值來模擬的
	（emulated by a separate value that is kept for up to 300 seconds）。

Redis 是一種儲存引擎，通常用於快取，並由於他的高性能而流行起來，這可能也正是您使用 Redis 驅動的原因。

缺點是它並不像關係型資料庫那樣普遍，需要您的系統中安裝了 `phpredis <https://github.com/phpredis/phpredis>`_
這個 PHP 擴展，它並不是 PHP 程序自帶的。
可能的情況是，您使用 Redis 驅動的原因是您已經非常熟悉 Redis 了並且您使用它還有其他的目的。

和文件驅動和資料庫驅動一樣，您必須通過 ``$config['sess_save_path']`` 參數來設定儲存 session 的位置。
這裡的格式有些不同，同時也要複雜一點，這在 *phpredis* 擴展的 README 文件中有很好的解釋，鏈接如下::

	https://github.com/phpredis/phpredis#php-session-handler

.. warning:: CodeIgniter 的 Session 類並沒有真的用到 'redis' 的 ``session.save_handler`` ，
	**只是** 採用了它的路徑的格式而已。

最常見的情況是，一個簡單 ``host:port`` 對就可以了::

	$config['sess_driver'] = 'redis';
	$config['sess_save_path'] = 'tcp://localhost:6379';

Memcached 驅動
----------------

.. note:: 由於 Memcache 沒有鎖機制，這個驅動的鎖是通過一個保持 300 秒的值來模擬的
	（emulated by a separate value that is kept for up to 300 seconds）。

Memcached 驅動和 Redis 驅動非常相似，除了它的可用性可能要好點，因為 PHP 的 `Memcached
<http://php.net/memcached>`_ 擴展已經通過 PECL 發佈了，並且在某些 Linux 發行版本中，
可以非常方便的安裝它。

除了這一點，以及排除任何對 Redis 的偏見，關於 Memcached 要說的真的沒什麼區別，
它也是一款通常用於快取的產品，而且以它的速度而聞名。

不過，值得注意的是，使用 Memcached 設定 X 的過期時間為 Y 秒，它只能保證 X 會在 Y 秒過後被刪除
（但不會早於這個時間）。這個是非常少見的，但是應該注意一下，因為它可能會導致 session 的丟失。

``$config['sess_save_path']`` 參數的格式相當簡單，使用 ``host:port`` 對即可::

	$config['sess_driver'] = 'memcached';
	$config['sess_save_path'] = 'localhost:11211';

小提示
^^^^^^^^^

也可以使用一個可選的 *權重* 參數來支援多伺服器的設定，權重參數使用冒號分割（``:weight``），
但是我們並沒有測試這是絕對可靠的。

如果您想體驗這個特性（風險自負），只需簡單的將多個伺服器使用逗號分隔::

	// localhost will be given higher priority (5) here,
	// compared to 192.0.2.1 with a weight of 1.
	$config['sess_save_path'] = 'localhost:11211:5,192.0.2.1:11211:1';

自定義驅動
--------------

您也可以建立您自己的自定義 session 驅動，但是要記住的是，這通常來說都不是那麼簡單，
因為需要用到很多知識來正確實現它。

您不僅要知道 session 一般的工作原理，而且要知道它在 PHP 中是如何實現的，
還要知道它的內部儲存機制是如何工作的，如何去處理並發，如何去避免死鎖（不是通過去掉鎖機制），
以及最後一點但也是很重要的一點，如何去處理潛在的安全問題。

總的來說，如果您不知道怎麼在原生的 PHP 中實現這些，那麼您也不應該在 CodeIgniter 中嘗試實現它。
我已經警告過您了。

如果您只想給您的 session 加入一些額外的功能，您只要擴展 Session 基類就可以了，這要容易的多。
要學習如何實現這點，請閱讀 :doc:`建立您的類庫 <../general/creating_libraries>` 這一節。

言歸正傳，當您為 CodeIgniter 建立 session 驅動時，有三條規則您必須遵循：

  - 將您的驅動文件放在 **application/libraries/Session/drivers/** 資料夾下，並遵循 Session 類所使用的命名規範。

    例如，如果您想建立一個名為 'dummy' 的驅動，那麼您需要建立一個名為 ``Session_dummy_driver`` 的類，
    並將其放在 *application/libraries/Session/drivers/Session_dummy_driver.php* 文件中。

  - 擴展 ``CI_Session_driver`` 類。

    這只是一個擁有幾個內部輔助成員函數的基本類，同樣可以和其他類庫一樣被擴展。如果您真的需要這樣做，
    我們並不打算在這裡多做解釋，因為如果您知道如何在 CI 中擴展或覆寫類，那麼您已經知道這樣做的成員函數了。
    如果您還不知道，那麼可能您根本就不應該這樣做。

  - 實現 `SessionHandlerInterface <http://php.net/sessionhandlerinterface>`_ 接口。

    .. note:: 您可能已經注意到 ``SessionHandlerInterface`` 接口已經在 PHP 5.4.0 之後的版本中提供了。
    	CodeIgniter 會在您執行老版本的 PHP 時自動聲明這個接口。

    參考連接中的內容，瞭解為什麼以及如何實現。

所以，使用我們上面的 'dummy' 驅動的範例，您可能會寫如下程式碼::

	// application/libraries/Session/drivers/Session_dummy_driver.php:

	class CI_Session_dummy_driver extends CI_Session_driver implements SessionHandlerInterface
	{

		public function __construct(&$params)
		{
			// DO NOT forget this
			parent::__construct($params);

			// Configuration & other initializations
		}

		public function open($save_path, $name)
		{
			// Initialize storage mechanism (connection)
		}

		public function read($session_id)
		{
			// Read session data (if exists), acquire locks
		}

		public function write($session_id, $session_data)
		{
			// Create / update session data (it might not exist!)
		}

		public function close()
		{
			// Free locks, close connections / streams / etc.
		}

		public function destroy($session_id)
		{
			// Call close() method & destroy data for current session (order may differ)
		}

		public function gc($maxlifetime)
		{
			// Erase data for expired sessions
		}

	}

如果一切順利，現在您就可以將 *sess_driver* 參數設定為 'dummy' ，來使用您自定義的驅動。恭喜您！

***************
類參考
***************

.. php:class:: CI_Session

	.. php:method:: userdata([$key = NULL])

		:param	mixed	$key: Session item key or NULL
		:returns:	Value of the specified item key, or an array of all userdata
		:rtype:	mixed

		從 ``$_SESSION`` 陣列中讀取指定的項。如果沒有指定參數，傳回所有 "userdata" 的陣列。

		.. note:: 這是個遺留成員函數，只是為了和老的應用程式向前相容而保留。
			您可以直接使用 ``$_SESSION`` 替代它。

	.. php:method:: all_userdata()

		:returns:	An array of all userdata
		:rtype:	array

		傳回所有 "userdata" 的陣列。

		.. note:: 該成員函數已廢棄，使用不帶參數的 ``userdata()`` 成員函數來代替。

	.. php:method:: &get_userdata()

		:returns:	A reference to ``$_SESSION``
		:rtype:	array

		傳回一個 ``$_SESSION`` 陣列的引用。

		.. note:: 這是個遺留成員函數，只是為了和老的應用程式向前相容而保留。

	.. php:method:: has_userdata($key)

		:param	string	$key: Session item key
		:returns:	TRUE if the specified key exists, FALSE if not
		:rtype:	bool

		檢查 ``$_SESSION`` 陣列中是否存在某項。

		.. note:: 這是個遺留成員函數，只是為了和老的應用程式向前相容而保留。
			它只是 ``isset($_SESSION[$key])`` 的一個別名，請使用這個來替代它。

	.. php:method:: set_userdata($data[, $value = NULL])

		:param	mixed	$data: An array of key/value pairs to set as session data, or the key for a single item
		:param	mixed	$value:	The value to set for a specific session item, if $data is a key
		:rtype:	void

		將資料賦值給 ``$_SESSION`` 全區變數。

		.. note:: 這是個遺留成員函數，只是為了和老的應用程式向前相容而保留。

	.. php:method:: unset_userdata($key)

		:param	mixed	$key: Key for the session data item to unset, or an array of multiple keys
		:rtype:	void

		從 ``$_SESSION`` 全區變數中刪除某個值。

		.. note:: 這是個遺留成員函數，只是為了和老的應用程式向前相容而保留。
			它只是 ``unset($_SESSION[$key])`` 的一個別名，請使用這個來替代它。

	.. php:method:: mark_as_flash($key)

		:param	mixed	$key: Key to mark as flashdata, or an array of multiple keys
		:returns:	TRUE on success, FALSE on failure
		:rtype:	bool

		將 ``$_SESSION`` 陣列中的一項（或多項）標記為 "flashdata" 。

	.. php:method:: get_flash_keys()

		:returns:	Array containing the keys of all "flashdata" items.
		:rtype:	array

		讀取 ``$_SESSION`` 陣列中所有標記為 "flashdata" 的一個清單。

	.. php:method:: unmark_flash($key)

		:param	mixed	$key: Key to be un-marked as flashdata, or an array of multiple keys
		:rtype:	void

		將 ``$_SESSION`` 陣列中的一項（或多項）移除 "flashdata" 標記。

	.. php:method:: flashdata([$key = NULL])

		:param	mixed	$key: Flashdata item key or NULL
		:returns:	Value of the specified item key, or an array of all flashdata
		:rtype:	mixed

		從 ``$_SESSION`` 陣列中讀取某個標記為 "flashdata" 的指定項。
		如果沒有指定參數，傳回所有 "flashdata" 的陣列。

		.. note:: 這是個遺留成員函數，只是為了和老的應用程式向前相容而保留。
			您可以直接使用 ``$_SESSION`` 替代它。

	.. php:method:: keep_flashdata($key)

		:param	mixed	$key: Flashdata key to keep, or an array of multiple keys
		:returns:	TRUE on success, FALSE on failure
		:rtype:	bool

		將某個指定的 "flashdata" 設定為在下一次請求中仍然保持有效。

		.. note:: 這是個遺留成員函數，只是為了和老的應用程式向前相容而保留。
			它只是 ``mark_as_flash()`` 成員函數的一個別名。

	.. php:method:: set_flashdata($data[, $value = NULL])

		:param	mixed	$data: An array of key/value pairs to set as flashdata, or the key for a single item
		:param	mixed	$value:	The value to set for a specific session item, if $data is a key
		:rtype:	void

		將資料賦值給 ``$_SESSION`` 全區變數，並標記為 "flashdata" 。

		.. note:: 這是個遺留成員函數，只是為了和老的應用程式向前相容而保留。

	.. php:method:: mark_as_temp($key[, $ttl = 300])

		:param	mixed	$key: Key to mark as tempdata, or an array of multiple keys
		:param	int	$ttl: Time-to-live value for the tempdata, in seconds
		:returns:	TRUE on success, FALSE on failure
		:rtype:	bool

		將 ``$_SESSION`` 陣列中的一項（或多項）標記為 "tempdata" 。

	.. php:method:: get_temp_keys()

		:returns:	Array containing the keys of all "tempdata" items.
		:rtype:	array

		讀取 ``$_SESSION`` 陣列中所有標記為 "tempdata" 的一個清單。

	.. php:method:: unmark_temp($key)

		:param	mixed	$key: Key to be un-marked as tempdata, or an array of multiple keys
		:rtype:	void

		將 ``$_SESSION`` 陣列中的一項（或多項）移除 "tempdata" 標記。

	.. php:method:: tempdata([$key = NULL])

		:param	mixed	$key: Tempdata item key or NULL
		:returns:	Value of the specified item key, or an array of all tempdata
		:rtype:	mixed

		從 ``$_SESSION`` 陣列中讀取某個標記為 "tempdata" 的指定項。
		如果沒有指定參數，傳回所有 "tempdata" 的陣列。

		.. note:: 這是個遺留成員函數，只是為了和老的應用程式向前相容而保留。
			您可以直接使用 ``$_SESSION`` 替代它。

	.. php:method:: set_tempdata($data[, $value = NULL])

		:param	mixed	$data: An array of key/value pairs to set as tempdata, or the key for a single item
		:param	mixed	$value:	The value to set for a specific session item, if $data is a key
		:param	int	$ttl: Time-to-live value for the tempdata item(s), in seconds
		:rtype:	void

		將資料賦值給 ``$_SESSION`` 全區變數，並標記為 "tempdata" 。

		.. note:: 這是個遺留成員函數，只是為了和老的應用程式向前相容而保留。

	.. php:method:: sess_regenerate([$destroy = FALSE])

		:param	bool	$destroy: Whether to destroy session data
		:rtype:	void

		重新產生 session ID ，$destroy 參數可選，用於銷毀目前的 session 資料。

		.. note:: 該成員函數只是 PHP 原生的 `session_regenerate_id()
			<http://php.net/session_regenerate_id>`_ 函數的一個別名而已。

	.. php:method:: sess_destroy()

		:rtype:	void

		銷毀目前 session 。

		.. note:: 這個成員函數必須在處理 session 相關的操作的**最後**呼叫。
			如果呼叫這個成員函數，所有的 session 資料都會丟失。

		.. note:: 該成員函數只是 PHP 原生的 `session_destroy()
			<http://php.net/session_destroy>`_  函數的一個別名而已。

	.. php:method:: __get($key)

		:param	string	$key: Session item key
		:returns:	The requested session data item, or NULL if it doesn't exist
		:rtype:	mixed

		魔術成員函數，依據您的喜好，使用 ``$this->session->item`` 這種方式來替代
		``$_SESSION['item']`` 。

		如果您存取 ``$this->session->session_id`` 它也會呼叫 ``session_id()`` 成員函數來傳回 session ID 。

	.. php:method:: __set($key, $value)

		:param	string	$key: Session item key
		:param	mixed	$value: Value to assign to the session item key
		:returns:	void

		魔術成員函數，直接賦值給 ``$this->session`` 屬性，以此來替代賦值給 ``$_SESSION`` 陣列::

			$this->session->foo = 'bar';

			// Results in:
			// $_SESSION['foo'] = 'bar';
