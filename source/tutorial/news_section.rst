############
新聞模組
############

在上一節中，我們通過寫出一個包含靜態頁面的類瞭解了一些框架的基本概念，
我們也依據自定義路由規則來重定向 URI 。現在是時候向大家介紹動態內容
和如何使用資料庫了。

建立您的資料模型
---------------------

資料庫的查詢操作應該放在模型裡，而不是寫在控制器裡，這樣可以很方便的重用它。
模型正是用於從資料庫或者其他儲存中讀取、新增、更新資料的地方。它就代表您的資料。

打開 *application/models/* 目錄，新建一個文件 *News_model.php* ，然後寫入下面的程式碼。
確保您的 :doc:`資料庫設定 <../database/configuration>` 正確。

::

	<?php
	class News_model extends CI_Model {

		public function __construct()
		{
			$this->load->database();
		}
	}

這個程式碼和之前的控制器的程式碼有點類似，它通過繼承 ``CI_Model`` 建立了一個新模型，
並載入了資料庫類。資料庫類可以通過 ``$this->db`` 物件存取。

在查詢資料庫之前，我們要先建立一個資料庫表。連接您的資料庫，執行下面的 SQL 語句（MySQL），並加入一些測試資料。

::

	CREATE TABLE news (
		id int(11) NOT NULL AUTO_INCREMENT,
		title varchar(128) NOT NULL,
		slug varchar(128) NOT NULL,
		text text NOT NULL,
		PRIMARY KEY (id),
		KEY slug (slug)
	);

現在，資料庫和模型都準備好了，您需要一個成員函數來從資料庫中讀取所有的新聞文章。
為實現這點，我們使用了 CodeIgniter 的資料庫抽像層 :doc:`查詢產生器 <../database/query_builder>` ，
通過它您可以編寫您的查詢程式碼，並在 :doc:`所有支援的資料庫平台 <../general/requirements>` 上執行。
向您的模型中加入如下程式碼。

::

	public function get_news($slug = FALSE)
	{
		if ($slug === FALSE)
		{
			$query = $this->db->get('news');
			return $query->result_array();
		}

		$query = $this->db->get_where('news', array('slug' => $slug));
		return $query->row_array();
	}

通過這個程式碼，您可以執行兩種不同的查詢，一種是讀取所有的新聞項目，另一種
是依據它的 `slug <#>`_ 來讀取新聞項目。您應該注意到，``$slug`` 變數在執行查詢之前
並沒有做檢查， :doc:`查詢產生器 <../database/query_builder>` 會自動幫您檢查的。

顯示新聞
----------------

現在，查詢已經寫好了，接下來我們需要將模型綁定到檢視上，向用戶顯示新聞項目了。
這可以在之前寫的 ``Pages`` 控制器裡來做，但為了更清楚的闡述，我們定義了一個新的 
``News`` 控制器，建立在 *application/controllers/News.php* 文件中。

::

	<?php
	class News extends CI_Controller {

		public function __construct()
		{
			parent::__construct();
			$this->load->model('news_model');
			$this->load->helper('url_helper');
		}

		public function index()
		{
			$data['news'] = $this->news_model->get_news();
		}

		public function view($slug = NULL)
		{
			$data['news_item'] = $this->news_model->get_news($slug);
		}
	}

閱讀上面的程式碼您會發現，這和之前寫的程式碼有些相似之處。首先是 ``__construct()`` 
成員函數，它呼叫父類（``CI_Controller``）中的構造函數，並載入模型。這樣模型就可以
在這個控制器的其他成員函數中使用了。另外它還載入了 :doc:`URL 輔助函數 <../helpers/url_helper>` ，
因為我們在後面的檢視中會用到它。

其次，有兩個成員函數用來顯示新聞項目，一個顯示所有的，另一個顯示特定的。
您可以看到第二個成員函數中呼叫模型成員函數時傳入了 ``$slug`` 參數，模型依據這個 slug 
傳回特定的新聞項目。

現在，通過模型，控制器已經讀取到資料了，但還沒有顯示。下一步要做的就是，
將資料傳遞給檢視。

::

	public function index()
	{
		$data['news'] = $this->news_model->get_news();
		$data['title'] = 'News archive';

		$this->load->view('templates/header', $data);
		$this->load->view('news/index', $data);
		$this->load->view('templates/footer');
	}

上面的程式碼從模型中讀取所有的新聞項目，並賦值給一個變數，另外頁面的標題賦值給了
``$data['title']`` 元素，然後所有的資料被傳遞給檢視。現在您需要建立一個檢視文件來
顯示新聞項目了，新建 *application/views/news/index.php* 文件並加入如下程式碼。

::

	<h2><?php echo $title; ?></h2>
	
	<?php foreach ($news as $news_item): ?>

		<h3><?php echo $news_item['title']; ?></h3>
		<div class="main">
			<?php echo $news_item['text']; ?>
		</div>
		<p><a href="<?php echo site_url('news/'.$news_item['slug']); ?>">View article</a></p>

	<?php endforeach; ?>

這裡，通過一個循環將所有的新聞項目顯示給用戶，您可以看到我們在 HTML 模板中混用了 PHP ，
如果您希望使用一種模板語言，您可以使用 CodeIgniter 的 :doc:`模板解析類 <../libraries/parser>` ，
或其他的第三方解析器。

新聞的清單頁就做好了，但是還缺了顯示特定新聞項目的頁面，之前建立的模型可以很容易的
實現該功能，您只需要向控制器中加入一些程式碼，然後再新建一個檢視就可以了。回到 ``News``
控制器，使用下面的程式碼取代掉 ``view()`` 成員函數：

::

	public function view($slug = NULL)
	{
		$data['news_item'] = $this->news_model->get_news($slug);

		if (empty($data['news_item']))
		{
			show_404();
		}

		$data['title'] = $data['news_item']['title'];

		$this->load->view('templates/header', $data);
		$this->load->view('news/view', $data);
		$this->load->view('templates/footer');
	}

我們並沒有直接呼叫 ``get_news()`` 成員函數，而是傳入了一個 ``$slug`` 參數，
所以它會傳回相應的新聞項目。最後剩下的事是建立檢視文件
*application/views/news/view.php* 並加入如下程式碼 。

::

	<?php
	echo '<h2>'.$news_item['title'].'</h2>';
	echo $news_item['text'];

路由
-------

由於之前建立的通配符路由規則，您需要新增一條路由來顯示您剛剛建立的控制器，
修改您的路由設定文件（*application/config/routes.php*）加入類似下面的程式碼。
該規則可以讓請求存取 ``News`` 控制器而不是 ``Pages`` 控制器，第一行可以讓
帶 slug 的 URI 重定向到 ``News`` 控制器的 ``view()`` 成員函數。

::

	$route['news/(:any)'] = 'news/view/$1';
	$route['news'] = 'news';
	$route['(:any)'] = 'pages/view/$1';
	$route['default_controller'] = 'pages/view';

把瀏覽器的地址改回根目錄，在後面加上 index.php/news 來看看您的新聞頁面吧。
