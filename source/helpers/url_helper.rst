#################
URL 輔助函數
#################

URL 輔助函數文件包含了一些幫助您處理 URL 的函數。

.. contents::
  :local:

.. raw:: html

  <div class="custom-index container"></div>

載入輔助函數
===================

該輔助函數通過下面的程式碼載入::

	$this->load->helper('url');

可用函數
===================

該輔助函數有下列可用函數：

.. php:function:: site_url([$uri = ''[, $protocol = NULL]])

	:param	string	$uri: URI string
	:param	string	$protocol: Protocol, e.g. 'http' or 'https'
	:returns:	Site URL
	:rtype:	string

	依據設定文件傳回您的站點 URL 。index.php （讀取其他您在設定文件中設定的 **index_page** 參數）
	將會包含在您的 URL 中，另外再加上您傳給函數的 URI 參數，以及設定文件中設定的 **url_suffix** 參數。

	推薦在任何時候都使用這種成員函數來產生您的 URL ，這樣在您的 URL 變動時您的程式碼將具有可移植性。

	傳給函數的 URI 段參數可以是一個字元串，也可以是個陣列，下面是字元串的範例::

		echo site_url('news/local/123');

	上例將傳回類似於：*http://example.com/index.php/news/local/123*

	下面是使用陣列的範例::

		$segments = array('news', 'local', '123');
		echo site_url($segments);

	該函數是 ``CI_Config::site_url()`` 的別名，更多資訊請查閱 :doc:`設定類 <../libraries/config>` 文件。

.. php:function:: base_url($uri = '', $protocol = NULL)

	:param	string	$uri: URI string
	:param	string	$protocol: Protocol, e.g. 'http' or 'https'
	:returns:	Base URL
	:rtype:	string

	依據設定文件傳回您站點的根 URL ，例如::

		echo base_url();

	該函數和 :php:func:`site_url()` 函數相同，只是不會在 URL 的後面加上 *index_page* 或 *url_suffix* 。

	另外，和 :php:func:`site_url()` 一樣的是，您也可以使用字元串或陣列格式的 URI 段。下面是字元串的範例::

		echo base_url("blog/post/123");

	上例將傳回類似於：*http://example.com/blog/post/123*

	跟 :php:func:`site_url()` 函數不一樣的是，您可以指定一個文件路徑（例如圖片或樣式文件），這將很有用，例如::

		echo base_url("images/icons/edit.png");

	將傳回類似於：*http://example.com/images/icons/edit.png*

	該函數是 ``CI_Config::base_url()`` 的別名，更多資訊請查閱 :doc:`設定類 <../libraries/config>` 文件。

.. php:function:: current_url()

	:returns:	The current URL
	:rtype:	string

	傳回目前正在瀏覽的頁面的完整 URL （包括分段）。

	.. note:: 該函數和呼叫下面的程式碼效果是一樣的：
		|
		| site_url(uri_string());


.. php:function:: uri_string()

	:returns:	An URI string
	:rtype:	string

	傳回包含該函數的頁面的 URI 分段。例如，如果您的 URL 是::

		http://some-site.com/blog/comments/123

	函數將傳回::

		blog/comments/123

	該函數是 ``CI_Config::uri_string()`` 的別名，更多資訊請查閱 :doc:`設定類 <../libraries/config>` 文件。


.. php:function:: index_page()

	:returns:	'index_page' value
	:rtype:	mixed

	傳回您在設定文件中設定的 **index_page** 參數，例如::

		echo index_page();

.. php:function:: anchor($uri = '', $title = '', $attributes = '')

	:param	string	$uri: URI string
	:param	string	$title: Anchor title
	:param	mixed	$attributes: HTML attributes
	:returns:	HTML hyperlink (anchor tag)
	:rtype:	string

	依據您提供的 URL 產生一個標準的 HTML 鏈接。

	第一個參數可以包含任何您想加入到 URL 上的段，和上面的 :php:func:`site_url()` 函數一樣，URL
	的段可以是字元串或陣列。

	.. note:: 如果您建立的鏈接是指向您自己的應用程式，那麼不用包含根 URL （http&#58;//...）。
		這個會依據您的設定文件自動加入到 URL 前面。所以您只需指定要加入的 URL 段就可以了。

	第二個參數是鏈接的文字，如果留空，將使用鏈接本身作為文字。

	第三個參數為您希望加入到鏈接的屬性，可以是一個字元串，也可以是個關聯陣列。

	這裡是一些範例::

		echo anchor('news/local/123', 'My News', 'title="News title"');
		// Prints: <a href="http://example.com/index.php/news/local/123" title="News title">My News</a>

		echo anchor('news/local/123', 'My News', array('title' => 'The best news!'));
		// Prints: <a href="http://example.com/index.php/news/local/123" title="The best news!">My News</a>

		echo anchor('', 'Click here');
		// Prints: <a href="http://example.com">Click Here</a>


.. php:function:: anchor_popup($uri = '', $title = '', $attributes = FALSE)

	:param	string	$uri: URI string
	:param	string	$title: Anchor title
	:param	mixed	$attributes: HTML attributes
	:returns:	Pop-up hyperlink
	:rtype:	string

	和 :php:func:`anchor()` 函數非常類似，只是它產生的 URL 將會在新窗口被打開。您可以通過第三個參數指定
	JavaScript 的窗口屬性，以此來控制窗口將如何被打開。如果沒有設定第三個參數，將會使用您的瀏覽器設定打開
	一個新窗口。

	這裡是屬性的範例::

		$atts = array(
			'width'       => 800,
			'height'      => 600,
			'scrollbars'  => 'yes',
			'status'      => 'yes',
			'resizable'   => 'yes',
			'screenx'     => 0,
			'screeny'     => 0,
			'window_name' => '_blank'
		);

		echo anchor_popup('news/local/123', 'Click Me!', $atts);

	.. note:: 上面的屬性是函數的預設值，所以您只需要設定和您想要的不一樣的參數。如果想使用所有預設的參數，
		只要簡單的傳一個空陣列即可：
		|
		| echo anchor_popup('news/local/123', 'Click Me!', array());

	.. note:: **window_name** 其實並不算一個屬性，而是 Javascript 的
		`window.open() <http://www.w3schools.com/jsref/met_win_open.asp>` 函數的一個參數而已，
		該函數接受一個窗口名稱或一個 window 物件。

	.. note:: 任何不同於上面列出來的其他的屬性將會作為 HTML 鏈接的屬性。


.. php:function:: mailto($email, $title = '', $attributes = '')

	:param	string	$email: E-mail address
	:param	string	$title: Anchor title
	:param	mixed	$attributes: HTML attributes
	:returns:	A "mail to" hyperlink
	:rtype:	string

	建立一個標準的 HTML e-mail 鏈接。例如::

		echo mailto('me@my-site.com', 'Click Here to Contact Me');

	和上面的 :php:func:`anchor()` 函數一樣，您可以通過第三個參數設定屬性::

		$attributes = array('title' => 'Mail me');
		echo mailto('me@my-site.com', 'Contact Me', $attributes);

.. php:function:: safe_mailto($email, $title = '', $attributes = '')

	:param	string	$email: E-mail address
	:param	string	$title: Anchor title
	:param	mixed	$attributes: HTML attributes
	:returns:	A spam-safe "mail to" hyperlink
	:rtype:	string

	和 :php:func:`mailto()` 函數一樣，但是它的 *mailto* 標籤使用了一個混淆的寫法，
	可以防止您的 e-mail 地址被垃圾郵件機器人爬到。

.. php:function:: auto_link($str, $type = 'both', $popup = FALSE)

	:param	string	$str: Input string
	:param	string	$type: Link type ('email', 'url' or 'both')
	:param	bool	$popup: Whether to create popup links
	:returns:	Linkified string
	:rtype:	string

	將一個字元串中的 URL 和 e-mail 地址自動轉換為鏈接，例如::

		$string = auto_link($string);

	第二個參數用於決定是轉換 URL 還是 e-mail 地址，預設情況不指定該參數，兩者都會被轉換。
	E-mail 地址的鏈接是使用上面介紹的 :php:func:`safe_mailto()` 函數產生的。

	只轉換 URL ::

		$string = auto_link($string, 'url');

	只轉換 e-mail 地址::

		$string = auto_link($string, 'email');

	第三個參數用於指定鏈接是否要在新窗口打開。可以是布林值 TRUE 或 FALSE ::

		$string = auto_link($string, 'both', TRUE);


.. php:function:: url_title($str, $separator = '-', $lowercase = FALSE)

	:param	string	$str: Input string
	:param	string	$separator: Word separator
	:param	bool	$lowercase: Whether to transform the output string to lower-case
	:returns:	URL-formatted string
	:rtype:	string

	將字元串轉換為對人類友好的 URL 字元串格式。例如，如果您有一個部落格，您希望使用部落格的標題作為 URL ，
	這時該函數很有用。例如::

		$title = "What's wrong with CSS?";
		$url_title = url_title($title);
		// Produces: Whats-wrong-with-CSS

	第二個參數指定分隔字元，預設使用連字元。一般的選擇有：**-** （連字元） 或者 **_** （下劃線）

	例如::

		$title = "What's wrong with CSS?";
		$url_title = url_title($title, 'underscore');
		// Produces: Whats_wrong_with_CSS

	.. note:: 第二個參數連字元和下劃線的老的用法已經廢棄。

	第三個參數指定是否強制轉換為小寫。預設不會，參數類型為布林值 TRUE 或 FALSE 。

	例如::

		$title = "What's wrong with CSS?";
		$url_title = url_title($title, 'underscore', TRUE);
		// Produces: whats_wrong_with_css


.. php:function:: prep_url($str = '')

	:param	string	$str: URL string
	:returns:	Protocol-prefixed URL string
	:rtype:	string

	當 URL 中缺少協議前綴部分時，使用該函數將會向 URL 中加入 http&#58;// 。

	像下面這樣使用該函數::

		$url = prep_url('example.com');


.. php:function:: redirect($uri = '', $method = 'auto', $code = NULL)

	:param	string	$uri: URI string
	:param	string	$method: Redirect method ('auto', 'location' or 'refresh')
	:param	string	$code: HTTP Response code (usually 302 or 303)
	:rtype:	void

	通過 HTTP 頭重定向到指定 URL 。您可以指定一個完整的 URL ，也可以指定一個 URL 段，
	該函數會依據設定文件自動產生改 URL 。

	第二個參數用於指定一種重定向成員函數。可用的成員函數有：**auto** 、 **location** 和 **refresh** 。
	location 成員函數速度快，但是在 ISS 伺服器上不可靠。預設值為 **auto** ，它會依據您的伺服器環境
	智能的選擇使用哪種成員函數。

	第三個參數可選，允許您發送一個指定的 HTTP 狀態碼，這個可以用來為搜索引擎建立 301 重定向。
	預設的狀態碼為 302 ，該參數只適用於 **location** 重定向成員函數，對於 *refresh* 成員函數無效。例如::

		if ($logged_in == FALSE)
		{
			redirect('/login/form/');
		}

		// with 301 redirect
		redirect('/article/13', 'location', 301);

	.. note:: 為了讓該函數有效，它必須在任何內容輸出到瀏覽器之前被呼叫。因為輸出內容會使用伺服器 HTTP 頭。

	.. note:: 為了更好的控制伺服器頭，您應該使用 :doc:`輸出類 </libraries/output>` 的 ``set_header()`` 成員函數。

	.. note:: 使用 IIS 的用戶要注意，如果您隱藏了 `Server` 這個 HTTP 頭， *auto* 成員函數將無法檢測到 IIS 。
		在這種情況下，推薦您使用 **refresh** 成員函數。

	.. note:: 當使用 HTTP/1.1 的 POST 來存取您的頁面時，如果您使用的是 **location** 成員函數，會自動使用 HTTP 303 狀態碼。

	.. important:: 該函數會終止腳本的執行。
