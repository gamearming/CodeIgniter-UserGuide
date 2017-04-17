###########
控制器
###########

控制器是您整個應用的核心，因為它們決定了 HTTP 請求將被如何處理。

.. contents:: 資料夾

什麼是控制器？
=====================

**簡而言之，一個控制器就是一個類文件，是以一種能夠和 URI 關聯在一起的方式來命名的。**

考慮下面的 URI::

	example.com/index.php/blog/

上例中，CodeIgniter 將會嘗試查詢一個名為 Blog.php 的控制器並載入它。

**當控制器的名稱和 URI 的第一段匹配上時，它將會被載入。**

讓我們試試看：Hello World！
============================

接下來您會看到如何建立一個簡單的控制器，打開您的文字編輯器，新建一個文件 Blog.php ，
然後放入以下程式碼::

	<?php
	class Blog extends CI_Controller {

		public function index()
		{
			echo 'Hello World!';
		}
	}

然後將文件儲存到 *application/controllers/* 資料夾下。

.. important:: 文件名必須是大寫字母開頭，如：'Blog.php' 。

現在使用類似下面的 URL 來存取您的站點::

	example.com/index.php/blog/

如果一切正常，您將看到：

	Hello World!

.. important:: 類名必須以大寫字母開頭。

這是有效的::

	<?php
	class Blog extends CI_Controller {

	}

這是無效的::

	<?php
	class blog extends CI_Controller {

	}

另外，一定要確保您的控制器繼承了父控制器類，這樣它才能使用父類的成員函數。

成員函數
=======

上例中，成員函數名為 ``index()`` 。"index" 成員函數總是在 URI 的 **第二段** 為空時被呼叫。
另一種顯示 "Hello World" 消息的成員函數是::

	example.com/index.php/blog/index/

**URI 中的第二段用於決定呼叫控制器中的哪個成員函數。**

讓我們試一下，向您的控制器加入一個新的成員函數::

	<?php
	class Blog extends CI_Controller {

		public function index()
		{
			echo 'Hello World!';
		}

		public function comments()
		{
			echo 'Look at this!';
		}
	}

現在，通過下面的 URL 來呼叫 comments 成員函數::

	example.com/index.php/blog/comments/

您應該能看到您的新消息了。

通過 URI 分段向您的成員函數傳遞參數
====================================

如果您的 URI 多於兩個段，多餘的段將作為參數傳遞到您的成員函數中。

例如，假設您的 URI 是這樣::

	example.com/index.php/products/shoes/sandals/123

您的成員函數將會收到第三段和第四段兩個參數（"sandals" 和 "123"）::

	<?php
	class Products extends CI_Controller {

		public function shoes($sandals, $id)
		{
			echo $sandals;
			echo $id;
		}
	}

.. important:: 如果您使用了 :doc:`URI 路由 <routing>` ，傳遞到您的成員函數的參數將是路由後的參數。

定義預設控制器
=============================

CodeIgniter 可以設定一個預設的控制器，當 URI 沒有分段參數時載入，例如當用戶直接存取您網站的首頁時。
打開 **application/config/routes.php** 文件，通過下面的參數指定一個預設的控制器::

	$route['default_controller'] = 'blog';

其中，「Blog」是您想載入的控制器類名，如果您現在通過不帶任何參數的 index.php 存取您的站點，您將看到您的「Hello World」消息。

For more information, please refer to the "Reserved Routes" section of the
:doc:`URI 路由 <routing>` documentation.

重映射成員函數
======================

正如上文所說，URI 的第二段通常決定控制器的哪個成員函數被呼叫。CodeIgniter 允許您使用 ``_remap()`` 成員函數來重寫該規則::

	public function _remap()
	{
		// Some code here...
	}

.. important:: 如果您的控制包含一個 _remap() 成員函數，那麼無論 URI 中包含什麼參數時都會呼叫該成員函數。
	它允許您定義您自己的路由規則，重寫預設的使用 URI 中的分段來決定呼叫哪個成員函數這種行為。

被重寫的成員函數（通常是 URI 的第二段）將被作為參數傳遞到 ``_remap()`` 成員函數::

	public function _remap($method)
	{
		if ($method === 'some_method')
		{
			$this->$method();
		}
		else
		{
			$this->default_method();
		}
	}

成員函數名之後的所有其他段將作為 ``_remap()`` 成員函數的第二個參數，它是可選的。這個參數可以使用 PHP 的
`call_user_func_array() <http://php.net/call_user_func_array>`_ 函數來模擬 CodeIgniter 的預設行為。

例如::

	public function _remap($method, $params = array())
	{
		$method = 'process_'.$method;
		if (method_exists($this, $method))
		{
			return call_user_func_array(array($this, $method), $params);
		}
		show_404();
	}

處理輸出
=================

CodeIgniter 有一個輸出類，它可以自動的將最終資料發送到您的瀏覽器。
更多資訊可以閱讀 :doc:`檢視 <views>` 和 :doc:`輸出類 <../libraries/output>` 頁面。但是，有時候，
您可能希望對最終的資料進行某種方式的後處理，然後您自己手工發送到瀏覽器。CodeIgniter
允許您向您的控制器中加入一個 ``_output()`` 成員函數，該成員函數可以接受最終的輸出資料。

.. important:: 如果您的控制器含有一個 ``_output()`` 成員函數，輸出類將會呼叫該成員函數來顯示資料，
	而不是直接顯示資料。該成員函數的第一個參數包含了最終輸出的資料。

這裡是個範例::

	public function _output($output)
	{
		echo $output;
	}

.. note::

	請注意，當資料傳到 ``_output()`` 成員函數時，資料已經是最終狀態。這時基準測試和計算記憶體佔用都已經完成，
	快取文件也已經寫到文件（如果您開啟快取的話），HTTP 頭也已經發送（如果用到了該 :doc:`特性 <../libraries/output>`）。
	為了使您的控制器能正確處理快取，``_output()`` 可以這樣寫::

		if ($this->output->cache_expiration > 0)
		{
			$this->output->_write_cache($output);
		}

	如果您在使用 ``_output()`` 時，希望讀取頁面執行時間和記憶體佔用情況，結果可能會不準確，
	因為並沒有統計您後加的處理程式碼。另一個可選的成員函數是在所有最終輸出 *之前* 來進行處理，
	請參閱 :doc:`輸出類 <../libraries/output>` 。

私有成員函數
===============

有時候您可能希望某些成員函數不能被公開存取，要實現這點，只要簡單的將成員函數聲明為 private 或 protected ，
這樣這個成員函數就不能被 URL 存取到了。例如，如果您有一個下面這個成員函數::

	private function _utility()
	{
		// some code
	}

使用下面的 URL 嘗試存取它，您會發現是無法存取的::

	example.com/index.php/blog/_utility/

.. note:: 為了向後相容原有的功能，在成員函數名前加上一個下劃線前綴也可以讓該成員函數無法存取。

將控制器放入子資料夾中
================================================

如果您正在構建一個比較大的應用，那麼將控制器放到子資料夾下進行組織可能會方便一點。CodeIgniter 也可以實現這一點。

您只需要簡單的在 *application/controllers/* 資料夾下建立新的資料夾，並將控制器文件放到子資料夾下。

.. note:: 當使用該功能時，URI 的第一段必須指定資料夾，例如，假設您在如下位置有一個控制器::

		application/controllers/products/Shoes.php

	為了呼叫該控制器，您的 URI 應該像下面這樣::

		example.com/index.php/products/shoes/show/123

Each of your sub-directories may contain a default controller which will be
called if the URL contains *only* the sub-directory. Simply put a controller
in there that matches the name of your 'default_controller' as specified in
your *application/config/routes.php* file.

您也可以使用 CodeIgniter 的 :doc:`URI 路由 <routing>` 功能來重定向 URI。

構造函數
==================

如果您打算在您的控制器中使用構造函數，您 **必須** 將下面這行程式碼放在裡面::

	parent::__construct();

原因是您的構造函數將會覆蓋父類的構造函數，所以我們要手工的呼叫它。

例如::

	<?php
	class Blog extends CI_Controller {

		public function __construct()
		{
			parent::__construct();
			// Your own constructor code
		}
	}

如果您需要在您的類被初始化時設定一些預設值，或者進行一些預設處理，構造函數將很有用。
構造函數沒有傳回值，但是可以執行一些預設操作。

保留成員函數名
=====================

因為您的控制器將繼承主程序的控制器，在新建成員函數時您必須要小心不要使用和父類一樣的成員函數名，
要不然您的成員函數將覆蓋它們，參見 :doc:`保留名稱 <reserved_names>` 。

.. important:: 另外，您也絕對不要新建一個和類名稱一樣的成員函數。如果您這樣做了，而且您的控制器
	又沒有一個 ``__construct()`` 構造函數，那麼這個和類名同名的成員函數 ``Index::index()``
	將會作為類的構造函數被執行！這個是 PHP4 的向前相容的一個特性。

就這樣了！
==========

OK，總的來說，這就是關於控制器的所有內容了。
