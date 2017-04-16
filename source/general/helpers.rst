################
輔助函數
################

輔助函數，顧名思義，是幫助我們完成特定任務的函數。每個輔助函數文件都是某一類
函數的集合。例如， **URL 輔助函數** 幫助我們建立鏈接，**表單輔助函數**幫助
我們建立表單元素，**本文輔助函數** 幫助我們處理文字的格式化，**Cookie 輔助函數**
幫助我們讀取或設定 Cookie ，**文件輔助函數** 幫助我們處理文件，等等等等。

不同於 CodeIgniter 中的大多數系統，輔助函數沒有使用面向物件的方式來實現的。
它們是簡單的過程式函數，每個函數處理一個特定的任務，不相依於其他的函數。

CodeIgniter 預設不會自己載入輔助函數，所以使用輔助函數的第一步就是載入它。
一旦載入了，它就可以在您的 :doc:`控制器 <../general/controllers>` 和
:doc:`檢視 <../general/views>` 中全區存取了。

一般情況下，輔助函數位於 **system/helpers** 或者 **application/helpers** 目錄
目錄下。CodeIgniter 首先會查找 **application/helpers** 目錄，如果該目錄不存在，
或者您載入的輔助函數沒有在該目錄下找到，CodeIgniter 就會去 *system/helpers/* 目錄查找。

載入輔助函數
================

可以使用下面的成員函數簡單的載入輔助函數::

	$this->load->helper('name');

**name** 參數為輔助函數的文件名，去掉 .php 文件後綴以及 _helper 部分。

例如，要載入 **URL 輔助函數** ，它的文件名為 **url_helper.php** ，您可以這樣載入它::

	$this->load->helper('url');

輔助函數可以在您的控制器成員函數的任何地方載入（甚至可以在您的檢視文件中載入，儘管這不是
個好的實踐），只要確保在使用之前載入它就可以了。您可以在您的控制器的構造函數中載入它，
這樣就可以在該控制器的任何成員函數中使用它，您也可以在某個需要它的函數中唯一載入它。

.. note:: 上面的載入輔助函數的成員函數沒有傳回值，所以不要將它賦值給變數，直接呼叫就好了。

載入多個輔助函數
========================

如果您需要載入多個輔助函數，您可以使用一個陣列，像下面這樣::

	$this->load->helper(
		array('helper1', 'helper2', 'helper3')
	);

自動載入輔助函數
====================

如果您需要在您的整個應用程式中使用某個輔助函數，您可以將其設定為在 CodeIgniter 初始化時
自動載入它。打開 **application/config/autoload.php** 文件然後將您想載入的輔助函數加入到
autoload 陣列中。

使用輔助函數
==============

一旦您想要使用的輔助函數被載入，您就可以像使用標準的 PHP 函數一樣使用它們。

例如，要在您的檢視文件中使用 ``anchor()`` 函數建立一個鏈接，您可以這樣做::

	<?php echo anchor('blog/comments', 'Click Here');?>

其中，"Click Here" 是鏈接的名稱，"blog/comments" 是您希望鏈接到 
controller/method 的 URI 。

擴展輔助函數
===================

為了擴展輔助函數，您需要在 **application/helpers/** 目錄下新建一個文件，
文件名和已存在的輔助函數文件名一樣，但是要加上 **MY\_** 前綴（這個可以設定，
見下文）。

如果您只是想往現有類中加入一些功能，例如增加一兩個成員函數，或者修改輔助函數中的
某個函數，這時取代整個類感覺就有點殺雞用牛刀了。在這種情況下，最好的成員函數是
擴展類。

.. note:: 「擴展」一詞在這裡可能不是很恰當，因為輔助函數函數都是過程式的獨立函數，
	在傳統編程中並不能被擴展。不過在 CodeIgniter 中，您可以向輔助函數中加入函數，
	或者使用您自己的函數替代輔助函數中的函數。

例如，要擴展原始的 **陣列輔助函數** ，首先您要建立一個文件 **application/helpers/MY_array_helper.php** ，
然後像下面這樣加入或重寫函數::

	// any_in_array() is not in the Array Helper, so it defines a new function
	function any_in_array($needle, $haystack)
	{
		$needle = is_array($needle) ? $needle : array($needle);

		foreach ($needle as $item)
		{
			if (in_array($item, $haystack))
			{
				return TRUE;
			}
	        }

		return FALSE;
	}

	// random_element() is included in Array Helper, so it overrides the native function
	function random_element($array)
	{
		shuffle($array);
		return array_pop($array);
	}

設定自定義前綴
-----------------------

用於擴展輔助函數的文件名前綴和擴展類庫和核心類是一樣的。要自定義這個前綴，您可以打開
**application/config/config.php** 文件然後找到這項::

	$config['subclass_prefix'] = 'MY_';

請注意所有原始的 CodeIgniter 類庫都以 **CI\_** 開頭，所以請不要使用這個
作為您的自定義前綴。

然後？
=========

在目錄裡您可以找到所有的輔助函數清單，您可以瀏覽下它們看看它們都是做什麼的。