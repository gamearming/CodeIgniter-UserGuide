############
靜態頁面
############

**Note:** 這篇教程假設您已經下載好 CodeIgniter ，並將其 :doc:`安裝 <../installation/index>`
到您的開發環境。

您要做的第一件事情是新建一個 **控制器** 來處理靜態頁面，控制器就是一個簡單的類，
用來完成您的工作，它是您整個 Web 應用程式的 「粘合劑」 。

例如，當存取下面這個 URL 時:

	http://example.com/news/latest/10

通過這個 URL 我們就可以推測出來，有一個叫做 "news" 的控制器，被呼叫的成員函數為 "latest" ，
這個成員函數的作用應該是查詢 10 條新聞項目並顯示在頁面上。在 MVC 模式裡，您會經常看到下面
格式的 URL ：

	http://example.com/[controller-class]/[controller-method]/[arguments]

在正式環境下 URL 的格式可能會更複雜，但是現在，我們只需要關心這些就夠了。

新建一個文件 *application/controllers/Pages.php* ，然後加入如下程式碼。

::

	<?php
	class Pages extends CI_Controller {

		public function view($page = 'home')
		{
	    }
	}

您剛剛建立了一個 ``Pages`` 類，有一個成員函數 view 並可接受一個 $page 參數。
``Pages`` 類繼承自 ``CI_Controller`` 類，這意味著它可以存取 ``CI_Controller``
類（ *system/core/Controller.php* ）中定義的成員函數和變數。

控制器將會成為您的 Web 應用程式中的處理請求的核心，在關於 CodeIgniter
的技術討論中，這有時候被稱作 **超級物件** 。和其他的 PHP 類一樣，可以在
您的控制器中使用 ``$this`` 來存取它，通過 ``$this`` 您就可以載入類庫、
檢視、以及針對框架的一般性操作。

現在，您已經建立了您的第一個成員函數，是時候建立一些基本的頁面模板了，我們將
新建兩個檢視（頁面模板）分別作為我們的頁腳和頁頭。

新建頁頭文件 *application/views/templates/header.php* 並加入以下程式碼：

::

	<html>
		<head>
			<title>CodeIgniter Tutorial</title>
		</head>
		<body>

			<h1><?php echo $title; ?></h1>

頁頭包含了一些基本的 HTML 程式碼，用於顯示頁面的主檢視之前的內容。
另外，它還打印出了 ``$title`` 變數，這個我們後面講控制器的時候再講。
現在，再新建個頁腳文件 *application/views/templates/footer.php* ，然後加入以下程式碼：

::

			<em>&copy; 2015</em>
		</body>
	</html>

在控制器中加入邏輯
------------------------------

您剛剛新建了一個控制器，裡面有一個 ``view()`` 成員函數，這個成員函數接受一個參數
用於指定要載入的頁面，靜態頁面模板位於 *application/views/pages/* 目錄。

在該目錄中，再新建兩個文件 *home.php* 和 *about.php* ，在每個文件裡隨便
寫點東西然後儲存它們。如果您沒什麼好寫的，就寫 "Hello World!" 吧。

為了載入這些頁面，您需要先檢查下請求的頁面是否存在：

::

	public function view($page = 'home')
	{
	  if ( ! file_exists(APPPATH.'views/pages/'.$page.'.php'))
		{
			// Whoops, we don't have a page for that!
			show_404();
		}

		$data['title'] = ucfirst($page); // Capitalize the first letter

		$this->load->view('templates/header', $data);
		$this->load->view('pages/'.$page, $data);
		$this->load->view('templates/footer', $data);
	}

當請求的頁面存在，將包括頁面和頁腳一起被載入並顯示給用戶，如果不存在，
會顯示一個 "404 Page not found" 錯誤。

第一行檢查頁面是否存在，``file_exists()`` 是個原生的 PHP 函數，用於檢查某個
文件是否存在，``show_404()`` 是個 CodeIgniter 內置的函數，用來顯示一個預設的
錯誤頁面。

在頁頭文件中，``$title`` 變數用來自定義頁面的標題，它是在這個成員函數中賦值的，
但是注意的是並不是直接賦值給 title 變數，而是賦值給一個 ``$data`` 陣列的
title 元素。

最後要做的是按順序載入所需的檢視，``view()`` 成員函數的第二個參數用於向檢視傳遞參數，
``$data`` 陣列中的每一項將被賦值給一個變數，這個變數的名字就是陣列的鍵值。
所以控制器中 ``$data['title']`` 的值，就等於檢視中的 ``$title`` 的值。

路由
-------

控制器現在開始工作了！在您的瀏覽器中輸入 ``[your-site-url]index.php/pages/view``
來查看您的頁面。當您存取 ``index.php/pages/view/about`` 時您將看到 about 頁面，
包括頁頭和頁腳。

使用自定義的路由規則，您可以將任意的 URI 映射到任意的控制器和成員函數上，從而打破
預設的規則：

``http://example.com/[controller-class]/[controller-method]/[arguments]``

讓我們來試試。打開文件 *application/config/routes.php* 然後加入如下兩行程式碼，
並刪除掉其他對 ``$route`` 陣列賦值的程式碼。

::

	$route['default_controller'] = 'pages/view';
	$route['(:any)'] = 'pages/view/$1';

CodeIgniter 從上到下讀取路由規則並將請求映射到第一個匹配的規則，每一個規則都是
一個正則表達式（左側）映射到 一個控制器和成員函數（右側）。當有請求到來時，CodeIgniter
首先查找能匹配的第一條規則，然後呼叫相應的控制器和成員函數，可能還帶有參數。

您可以在關於 :doc:`URI 路由的文件 <../general/routing>` 中找到更多資訊。

這裡，第二條規則中 ``$routes`` 陣列使用了通配符 ``(:any)`` 可以匹配所有的請求，
然後將參數傳遞給 ``Pages`` 類的 ``view()`` 成員函數。

現在存取 ``index.php/about`` 。路由規則是不是正確的將您帶到了控制器中的 ``view()`` 成員函數？實在是太棒了！
