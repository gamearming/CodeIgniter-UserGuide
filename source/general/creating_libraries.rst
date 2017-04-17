##################
建立類庫
##################

當我們使用 「類庫」 這個詞的時候，通常我們指的是位於 libraries 這個資料夾下的那些類，
在我們這份用戶手冊的類庫參考部分有詳細的介紹。但是在這篇文章中，我們將介紹
如何在 application/libraries 資料夾下建立您自己的類庫，和全區的框架類庫獨立開來。

另外，如果您希望在現有的類庫中加入某些額外功能，CodeIgniter 允許您擴展原生的類，
或者您甚至可以在您的 *application/libraries* 資料夾下放置一個和原生的類庫同名的文件
完全替代它。

總結起來：

-  您可以建立一個全新的類庫，
-  您可以擴展原生的類庫，
-  您可以取代掉原生的類庫。

下面將詳細講述這三點。

.. note:: 除了資料庫類不能被擴展或被您的類取代外，其他的類都可以。

儲存位置
=========

您的類庫文件應該放置在 *application/libraries* 資料夾下，當您初始化類時，CodeIgniter 
會在這個資料夾下尋找這些類。

命名約定
==================

-  文件名首字母必須大寫，例如：Myclass.php
-  類名定義首字母必須大寫，例如：class Myclass
-  類名和文件名必須一致

類文件
==============

類應該定義成如下原型::

	<?php
	defined('BASEPATH') OR exit('No direct script access allowed'); 

	class Someclass {

		public function some_method()
		{
		}
	}

.. note:: 這裡的 Someclass 名字只是個範例。

使用您的類
================

在您的 :doc:`控制器 <controllers>` 的任何成員函數中使用如下程式碼初始化您的類::

	$this->load->library('someclass');

其中，*someclass* 為文件名，不包括 .php 文件擴展名。文件名可以寫成首字母大寫，
也可以寫成全小寫，CodeIgniter 都可以識別。

一旦載入，您就可以使用小寫字母名稱來存取您的類::

	$this->someclass->some_method();  // Object instances will always be lower case

初始化類時傳入參數
===============================================

在載入類庫的時候，您可以通過第二個參數動態的傳遞一個陣列資料，該陣列將被傳到
您的類的構造函數中::

	$params = array('type' => 'large', 'color' => 'red');

	$this->load->library('someclass', $params);

如果您使用了該功能，您必須在定義類的構造函數時加上參數::

	<?php defined('BASEPATH') OR exit('No direct script access allowed');

	class Someclass {

		public function __construct($params)
		{
			// Do something with $params
		}
	}

您也可以將參數儲存在設定文件中來傳遞，只需簡單的建立一個和類文件同名的設定文件，
並儲存到您的 *application/config/* 資料夾下。要注意的是，如果您使用了上面介紹的成員函數
動態的傳遞參數，設定文件將不可用。

在您的類庫中使用 CodeIgniter 資源
===================================================

在您的類庫中使用 ``get_instance()`` 函數來存取 CodeIgniter 的原生資源，這個函數傳回
CodeIgniter 超級物件。

通常情況下，在您的控制器成員函數中您會使用 ``$this`` 來呼叫所有可用的 CodeIgniter 成員函數::

	$this->load->helper('url');
	$this->load->library('session');
	$this->config->item('base_url');
	// etc.

但是 ``$this`` 只能在您的控制器、模型或檢視中直接使用，如果您想在您自己的類中使用 
CodeIgniter 類，您可以像下面這樣做：

首先，將 CodeIgniter 物件賦值給一個變數::

	$CI =& get_instance();

一旦您把 CodeIgniter 物件賦值給一個變數之後，您就可以使用這個變數來 *代替* ``$this`` ::

	$CI =& get_instance();

	$CI->load->helper('url');
	$CI->load->library('session');
	$CI->config->item('base_url');
	// etc.

.. note:: 您會看到上面的 ``get_instance()`` 函數通過引用來傳遞::
	
		$CI =& get_instance();

	這是非常重要的，引用賦值允許您使用原始的 CodeIgniter 物件，而不是建立一個副本。

既然類庫是一個類，那麼我們最好充分的使用 OOP 原則，所以，為了讓類中的所有成員函數都能使用
CodeIgniter 超級物件，建議將其賦值給一個屬性::

	class Example_library {

		protected $CI;

		// We'll use a constructor, as you can't directly call a function
		// from a property definition.
		public function __construct()
		{
			// Assign the CodeIgniter super-object
			$this->CI =& get_instance();
		}

		public function foo()
		{
			$this->CI->load->helper('url');
			redirect();
		}

		public function bar()
		{
			echo $this->CI->config->item('base_url');
		}

	}

使用您自己的類庫取代原生類庫
=============================================

簡單的將您的類文件名改為和原生的類庫文件一致，CodeIgniter 就會使用它取代掉原生的類庫。
要使用該功能，您必須將您的類庫文件和類定義改成和原生的類庫完全一樣，例如，
要取代掉原生的 Email 類的話，您要新建一個 *application/libraries/Email.php* 文件，
然後定義定義您的類::

	class CI_Email {
	
	}

注意大多數原生類都以 CI\_ 開頭。

要載入您的類庫，和標準的成員函數一樣::

	$this->load->library('email');

.. note:: 注意資料庫類不能被您自己的類取代掉。

擴展原生類庫
==========================

如果您只是想往現有的類庫中加入一些功能，例如增加一兩個成員函數，
這時取代整個類感覺就有點殺雞用牛刀了。在這種情況下，最好的成員函數是
擴展類庫。擴展一個類和取代一個類差不多，除了以下幾點：

-  類在定義時必須繼承自父類。
-  您的新類名和文件名必須以 MY\_ 為前綴（這個可設定，見下文）

例如，要擴展原生的 Email 類您需要新建一個文件命名為 *application/libraries/MY_Email.php* ，
然後定義您的類::

	class MY_Email extends CI_Email {

	}

如果您需要在您的類中使用構造函數，確保您呼叫了父類的構造函數::

	class MY_Email extends CI_Email {

		public function __construct($config = array())
		{
			parent::__construct($config);
		}

	}

.. note:: 並不是所有的類庫構造函數的參數都是一樣的，在對類庫擴展之前
	先看看它是怎麼實現的。

載入您的擴展類
----------------------

要載入您的擴展類，還是使用和通常一樣的語法。不用包含前綴。例如，
要載入上例中您擴展的 Email 類，您可以使用::

	$this->load->library('email');

一旦載入，您還是和通常一樣使用類變數來存取您擴展的類，以 email 類為例，
存取它的成員函數如下::

	$this->email->some_method();

設定自定義前綴
-----------------------

要設定您自己的類的前綴，您可以打開 *application/config/config.php* 文件，
找到下面這項::

	$config['subclass_prefix'] = 'MY_';

請注意所有原始的 CodeIgniter 類庫都以 **CI\_** 開頭，所以請不要使用這個
作為您的自定義前綴。
