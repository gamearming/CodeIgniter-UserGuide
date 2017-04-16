############
靜態頁面
############

.. note::

本篇教學是假設您已經下載並 :doc:`安裝 <../installation/index>` CodeIgniter 到您的開發環境中。

那麼第一件要做的就是新增一個 **控制器** 來處理靜態頁面。

**控制器** 是一個簡單的類別，用來幫助委派工作，它是整個 Web 應用程式的 **整合轉譯介面**。

例如： 當瀏覽器發出一個網址請求時::

	http://example.com/news/latest/10

通過這個網址我們可以推測出 **控制器** 的名稱是 "news" 而此 **控制器** 將被呼叫的成員函數為 "latest"。
而這個成員函數的作用應該是查詢 10 條新聞記錄並顯示到頁面上，在 MVC 架構您經常會看到以下網址::

	http://example.com/[controller-class]/[controller-method]/[arguments]

在正式環境下網址的格式可能會更複雜，但目前我們只需要關心這些就夠了。

新增 *application/controllers/Pages.php* 檔案並加入如下程式碼::

	<?php
	class Pages extends CI_Controller {
		public function view($page = 'home') {
		 // TODO 
	  }
	}


剛剛建立名稱為 ``Pages`` 的類別及一個成員函數 ``view``，並可接受一個 $page 參數。

``Pages`` 類別繼承了 ``CI_Controller`` 類別，表示它可以存取 ``CI_Controller`` (system/core/Controller.php)中定義的成員函數和變數。

此 **控制器** 將會成為整個 Web 應用程式處理請求的核心，這時被稱作 **超級物件** 。 
就像所有的 php 類別一樣，可以在這個 **控制器** 中使用 ``$this`` 來存取類別庫、檢視、以及針對框架的一般性操作。


現在您已經建立了第一個成員函數，再來就是建立基本頁面的模板了。

我們將建立 ``頁首模板`` 檔案 *application/views/templates/header.php* 並加入以下的程式碼:: 

	<html>
		<head>
			<title>CodeIgniter Tutorial</title>
		</head>
		<body>

			<h1><?php echo $title; ?></h1>

*header.php* 主要用於顯示主頁面之前的 HTML 基本程式碼，包括 head、title 等內容，也顯示了 ``$title`` 變數，將在後面說明 **控制器** 的時候再來定義。

再來建立 ``頁尾模板`` 檔案 *application/views/templates/footer.php* ，然後加入以下程式碼::

			<em>&copy; 2015</em>
		</body>
	</html>
	
這樣就完成兩個 ``view`` （頁面模板）作為我們的頁首和頁尾。

在控制器中加入邏輯
------------------------------

在剛才新增的 **控制器** 中，有個 ``view()`` 的成員函數包括一個要載入指定頁面的參數。

靜態頁面模板位於 *application/views/pages/* 資料夾，在此資料夾中我們分別建立 *home.php* 和 *about.php* 二個檔案。
在各別文件中隨意寫入一些資料，如果不知要寫什麼就寫 "Hello World!" 吧，這是為了測試存取頁面時，檢查頁面是否存在::

	public function view($page = 'home') {
	  if( ! file_exists(APPPATH.'views/pages/'.$page.'.php'))	{
			// Whoops, we don't have a page for that!
			show_404();
		}

		$data['title'] = ucfirst($page); // Capitalize the first letter

		$this->load->view('templates/header', $data);
		$this->load->view('pages/'.$page, $data);
		$this->load->view('templates/footer', $data);
	}

當存取的頁面存在，則會將頁首和頁尾一起顯示給用戶，如果不存在則會顯示 "404 找不到頁面" 的錯誤。

上面程式碼第一行是檢查頁面是否存在 ``file_exists()`` 是 PHP 的原生函數，用於檢查某個文件是否存在，
``show_404()`` 是 CodeIgniter 內建函數，用來顯示預設的錯誤頁面。

在頁首文件中 ``$title`` 變數用來自定義頁面的標題，我們在這個成員函數中賦值，但是要 **注意** 並不是直接賦值給 title 變數，而是賦值給 ``$data`` 陣列的 title 元素。


最後要做的是按照順序來讀取檢視， ``view()`` 成員函數中的第二個參數是用於向檢視傳遞參數。
``$data`` 陣列中的 **索引鍵值** 就是相應的 **變數名稱**，所以在 **控制器** 中 $data['title'] 的值等同於檢視中的 $title 值。

路由 (Routing)
-------

控制器現在開始工作了！在瀏覽器中輸入 ``[您的網址]index.php/pages/view``，  
本機測試可輸入 ``http://localhost/index.php/pages/view`` 來存取您的頁面。
當您存取 ``index.php/pages/view/about`` 時您將看到 about 頁面，包括頁首和頁尾。

使用自定義的路由規則，您可以將任意的 URI 對應到任意的 **控制器** 與成員函數，進而擺脫了傳統網址預設的規則 ``http://example.com/[controller-class]/[controller-method]/[arguments]``

讓我們來試試開啟 *application/config/routes.php* 檔案，然後加入如下兩行程式碼，並刪除掉其他對 ``$route`` 陣列賦值的程式碼::

	$route['default_controller'] = 'pages/view';
	$route['(:any)'] = 'pages/view/$1';

CodeIgniter 從上到下讀取路由規則，並將請求對應到第一個符合的規則，每規則都是以正則表達式(左側)對應到反斜線分隔的 **控制器** 和成員函數(右側)。

當有請求到來時，CodeIgniter 首先查詢第一個符合的規則，然後呼叫相應的 **控制器** 和成員函數，可能還包含了參數。

關於路由的更多資訊，請參閱： :doc:`URI 路由 <../general/routing>` 一節。

這裡第二條規則中 ``$routes`` 陣列使用了萬用字元 ``(:any)`` 可以符合所有的請求，然後將參數傳遞給 ``Pages`` 類別的 ``view()`` 成員函數。

現在存取 ``index.php/about`` ，路由規則是不是正確的將您帶到了 **控制器** 中 ``view()`` 的成員函數呢？實在是太棒了！


.. 中文名詞解譯：
.. **控制器**         = Controller
.. **整合轉譯介面**   = glue
.. **網址**           = URL

