##########################
建立附屬類
##########################

有些時候，您可能想在您的控制器之外新建一些類，但同時又希望
這些類還能存取 CodeIgniter 的資源。下面您會看到，這其實很簡單。

get_instance()
==============

.. php:function:: get_instance()

	:returns:	Reference to your controller's instance
	:rtype:	CI_Controller

任何在您的控制器成員函數中初始化的類都可以簡單的通過 ``get_instance()``
函數來存取 CodeIgniter 資源。這個函數傳回一個 CodeIgniter 物件。

通常來說，呼叫 CodeIgniter 的成員函數需要使用 ``$this`` ::

	$this->load->helper('url');
	$this->load->library('session');
	$this->config->item('base_url');
	// etc.

但是 ``$this`` 只能在您的控制器、模型或檢視中使用，如果您想在
您自己的類中使用 CodeIgniter 類，您可以像下面這樣做：

首先，將 CodeIgniter 物件賦值給一個變數::

	$CI =& get_instance();

一旦您把 CodeIgniter 物件賦值給一個變數之後，您就可以使用這個變數
來 *代替* ``$this`` ::

	$CI =& get_instance();

	$CI->load->helper('url');
	$CI->load->library('session');
	$CI->config->item('base_url');
	// etc.

如果您在類中使用``get_instance()`` 函數，最好的成員函數是將它賦值給
一個屬性 ，這樣您就不用在每個成員函數裡都呼叫 ``get_instance()`` 了。

例如::

	class Example {

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
			$this->CI->config->item('base_url');
		}
	}

在上面的範例中， ``foo()`` 和 ``bar()`` 成員函數在初始化 Example 
類之後都可以正常工作，而不需要在每個成員函數裡都呼叫 ``get_instance()`` 函數。
