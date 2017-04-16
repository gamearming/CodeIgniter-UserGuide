####################
文件上傳類
####################

CodeIgniter 的文件上傳類用於上傳文件，您可以設定參數限制上傳文件的類型和大小。

.. contents::
  :local:

.. raw:: html

  <div class="custom-index container"></div>

***********
處理流程
***********

上傳一個文件通常涉及以下幾步：

-  顯示一個上傳表單，用戶選擇文件並上傳。
-  當送出表單時，文件將被上傳到您指定的目錄。
-  同時，依據您設定的參數對文件進行校驗是否允許上傳。
-  上傳成功後，向用戶顯示成功消息。

下面是個簡單的教程來示範該過程，然後會列出一些其他的參考資訊。

建立上傳表單
========================

使用文字編輯器新建一個文件 upload_form.php ，放入如下程式碼，並儲存到 **application/views/** 目錄下::

	<html>
	<head>
	<title>Upload Form</title>
	</head>
	<body>

	<?php echo $error;?>

	<?php echo form_open_multipart('upload/do_upload');?>

	<input type="file" name="userfile" size="20" />

	<br /><br />

	<input type="submit" value="upload" />

	</form>

	</body>
	</html>

您會注意到我們使用了表單輔助函數來建立 form 的起始標籤，文件上傳需要使用 multipart 表單，
輔助函數可以幫您正確產生它。還要注意的是，程式碼裡有一個 $error 變數，當發生錯誤時，
可以用它來顯示錯誤資訊。

上傳成功頁面
================

使用文字編輯器新建一個文件 upload_success.php ，放入如下程式碼，並儲存到 **application/views/** 目錄下::

	<html>
	<head>
	<title>Upload Form</title>
	</head>
	<body>

	<h3>Your file was successfully uploaded!</h3>

	<ul>
	<?php foreach ($upload_data as $item => $value):?>
	<li><?php echo $item;?>: <?php echo $value;?></li>
	<?php endforeach; ?>
	</ul>

	<p><?php echo anchor('upload', 'Upload Another File!'); ?></p>

	</body>
	</html>

控制器
==============

使用文字編輯器新建一個控制器 Upload.php ，放入如下程式碼，並儲存到 **application/controllers/** 目錄下::

	<?php

	class Upload extends CI_Controller {

		public function __construct()
		{
			parent::__construct();
			$this->load->helper(array('form', 'url'));
		}

		public function index()
		{
			$this->load->view('upload_form', array('error' => ' ' ));
		}

		public function do_upload()
		{
			$config['upload_path']		= './uploads/';
			$config['allowed_types']	= 'gif|jpg|png';
			$config['max_size']		= 100;
			$config['max_width']		= 1024;
			$config['max_height']		= 768;

			$this->load->library('upload', $config);

			if ( ! $this->upload->do_upload('userfile'))
			{
				$error = array('error' => $this->upload->display_errors());

				$this->load->view('upload_form', $error);
			}
			else
			{
				$data = array('upload_data' => $this->upload->data());

				$this->load->view('upload_success', $data);
			}
		}
	}
	?>

上傳文件目錄
====================

您需要一個目錄來儲存上傳的圖片，在 CodeIgniter 的安裝根目錄下建立一個 uploads 目錄，
並將它的權限設定為 777 。

嘗試一下！
==========

使用類似於下面的 URL 來成員函數您的站點::

	example.com/index.php/upload/

您應該能看到一個上傳文件的表單，嘗試著上傳一個圖片文件（jpg、gif 或 png 都可以），
如果您的控制器中路徑設定正確，您就可以成功上傳文件了。

***************
參考指南
***************

初始化文件上傳類
=============================

正如 CodeIgniter 中的其他類一樣，在您的控制器中使用 ``$this->load->library()``
成員函數來初始化文件上傳類::

	$this->load->library('upload');

初始化之後，文件上傳類的物件就可以這樣存取::

	$this->upload

參數設定
===================

和其他的類庫一樣，您可以通過您設定的參數來控制允許上傳什麼類型的文件。
在上面的控制器中，您設定了下面的這些參數::

	$config['upload_path'] = './uploads/';
	$config['allowed_types'] = 'gif|jpg|png';
	$config['max_size']	= '100';
	$config['max_width'] = '1024';
	$config['max_height'] = '768';

	$this->load->library('upload', $config);

	// Alternately you can set preferences by calling the ``initialize()`` method. Useful if you auto-load the class:
	$this->upload->initialize($config);

上面的參數依據它的名稱就能很容易理解，下表列出了所有可用的參數。

參數
===========

下表列出了所有可用的參數，當沒有指定參數時程序會使用預設值。

============================ ================= ======================= ======================================================================
參數                         預設值            選項                    描述
============================ ================= ======================= ======================================================================
**upload_path**              None              None                    文件上傳的位置，必須是可寫的，可以是相對路徑或絕對路徑
**allowed_types**            None              None                    允許上的文件 MIME 類型，通常文件的後綴名可作為 MIME 類型
                                                                       可以是陣列，也可以是以管道符（|）分割的字元串
**file_name**                None              Desired file name       如果設定了，CodeIgniter 將會使用該參數重命名上傳的文件
                                                                       設定的文件名後綴必須也要是允許的文件類型
                                                                       如果沒有設定後綴，將使用原文件的後綴名
**file_ext_tolower**         FALSE             TRUE/FALSE (boolean)    如果設定為 TRUE ，文件後綴名將轉換為小寫
**overwrite**                FALSE             TRUE/FALSE (boolean)    如果設定為 TRUE ，上傳的文件如果和已有的文件同名，將會覆蓋已存在文件
                                                                       如果設定為 FALSE ，將會在文件名後加上一個數字
**max_size**                 0                 None                    允許上傳文件大小的最大值（單位 KB），設定為 0 表示無限制
                                                                       注意：大多數 PHP 會有它們自己的限制值，定義在 php.ini 文件中
                                                                       通常是預設的 2 MB （2048 KB）。
**max_width**                0                 None                    圖片的最大寬度（單位為像素），設定為 0 表示無限制
**max_height**               0                 None                    圖片的最大高度（單位為像素），設定為 0 表示無限制
**min_width**                0                 None                    圖片的最小寬度（單位為像素），設定為 0 表示無限制
**min_height**               0                 None                    圖片的最小高度（單位為像素），設定為 0 表示無限制
**max_filename**             0                 None                    文件名的最大長度，設定為 0 表示無限制
**max_filename_increment**   100               None                    當 overwrite 參數設定為 FALSE 時，將會在同名文件的後面加上一個自增的數字
                                                                       這個參數用於設定這個數字的最大值
**encrypt_name**             FALSE             TRUE/FALSE (boolean)    如果設定為 TRUE ，文件名將會轉換為一個隨機的字元串
                                                                       如果您不希望上傳文件的人知道儲存後的文件名，這個參數會很有用
**remove_spaces**            TRUE              TRUE/FALSE (boolean)    如果設定為 TRUE ，文件名中的所有空格將轉換為下劃線，推薦這樣做
**detect_mime**              TRUE              TRUE/FALSE (boolean)    如果設定為 TRUE ，將會在服務端對文件類型進行檢測，可以預防程式碼注入攻擊
                                                                       除非不得已，請不要停用該選項，這將導致安全風險
**mod_mime_fix**             TRUE              TRUE/FALSE (boolean)    如果設定為 TRUE ，那麼帶有多個後綴名的文件將會加入一個下劃線後綴
                                                                       這樣可以避免觸發 `Apache mod_mime
                                                                       <http://httpd.apache.org/docs/2.0/mod/mod_mime.html#multipleext>`_ 。
                                                                       如果您的上傳目錄是公開的，請不要關閉該選項，這將導致安全風險
============================ ================= ======================= ======================================================================

在設定文件中設定參數
====================================

如果您不喜歡使用上面的成員函數來設定參數，您可以將參數儲存到設定文件中。您只需簡單的建立一個文件 
upload.php 並將 $config 陣列放到該文件中，然後儲存文件到 **config/upload.php** ，這些參數將會自動被使用。
如果您在設定文件中設定參數，那麼您就不需要使用 ``$this->upload->initialize()`` 成員函數了。

***************
類參考
***************

.. php:class:: CI_Upload

	.. php:method:: initialize([array $config = array()[, $reset = TRUE]])

		:param	array	$config: Preferences
		:param	bool	$reset: Whether to reset preferences (that are not provided in $config) to their defaults
		:returns:	CI_Upload instance (method chaining)
		:rtype:	CI_Upload

	.. php:method:: do_upload([$field = 'userfile'])

		:param	string	$field: Name of the form field
		:returns:	TRUE on success, FALSE on failure
		:rtype:	bool

		依據您設定的參數上傳文件。

		.. note:: 預設情況下上傳文件是來自於表單的 userfile 字段，而且表單應該是 "multipart" 類型。

		::

			<form method="post" action="some_action" enctype="multipart/form-data" />

		如果您想設定您自己的字段，可以將字段名傳給 ``do_upload()`` 成員函數::

			$field_name = "some_field_name";
			$this->upload->do_upload($field_name);

	.. php:method:: display_errors([$open = '<p>'[, $close = '</p>']])

		:param	string	$open: Opening markup
		:param	string	$close: Closing markup
		:returns:	Formatted error message(s)
		:rtype:	string

		如果 ``do_upload()`` 成員函數傳回 FALSE ，可以使用該成員函數來讀取錯誤資訊。
		該成員函數傳回所有的錯誤資訊，而不是是直接顯示出來。

		**格式化錯誤資訊**

			預設情況下該成員函數會將錯誤資訊包在 <p> 標籤中，您可以設定您自己的標籤::

				$this->upload->display_errors('<p>', '</p>');


	.. php:method:: data([$index = NULL])

		:param	string	$data: Element to return instead of the full array
		:returns:	Information about the uploaded file
		:rtype:	mixed

		該成員函數傳回一個陣列，包含您上傳的文件的所有資訊，下面是陣列的原型::

			Array
			(
				[file_name]	=> mypic.jpg
				[file_type]	=> image/jpeg
				[file_path]	=> /path/to/your/upload/
				[full_path]	=> /path/to/your/upload/jpg.jpg
				[raw_name]	=> mypic
				[orig_name]	=> mypic.jpg
				[client_name]	=> mypic.jpg
				[file_ext]	=> .jpg
				[file_size]	=> 22.2
				[is_image]	=> 1
				[image_width]	=> 800
				[image_height]	=> 600
				[image_type]	=> jpeg
				[image_size_str] => width="800" height="200"
			)

		您也可以只傳回陣列中的一項::

			$this->upload->data('file_name');	// Returns: mypic.jpg

		下表解釋了上面列出的所有陣列項：

		================ ====================================================================================================
		項               描述
		================ ====================================================================================================
		file_name        上傳文件的文件名，包含後綴名
		file_type        文件的 MIME 類型
		file_path        文件的絕對路徑
		full_path        文件的絕對路徑，包含文件名
		raw_name         文件名，不含後綴名
		orig_name        原始的文件名，只有在使用了 encrypt_name 參數時該值才有用
		client_name      用戶送出過來的文件名，還沒有對該文件名做任何處理
		file_ext         文件後綴名，包括句點
		file_size        文件大小（單位 kb）
		is_image         文件是否為圖片（1 = image. 0 = not.）
		image_width      圖片寬度
		image_height     圖片高度
		image_type       圖片類型（通常是不帶句點的文件後綴名）
		image_size_str   一個包含了圖片寬度和高度的字元串（用於放在 image 標籤中）
		================ ====================================================================================================
