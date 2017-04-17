############################
建立核心系統類
############################

每次 CodeIgniter 執行時，都有一些基礎類伴隨著核心框架自動的被初始化。但您也可以使用您自己類來替代這些核心類或者擴展這些核心類。

**大多數用戶一般不會有這種需求，但對於那些想較大幅度的改變 CodeIgniter 的人來說，我們依然提供了取代和擴展核心類的選擇。**

.. note:: 改變系統核心類會產生很大影響，所以在您做之前必須清楚地知道自己正在做什麼。

系統類清單
=================

以下是系統核心文件的清單，它們在每次 CodeIgniter 啟動時被呼叫：

-  Benchmark
-  Config
-  Controller
-  Exceptions
-  Hooks
-  Input
-  Language
-  Loader
-  Log
-  Output
-  Router
-  Security
-  URI
-  Utf8

取代核心類
======================

要使用您自己的系統類取代預設的系統類只需簡單的將您自己的文件放入資料夾 *application/core* 下::

	application/core/some_class.php

如果這個資料夾不存在，您可以建立一個。

任何一個和上面清單中同名的文件將被取代成核心類。

要注意的是，您的類名必須以 CI 開頭，例如，您的文件是 Input.php，那麼類應該命名為::

	class CI_Input {

	}

擴展核心類
====================

如果您只是想往現有類中加入一些功能，例如增加一兩個成員函數，這時取代整個類感覺就有點殺雞用牛刀了。在這種情況下，最好是使用擴展類的成員函數。擴展一個類和取代一個類的做法幾乎是一樣的，除了要注意以下幾點：

-  您定義的類必須繼承自父類。
-  您的類名和文件名必須以 MY\_ 開頭。（這是可設定的，見下文）

舉個範例，要擴展原始的 Input 類，您需要新建一個文件 application/core/MY_Input.php，然後像下面這樣定義您的類::

	class MY_Input extends CI_Input {

	}

.. note:: 如果在您的類中需要使用構造函數，記得要呼叫父類的構造函數：

	::

		class MY_Input extends CI_Input {

			public function __construct()
			{
				parent::__construct();
			}
		}

**提示：** 任何和父類同名的成員函數將會取代父類中的成員函數（這又被稱作「成員函數覆蓋」），這讓您可以充分的利用並修改 CodeIgniter 的核心。

如果您擴展了控制器核心類，那麼記得在您的應用程式控制器裡繼承您擴展的新類。

::

	class Welcome extends MY_Controller {

		public function __construct()
		{
			parent::__construct();
			// Your own constructor code
		}

		public function index()
		{
			$this->load->view('welcome_message');
		}
	}

自定義前綴
-----------------------

要想自定義您自己的類的前綴，打開文件 *application/config/config.php* 然後找到這項::

	$config['subclass_prefix'] = 'MY_';

請注意所有原始的 CodeIgniter 類庫都以 CI\_ 開頭，所以請不要使用這個作為您的自定義前綴。
