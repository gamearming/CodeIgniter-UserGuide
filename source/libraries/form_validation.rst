###############
表單驗證類
###############

CodeIgniter 提供了一個全面的表單驗證和資料預處理類可以幫您少寫很多程式碼。

.. contents:: Page Contents

********
概述
********

在解釋 CodeIgniter 的資料驗證處理之前，讓我們先描述一下一般的情況：

#. 顯示一個表單。
#. 您填寫並送出了它。
#. 如果您送出了一些無效的資訊，或者可能漏掉了一個必填項，
   表單將會重新顯示您的資料，並提示一個錯誤資訊。
#. 這個過程將繼續，直到您送出了一個有效的表單。

在接收端，腳本必須：

#. 檢查必填的資料。
#. 驗證資料類型是否為正確，條件是否滿足。例如，如果送出一個用戶名，
   必須驗證它是否只包含了允許的字元，必須有一個最小長度，不能超過最大長度。
   用戶名不能和已存在的其他人名字相同，或者不能是某個保留字，等等。
#. 為確保安全性對資料進行過濾。
#. 如果需要，預格式化資料（資料需要清除空白嗎？需要 HTML 編碼？等等）
#. 準備資料，插入資料庫。

儘管上面的過程並不是很複雜，但是通常需要編寫很多程式碼，而且為了顯示錯誤資訊，
在網頁中經常要使用多種不同的控制結構。表單驗證雖然簡單，但是實現起來卻非常枯燥。

************************
表單驗證指南
************************

下面是實現 CodeIgniter 表單驗證的一個簡易教程。

為了進行表單驗證，您需要這三樣東西：

#. 一個包含表單的 :doc:`檢視 <../general/views>` 文件。
#. 一個包含「成功」資訊的檢視文件，在成功送出後將被顯示。
#. 一個接收並處理所送出資料的 :doc:`控制器 <../general/controllers>` 成員函數。

讓我們以一個會員註冊表單為例來建立這三樣東西。

表單
========

使用文字編輯器建立一個名為 myform.php 的文件，在它裡面插入如下程式碼，
並把它儲存到您的 applications/views/ 資料夾下::

	<html>
	<head>
	<title>My Form</title>
	</head>
	<body>

	<?php echo validation_errors(); ?>

	<?php echo form_open('form'); ?>

	<h5>Username</h5>
	<input type="text" name="username" value="" size="50" />

	<h5>Password</h5>
	<input type="text" name="password" value="" size="50" />

	<h5>Password Confirm</h5>
	<input type="text" name="passconf" value="" size="50" />

	<h5>Email Address</h5>
	<input type="text" name="email" value="" size="50" />

	<div><input type="submit" value="Submit" /></div>

	</form>

	</body>
	</html>

成功頁面
================

使用文字編輯器建立一個名為 formsuccess.php 的文件，在它裡面插入如下程式碼，
並把它儲存到您的 applications/views/ 資料夾下::

	<html>
	<head>
	<title>My Form</title>
	</head>
	<body>

	<h3>Your form was successfully submitted!</h3>

	<p><?php echo anchor('form', 'Try it again!'); ?></p>

	</body>
	</html>

控制器
==============

使用文字編輯器建立一個名為 Form.php 的控制器文件，在它裡面插入如下程式碼，
並把它儲存到您的 application/controllers/ 資料夾下::

	<?php

	class Form extends CI_Controller {

		public function index()
		{
			$this->load->helper(array('form', 'url'));

			$this->load->library('form_validation');

			if ($this->form_validation->run() == FALSE)
			{
				$this->load->view('myform');
			}
			else
			{
				$this->load->view('formsuccess');
			}
		}
	}

試一下！
========

存取類似於下面這樣的 URL 來體驗一下您的表單::

	example.com/index.php/form/

如果您送出表單，您會看到表單只是簡單重新載入了，這是因為您還沒有設定任何驗證規則。

**由於您還沒有告訴表單驗證類驗證什麼東西，它預設傳回 FALSE， ``run()``
成員函數只在全部成功匹配了您的規則後才會傳回 TRUE 。**

解釋
===========

在這個頁面上您會注意到以下幾點：

範例中的表單（myform.php）是一個標準的 Web 表單，除了以下兩點：

#. 它使用了一個 表單輔助函數 來建立表單的起始標籤。，嚴格來說這並不是必要的，
   您完全可以使用標準的 HTML 來建立，使用輔助函數的好處是它產生 action 的時候，
   是基於您設定文件來產生 URL 的，這使得您的應用在更改 URL 時更具移植性。
#. 在表單的頂部您將注意到如下函數呼叫：
   ::

	<?php echo validation_errors(); ?>

   這個函數將會傳回驗證器傳回的所有錯誤資訊。如果沒有錯誤資訊，它將傳回空字元串。

控制器（Form.php）有一個成員函數： ``index()`` 。這個成員函數初始化驗證類，
並載入您檢視中用到的 表單輔助函數 和 URL 輔助函數，它也會 執行 驗證流程，
基於驗證是否成功，它會重新顯示表單或顯示成功頁面。

.. _setting-validation-rules:

設定驗證規則
========================

CodeIgniter 允許您為單個表單域建立多個驗證規則，按順序層疊在一起，
您也可以同時對表單域的資料進行預處理。要設定驗證規則，
可以使用 ``set_rules()``  成員函數::

	$this->form_validation->set_rules();

上面的成員函數有 **三個** 參數：

#. 表單域名 - 就是您給表單域取的那個名字。
#. 表單域的 "人性化" 名字，它將被插入到錯誤資訊中。例如，
   如果您有一個表單域叫做 「user」 ，您可能會給它一個人性化的名字叫做 「用戶名」 。
#. 為此表單域設定的驗證規則。
#. （可選的）當此表單域設定自定義的錯誤資訊，如果沒有設定該參數，將使用預設的。

.. note:: 如果您想讓表單域的名字儲存在一個語言文件裡，請參考 :ref:`translating-field-names`

下面是個範例，在您的控制器（Form.php）中緊接著驗證初始化函數之後，加入這段程式碼::

	$this->form_validation->set_rules('username', 'Username', 'required');
	$this->form_validation->set_rules('password', 'Password', 'required');
	$this->form_validation->set_rules('passconf', 'Password Confirmation', 'required');
	$this->form_validation->set_rules('email', 'Email', 'required');

您的控制器現在看起來像這樣::

	<?php

	class Form extends CI_Controller {

		public function index()
		{
			$this->load->helper(array('form', 'url'));

			$this->load->library('form_validation');

			$this->form_validation->set_rules('username', 'Username', 'required');
			$this->form_validation->set_rules('password', 'Password', 'required',
				array('required' => 'You must provide a %s.')
			);
			$this->form_validation->set_rules('passconf', 'Password Confirmation', 'required');
			$this->form_validation->set_rules('email', 'Email', 'required');

			if ($this->form_validation->run() == FALSE)
			{
				$this->load->view('myform');
			}
			else
			{
				$this->load->view('formsuccess');
			}
		}
	}

現在如果您不填寫表單就送出，您將會看到錯誤資訊。如果您填寫了所有的表單域並送出，您會看到成功頁。

.. note:: 當出現錯誤時表單頁將重新載入，所有的表單域將會被清空，並沒有被重新填充。
	稍後我們再去處理這個問題。

使用陣列來設定驗證規則
============================

在繼續之前請注意，如果您更喜歡通過一個操作設定所有規則的話，
您也可以使用一個陣列來設定驗證規則，如果您使用這種方式，
您必須像下面這樣來定義您的陣列::

	$config = array(
		array(
			'field' => 'username',
			'label' => 'Username',
			'rules' => 'required'
		),
		array(
			'field' => 'password',
			'label' => 'Password',
			'rules' => 'required',
			'errors' => array(
				'required' => 'You must provide a %s.',
			),
		),
		array(
			'field' => 'passconf',
			'label' => 'Password Confirmation',
			'rules' => 'required'
		),
		array(
			'field' => 'email',
			'label' => 'Email',
			'rules' => 'required'
		)
	);

	$this->form_validation->set_rules($config);

級聯規則（Cascading Rules）
==============================

CodeIgniter 允許您將多個規則連接在一起。讓我們試一試，修改規則設定函數中的第三個參數，如下::

	$this->form_validation->set_rules(
		'username', 'Username',
		'required|min_length[5]|max_length[12]|is_unique[users.username]',
		array(
			'required'	=> 'You have not provided %s.',
			'is_unique'	=> 'This %s already exists.'
		)
	);
	$this->form_validation->set_rules('password', 'Password', 'required');
	$this->form_validation->set_rules('passconf', 'Password Confirmation', 'required|matches[password]');
	$this->form_validation->set_rules('email', 'Email', 'required|valid_email|is_unique[users.email]');

上面的程式碼設定了以下規則：

#. 用戶名表單域長度不得小於 5 個字元、不得大於 12 個字元。
#. 密碼表單域必須跟密碼確認表單域的資料一致。
#. 電子郵件表單域必須是一個有效郵件地址。

馬上試試看！送出不合法的資料後您會看到新的錯誤資訊，跟您設定的新規則相符。
還有很多其他的驗證規則，您可以閱讀驗證規則參考。

.. note:: 您也可以傳一個包含規則的陣列給 ``set_rules()`` 成員函數來替代字元串，例如::

	$this->form_validation->set_rules('username', 'Username', array('required', 'min_length[5]'));

預處理資料
=============

除了上面我們使用的那些驗證函數，您還可以以多種方式來預處理您的資料。
例如，您可以設定像這樣的規則::

	$this->form_validation->set_rules('username', 'Username', 'trim|required|min_length[5]|max_length[12]');
	$this->form_validation->set_rules('password', 'Password', 'trim|required|min_length[8]');
	$this->form_validation->set_rules('passconf', 'Password Confirmation', 'trim|required|matches[password]');
	$this->form_validation->set_rules('email', 'Email', 'trim|required|valid_email');

在上面的範例裡，我們去掉字元串兩端空白（trimming），檢查字元串的長度，確保兩次輸入的密碼一致。

**任何只有一個參數的 PHP 原生函數都可以被用作一個規則，比如 ``htmlspecialchars``，``trim`` 等等。**

.. note:: 您一般會在驗證規則**之後**使用預處理功能，這樣如果發生錯誤，原資料將會被顯示在表單。

重新填充表單
======================

目前為止我們只是在處理錯誤，是時候用送出的資料重新填充表單了。
CodeIgniter 為此提供了幾個輔助函數，您最常用到的一個是::

	set_value('field name')

打開 myform.php 檢視文件並使用 :php:func:`set_value()` 函數更新每個表單域的 **值** ：

**不要忘記在 :php:func:`set_value()` 函數中包含每個表單域的名字！**

::

	<html>
	<head>
	<title>My Form</title>
	</head>
	<body>

	<?php echo validation_errors(); ?>

	<?php echo form_open('form'); ?>

	<h5>Username</h5>
	<input type="text" name="username" value="<?php echo set_value('username'); ?>" size="50" />

	<h5>Password</h5>
	<input type="text" name="password" value="<?php echo set_value('password'); ?>" size="50" />

	<h5>Password Confirm</h5>
	<input type="text" name="passconf" value="<?php echo set_value('passconf'); ?>" size="50" />

	<h5>Email Address</h5>
	<input type="text" name="email" value="<?php echo set_value('email'); ?>" size="50" />

	<div><input type="submit" value="Submit" /></div>

	</form>

	</body>
	</html>

現在刷新您的頁面並送出表單觸發一個錯誤，您的表單域應該被重新填充了。

.. note:: 下面的 :ref:`class-reference` 節包含了可以讓您重填下拉菜單，單選框和復選框的函數。

.. important:: 如果您使用一個陣列作為一個表單域的名字，那麼函數的參數也應該是一個陣列。例如::

	<input type="text" name="colors[]" value="<?php echo set_value('colors[]'); ?>" size="50" />

更多資訊請參考下面的 :ref:`using-arrays-as-field-names` 一節。

回調：您自己的驗證函數
======================================

驗證系統支援設定您自己的驗證函數，這樣您可以擴展驗證類以適應您自己的需求。
例如，如果您需要查詢資料庫來檢查用戶名是否唯一，您可以建立一個回調函數，
讓我們來新建一個範例。

在您的控制器中，將用戶名的規則修改為::

	$this->form_validation->set_rules('username', 'Username', 'callback_username_check');

然後在您的控制器中加入一個新的成員函數 ``username_check()`` 。您的控制器現在看起來是這樣::

	<?php

	class Form extends CI_Controller {

		public function index()
		{
			$this->load->helper(array('form', 'url'));

			$this->load->library('form_validation');

			$this->form_validation->set_rules('username', 'Username', 'callback_username_check');
			$this->form_validation->set_rules('password', 'Password', 'required');
			$this->form_validation->set_rules('passconf', 'Password Confirmation', 'required');
			$this->form_validation->set_rules('email', 'Email', 'required|is_unique[users.email]');

			if ($this->form_validation->run() == FALSE)
			{
				$this->load->view('myform');
			}
			else
			{
				$this->load->view('formsuccess');
			}
		}

		public function username_check($str)
		{
			if ($str == 'test')
			{
				$this->form_validation->set_message('username_check', 'The {field} field can not be the word "test"');
				return FALSE;
			}
			else
			{
				return TRUE;
			}
		}

	}

重新載入表單並以 「test」 作為用戶名送出資料，您會看到表單域資料被傳遞到您的回調函數中處理了。

要呼叫一個回調函數只需把函數名加一個 "callback\_" **前綴** 並放在驗證規則裡。
如果您需要在您的回調函數中呼叫一個額外的參數，您只需要在回調函數後面用[]把參數
（這個參數只能是字元串類型）括起來，例如：``callback_foo[bar]`` ，
其中 bar 將成為您的回調函數中的第二個參數。

.. note:: 您也可以對傳給您的表單資料進行處理並傳回，如果您的回調函數傳回了除布爾型的
	TRUE 或 FALSE 之外的任何值，它將被認為是您新處理過的表單資料。

使用任何可呼叫的成員函數作為驗證規則
================================

如果回調的規則對您來說還不夠好（例如，它們被限制只能定義在控制器中），
別失望，還有一種成員函數來建立自定義的規則：任何 ``is_callable()`` 函數傳回
TRUE 的東西都可以作為規則。

看下面的範例::

	$this->form_validation->set_rules(
		'username', 'Username',
		array(
			'required',
			array($this->users_model, 'valid_username')
		)
	);

上面的程式碼將使用 ``Users_model`` 模型的 ``valid_username()`` 成員函數來作為驗證規則。

當然，這只是個範例，規則不只限於使用模型的成員函數，您可以使用任何物件和成員函數來接受域值作為第一個參數。您也可以使用匿名函數::

	$this->form_validation->set_rules(
		'username', 'Username',
		array(
			'required',
			function($value)
			{
				// Check $value
			}
		)
	);

但是，由於可呼叫的規則並不是一個字元串，也沒有一個規則名，所以當您需要為它們設定
相應的錯誤消息時會有麻煩。為了解決這個問題，您可以將這樣的規則放到一個陣列的第二個值，
第一個值放置規則名::

	$this->form_validation->set_rules(
		'username', 'Username',
		array(
			'required',
			array('username_callable', array($this->users_model, 'valid_username'))
		)
	);

下面是使用匿名函數的版本::

	$this->form_validation->set_rules(
		'username', 'Username',
		array(
			'required',
			array(
				'username_callable',
				function($str)
				{
					// Check validity of $str and return TRUE or FALSE
				}
			)
		)
	);

.. _setting-error-messages:

設定錯誤資訊
======================

所有原生的錯誤資訊都位於下面的語言文件中： **language/english/form_validation_lang.php**

To set your own global custom message for a rule, you can either
extend/override the language file by creating your own in
**application/language/english/form_validation_lang.php** (read more
about this in the :doc:`Language Class <language>` documentation),
or use the following method::

	$this->form_validation->set_message('rule', 'Error Message');

如果您要為某個域的某個規則設定您的自定義資訊，可以使用 set_rules() 成員函數::

	$this->form_validation->set_rules('field_name', 'Field Label', 'rule1|rule2|rule3',
		array('rule2' => 'Error Message on rule2 for this field_name')
	);

其中， rule 是該規則的名稱，Error Message 為該規則顯示的錯誤資訊。

如果您希望在錯誤資訊中包含域的人性化名稱，或者某些規則設定的一個可選參數
（例如：max_length），您可以在消息中使用 **{field}** 和 **{param}** 標籤::

	$this->form_validation->set_message('min_length', '{field} must have at least {param} characters.');

如果域的人性化名稱為 Username ，並有一個規則 min_length[5] ，那麼錯誤資訊會顯示：
"Username must have at least 5 characters."

.. note:: 老的 `sprintf()` 成員函數和在字元串使用 **%s** 也還可以工作，但是會覆寫掉上面的標籤。
	所以您同時只應該使用兩個中的一個。

在上面回調的範例中，錯誤資訊是通過成員函數的名稱（不帶 "callback\_" 前綴）來設定的::

	$this->form_validation->set_message('username_check')

.. _translating-field-names:

翻譯表單域名稱
=======================

如果您希望將傳遞給 ``set_rules()`` 成員函數的人性化名稱儲存在一個語言文件中，
使他們能被翻譯成其他語言，您可以這麼做：

首先，給人性化名稱加入一個前綴：**lang:**，如下：

	 $this->form_validation->set_rules('first_name', 'lang:first_name', 'required');

然後，將該名稱儲存到您的某個語言文件陣列中（不帶前綴）::

	$lang['first_name'] = 'First Name';

.. note:: 如果您儲存的語言文件沒有自動被 CI 載入，您要記住在您的控制器中使用下面的成員函數手工載入::

	$this->lang->load('file_name');

關於語言文件的更多資訊，參看 :doc:`語言類 <language>` 。

.. _changing-delimiters:

更改錯誤定界符
=============================

在預設情況下，表單驗證類會使用 <p> 標籤來分割每條錯誤資訊。
您可以通過全區的，唯一的，或者通過設定文件對其進行自定義。

#. **全區的修改定界符**
   要在全區範圍內修改錯誤定界符，您可以在控制器成員函數中載入表單驗證類之後，使用下面的程式碼::

      $this->form_validation->set_error_delimiters('<div class="error">', '</div>');

   在這個範例中，我們改成使用 <div> 標籤來作為定界符。

#. **唯一的修改定界符**
   有兩個錯誤產生成員函數可以用於設定它們自己的定界符，如下::

      <?php echo form_error('field name', '<div class="error">', '</div>'); ?>

   或者::

      <?php echo validation_errors('<div class="error">', '</div>'); ?>

#. **在設定文件中設定定界符**
   您還可以在設定文件 application/config/form_validation.php 中定義錯誤定界符，如下::

      $config['error_prefix'] = '<div class="error_prefix">';
      $config['error_suffix'] = '</div>';

唯一顯示錯誤
===========================

如果您喜歡緊挨著每個表單域顯示錯誤資訊而不是顯示為一個清單，
您可以使用 :php:func:`form_error()` 成員函數。

嘗試一下！修改您的表單如下::

	<h5>Username</h5>
	<?php echo form_error('username'); ?>
	<input type="text" name="username" value="<?php echo set_value('username'); ?>" size="50" />

	<h5>Password</h5>
	<?php echo form_error('password'); ?>
	<input type="text" name="password" value="<?php echo set_value('password'); ?>" size="50" />

	<h5>Password Confirm</h5>
	<?php echo form_error('passconf'); ?>
	<input type="text" name="passconf" value="<?php echo set_value('passconf'); ?>" size="50" />

	<h5>Email Address</h5>
	<?php echo form_error('email'); ?>
	<input type="text" name="email" value="<?php echo set_value('email'); ?>" size="50" />

如果沒有錯誤資訊，將不會顯示。如果有錯誤資訊，將會在輸入框的旁邊唯一顯示。

.. important:: 如果您使用一個陣列作為一個表單域的名字，那麼函數的參數也應該是一個陣列。例如::

	<?php echo form_error('options[size]'); ?>
	<input type="text" name="options[size]" value="<?php echo set_value("options[size]"); ?>" size="50" />

更多資訊，請參考下面的 :ref:`using-arrays-as-field-names` 一節。

驗證陣列（除 $_POST 陣列）
=======================================

有時您可能希望對一個單純的陣列進行驗證，而不是對 ``$_POST`` 陣列。

在這種情況下，您可以先定義要驗證的陣列::

	$data = array(
		'username' => 'johndoe',
		'password' => 'mypassword',
		'passconf' => 'mypassword'
	);

	$this->form_validation->set_data($data);

Creating validation rules, running the validation, and retrieving error
messages works the same whether you are validating ``$_POST`` data or
another array of your choice.

.. important:: You have to call the ``set_data()`` method *before* defining
	any validation rules.

.. important:: 如果您想驗證多個陣列，那麼您應該在驗證下一個新陣列之前先呼叫 ``reset_validation()`` 成員函數。

更多資訊，請參數下面的 :ref:`class-reference` 一節。

.. _saving-groups:

************************************************
將一系列驗證規則儲存到一個設定文件
************************************************

表單驗證類的一個不錯的特性是，它允許您將整個應用的所有驗證規則儲存到一個設定文件中去。
您可以對這些規則進行分組，這些組既可以在匹配控制器和成員函數時自動載入，也可以在需要時手動呼叫。

如何儲存您的規則
======================

如果要儲存驗證規則，您需要在 application/config/ 資料夾下建立一個名為 form_validation.php 的文件。
然後在該文件中，將驗證規則儲存在陣列 $config 中即可。和之前介紹的一樣，驗證規則陣列格式如下::

	$config = array(
		array(
			'field' => 'username',
			'label' => 'Username',
			'rules' => 'required'
		),
		array(
			'field' => 'password',
			'label' => 'Password',
			'rules' => 'required'
		),
		array(
			'field' => 'passconf',
			'label' => 'Password Confirmation',
			'rules' => 'required'
		),
		array(
			'field' => 'email',
			'label' => 'Email',
			'rules' => 'required'
		)
	);

您的驗證規則會被自動載入，當用戶觸發 ``run()`` 成員函數時被呼叫。

請務必要將陣列名稱定義成 ``$config`` 。

建立規則集
======================

為了將您的多個規則組織成規則集，您需要將它們放置到子陣列中。
請參考下面的範例，在此例中我們設定了兩組規則集，我們分別命名為
"signup" 和 "email" ，您可以依據自己的需求任意命名::

	$config = array(
		'signup' => array(
			array(
				'field' => 'username',
				'label' => 'Username',
				'rules' => 'required'
			),
			array(
				'field' => 'password',
				'label' => 'Password',
				'rules' => 'required'
			),
			array(
				'field' => 'passconf',
				'label' => 'Password Confirmation',
				'rules' => 'required'
			),
			array(
				'field' => 'email',
				'label' => 'Email',
				'rules' => 'required'
			)
		),
		'email' => array(
			array(
				'field' => 'emailaddress',
				'label' => 'EmailAddress',
				'rules' => 'required|valid_email'
			),
			array(
				'field' => 'name',
				'label' => 'Name',
				'rules' => 'required|alpha'
			),
			array(
				'field' => 'title',
				'label' => 'Title',
				'rules' => 'required'
			),
			array(
				'field' => 'message',
				'label' => 'MessageBody',
				'rules' => 'required'
			)
		)
	);

呼叫某組驗證規則
=============================

為了呼叫特定組的驗證規則，您可以將它的名稱傳給 ``run()`` 成員函數。
例如，使用 signup 規則您可以這樣::

	if ($this->form_validation->run('signup') == FALSE)
	{
		$this->load->view('myform');
	}
	else
	{
		$this->load->view('formsuccess');
	}

將控制器成員函數和規則集關聯在一起
=================================================

呼叫一組規則的另一種成員函數是將控制器成員函數和規則集關聯在一起（這種成員函數也更自動），
例如，假設您有一個控制器類 Member 和一個成員函數 signup ，您的類如下::

	<?php

	class Member extends CI_Controller {

		public function signup()
		{
			$this->load->library('form_validation');

			if ($this->form_validation->run() == FALSE)
			{
				$this->load->view('myform');
			}
			else
			{
				$this->load->view('formsuccess');
			}
		}
	}

在您的驗證規則設定文件中，使用 member/signup 來給這組規則集命名::

	$config = array(
		'member/signup' => array(
			array(
				'field' => 'username',
				'label' => 'Username',
				'rules' => 'required'
			),
			array(
				'field' => 'password',
				'label' => 'Password',
				'rules' => 'required'
			),
			array(
				'field' => 'passconf',
				'label' => 'PasswordConfirmation',
				'rules' => 'required'
			),
			array(
				'field' => 'email',
				'label' => 'Email',
				'rules' => 'required'
			)
		)
	);

當一組規則的名稱和控制器類/成員函數名稱完全一樣時，它會在該控制器類/成員函數中自動被
``run()`` 成員函數呼叫。

.. _using-arrays-as-field-names:

***************************
使用陣列作為域名稱
***************************

表單驗證類支援使用陣列作為域名稱，比如::

	<input type="text" name="options[]" value="" size="50" />

如果您將域名稱定義為陣列，那麼在使用域名稱作為參數的 :ref:`輔助函數函數 <helper-functions>` 時，
您必須傳遞給他們與域名稱完全一樣的陣列名，對這個域名稱的驗證規則也一樣。

例如，為上面的域設定驗證規則::

	$this->form_validation->set_rules('options[]', 'Options', 'required');

或者，為上面的域顯示錯誤資訊::

	<?php echo form_error('options[]'); ?>

或者，重新填充該域的值::

	<input type="text" name="options[]" value="<?php echo set_value('options[]'); ?>" size="50" />

您也可以使用多維陣列作為域的名稱，例如::

	<input type="text" name="options[size]" value="" size="50" />

甚至::

	<input type="text" name="sports[nba][basketball]" value="" size="50" />

和上面的範例一樣，您必須在輔助函數中使用完全一樣的陣列名::

	<?php echo form_error('sports[nba][basketball]'); ?>

如果您正在使用復選框（或其他擁有多個選項的域），不要忘了在每個選項後加個空的方括號，
這樣，所有的選擇才會被加入到 POST 陣列中::

	<input type="checkbox" name="options[]" value="red" />
	<input type="checkbox" name="options[]" value="blue" />
	<input type="checkbox" name="options[]" value="green" />

或者，使用多維陣列::

	<input type="checkbox" name="options[color][]" value="red" />
	<input type="checkbox" name="options[color][]" value="blue" />
	<input type="checkbox" name="options[color][]" value="green" />

當您使用輔助函數時，也要加入方括號::

	<?php echo form_error('options[color][]'); ?>


**************
規則參考
**************

下表列出了所有可用的原生規則：

========================= ========== ============================================================================================= =======================
規則                      參數        描述                                                                                          範例
========================= ========== ============================================================================================= =======================
**required**              No         如果表單元素為空，傳回 FALSE
**matches**               Yes        如果表單元素值與參數中對應的表單字段的值不相等，傳回 FALSE                                     matches[form_item]
**regex_match**           Yes        如果表單元素不匹配正則表達式，傳回 FALSE                                                       regex_match[/regex/]
**differs**               Yes        如果表單元素值與參數中對應的表單字段的值相等，傳回 FALSE                                       differs[form_item]
**is_unique**             Yes        如果表單元素值在指定的表和字段中並不唯一，傳回 FALSE                                           is_unique[table.field]
                                     注意：這個規則需要啟用 :doc:`查詢產生器 <../database/query_builder>`
**min_length**            Yes        如果表單元素值的長度小於參數值，傳回 FALSE                                                     min_length[3]
**max_length**            Yes        如果表單元素值的長度大於參數值，傳回 FALSE                                                     max_length[12]
**exact_length**          Yes        如果表單元素值的長度不等於參數值，傳回 FALSE                                                   exact_length[8]
**greater_than**          Yes        如果表單元素值小於或等於參數值或非數字，傳回 FALSE                                             greater_than[8]
**greater_than_equal_to** Yes        如果表單元素值小於參數值或非數字，傳回 FALSE                                                   greater_than_equal_to[8]
**less_than**             Yes        如果表單元素值大於或等於參數值或非數字，傳回 FALSE                                             less_than[8]
**less_than_equal_to**    Yes        如果表單元素值大於參數值或非數字，傳回 FALSE                                                   less_than_equal_to[8]
**in_list**               Yes        如果表單元素值不在規定的清單中，傳回 FALSE                                                     in_list[red,blue,green]
**alpha**                 No         如果表單元素值包含除字母以外的其他字元，傳回 FALSE
**alpha_numeric**         No         如果表單元素值包含除字母和數字以外的其他字元，傳回 FALSE
**alpha_numeric_spaces**  No         如果表單元素值包含除字母、數字和空格以外的其他字元，傳回 FALSE
                                     應該在 trim 之後使用，避免首尾的空格
**alpha_dash**            No         如果表單元素值包含除字母/數字/下劃線/破折號以外的其他字元，傳回 FALSE
**numeric**               No         如果表單元素值包含除數字以外的字元，傳回 FALSE
**integer**               No         如果表單元素包含除整數以外的字元，傳回 FALSE
**decimal**               No         如果表單元素包含非十進制數字時，傳回 FALSE
**is_natural**            No         如果表單元素值包含了非自然數的其他數值 （不包括零），傳回 FALSE
                                     自然數形如：0、1、2、3 .... 等等。
**is_natural_no_zero**    No         如果表單元素值包含了非自然數的其他數值 （包括零），傳回 FALSE
                                     非零的自然數：1、2、3 .... 等等。
**valid_url**             No         如果表單元素值包含不合法的 URL，傳回 FALSE
**valid_email**           No         如果表單元素值包含不合法的 email 地址，傳回 FALSE
**valid_emails**          No         如果表單元素值包含不合法的 email 地址（地址之間用逗號分割），傳回 FALSE
**valid_ip**              Yes        如果表單元素值不是一個合法的 IP 地址，傳回 FALSE
                                     通過可選參數 "ipv4" 或 "ipv6" 來指定 IP 地址格式。
**valid_base64**          No         如果表單元素值包含除了 base64 編碼字元之外的其他字元，傳回 FALSE
========================= ========== ============================================================================================= =======================

.. note:: 這些規則也可以作為獨立的函數被呼叫，例如::

		$this->form_validation->required($string);

.. note:: 您也可以使用任何一個接受兩個參數的原生 PHP 函數（其中至少有一個參數是必須的，用於傳遞域值）

******************
預處理參考
******************

下表列出了所有可用的預處理成員函數：

==================== ========= =======================================================================================================
名稱                 參數      描述
==================== ========= =======================================================================================================
**prep_for_form**    No        DEPRECATED: 將特殊字元的轉換，以便可以在表單域中顯示 HTML 資料，而不會破壞它
**prep_url**         No        當 URL 丟失 "http://" 時，加入 "http://"
**strip_image_tags** No        移除 HTML 中的 image 標籤，只保留 URL
**encode_php_tags**  No        將 PHP 標籤轉成實體
==================== ========= =======================================================================================================

.. note:: 您也可以使用任何一個接受一個參數的原生 PHP 函數。
	例如： ``trim()`` 、 ``htmlspecialchars()`` 、 ``urldecode()`` 等

.. _class-reference:

***************
類參考
***************

.. php:class:: CI_Form_validation

	.. php:method:: set_rules($field[, $label = ''[, $rules = ''[, $errors = array()]]])

		:param	string	$field: Field name
		:param	string	$label: Field label
		:param	mixed	$rules: Validation rules, as a string list separated by a pipe "|", or as an array or rules
		:param	array	$errors: A list of custom error messages
		:returns:	CI_Form_validation instance (method chaining)
		:rtype:	CI_Form_validation

		允許您設定驗證規則，如在本教程上面描述的：

		-  :ref:`setting-validation-rules`
		-  :ref:`saving-groups`

	.. php:method:: run([$group = ''])

		:param	string	$group: The name of the validation group to run
		:returns:	TRUE on success, FALSE if validation failed
		:rtype:	bool

		執行驗證程序。成功傳回 TRUE，失敗傳回 FALSE。
		您也可以傳一個驗證規則集的名稱作為參數，參考 :ref:`saving-groups`

	.. php:method:: set_message($lang[, $val = ''])

		:param	string	$lang: The rule the message is for
		:param	string	$val: The message
		:returns:	CI_Form_validation instance (method chaining)
		:rtype:	CI_Form_validation

		允許您設定自定義錯誤消息，參考 :ref:`setting-error-messages`

	.. php:method:: set_error_delimiters([$prefix = '<p>'[, $suffix = '</p>']])

		:param	string	$prefix: Error message prefix
		:param	string	$suffix: Error message suffix
		:returns:	CI_Form_validation instance (method chaining)
		:rtype:	CI_Form_validation

		設定錯誤消息的前綴和後綴。

	.. php:method:: set_data($data)

		:param	array	$data: Array of data validate
		:returns:	CI_Form_validation instance (method chaining)
		:rtype:	CI_Form_validation

		允許您設定一個陣列來進行驗證，取代預設的 ``$_POST`` 陣列

	.. php:method:: reset_validation()

		:returns:	CI_Form_validation instance (method chaining)
		:rtype:	CI_Form_validation

		當您驗證多個陣列時，該成員函數可以重置驗證規則，當驗證下一個新陣列時應該呼叫它。

	.. php:method:: error_array()

		:returns:	Array of error messages
		:rtype:	array

		傳回錯誤資訊陣列。

	.. php:method:: error_string([$prefix = ''[, $suffix = '']])

		:param	string	$prefix: Error message prefix
		:param	string	$suffix: Error message suffix
		:returns:	Error messages as a string
		:rtype:	string

		傳回所有的錯誤資訊（和 error_array() 傳回結果一樣），並使用換行字元分割格式化成字元串

	.. php:method:: error($field[, $prefix = ''[, $suffix = '']])

		:param	string $field: Field name
		:param	string $prefix: Optional prefix
		:param	string $suffix: Optional suffix
		:returns:	Error message string
		:rtype:	string

		傳回特定域的錯誤消息，也可以加入一個前綴和/或後綴（通常是 HTML 標籤）

	.. php:method:: has_rule($field)

		:param	string	$field: Field name
		:returns:	TRUE if the field has rules set, FALSE if not
		:rtype:	bool

		檢查某個域是否有驗證規則。

.. _helper-functions:

****************
輔助函數參考
****************

請參考 :doc:`表單輔助函數 <../helpers/form_helper>` 手冊瞭解以下函數：

-  :php:func:`form_error()`
-  :php:func:`validation_errors()`
-  :php:func:`set_value()`
-  :php:func:`set_select()`
-  :php:func:`set_checkbox()`
-  :php:func:`set_radio()`

注意這些都是過程式的函數，所以 **不需要** 加入 ``$this->form_validation`` 就可以直接呼叫它們。
