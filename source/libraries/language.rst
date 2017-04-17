##############
語言類
##############

語言類提供了一些成員函數用於讀取語言文件和不同語言的文字來實現國際化。

在您的 CodeIgniter 的 **system** 資料夾，有一個 **language** 子資料夾，
它包含了一系列 **英文** 的語言文件。
在 **system/language/english/** 這個資料夾下的這些文件定義了 CodeIgniter 
框架的各個部分使用到的一些一般消息，錯誤消息，以及其他一些通用的單詞或短語。

如果需要的話，您可以建立屬於您自己的語言文件，用於提供應用程式的錯誤消息和其他消息，
或者將核心部分的消息翻譯為其他的語言。翻譯的消息或您另加的消息應該放在 
**application/language/** 資料夾下，每種不同的語言都有相應的一個子資料夾（例如，
'french' 或者 'german'）。

CodeIgniter 框架自帶了一套 "英語" 語言文件，另外可以在 
`CodeIgniter 3 翻譯倉庫 <https://github.com/bcit-ci/codeigniter3-translations>`_ 
找到其他不同的語言，每個語言都有一個獨立的資料夾。

當 CodeIgniter 載入語言文件時，它會先載入 **system/language/** 資料夾下的，然後再載入
您的 **application/language/** 資料夾下的來覆蓋它。

.. note:: 每個語言都有它自己的資料夾，例如，英語語言文件位於：system/language/english

.. contents::
  :local:

.. raw:: html

  <div class="custom-index container"></div>

***************************
處理多語言
***************************

如果您想讓您的應用程式支援多語言，您就需要在 **application/language/** 資料夾下提供不同語言的文件，
然後在 **application/config/config.php** 設定文件中指定預設語言。

**application/language/english/** 資料夾可以包含您的應用程式需要的額外語言文件，例如錯誤消息。

每個語言對應的資料夾中都應該包含從 翻譯倉庫 中讀取到的核心文件，或者您自己翻譯它們，您也可以加入
您的程序需要的其他文件。

您應該將您正在使用的語言儲存到一個會話變數中。

語言文件的範例
=====================

::

	system/
		language/
			english/
				...
				email_lang.php
				form_validation_lang.php
				...

	application/
		language/
			english/
				error_messages_lang.php
			french/
				...
				email_lang.php
				error_messages_lang.php
				form_validation_lang.php
				...

切換語言
==============================

::

	$idiom = $this->session->get_userdata('language');
	$this->lang->load('error_messages', $idiom);
	$oops = $this->lang->line('message_key');

********************
國際化
********************

CodeIgniter 的語言類給您的應用程式提供了一種簡單輕便的方式來實現多語言，
它並不是通常我們所說的 `國際化與本地化 <http://en.wikipedia.org/wiki/Internationalization_and_localization>`_
的完整實現。

我們可以給每一種語言一個別名，一個更通用的名字，而不是使用諸如 "en"、
"en-US"、"en-CA-x-ca" 這種國際標準的縮寫名字。

.. note:: 當然，您完全可以在您的程序中使用國際標準的縮寫名字。

************************
使用語言類
************************

建立語言文件
=======================

語言文件的命名必須以 **_lang.php** 結尾，例如，您想建立一個包含錯誤消息的文件，
您可以把它命名為：error_lang.php 。

在此文件中，您可以在每行把一個字元串賦值給名為 $lang 的陣列，例如::

	$lang['language_key'] = 'The actual message to be shown';

.. note:: 在每個文件中使用一個通用的前綴來避免和其他文件中的相似名稱衝突是個好成員函數。
	例如，如果您在建立錯誤消息您可以使用 error\_ 前綴。

::

	$lang['error_email_missing'] = 'You must submit an email address';
	$lang['error_url_missing'] = 'You must submit a URL';
	$lang['error_username_missing'] = 'You must submit a username';

載入語言文件
=======================

在使用語言文件之前，您必須先載入它。可以使用下面的程式碼::

	$this->lang->load('filename', 'language');

其中 filename 是您要載入的語言文件名（不帶擴展名），language 是要載入哪種語言（比如，英語）。
如果沒有第二個參數，將會使用 **application/config/config.php** 中設定的預設語言。

您也可以通過傳一個語言文件的陣列給第一個參數來同時載入多個語言文件。
::

	$this->lang->load(array('filename1', 'filename2'));

.. note:: *language* 參數只能包含字母。

讀取語言文字
=======================

當您的語言文件已經載入，您就可以通過下面的成員函數來存取任何一行語言文字::

	$this->lang->line('language_key');

其中，*language_key* 參數是您想顯示的文字行所對應的陣列的鍵名。

萬一您不確定您想讀取的那行文字是否存在，您還可以將第二個參數設定為 FALSE 停用錯誤日誌::

	$this->lang->line('misc_key', FALSE);

.. note:: 該成員函數只是簡單的傳回文字行，而不是顯示出它。

使用語言行作為表單的標籤
-----------------------------------

這一特性已經從語言類中廢棄，並移到了 :doc:`語言輔助函數 <../helpers/language_helper>`
的 :php:func:`lang()` 函數。

自動載入語言文件
======================

如果您發現您需要在整個應用程式中使用某個語言文件，您可以讓 CodeIgniter
在系統初始化的時候 :doc:`自動載入 <../general/autoloader>` 該語言文件。
可以打開 **application/config/autoload.php** 文件，把語言放在 autoload 陣列中。

***************
類參考
***************

.. php:class:: CI_Lang

	.. php:method:: load($langfile[, $idiom = ''[, $return = FALSE[, $add_suffix = TRUE[, $alt_path = '']]]])

		:param	mixed	$langfile: Language file to load or array with multiple files
		:param	string	$idiom: Language name (i.e. 'english')
		:param	bool	$return: Whether to return the loaded array of translations
		:param	bool	$add_suffix: Whether to add the '_lang' suffix to the language file name
		:param	string	$alt_path: An alternative path to look in for the language file
		:returns:	Array of language lines if $return is set to TRUE, otherwise void
		:rtype:	mixed

		載入一個語言文件。

	.. php:method:: line($line[, $log_errors = TRUE])

		:param	string	$line: Language line key name
		:param	bool	$log_errors: Whether to log an error if the line isn't found
		:returns:	Language line string or FALSE on failure
		:rtype:	string

		從一個已載入的語言文件中，通過行名讀取一行該語言的文字。