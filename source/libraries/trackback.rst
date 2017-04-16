###############
引用通告類
###############

引用通告類提供了一些成員函數用於發送和接受引用通告資料。

如果您還不知道什麼是引用通告，可以在
`這裡 <http://en.wikipedia.org/wiki/Trackback>`_ 找到更多資訊。

.. contents::
  :local:

.. raw:: html

  <div class="custom-index container"></div>

*************************
使用引用通告類
*************************

初始化類
======================

正如 CodeIgniter 中的其他類一樣，在您的控制器中使用 ``$this->load->library()``
成員函數來初始化引用通告類::

	$this->load->library('trackback');

初始化之後，引用通告類的物件就可以這樣存取::

	$this->trackback

發送引用通告
==================

可以在您的控制器的任何成員函數中使用類似於如下程式碼來發送引用通告::

	$this->load->library('trackback');

	$tb_data = array(
		'ping_url'  => 'http://example.com/trackback/456',
		'url'       => 'http://www.my-example.com/blog/entry/123',
		'title'     => 'The Title of My Entry',
		'excerpt'   => 'The entry content.',
		'blog_name' => 'My Blog Name',
		'charset'   => 'utf-8'
	);

	if ( ! $this->trackback->send($tb_data))
	{
		echo $this->trackback->display_errors();
	}
	else
	{
		echo 'Trackback was sent!';
	}

陣列中每一項的解釋：

-  **ping_url** - 您想發送引用通告到該站點的 URL ，您可以同時向發送多個 URL 發送，多個 URL 之間使用逗號分割
-  **url** - 對應的是您的部落格的 URL
-  **title** - 您的部落格標題
-  **excerpt** - 您的部落格內容（摘要）
-  **blog_name** - 您的部落格的名稱
-  **charset** - 您的部落格所使用的字元編碼，如果忽略，預設使用 UTF-8

.. note:: 引用通告類會自動發送您的部落格的前 500 個字元，同時它也會去除所有的 HTML 標籤。

發送引用通告的成員函數會依據成功或失敗傳回 TRUE 或 FALSE ，如果失敗，可以使用下面的程式碼讀取錯誤資訊::

	$this->trackback->display_errors();

接受引用通告
====================

在接受引用通告之前，您必須先建立一個部落格，如果您還沒有部落格，
那麼接下來的內容對您來說就沒什麼意義。

接受引用通告比發送要複雜一點，這是因為您需要一個資料庫表來儲存它們，
而且您還需要對接受到的引用通告資料進行驗證。我們鼓勵您實現一個完整的驗證過程，
來防止垃圾資訊和重複資料。您可能還希望限制一段時間內從某個 IP 發送過來的引用通告的數量，
以此減少垃圾資訊。接受引用通告的過程很簡單，驗證才是難點。

您的 Ping URL
=============

為了接受引用通告，您必須在您的每篇部落格旁邊顯示一個引用通告 URL ，
人們使用這個 URL 來向您發送引用通告（我們稱其為 Ping URL）。

您的 Ping URL 必須指向一個控制器成員函數，在該成員函數中寫接受引用通告的程式碼，而且該 URL
必須包含您部落格的 ID ，這樣當接受到引用通告時您就可以知道是針對哪篇部落格的。

例如，假設您的控制器類叫 Trackback ，接受成員函數叫 receive ，您的 Ping URL
將類似於下面這樣::

	http://example.com/index.php/trackback/receive/entry_id

其中，entry_id 代表您每篇部落格的 ID 。

新建 Trackback 表
==========================

在接受引用通告之前，您必須建立一個資料庫表來儲存它。下面是表的一個基本原型::

	CREATE TABLE trackbacks (
		tb_id int(10) unsigned NOT NULL auto_increment,
		entry_id int(10) unsigned NOT NULL default 0,
		url varchar(200) NOT NULL,
		title varchar(100) NOT NULL,
		excerpt text NOT NULL,
		blog_name varchar(100) NOT NULL,
		tb_date int(10) NOT NULL,
		ip_address varchar(45) NOT NULL,
		PRIMARY KEY `tb_id` (`tb_id`),
		KEY `entry_id` (`entry_id`)
	);

在引用通告的規範中只有四項資訊是發送一個引用通告所必須的：url、title、excerpt 和 blog_name 。
但為了讓資料更有用，我們還在表中加入了幾個其他的字段（date、ip_address 等）。

處理引用通告
======================

下面是一個如何接受並處理引用通告的範例。下面的程式碼將放在您的接受引用通告的控制器成員函數中::

	$this->load->library('trackback');
	$this->load->database();

	if ($this->uri->segment(3) == FALSE)
	{
		$this->trackback->send_error('Unable to determine the entry ID');
	}

	if ( ! $this->trackback->receive())
	{
		$this->trackback->send_error('The Trackback did not contain valid data');
	}

	$data = array(
		'tb_id'      => '',
		'entry_id'   => $this->uri->segment(3),
		'url'        => $this->trackback->data('url'),
		'title'      => $this->trackback->data('title'),
		'excerpt'    => $this->trackback->data('excerpt'),
		'blog_name'  => $this->trackback->data('blog_name'),
		'tb_date'    => time(),
		'ip_address' => $this->input->ip_address()
	);

	$sql = $this->db->insert_string('trackbacks', $data);
	$this->db->query($sql);

	$this->trackback->send_success();

說明
^^^^^^

entry_id 將從您的 URL 的第三段讀取，這是基於我們之前範例中的 URL::

	http://example.com/index.php/trackback/receive/entry_id

注意 entry_id 是第三段，您可以這樣讀取::

	$this->uri->segment(3);

在我們上面的接受引用通告的程式碼中，如果第三段為空，我們將發送一個錯誤資訊。
如果沒有有效的 entry_id ，沒必要繼續處理下去。

$this->trackback->receive() 是個簡單的驗證成員函數，它檢查接受到的資料並確保包含了
我們所需的四種資訊：url、title、excerpt 和 blog_name 。該成員函數成功傳回 TRUE ，
失敗傳回 FALSE 。如果失敗，也發送一個錯誤資訊。

接受到的引用通告資料可以通過下面的成員函數來讀取::

	$this->trackback->data('item')

其中，item 代表四種資訊中的一種：url、title、excerpt 和 blog_name 。

如果引用通告資料成功接受，您可以使用下面的程式碼發送一個成功消息::

	$this->trackback->send_success();

.. note:: 上面的程式碼中不包含資料校驗，我們建議您加入。

***************
類參考
***************

.. php:class:: CI_Trackback

	.. attribute:: $data = array('url' => '', 'title' => '', 'excerpt' => '', 'blog_name' => '', 'charset' => '')

		引用通告資料的陣列。

	.. attribute:: $convert_ascii = TRUE

		是否將高位 ASCII 和 MS Word 特殊字元 轉換為 HTML 實體。

	.. php:method:: send($tb_data)

		:param	array	$tb_data: Trackback data
		:returns:	TRUE on success, FALSE on failure
		:rtype:	bool

		發送引用通告。

	.. php:method:: receive()

		:returns:	TRUE on success, FALSE on failure
		:rtype:	bool

		該成員函數簡單的檢驗接受到的引用通告資料，成功傳回 TRUE ，失敗傳回 FALSE 。
		如果資料是有效的，將加入到 ``$this->data`` 陣列，以便儲存到資料庫。

	.. php:method:: send_error([$message = 'Incomplete information'])

		:param	string	$message: Error message
		:rtype: void

		向引用通告請求傳回一條錯誤資訊。

		.. note:: 該成員函數將會終止腳本的執行。

	.. php:method:: send_success()

		:rtype:	void

		向引用通告請求傳回一條成功資訊。

		.. note:: 該成員函數將會終止腳本的執行。

	.. php:method:: data($item)

		:param	string	$item: Data key
		:returns:	Data value or empty string if not found
		:rtype:	string

		從引用通告資料中讀取一項記錄。

	.. php:method:: process($url, $data)

		:param	string	$url: Target url
		:param	string	$data: Raw POST data
		:returns:	TRUE on success, FALSE on failure
		:rtype:	bool

		打開一個 socket 連接，並將資料傳送到伺服器。成功傳回 TRUE ，失敗傳回 FALSE 。

	.. php:method:: extract_urls($urls)

		:param	string	$urls: Comma-separated URL list
		:returns:	Array of URLs
		:rtype:	array

		該成員函數用於發送多條引用通告，它接受一個包含多條 URL 的字元串
		（以逗號或空格分割），將其轉換為一個陣列。

	.. php:method:: validate_url(&$url)

		:param	string	$url: Trackback URL
		:rtype:	void

		如果 URL 中沒有包括協議部分，該成員函數簡單將 *http://* 前綴加入到 URL 前面。

	.. php:method:: get_id($url)

		:param	string	$url: Trackback URL
		:returns:	URL ID or FALSE on failure
		:rtype:	string

		查找並傳回一個引用通告 URL 的 ID ，失敗傳回 FALSE 。

	.. php:method:: convert_xml($str)

		:param	string	$str: Input string
		:returns:	Converted string
		:rtype:	string

		將 XML 保留字元轉換為實體。

	.. php:method:: limit_characters($str[, $n = 500[, $end_char = '…']])

		:param	string	$str: Input string
		:param	int	$n: Max characters number
		:param	string	$end_char: Character to put at end of string
		:returns:	Shortened string
		:rtype:	string

		將字元串裁剪到指定字元個數，會保持單詞的完整性。

	.. php:method:: convert_ascii($str)

		:param	string	$str: Input string
		:returns:	Converted string
		:rtype:	string

		將高位 ASCII 和 MS Word 特殊字元轉換為 HTML 實體。

	.. php:method:: set_error($msg)

		:param	string	$msg: Error message
		:rtype:	void

		設定一個錯誤資訊。

	.. php:method:: display_errors([$open = '<p>'[, $close = '</p>']])

		:param	string	$open: Open tag
		:param	string	$close: Close tag
		:returns:	HTML formatted error messages
		:rtype:	string

		傳回 HTML 格式的錯誤資訊，如果沒有錯誤，傳回空字元串。
