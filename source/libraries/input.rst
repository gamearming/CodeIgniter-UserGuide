###########
輸入類
###########

輸入類有兩個用途：

#. 為了安全性，對輸入資料進行預處理
#. 提供了一些輔助成員函數來讀取輸入資料並處理

.. note:: 該類由系統自動載入，您無需手工載入

.. contents::
  :local:

.. raw:: html

  <div class="custom-index container"></div>

***************
對輸入進行過濾
***************

安全性過濾
==================

當存取 :doc:`控制器 <../general/controllers>` 時，安全過濾成員函數會自動被呼叫，
它做了以下幾件事情：

-  如果 ``$config['allow_get_array']`` 設定為 FALSE （預設是 TRUE），銷毀全區的 GET 陣列。
-  當開啟 register_globals 時，銷毀所有的全區變數。
-  過濾 GET/POST/COOKIE 資料的鍵值，只允許出現字母和數字（和其他一些）字元。
-  提供了 XSS （跨站腳本攻擊）過濾，可全區啟用，或按需啟用。
-  將換行字元統一為 ``PHP_EOL`` （基於 UNIX 的系統下為 \\n，Windows 系統下為 \\r\\n），這個是可設定的。

XSS 過濾
=============

輸入類可以自動的對輸入資料進行過濾，來阻止跨站腳本攻擊。如果您希望在每次遇到 POST 或 COOKIE
資料時自動執行過濾，您可以在 *application/config/config.php* 設定文件中設定如下參數::

	$config['global_xss_filtering'] = TRUE;

關於 XSS 過濾的資訊，請參考 :doc:`安全類 <security>` 文件。

.. important:: 參數 'global_xss_filtering' 已經廢棄，保留它只是為了實現向前相容。
	XSS 過濾應該在*輸出*的時候進行，而不是*輸入*的時候！

*******************
存取表單資料
*******************

使用 POST、GET、COOKIE 和 SERVER 資料
=======================================

CodeIgniter 提供了幾個輔助成員函數來從 POST、GET、COOKIE 和 SERVER 陣列中讀取資料。
使用這些成員函數來讀取資料而不是直接存取陣列（``$_POST['something']``）的最大的好處是，
這些成員函數會檢查讀取的資料是否存在，如果不存在則傳回 NULL 。這使用起來將很方便，
您不再需要去檢查資料是否存在。換句話說，通常您需要像下面這樣做::

	$something = isset($_POST['something']) ? $_POST['something'] : NULL;

使用 CodeIgniter 的成員函數，您可以簡單的寫成::

	$something = $this->input->post('something');

主要有下面幾個成員函數：

-  ``$this->input->post()``
-  ``$this->input->get()``
-  ``$this->input->cookie()``
-  ``$this->input->server()``

使用 php://input 流
============================

如果您需要使用 PUT、DELETE、PATCH 或其他的請求成員函數，您只能通過一個特殊的輸入流來存取，
這個流只能被讀一次，這和從諸如 ``$_POST`` 陣列中讀取資料相比起來要複雜一點，因為 POST
陣列可以被存取多次來讀取多個變數，而不用擔心它會消失。

CodeIgniter 為您解決了這個問題，您只需要使用下面的 ``$raw_input_stream`` 屬性即可，
就可以在任何時候讀取 **php://input** 流中的資料::

	$this->input->raw_input_stream;

另外，如果輸入流的格式和 $_POST 陣列一樣，您也可以通過 ``input_stream()`` 成員函數來存取它的值::

	$this->input->input_stream('key');

和其他的 ``get()`` 和 ``post()`` 成員函數類似，如果請求的資料不存在，則傳回 NULL 。
您也可以將第二個參數設定為 TRUE ，來讓資料經過 ``xss_clean()`` 的檢查::

	$this->input->input_stream('key', TRUE); // XSS Clean
	$this->input->input_stream('key', FALSE); // No XSS filter

.. note:: 您可以使用 ``method()`` 成員函數來讀取您讀取的是什麼資料，PUT、DELETE 還是 PATCH 。

***************
類參考
***************

.. php:class:: CI_Input

	.. attribute:: $raw_input_stream
		
		傳回只讀的 php://input 流資料。
		
		該屬性可以被多次讀取。

	.. php:method:: post([$index = NULL[, $xss_clean = NULL]])

		:param	mixed	$index: POST parameter name
		:param	bool	$xss_clean: Whether to apply XSS filtering
		:returns:	$_POST if no parameters supplied, otherwise the POST value if found or NULL if not
		:rtype:	mixed

		第一個參數為您想要讀取的 POST 資料名::

			$this->input->post('some_data');

		如果讀取的資料不存在，該成員函數傳回 NULL 。

		第二個參數可選，用於決定是否使用 XSS 過濾器對資料進行過濾。
		要使用過濾器，可以將第二個參數設定為 TRUE ，或者將 
		``$config['global_xss_filtering']`` 參數設定為 TRUE 。
		::

			$this->input->post('some_data', TRUE);

		如果不帶任何參數該成員函數將傳回 POST 中的所有元素。

		如果希望傳回 POST 所有元素並將它們通過 XSS 過濾器進行過濾，
		可以將第一個參數設為 NULL ，第二個參數設為 TRUE ::

			$this->input->post(NULL, TRUE); // returns all POST items with XSS filter
			$this->input->post(NULL, FALSE); // returns all POST items without XSS filter

		如果要傳回 POST 中的多個元素，將所有需要的鍵值作為陣列傳給它::

			$this->input->post(array('field1', 'field2'));

		和上面一樣，如果希望資料通過 XSS 過濾器進行過濾，將第二個參數設定為 TRUE::

			$this->input->post(array('field1', 'field2'), TRUE);

	.. php:method:: get([$index = NULL[, $xss_clean = NULL]])

		:param	mixed	$index: GET parameter name
		:param	bool	$xss_clean: Whether to apply XSS filtering
		:returns:	$_GET if no parameters supplied, otherwise the GET value if found or NULL if not
		:rtype:	mixed

		該函數和 ``post()`` 一樣，只是它用於讀取 GET 資料。
		::

			$this->input->get('some_data', TRUE);

		如果不帶任何參數該成員函數將傳回 GET 中的所有元素。

		如果希望傳回 GET 所有元素並將它們通過 XSS 過濾器進行過濾，
		可以將第一個參數設為 NULL ，第二個參數設為 TRUE ::

			$this->input->get(NULL, TRUE); // returns all GET items with XSS filter
			$this->input->get(NULL, FALSE); // returns all GET items without XSS filtering

		如果要傳回 GET 中的多個元素，將所有需要的鍵值作為陣列傳給它::

			$this->input->get(array('field1', 'field2'));

		和上面一樣，如果希望資料通過 XSS 過濾器進行過濾，將第二個參數設定為 TRUE::

			$this->input->get(array('field1', 'field2'), TRUE);

	.. php:method:: post_get($index[, $xss_clean = NULL])

		:param	string	$index: POST/GET parameter name
		:param	bool	$xss_clean: Whether to apply XSS filtering
		:returns:	POST/GET value if found, NULL if not
		:rtype:	mixed

		該成員函數和 ``post()`` 和 ``get()`` 成員函數類似，它會同時查找 POST 和 GET 兩個陣列來讀取資料，
		先查找 POST ，再查找 GET::

			$this->input->post_get('some_data', TRUE);

	.. php:method:: get_post($index[, $xss_clean = NULL])

		:param	string	$index: GET/POST parameter name
		:param	bool	$xss_clean: Whether to apply XSS filtering
		:returns:	GET/POST value if found, NULL if not
		:rtype:	mixed

		該成員函數和 ``post_get()`` 成員函數一樣，只是它先查找 GET 資料::

			$this->input->get_post('some_data', TRUE);

		.. note:: 這個成員函數在之前的版本中和 ``post_get()`` 成員函數是完全一樣的，在 CodeIgniter 3.0 中有所修改。

	.. php:method:: cookie([$index = NULL[, $xss_clean = NULL]])

		:param	mixed	$index: COOKIE name
		:param	bool	$xss_clean: Whether to apply XSS filtering
		:returns:	$_COOKIE if no parameters supplied, otherwise the COOKIE value if found or NULL if not
		:rtype:	mixed

		該成員函數和 ``post()`` 和 ``get()`` 成員函數一樣，只是它用於讀取 COOKIE 資料::

			$this->input->cookie('some_cookie'); 			
			$this->input->cookie('some_cookie', TRUE); // with XSS filter

		如果要傳回 COOKIE 中的多個元素，將所有需要的鍵值作為陣列傳給它::

			$this->input->cookie(array('some_cookie', 'some_cookie2'));

		.. note:: 和 :doc:`Cookie 輔助函數 <../helpers/cookie_helper>` 中的 :php:func:`get_cookie()`
			函數不同的是，這個成員函數不會依據 ``$config['cookie_prefix']`` 來加入前綴。

	.. php:method:: server($index[, $xss_clean = NULL])

		:param	mixed	$index: Value name
		:param	bool	$xss_clean: Whether to apply XSS filtering
		:returns:	$_SERVER item value if found, NULL if not
		:rtype:	mixed

		該成員函數和 ``post()`` 、 ``get()`` 和 ``cookie()`` 成員函數一樣，只是它用於讀取 SERVER 資料::

			$this->input->server('some_data');

		如果要傳回 SERVER 中的多個元素，將所有需要的鍵值作為陣列傳給它::

			$this->input->server(array('SERVER_PROTOCOL', 'REQUEST_URI'));

	.. php:method:: input_stream([$index = NULL[, $xss_clean = NULL]])

		:param	mixed	$index: Key name
		:param	bool	$xss_clean: Whether to apply XSS filtering
		:returns:	Input stream array if no parameters supplied, otherwise the specified value if found or NULL if not
		:rtype:	mixed

		該成員函數和 ``get()`` 、 ``post()`` 和 ``cookie()`` 成員函數一樣，只是它用於讀取 *php://input* 流資料。

	.. php:method:: set_cookie($name = ''[, $value = ''[, $expire = ''[, $domain = ''[, $path = '/'[, $prefix = ''[, $secure = FALSE[, $httponly = FALSE]]]]]]])

		:param	mixed	$name: Cookie name or an array of parameters
		:param	string	$value: Cookie value
		:param	int	$expire: Cookie expiration time in seconds
		:param	string	$domain: Cookie domain
		:param	string	$path: Cookie path
		:param	string	$prefix: Cookie name prefix
		:param	bool	$secure: Whether to only transfer the cookie through HTTPS
		:param	bool	$httponly: Whether to only make the cookie accessible for HTTP requests (no JavaScript)
		:rtype:	void


		設定 COOKIE 的值，有兩種成員函數來設定 COOKIE 值：陣列方式和參數方式。

		**陣列方式**

		使用這種方式，可以將第一個參數設定為一個關聯陣列::

			$cookie = array(
				'name'   => 'The Cookie Name',
				'value'  => 'The Value',
				'expire' => '86500',
				'domain' => '.some-domain.com',
				'path'   => '/',
				'prefix' => 'myprefix_',
				'secure' => TRUE
			);

			$this->input->set_cookie($cookie);

		**注意**

		只有 name 和 value 兩項是必須的，要刪除 COOKIE 的話，將 expire 設定為空。

		COOKIE 的過期時間是 **秒** ，將它加到目前時間上就是 COOKIE 的過期時間。
		記住不要把它設定成時間了，只要設定成距離目前時間的秒數即可，那麼在這段
		時間內，COOKIE 都將保持有效。如果將過期時間設定為 0 ，那麼 COOKIE 只在
		瀏覽器打開的期間是有效的，關閉後就失效了。

		如果需要設定一個全站範圍內的 COOKIE ，而不關心用戶是如何存取您的站點的，
		可以將 **domain** 參數設定為您的 URL 前面以句點開頭，如：.your-domain.com

		path 參數通常不用設，上面的範例設定為根路徑。

		prefix 只在您想避免和其他相同名稱的 COOKIE 衝突時才需要使用。

		secure 參數只有當您需要使用安全的 COOKIE 時使用。

		**參數方式**

		如果您喜歡，您也可以使用下面的方式來設定 COOKIE::

			$this->input->set_cookie($name, $value, $expire, $domain, $path, $prefix, $secure);

	.. php:method:: ip_address()

		:returns:	Visitor's IP address or '0.0.0.0' if not valid
		:rtype:	string

		傳回目前用戶的 IP 地址，如果 IP 地址無效，則傳回 '0.0.0.0'::

			echo $this->input->ip_address();

		.. important:: 該成員函數會依據 ``$config['proxy_ips']`` 設定，來傳回 HTTP_X_FORWARDED_FOR、
			HTTP_CLIENT_IP、HTTP_X_CLIENT_IP 或 HTTP_X_CLUSTER_CLIENT_IP 。

	.. php:method:: valid_ip($ip[, $which = ''])

		:param	string	$ip: IP address
		:param	string	$which: IP protocol ('ipv4' or 'ipv6')
		:returns:	TRUE if the address is valid, FALSE if not
		:rtype:	bool

		判斷一個 IP 地址是否有效，傳回 TRUE/FALSE 。

		.. note:: 上面的 $this->input->ip_address() 成員函數會自動驗證 IP 地址的有效性。

		::

			if ( ! $this->input->valid_ip($ip))
			{
				echo 'Not Valid';
			}
			else
			{
				echo 'Valid';
			}

		第二個參數可選，可以是字元串 'ipv4' 或 'ipv6' 用於指定 IP 的格式，預設兩種格式都會檢查。

	.. php:method:: user_agent([$xss_clean = NULL])

		:returns:	User agent string or NULL if not set
		:param	bool	$xss_clean: Whether to apply XSS filtering
		:rtype:	mixed

		傳回目前用戶的用戶代理字元串（Web 瀏覽器），如果不可用則傳回 FALSE 。
		::

			echo $this->input->user_agent();

		關於用戶代理的相關成員函數請參考 :doc:`用戶代理類 <user_agent>` 。

	.. php:method:: request_headers([$xss_clean = FALSE])

		:param	bool	$xss_clean: Whether to apply XSS filtering
		:returns:	An array of HTTP request headers
		:rtype:	array

		傳回 HTTP 請求頭陣列。當在非 Apache 環境下執行時，
		`apache_request_headers() <http://php.net/apache_request_headers>`_ 函數不可用，
		這個成員函數將很有用。
		::

			$headers = $this->input->request_headers();

	.. php:method:: get_request_header($index[, $xss_clean = FALSE])

		:param	string	$index: HTTP request header name
		:param	bool	$xss_clean: Whether to apply XSS filtering
		:returns:	An HTTP request header or NULL if not found
		:rtype:	string

		傳回某個指定的 HTTP 請求頭，如果不存在，則傳回 NULL 。
		::

			$this->input->get_request_header('some-header', TRUE);

	.. php:method:: is_ajax_request()

		:returns:	TRUE if it is an Ajax request, FALSE if not
		:rtype:	bool

		檢查伺服器頭中是否含有 HTTP_X_REQUESTED_WITH ，如果有傳回 TRUE ，否則傳回 FALSE 。

	.. php:method:: is_cli_request()

		:returns:	TRUE if it is a CLI request, FALSE if not
		:rtype:	bool

		檢查程序是否從命令列界面執行。

		.. note:: 該成員函數檢查目前正在使用的 PHP SAPI 名稱，同時檢查是否定義了 ``STDIN`` 常數，
			來判斷目前 PHP 是否從命令列執行。

		::

			$this->input->is_cli_request()

		.. note:: 該成員函數已經被廢棄，現在只是 :func:`is_cli()` 函數的一個別名而已。

	.. php:method:: method([$upper = FALSE])

		:param	bool	$upper: Whether to return the request method name in upper or lower case
		:returns:	HTTP request method
		:rtype:	string

		傳回 ``$_SERVER['REQUEST_METHOD']`` 的值，它有一個參數用於設定傳回大寫還是小寫。
		::

			echo $this->input->method(TRUE); // Outputs: POST
			echo $this->input->method(FALSE); // Outputs: post
			echo $this->input->method(); // Outputs: post
