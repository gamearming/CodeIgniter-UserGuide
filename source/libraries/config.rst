############
設定類
############

設定類用於讀取設定參數，這些參數可以來自於預設的設定文件（application/config/config.php），
也可以來自您自定義的設定文件。

.. note:: 該類由系統自動初始化，您無需手工載入。

.. contents::
  :local:

.. raw:: html

  <div class="custom-index container"></div>

*****************************
使用設定類
*****************************

設定文件剖析
========================

CodeIgniter 預設有一個主要的設定文件，位於 application/config/config.php 。
如果您使用文字編輯器打開它的話，您會看到設定項都儲存在一個叫做 $config 的陣列中。

您可以往這個文件中加入您自己的設定項，或者您喜歡將您的設定項和系統的分開的話，
您也可以建立您自己的設定文件並儲存到設定目錄下。

.. note:: 如果您要建立您自己的設定文件，使用和主設定文件相同的格式，將設定項儲存到名為 $config 的陣列中。
	CodeIgniter 會智能的管理這些文件，所以就算陣列名都一樣也不會衝突（假設陣列的索引沒有相同的）。

載入設定文件
=====================

.. note::
	CodeIgniter 會自動載入主設定文件（application/config/config.php），所以您只需要載入您自己
	建立的設定文件就可以了。

有兩種載入設定文件的方式：

手工載入
**************

要載入您自定義的設定文件，您需要在 :doc:`控制器 </general/controllers>` 中使用下面的成員函數::

	$this->config->load('filename');

其中，filename 是您的設定文件的名稱，無需 .php 擴展名。

如果您需要載入多個設定文件，它們會被合併成一個大的 config 陣列裡。儘管您是在不同的設定文件中定義的，
但是，如果有兩個陣列索引名稱一樣的話還是會發生名稱衝突。為了避免衝突，您可以將第二個參數設定為 TRUE ，
這樣每個設定文件中的設定會被儲存到以該設定文件名為索引的陣列中去。例如::

	// Stored in an array with this prototype: $this->config['blog_settings'] = $config
	$this->config->load('blog_settings', TRUE);

請閱讀下面的 「讀取設定項」 一節，學習如何讀取通過這種方式載入的設定。

第三個參數用於抑制錯誤資訊，當設定文件不存在時，不會報錯::

	$this->config->load('blog_settings', FALSE, TRUE);

自動載入
************

如果您發現有一個設定文件您需要在全區範圍內使用，您可以讓系統自動載入它。
要實現這點，打開位於 application/config/ 目錄下的 **autoload.php** 文件，
將您的設定文件加入到自動載入陣列中。


讀取設定項
=====================

要從您的設定文件中讀取某個設定項，使用如下成員函數::

	$this->config->item('item_name');

其中 item_name 是您希望讀取的 $config 陣列的索引名，例如，要讀取語言選項，
您可以這樣::

	$lang = $this->config->item('language');

如果您要讀取的設定項不存在，成員函數傳回 NULL 。

如果您在使用 $this->config->load 成員函數時使用了第二個參數，每個設定文件中的設定
被儲存到以該設定文件名為索引的陣列中，要讀取該設定項，您可以將 $this->config->item()
成員函數的第二個參數設定為這個索引名（也就是設定文件名）。例如::

	// Loads a config file named blog_settings.php and assigns it to an index named "blog_settings"
	$this->config->load('blog_settings', TRUE);

	// Retrieve a config item named site_name contained within the blog_settings array
	$site_name = $this->config->item('site_name', 'blog_settings');

	// An alternate way to specify the same item:
	$blog_config = $this->config->item('blog_settings');
	$site_name = $blog_config['site_name'];

設定設定項
=====================

如果您想動態的設定一個設定項，或修改某個已存在的設定項，您可以這樣::

	$this->config->set_item('item_name', 'item_value');

其中，item_name 是您希望修改的 $config 陣列的索引名，item_value 為要設定的值。

.. _config-environments:

多環境
============

您可以依據目前的環境來載入不同的設定文件，index.php 文件中定義了 ENVIRONMENT
常數，在 :doc:`處理多環境 </general/environments>` 中有更詳細的介紹。

要建立特定環境的設定文件，新建或複製一個設定文件到 application/config/{ENVIRONMENT}/{FILENAME}.php 。

例如，要新建一個生產環境的設定文件，您可以：

#. 新建目錄 application/config/production/
#. 將已有的 config.php 文件拷貝到該目錄
#. 編輯 application/config/production/config.php 文件，使用生產環境下設定

當您將 ENVIRONMENT 常數設定為 'production' 時，您新建的生產環境下的 config.php 
裡的設定將會載入。

您可以放置以下設定文件到特定環境的目錄下：

-  預設的 CodeIgniter 設定文件
-  您自己的設定文件

.. note::
	CodeIgniter 總是先載入全區設定文件（例如，application/config/ 目錄下的設定文件），
	然後再去嘗試載入目前環境的設定文件。這意味著您沒必要將所有的設定文件都放到特定環境的設定目錄下，
	只需要放那些在每個環境下不一樣的設定文件就可以了。另外，您也不用拷貝所有的設定文件內容到
	特定環境的設定文件中，只需要將那些在每個環境下不一樣的設定項拷進去就行了。定義在環境目錄下的設定項，
	會覆蓋掉全區的設定。


***************
類參考
***************

.. php:class:: CI_Config

	.. attribute:: $config

		所有已載入的設定項組成的陣列。

	.. attribute:: $is_loaded

		所有已載入的設定文件組成的陣列。


	.. php:method:: item($item[, $index=''])

		:param	string	$item: Config item name
		:param	string	$index: Index name
		:returns:	Config item value or NULL if not found
		:rtype:	mixed

		讀取某個設定項。

	.. php:method:: set_item($item, $value)

		:param	string	$item: Config item name
		:param	string	$value: Config item value
		:rtype:	void

		設定某個設定項的值。

	.. php:method:: slash_item($item)

		:param	string	$item: config item name
		:returns:	Config item value with a trailing forward slash or NULL if not found
		:rtype:	mixed

		這個成員函數和 ``item()`` 一樣，只是在讀取的設定項後面加入一個斜線，如果設定項不存在，傳回 NULL 。

	.. php:method:: load([$file = ''[, $use_sections = FALSE[, $fail_gracefully = FALSE]]])

		:param	string	$file: Configuration file name
		:param	bool	$use_sections: Whether config values shoud be loaded into their own section (index of the main config array)
		:param	bool	$fail_gracefully: Whether to return FALSE or to display an error message
		:returns:	TRUE on success, FALSE on failure
		:rtype:	bool

		載入設定文件。

	.. php:method:: site_url()

		:returns:	Site URL
		:rtype:	string

		該成員函數傳回您的網站的 URL ，包括您在設定文件中設定的 "index" 值。

		這個成員函數通常通過 :doc:`URL 輔助函數 </helpers/url_helper>` 中函數來存取。

	.. php:method:: base_url()

		:returns:	Base URL
		:rtype:	string

		該成員函數傳回您的網站的根 URL ，您可以在後面加上樣式和圖片的路徑來存取它們。

		這個成員函數通常通過 :doc:`URL 輔助函數 </helpers/url_helper>` 中函數來存取。

	.. php:method:: system_url()

		:returns:	URL pointing at your CI system/ directory
		:rtype:	string

		該成員函數傳回 CodeIgniter 的 system 目錄的 URL 。

		.. note:: 該成員函數已經廢棄，因為這是一個不安全的編碼實踐。您的 *system/* 目錄不應該被公開存取。
