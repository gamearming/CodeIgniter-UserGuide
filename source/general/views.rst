#####
檢視
#####

簡單來說，一個檢視其實就是一個 Web 頁面，或者頁面的一部分，像頁頭、頁腳、側邊欄等。
實際上，檢視可以很靈活的嵌在另一個檢視裡，然後這個檢視再嵌在另一個檢視裡，等等，
如果您想使用這種層次結構的話，可以這樣做。

檢視不是直接被呼叫的，它必須通過 :doc:`控制器 <controllers>` 來載入。在 MVC 框架裡，
控制器扮演著類似於交警的角色，它專門負責讀取特定的檢視。如果您還沒有讀過
:doc:`控制器 <controllers>` 頁面，您應該先看下這個。

使用在 :doc:`控制器 <controllers>` 頁面中建立的控制器範例，讓我們再加入一個檢視。

建立檢視
===============

使用您的文字編輯器，建立一個 blogview.php 文件，程式碼如下::

	<html>
	<head>
		<title>My Blog</title>
	</head>
	<body>
		<h1>Welcome to my Blog!</h1>
	</body>
	</html>
	
然後儲存到您的 *application/views/* 資料夾下。

載入檢視
==============

使用下面的成員函數來載入指定的檢視::

	$this->load->view('name');

name 參數為您的檢視文件名。

.. note:: 文件的擴展名 .php 可以省略，除非您使用了其他的擴展名。

現在，打開您之前建立的控制器文件 Blog.php ，然後將 echo 語句取代成
載入檢視的程式碼::

	<?php
	class Blog extends CI_Controller {

		public function index()
		{
			$this->load->view('blogview');
		}
	}

跟之前一樣，通過類似於下面的 URL 來存取您的網站，您將看到新的頁面::

	example.com/index.php/blog/

載入多個檢視
======================

CodeIgniter 可以智能的處理在控制器中多次呼叫 ``$this->load->view()`` 成員函數。
如果出現了多次呼叫，檢視會被合併到一起。例如，您可能希望有一個頁頭檢視、
一個菜單檢視，一個內容檢視 以及 一個頁腳檢視。程式碼看起來應該這樣::

	<?php

	class Page extends CI_Controller {

		public function index()
		{
			$data['page_title'] = 'Your title';
			$this->load->view('header');
			$this->load->view('menu');
			$this->load->view('content', $data);
			$this->load->view('footer');
		}

	}

在上面的範例中，我們使用了 "加入動態資料" ，我們會在後面講到。

在子資料夾中儲存檢視
====================================

如果您喜歡的話，您的檢視文件可以放到子資料夾下組織儲存，當您這樣做，
載入檢視時需要包含子資料夾的名字，例如::

	$this->load->view('directory_name/file_name');

向檢視加入動態資料
===============================

通過檢視載入成員函數的第二個參數可以從控制器中動態的向檢視傳入資料，
這個參數可以是一個 **陣列** 或者一個 **物件** 。這裡是使用陣列的範例::

	$data = array(
		'title' => 'My Title',
		'heading' => 'My Heading',
		'message' => 'My Message'
	);

	$this->load->view('blogview', $data);

這裡是使用物件的範例::

	$data = new Someclass();
	$this->load->view('blogview', $data);

.. note:: 當您使用物件時，物件中的變數會轉換為陣列元素。

讓我們在您的控制器文件中嘗試一下，加入如下程式碼::

	<?php
	class Blog extends CI_Controller {

		public function index()
		{
			$data['title'] = "My Real Title";
			$data['heading'] = "My Real Heading";

			$this->load->view('blogview', $data);
		}
	}

再打開您的檢視文件，將文字修改為傳入的陣列對應的變數::

	<html>
	<head>
		<title><?php echo $title;?></title>
	</head>
	<body>
		<h1><?php echo $heading;?></h1>
	</body>
	</html>

然後通過剛剛的 URL 重新載入頁面，您應該可以看到變數被取代了。

使用循環
==============

傳入檢視文件的資料不僅僅限制為普通的變數，您還可以傳入多維陣列，
這樣您就可以在檢視中產生多行了。例如，如果您從資料庫中讀取資料，
一般情況下資料都是一個多維陣列。

這裡是個簡單的範例，將它加入到您的控制器中::

	<?php
	class Blog extends CI_Controller {

		public function index()
		{
			$data['todo_list'] = array('Clean House', 'Call Mom', 'Run Errands');

			$data['title'] = "My Real Title";
			$data['heading'] = "My Real Heading";

			$this->load->view('blogview', $data);
		}
	}

然後打開您的檢視文件，建立一個循環::

	<html>
	<head>
		<title><?php echo $title;?></title>
	</head>
	<body>
		<h1><?php echo $heading;?></h1>
	
		<h3>My Todo List</h3>

		<ul>
		<?php foreach ($todo_list as $item):?>
	
			<li><?php echo $item;?></li>
	
		<?php endforeach;?>
		</ul>

	</body>
	</html>

.. note:: 您會發現在上例中，我們使用了 PHP 的替代語法，如果您對其還不熟悉，可以閱讀
	:doc:`這裡 <alternative_php>` 。

將檢視作為資料傳回
=======================

載入檢視成員函數有一個可選的第三個參數可以讓您修改它的預設行為，它讓檢視作為字元串傳回
而不是顯示到瀏覽器中，這在您想對檢視資料做某些處理時很有用。如果您將該參數設定為 TRUE ，
該成員函數傳回字元串，預設情況下為 FALSE ，檢視將顯示到瀏覽器。如果您需要傳回的資料，
記住將它賦值給一個變數::

	$string = $this->load->view('myfile', '', TRUE);