#############
表情輔助函數
#############

表情輔助函數文件包含了一些讓您管理表情的函數。

.. important:: 表情輔助函數已經廢棄，不建議使用。現在只是為了向前相容而保留。

.. contents::
  :local:

.. raw:: html

  <div class="custom-index container"></div>

載入輔助函數
===================

該輔助函數通過下面的程式碼載入::

	$this->load->helper('smiley');

概述
========

表情輔助函數用於將純文字的表情轉換為圖片，例如：:-) 轉換為 |smile!|

另外它還可以顯示一組表情圖片，當您點擊其中的某個表情時將會被插入到一個表單域中。
例如，如果您有一個部落格並允許用戶送出評論，您可以將這組表情圖片顯示在評論的旁邊，
這樣用戶就可以點擊想要的表情，然後通過一點點的 Javascript 程式碼，將該表情插入到
用戶的評論中去。

可點擊的表情包教程
==========================

這裡是一個如何在表單中使用可點擊的表情包的範例，這個範例需要您首先下載並安裝表情圖片，
然後按下面的步驟建立一個控制器和檢視。

.. important:: 開始之前，請先 `下載表情圖片 <https://ellislab.com/asset/ci_download_files/smileys.zip>`_
	然後將其放置到伺服器的一個公共資料夾，並打開 `application/config/smileys.php` 文件設定表情取代的規則。

控制器
--------------

在 **application/controllers/** 資料夾下，建立一個文件 Smileys.php 然後輸入下面的程式碼。

.. important:: 修改下面的 :php:func:`get_clickable_smileys()` 函數的 URL 參數，讓其指向您的表情資料夾。

您會發現我們除了使用到了表情庫，還使用到了 :doc:`表格類 <../libraries/table>`::

	<?php

	class Smileys extends CI_Controller {

		public function index()
		{
			$this->load->helper('smiley');
			$this->load->library('table');

			$image_array = get_clickable_smileys('http://example.com/images/smileys/', 'comments');
			$col_array = $this->table->make_columns($image_array, 8);

			$data['smiley_table'] = $this->table->generate($col_array);
			$this->load->view('smiley_view', $data);
		}

	}

然後，在 **application/views/** 資料夾下新建一個文件 **smiley_view.php** 並輸入以下程式碼::

	<html>
		<head>
			<title>Smileys</title>
			<?php echo smiley_js(); ?>
		</head>
		<body>
			<form name="blog">
				<textarea name="comments" id="comments" cols="40" rows="4"></textarea>
			</form>
			<p>Click to insert a smiley!</p>
			<?php echo $smiley_table; ?> </body> </html>
			When you have created the above controller and view, load it by visiting http://www.example.com/index.php/smileys/
		</body>
	</html>

字段別名
-------------

當修改檢視的時候，會牽扯到控制器中的 id 字段，帶來不便。為了解決這一問題，
您可以在檢視中給表情一個別名，並將其映射到 id 字段。

::

	$image_array = get_smiley_links("http://example.com/images/smileys/", "comment_textarea_alias");

將別名映射到 id 字段，可以使用 smiley_js 函數並傳入這兩個參數::

	$image_array = smiley_js("comment_textarea_alias", "comments");

可用函數
===================

.. php:function:: get_clickable_smileys($image_url[, $alias = ''[, $smileys = NULL]])

	:param	string	$image_url: URL path to the smileys directory
	:param	string	$alias: Field alias
	:returns:	An array of ready to use smileys
	:rtype:	array

	傳回一個已經綁定了可點擊表情的陣列。您必須提供表情文件夾的 URL ，
	還有表單域的 ID 或者表單域的別名。

	舉例::

		$image_array = get_clickable_smileys('http://example.com/images/smileys/', 'comment');

.. php:function:: smiley_js([$alias = ''[, $field_id = ''[, $inline = TRUE]]])

	:param	string	$alias: Field alias
	:param	string	$field_id: Field ID
	:param	bool	$inline: Whether we're inserting an inline smiley
	:returns:	Smiley-enabling JavaScript code
	:rtype:	string

	產生可以讓圖片點擊後插入到表單域中的 JavaScript 程式碼。如果您在產生表情鏈接的時候
	提供了一個別名來代替 id ，您需要在函數中傳入別名和相應的 id ，此函數被設計為
	應放在您 Web 頁面的 <head> 部分。

	舉例::

		<?php echo smiley_js(); ?>

.. php:function:: parse_smileys([$str = ''[, $image_url = ''[, $smileys = NULL]]])

	:param	string	$str: Text containing smiley codes
	:param	string	$image_url: URL path to the smileys directory
	:param	array	$smileys: An array of smileys
	:returns:	Parsed smileys
	:rtype:	string

	輸入一個文字字元串，並將其中的純文字表情取代為等效的表情圖片，第一個參數為您的字元串，
	第二個參數是您的表情資料夾對應的 URL 。

	舉例::

		$str = 'Here are some smileys: :-)  ;-)';
		$str = parse_smileys($str, 'http://example.com/images/smileys/');
		echo $str;

.. |smile!| image:: ../images/smile.png
