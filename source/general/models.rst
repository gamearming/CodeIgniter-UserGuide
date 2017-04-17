######
模型
######

模型對於那些想使用更傳統的 MVC 模式的人來說是可選的。

.. contents:: 資料夾

什麼是模型？
================

模型是專門用來和資料庫打交道的 PHP 類。例如，假設您使用 CodeIgniter
管理一個部落格，那麼您應該會有一個用於插入、更新以及讀取部落格資料的模型類。
這裡是一個模型類的範例::

	class Blog_model extends CI_Model {

		public $title;
		public $content;
		public $date;

		public function get_last_ten_entries()
		{
			$query = $this->db->get('entries', 10);
			return $query->result();
		}

		public function insert_entry()
		{
			$this->title	= $_POST['title']; // please read the below note
			$this->content	= $_POST['content'];
			$this->date	= time();

			$this->db->insert('entries', $this);
		}

		public function update_entry()
		{
			$this->title	= $_POST['title'];
			$this->content	= $_POST['content'];
			$this->date	= time();

			$this->db->update('entries', $this, array('id' => $_POST['id']));
		}

	}

.. note:: 上面的範例中使用了 :doc:`查詢產生器 <../database/query_builder>` 資料庫成員函數。

.. note:: 為了保證簡單，我們在這個範例中直接使用了 ``$_POST`` 資料，這其實是個不好的實踐，
	一個更通用的做法是使用 :doc:`輸入庫 <../libraries/input>` 的 ``$this->input->post('title')``。

剖析模型
==================

模型類位於您的 **application/models/** 資料夾下，如果您願意，也可以在裡面建立子資料夾。

模型類的基本原型如下::

	class Model_name extends CI_Model {

		public function __construct()
		{
			parent::__construct();
			// Your own constructor code
		}

	}

其中，**Model_name** 是類的名字，類名的第一個字母 **必須** 大寫，其餘部分小寫。確保您的類
繼承 CI_Model 基類。

文件名和類名應該一致，例如，如果您的類是這樣::

	class User_model extends CI_Model {

		public function __construct()
		{
			parent::__construct();
			// Your own constructor code
		}

	}

那麼您的文件名應該是這樣::

	application/models/User_model.php

載入模型
===============

您的模型一般會在您的 :doc:`控制器 <controllers>` 的成員函數中載入並呼叫，
您可以使用下面的成員函數來載入模型::

	$this->load->model('model_name');

如果您的模型位於一個子資料夾下，那麼載入時要帶上您的模型所在資料夾的相對路徑，
例如，如果您的模型位於 *application/models/blog/Queries.php* ，
您可以這樣載入它::

	$this->load->model('blog/queries');

載入之後，您就可以通過一個和您的類同名的物件存取模型中的成員函數。
::

	$this->load->model('model_name');

	$this->model_name->method();

如果您想將您的模型物件賦值給一個不同名字的物件，您可以使用 ``$this->load->model()``
成員函數的第二個參數::

	$this->load->model('model_name', 'foobar');

	$this->foobar->method();

這裡是一個範例，該控制器載入一個模型，並處理一個檢視::

	class Blog_controller extends CI_Controller {

		public function blog()
		{
			$this->load->model('blog');

			$data['query'] = $this->blog->get_last_ten_entries();

			$this->load->view('blog', $data);
		}
	}


模型的自動載入
===================

如果您發現您有一個模型需要在整個應用程式中使用，您可以讓 CodeIgniter
在系統初始化時自動載入它。打開 **application/config/autoload.php** 文件，
並將該模型加入到 autoload 陣列中。

連接資料庫
===========================

當模型載入之後，它 **並不會** 自動去連接您的資料庫，下面是一些關於
資料庫連接的選項：

-  您可以在控制器或模型中使用 :doc:`標準的資料庫成員函數 <../database/connecting>` 連接資料庫。
-  您可以設定第三個參數為 TRUE 讓模型在載入時自動連接資料庫，會使用您的資料庫設定文件中的設定::

	$this->load->model('model_name', '', TRUE);

-  您還可以通過第三個參數傳一個資料庫連接設定::

	$config['hostname'] = 'localhost';
	$config['username'] = 'myusername';
	$config['password'] = 'mypassword';
	$config['database'] = 'mydatabase';
	$config['dbdriver'] = 'mysqli';
	$config['dbprefix'] = '';
	$config['pconnect'] = FALSE;
	$config['db_debug'] = TRUE;

	$this->load->model('model_name', '', $config);
