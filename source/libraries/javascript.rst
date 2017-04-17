################
Javascript 類
################

CodeIgniter 提供一個類庫和一些共用的成員函數來處理 Javascript 。要注意的是，
CodeIgniter 並不是只能用於 jQuery ，其他腳本庫也可以。JQuery 僅僅是
作為一個方便的工具，如果您選擇使用它的話。

.. important:: 這個類庫已經廢棄，不要使用它。它將永遠處於 "實驗" 版本，
	而且現在也已經不提供支援了。保留它只是為了向前相容。

.. contents::
  :local:

.. raw:: html

  <div class="custom-index container"></div>

**************************
使用 Javascript 類
**************************

初始化類
======================

要初始化 Javascript 類，您可以在控制器的構造函數中使用 ``$this->load->library()``
函數。目前，唯一可用的庫是 jQuery ，可以使用下面的成員函數載入::

	$this->load->library('javascript');

Javascript 類也可以接受參數：

- js_library_driver (string) *default: 'jquery'*
- autoload (bool) *default: TRUE*

您可以通過一個關聯陣列覆蓋預設的參數::

	$this->load->library(
		'javascript',
		array(
			'js_library_driver' => 'scripto',
			'autoload' => FALSE
		)
	);

再次說明，目前只有 jQuery 是可用的，如果您不想讓 jQuery 腳本文件自動的包含在
script 標籤中，您可以設定 autoload 參數為 FALSE 。這在當您在 CodeIgniter 之外
載入它時，或者 script 標籤已經有了的時候很有用。

一旦載入完成，jQuery 類物件就可以通過下面的方式使用::

	$this->javascript

初始化設定
=======================

在檢視文件中設定變數
--------------------------------

作為一個 Javascript 庫，源文件必須能被應用程式存取到。

由於 Javascript 是一種客戶端語言，庫必須能寫入內容到最終的輸出中去，
這通常就是檢視。您需要在輸出的 ``<head>`` 中包含下面的變數。

::

	<?php echo $library_src;?>
	<?php echo $script_head;?>

``$library_src`` 是要載入的庫文件的路徑，以及之後所有插件腳本的路徑；
``$script_head`` 是需要顯示的具體的一些事件、函數和其他的命令。

設定庫路徑
----------------------------------------------

在 Javascript 類庫中有一些設定項，它們可以在 *application/config.php* 文件中
設定，也可以在它們自己的設定文件 *config/javascript.php* 中設定，還可以通過
在控制器中使用 ``set_item()`` 成員函數來設定。

例如，有一個 "載入中" 的圖片，或者進度條指示，如果沒有它的話，當呼叫 Ajax 請求時，
將會顯示 "載入中" 這樣的文字。

::

	$config['javascript_location'] = 'http://localhost/codeigniter/themes/js/jquery/';
	$config['javascript_ajax_img'] = 'images/ajax-loader.gif';

如果您把文件留在與圖片下載路徑相同的資料夾裡，那麼您不需要設定這個設定項。

jQuery 類
================

要在您的控制器構造函數中手工初始化 jQuery 類，使用 ``$this->load->library()`` 成員函數::

	$this->load->library('javascript/jquery');

您可以提供一個可選的參數來決定載入該庫時是否將其自動包含到 script 標籤中。
預設情況下會包含，如果不需要，可以像下面這樣來載入::

	$this->load->library('javascript/jquery', FALSE);

載入完成後，jQuery 類物件可以使用下面的程式碼來存取::

	$this->jquery

jQuery 事件
=============

使用下面的語法來設定事件。
::

	$this->jquery->event('element_path', code_to_run());

在上面的範例中：

-  "event" 可以是 blur、change、click、dblclick、error、focus、hover、
   keydown、keyup、load、mousedown、mouseup、mouseover、mouseup、resize、
   scroll 或者 unload 中的任何一個事件。
-  "element_path" 可以是任何的 `jQuery 選擇器 <http://api.jquery.com/category/selectors/>`_ 。
   使用 jQuery 獨特的選擇器語法，通常是一個元素 ID 或 CSS 選擇器。例如，"#notice_area" 
   會影響到 ``<div id="notice_area">`` ，"#content a.notice" 會影響到 ID 為 "content"
   的元素下的所有 class 為 "notice" 的鏈接。
-  "``code_to_run()``" 為您自己寫的腳本，或者是一個 jQuery 動作，例如下面所介紹的特效。

特效
=======

jQuery 庫支援很多強大的 `特效 <http://api.jquery.com/category/effects/>`_ ，在使用特效之前，
必須使用下面的成員函數載入::

	$this->jquery->effect([optional path] plugin name); // for example $this->jquery->effect('bounce');


hide() / show()
---------------

這兩個函數會影響您的頁面上元素的可見性，hide() 函數用於將元素隱藏，show() 則相反。

::

	$this->jquery->hide(target, optional speed, optional extra information);
	$this->jquery->show(target, optional speed, optional extra information);


-  "target" 是任何有效的 jQuery 選擇器。
-  "speed" 可選，可以設定為 slow、normal、fast 或您自己設定的毫秒數。
-  "extra information" 可選，可以包含一個回調，或者其他的附加資訊。

toggle()
--------

toggle() 用於將元素的可見性改成和目前的相反，將可見的元素隱藏，將隱藏的元素可見。

::

	$this->jquery->toggle(target);


-  "target" 是任何有效的 jQuery 選擇器。

animate()
---------

::

	 $this->jquery->animate(target, parameters, optional speed, optional extra information);


-  "target" 是任何有效的 jQuery 選擇器。
-  "parameters" 通常是您想改變元素的一些 CSS 屬性。
-  "speed" 可選，可以設定為 slow、normal、fast 或您自己設定的毫秒數。
-  "extra information" 可選，可以包含一個回調，或者其他的附加資訊。

更完整的說明，參見 `http://api.jquery.com/animate/ <http://api.jquery.com/animate/>`_

下面是個在 ID 為 "note" 的一個 div 上使用 animate() 的範例，它使用了 jQuery 庫的 click 事件，
通過 click 事件觸發。

::

	$params = array(
	'height' => 80,
	'width' => '50%',
	'marginLeft' => 125
	);
	$this->jquery->click('#trigger', $this->jquery->animate('#note', $params, 'normal'));

toggleClass()
-------------

該函數用於往目標元素加入或移除一個 CSS 類。

::

	$this->jquery->toggleClass(target, class)


-  "target" 是任何有效的 jQuery 選擇器。
-  "class" 是任何 CSS 類名，注意這個類必須是在某個已載入的 CSS 文件中定義的。

fadeIn() / fadeOut()
--------------------

這兩個特效會使某個元素漸變的隱藏和顯示。

::

	$this->jquery->fadeIn(target,  optional speed, optional extra information);
	$this->jquery->fadeOut(target,  optional speed, optional extra information);


-  "target" 是任何有效的 jQuery 選擇器。
-  "speed" 可選，可以設定為 slow、normal、fast 或您自己設定的毫秒數。
-  "extra information" 可選，可以包含一個回調，或者其他的附加資訊。

slideUp() / slideDown() / slideToggle()
---------------------------------------

這些特效可以讓元素滑動。

::

	$this->jquery->slideUp(target,  optional speed, optional extra information);
	$this->jquery->slideDown(target,  optional speed, optional extra information);
	$this->jquery->slideToggle(target,  optional speed, optional extra information);


-  "target" 是任何有效的 jQuery 選擇器。
-  "speed" 可選，可以設定為 slow、normal、fast 或您自己設定的毫秒數。
-  "extra information" 可選，可以設定為 slow、normal、fast 或您自己設定的毫秒數。

插件
=======

使用這個庫時還有幾個 jQuery 插件可用。

corner()
--------

用於在頁面的某個元素四周加入不同樣式的邊角。更多詳細資訊，參考
`http://malsup.com/jquery/corner/ <http://malsup.com/jquery/corner/>`_

::

	$this->jquery->corner(target, corner_style);


-  "target" 是任何有效的 jQuery 選擇器。
-  "corner_style" 可選，可以設定為任何有效的樣式，例如：
   round、sharp、bevel、bite、dog 等。如果只想設定某個邊角的樣式，
   可以在樣式後加入一個空格，然後使用 "tl" （左上），"tr" （右上），
   "bl" （左下），和 "br" （右下）。

::

	$this->jquery->corner("#note", "cool tl br");


tablesorter()
-------------

待加入

modal()
-------

待加入

calendar()
----------

待加入