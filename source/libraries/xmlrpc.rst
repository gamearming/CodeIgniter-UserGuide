##################################
XML-RPC 與 XML-RPC 伺服器類
##################################

CodeIgniter 的 XML-RPC  類允許您向另一個伺服器發送請求，
或者建立一個您自己的 XML-RPC 伺服器來接受請求。

.. contents::
  :local:

.. raw:: html

  <div class="custom-index container"></div>

***********************
什麼是 XML-RPC ？
***********************

這是一種在兩台計算機之間使用 XML 通過互聯網進行通信的簡單成員函數。
一台計算機 , 我們稱之為客戶端 , 發送一個 XML-RPC 請求給另外一台計算機，
我們稱之為伺服器，當伺服器收到請求時，對其進行處理然後將結果傳回給客戶端。

例如，使用 MetaWeblog API 時，XML-RPC 客戶端（通常是桌面發佈工具）
將會發送請求到您站點上的 XML-RPC 伺服器，這個請求可能是發佈一篇新部落格，
或者編輯一篇已有的部落格。當 XML-RPC 伺服器收到該請求時，它會決定使用
哪個類和成員函數來處理該請求，請求處理完成後，伺服器將發送一條回復消息。

關於 XML-RPC 的規範，您可以查看 `XML-RPC <http://www.xmlrpc.com/>`_ 的網站。

***********************
使用 XML-RPC 類
***********************

初始化類
======================

跟 CodeIgniter 中的其他類一樣，可以在您的控制器中使用 ``$this->load->library()``
成員函數載入 XML-RPC 類和 XML-RPC 伺服器類。

載入 XML-RPC 類如下::

	$this->load->library('xmlrpc');

一旦載入，XML-RPC 類就可以像下面這樣使用::

	$this->xmlrpc

載入 XML-RPC 伺服器類如下::

	$this->load->library('xmlrpc');
	$this->load->library('xmlrpcs');

一旦載入，XML-RPC 伺服器類就可以像下面這樣使用::

	$this->xmlrpcs

.. note:: 當使用 XML-RPC 伺服器類時，xmlrpc 和 xmlrpcs 都需要載入。

發送 XML-RPC 請求
========================

向 XML-RPC 伺服器發送一個請求，您需要指定以下資訊：

-  伺服器的 URL
-  您想要呼叫的伺服器成員函數
-  **請求** 資料（下面解釋）

下面是個基本的範例，向 `Ping-o-Matic <http://pingomatic.com/>`_
發送一個簡單的 Weblogs.com ping 請求。

::

	$this->load->library('xmlrpc');

	$this->xmlrpc->server('http://rpc.pingomatic.com/', 80);
	$this->xmlrpc->method('weblogUpdates.ping');

	$request = array('My Photoblog', 'http://www.my-site.com/photoblog/');
	$this->xmlrpc->request($request);

	if ( ! $this->xmlrpc->send_request())
	{
		echo $this->xmlrpc->display_error();
	}

解釋
-----------

上面的程式碼初始化了一個 XML-RPC 類，並設定了伺服器 URL 和要呼叫的成員函數
（weblogUpdates.ping）。然後通過 request() 成員函數編譯請求，
範例中請求是一個陣列（標題和您網站的 URL）。最後，使用 send_request()
成員函數發送完整的請求。如果發送請求成員函數傳回 FALSE ，我們會顯示出 XML-RPC
伺服器傳回的錯誤資訊。

請求解析
====================

XML-RPC 請求就是您發送給 XML-RPC 伺服器的資料，請求中的每一個資料也被稱為請求參數。
上面的範例中有兩個參數：您網站的 URL 和 標題。當 XML-RPC 伺服器收到請求後，
它會查找它所需要的參數。

請求參數必須放在一個陣列中，且陣列中的每個參數都必須是 7 種資料類型中的一種
（string、number、date 等），如果您的參數不是 string 類型，您必須在請求陣列中
指定它的資料類型。

下面是三個參數的簡單範例::

	$request = array('John', 'Doe', 'www.some-site.com');
	$this->xmlrpc->request($request);

如果您的資料類型不是 string ，或者您有幾個不同類型的資料，那麼您需要將
每個參數放到它唯一的陣列中，並在陣列的第二位聲明其資料類型::

	$request = array(
		array('John', 'string'),
		array('Doe', 'string'),
		array(FALSE, 'boolean'),
		array(12345, 'int')
	);
	$this->xmlrpc->request($request);

下面的 `資料類型 <#datatypes>`_ 一節列出了所有支援的資料類型。

建立一個 XML-RPC 伺服器
==========================

XML-RPC 伺服器扮演著類似於交通警察的角色，等待進入的請求，
並將它們轉到恰當的函數進行處理。

要建立您自己的 XML-RPC 伺服器，您需要先在負責處理請求的控制器中初始化
XML-RPC 伺服器類，然後設定一個映射陣列，用於將請求轉發到合適的類和成員函數，
以便進行處理。

下面是個範例::

	$this->load->library('xmlrpc');
	$this->load->library('xmlrpcs');

	$config['functions']['new_post'] = array('function' => 'My_blog.new_entry');
	$config['functions']['update_post'] = array('function' => 'My_blog.update_entry');
	$config['object'] = $this;

	$this->xmlrpcs->initialize($config);
	$this->xmlrpcs->serve();

上例中包含了兩個伺服器允許的請求成員函數，陣列的左邊是允許的成員函數名，
陣列的右邊是當請求該成員函數時，將會映射到的類和成員函數。

其中，'object' 是個特殊的鍵，用於傳遞一個執行緒物件，當映射的成員函數無法使用
CodeIgniter 超級物件時，它將是必須的。

換句話說，如果 XML-RPC 客戶端發送一個請求到 new\_post 成員函數，
您的伺服器會載入 My\_blog 類並呼叫 new\_entry 函數。如果這個請求是到
``update_post`` 成員函數的，那麼您的伺服器會載入 My\_blog 類並呼叫
``update_entry`` 成員函數。

上面範例中的函數名是任意的。您可以決定這些函數在您的伺服器上叫什麼名字，
如果您使用的是標準的 API，比如 Blogger 或者 MetaWeblog 的 API，
您必須使用標準的函數名。

這裡還有兩個附加的設定項，可以在伺服器類初始化時設定使用。debug 設為 TRUE 以便調試，
``xss_clean`` 可被設定為 FALSE 以避免資料被安全類庫的 ``xss_clean`` 函數過濾。

處理伺服器請求
==========================

當 XML-RPC 伺服器收到請求並載入類與成員函數來處理時，它會接收一個包含客戶端發送的資料參數。

在上面的範例中，如果請求的是 new_post 成員函數，伺服器請求的類與成員函數會像這樣::

	class My_blog extends CI_Controller {

		public function new_post($request)
		{

		}
	}

$request 變數是一個由服務端彙集的物件，包含由 XML-RPC 客戶端發送來的資料。
使用該物件可以讓您存取到請求參數以便處理請求。請求處理完成後，
發送一個響應傳回給客戶端。

下面是一個實際的範例，使用 Blogger API 。Blogger API 中的一個成員函數是 getUserInfo()，
XML-RPC 客戶端可以使用該成員函數發送用戶名和密碼到伺服器，在伺服器傳回的資料中，
會包含該用戶的資訊（暱稱，用戶 ID，Email 地址等等）。下面是處理的程式碼::

	class My_blog extends CI_Controller {

		public function getUserInfo($request)
		{
			$username = 'smitty';
			$password = 'secretsmittypass';

			$this->load->library('xmlrpc');

			$parameters = $request->output_parameters();

			if ($parameters[1] != $username && $parameters[2] != $password)
			{
				return $this->xmlrpc->send_error_message('100', 'Invalid Access');
			}

			$response = array(
				array(
					'nickname'  => array('Smitty', 'string'),
					'userid'    => array('99', 'string'),
					'url'       => array('http://yoursite.com', 'string'),
					'email'     => array('jsmith@yoursite.com', 'string'),
					'lastname'  => array('Smith', 'string'),
					'firstname' => array('John', 'string')
				),
	                         'struct'
			);

			return $this->xmlrpc->send_response($response);
		}
	}

注意
------

``output_parameters()`` 函數讀取一個由客戶端發送的請求參數陣列。
上面的範例中輸出參數將會是用戶名和密碼。

如果客戶端發送的用戶名和密碼無效的話，將使用 ``send_error_message()`` 函數傳回錯誤資訊。

如果操作成功，客戶端會收到包含用戶資訊的響應陣列。

格式化響應
=====================

和請求一樣，響應也必須被格式化為陣列。然而不同於請求資訊，響應陣列 **只包含一項**  。
該項可以是一個包含其他陣列的陣列，但是只能有一個主陣列，換句話說，
響應的結果大概是下面這個樣子::

	$response = array('Response data', 'array');

但是，響應通常會包含多個資訊。要做到這樣，我們必須把各個資訊放到他們自己的陣列中，
這樣主陣列就始終只有一個資料項。下面是一個範例展示如何實現這樣的效果::

	$response = array(
		array(
			'first_name' => array('John', 'string'),
			'last_name' => array('Doe', 'string'),
			'member_id' => array(123435, 'int'),
			'todo_list' => array(array('clean house', 'call mom', 'water plants'), 'array'),
		),
		'struct'
	);

注意：上面的陣列被格式化為 struct，這是響應最常見的資料類型。

如同請求一樣，響應可以是七種資料類型中的一種，參見 `資料類型 <#datatypes>`_ 一節。

發送錯誤資訊
=========================

如果您需要發送錯誤資訊給客戶端，可以使用下面的程式碼::

	return $this->xmlrpc->send_error_message('123', 'Requested data not available');

第一個參數為錯誤編號，第二個參數為錯誤資訊。

建立您自己的客戶端與服務端
===================================

為了幫助您理解目前為止講的這些內容，讓我們來建立兩個控制器，演示下 XML-RPC
的客戶端和服務端。您將用客戶端來發送一個請求到服務端並從服務端收到一個響應。

客戶端
----------

使用文字編輯器建立一個控制器 Xmlrpc_client.php ，在這個控制器中，
粘貼以下的程式碼並儲存到 applications/controllers/ 目錄::

	<?php

	class Xmlrpc_client extends CI_Controller {

		public function index()
		{
			$this->load->helper('url');
			$server_url = site_url('xmlrpc_server');

			$this->load->library('xmlrpc');

			$this->xmlrpc->server($server_url, 80);
			$this->xmlrpc->method('Greetings');

			$request = array('How is it going?');
			$this->xmlrpc->request($request);

			if ( ! $this->xmlrpc->send_request())
			{
				echo $this->xmlrpc->display_error();
			}
			else
			{
				echo '<pre>';
				print_r($this->xmlrpc->display_response());
				echo '</pre>';
			}
		}
	}
	?>

.. note:: 上面的程式碼中我們使用了一個 URL 輔助函數，更多關於輔助函數的資訊，
	您可以閱讀 :doc:`這裡 <../general/helpers>` 。

服務端
----------

使用文字編輯器建立一個控制器 Xmlrpc_server.php ，在這個控制器中，
粘貼以下的程式碼並儲存到 applications/controllers/ 目錄::

	<?php

	class Xmlrpc_server extends CI_Controller {

		public function index()
		{
			$this->load->library('xmlrpc');
			$this->load->library('xmlrpcs');

			$config['functions']['Greetings'] = array('function' => 'Xmlrpc_server.process');

			$this->xmlrpcs->initialize($config);
			$this->xmlrpcs->serve();
		}


		public function process($request)
		{
			$parameters = $request->output_parameters();

			$response = array(
				array(
					'you_said'  => $parameters[0],
					'i_respond' => 'Not bad at all.'
				),
				'struct'
			);

			return $this->xmlrpc->send_response($response);
		}
	}


嘗試一下
-------------

現在使用類似於下面這樣的鏈接存取您的站點::

	example.com/index.php/xmlrpc_client/

您應該能看到您發送到服務端的資訊，以及伺服器傳回的響應資訊。

在客戶端，您發送了一條消息（"How's is going?"）到服務端，
隨著一個請求發送到 "Greetings" 成員函數。服務端收到這個請求並映射到
"process" 函數，然後傳回響應資訊。

在請求參數中使用關聯陣列
===============================================

如果您希望在您的成員函數參數中使用關聯陣列，那麼您需要使用 struct 資料類型::

	$request = array(
		array(
			// Param 0
			array('name' => 'John'),
			'struct'
		),
		array(
			// Param 1
			array(
				'size' => 'large',
				'shape'=>'round'
			),
			'struct'
		)
	);

	$this->xmlrpc->request($request);

您可以在服務端處理請求資訊時讀取該關聯陣列。

::

	$parameters = $request->output_parameters();
	$name = $parameters[0]['name'];
	$size = $parameters[1]['size'];
	$shape = $parameters[1]['shape'];

資料類型
==========

依據 `XML-RPC 規範 <http://www.xmlrpc.com/spec>`_ 一共有七種不同的資料類型可以在 XML-RPC 中使用：

-  *int* or *i4*
-  *boolean*
-  *string*
-  *double*
-  *dateTime.iso8601*
-  *base64*
-  *struct* (contains array of values)
-  *array* (contains array of values)

***************
類參考
***************

.. php:class:: CI_Xmlrpc

	.. php:method:: initialize([$config = array()])

		:param	array	$config: Configuration data
		:rtype:	void

		初始化 XML-RPC 類，接受一個包含您設定的參數的關聯陣列。

	.. php:method:: server($url[, $port = 80[, $proxy = FALSE[, $proxy_port = 8080]]])

		:param	string	$url: XML-RPC server URL
		:param	int	$port: Server port
		:param	string	$proxy: Optional proxy
		:param	int	$proxy_port: Proxy listening port
		:rtype:	void

		用於設定 XML-RPC 伺服器端的 URL 和端口::

			$this->xmlrpc->server('http://www.sometimes.com/pings.php', 80);

		支援基本的 HTTP 身份認證，只需簡單的將其加入到 URL中::

			$this->xmlrpc->server('http://user:pass@localhost/', 80);

	.. php:method:: timeout($seconds = 5)

		:param	int	$seconds: Timeout in seconds
		:rtype:	void

		設定一個超時時間（單位為秒），超過該時間，請求將被取消::

			$this->xmlrpc->timeout(6);

		This timeout period will be used both for an initial connection to
                the remote server, as well as for getting a response from it.
                Make sure you set the timeout before calling ``send_request()``.

	.. php:method:: method($function)

		:param	string	$function: Method name
		:rtype:	void

		設定 XML-RPC 伺服器接受的請求成員函數::

			$this->xmlrpc->method('method');

		其中 method 參數為請求成員函數名。

	.. php:method:: request($incoming)

		:param	array	$incoming: Request data
		:rtype:	void

		接受一個陣列參數，並建立一個發送到 XML-RPC 伺服器的請求::

			$request = array(array('My Photoblog', 'string'), 'http://www.yoursite.com/photoblog/');
			$this->xmlrpc->request($request);

	.. php:method:: send_request()

		:returns:	TRUE on success, FALSE on failure
		:rtype:	bool

		發送請求的成員函數，成功傳回 TRUE，失敗傳回 FALSE ，可以用在條件判斷裡。

	.. method set_debug($flag = TRUE)

		:param	bool	$flag: Debug status flag
		:rtype:	void

		啟用或停用調試，在開發環境下，可以用它來顯示調試資訊和錯誤資料。

	.. php:method:: display_error()

		:returns:	Error message string
		:rtype:	string

		當請求失敗後，傳回錯誤資訊。
		::

			echo $this->xmlrpc->display_error();

	.. php:method:: display_response()

		:returns:	Response
		:rtype:	mixed

		遠程伺服器接收請求後傳回的響應，傳回的資料通常是一個關聯陣列。
		::

			$this->xmlrpc->display_response();

	.. php:method:: send_error_message($number, $message)

		:param	int	$number: Error number
		:param	string	$message: Error message
		:returns:	XML_RPC_Response instance
		:rtype:	XML_RPC_Response

		這個成員函數允許您從伺服器發送一個錯誤消息到客戶端。
		第一個參數是錯誤編號，第二個參數是錯誤資訊。
		::

			return $this->xmlrpc->send_error_message(123, 'Requested data not available');

	.. method send_response($response)

		:param	array	$response: Response data
		:returns:	XML_RPC_Response instance
		:rtype:	XML_RPC_Response

		從伺服器發送響應到客戶端，發送的陣列必須是有效的。
		::

			$response = array(
				array(
					'flerror' => array(FALSE, 'boolean'),
					'message' => "Thanks for the ping!"
				),
				'struct'
			);

			return $this->xmlrpc->send_response($response);
