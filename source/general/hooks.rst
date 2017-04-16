####################################
鉤子 - 擴展框架核心
####################################

CodeIgniter 的鉤子特性提供了一種成員函數來修改框架的內部運作流程，而無需修改
核心文件。CodeIgniter 的執行遵循著一個特定的流程，您可以參考這個頁面的
:doc:`應用程式流程圖 <../overview/appflow>` 。但是，有些時候您可能希望在
執行流程中的某些階段加入一些動作，例如在控制器載入之前或之後執行一段腳本，
或者在其他的某些位置觸發您的腳本。

啟用鉤子
==============

鉤子特性可以在 **application/config/config.php** 文件中全區的啟用或停用，
設定下面這個參數::

	$config['enable_hooks'] = TRUE;

定義鉤子
===============

鉤子是在 **application/config/hooks.php** 文件中被定義的，每個鉤子可以定義
為下面這樣的陣列格式::

	$hook['pre_controller'] = array(
		'class'    => 'MyClass',
		'function' => 'Myfunction',
		'filename' => 'Myclass.php',
		'filepath' => 'hooks',
		'params'   => array('beer', 'wine', 'snacks')
	);

**注意：**

陣列的索引為您想使用的掛鉤點名稱，例如上例中掛鉤點為 pre_controller ，
下面會列出所有可用的掛鉤點。鉤子陣列是一個關聯陣列，陣列的鍵值可以是
下面這些：

-  **class** 您希望呼叫的類名，如果您更喜歡使用過程式的函數的話，這一項可以留空。
-  **function** 您希望呼叫的成員函數或函數的名稱。
-  **filename** 包含您的類或函數的文件名。
-  **filepath** 包含您的腳本文件的目錄名。
   注意：
   您的腳本必須放在 *application/* 目錄裡面，所以 filepath 是相對 *application/*
   目錄的路徑，舉例來說，如果您的腳本位於 *application/hooks/* ，那麼 filepath
   可以簡單的設定為 'hooks' ，如果您的腳本位於 *application/hooks/utilities/* ，
   那麼 filepath 可以設定為 'hooks/utilities' ，路徑後面不用加斜線。
-  **params** 您希望傳遞給您腳本的任何參數，可選。

您也可以使用 lambda 表達式/匿名函數(或閉包)作為鉤子，這樣寫起來更簡單::

	$hook['post_controller'] = function()
	{
		/* do something here */
	};

多次呼叫同一個掛鉤點
===============================

如果您想在同一個掛鉤點處加入多個腳本，只需要將鉤子陣列變成二維陣列即可，像這樣::

	$hook['pre_controller'][] = array(
		'class'    => 'MyClass',
		'function' => 'MyMethod',
		'filename' => 'Myclass.php',
		'filepath' => 'hooks',
		'params'   => array('beer', 'wine', 'snacks')
	);

	$hook['pre_controller'][] = array(
		'class'    => 'MyOtherClass',
		'function' => 'MyOtherMethod',
		'filename' => 'Myotherclass.php',
		'filepath' => 'hooks',
		'params'   => array('red', 'yellow', 'blue')
	);

注意陣列索引後面多了個中括號::

	$hook['pre_controller'][]

這可以讓您在同一個掛鉤點處執行多個腳本，多個腳本執行順序就是您定義陣列的順序。

掛鉤點
===========

以下是所有可用掛鉤點的一份清單：

-  **pre_system**
   在系統執行的早期呼叫，這個時候只有 基準測試類 和 鉤子類 被載入了，
   還沒有執行到路由或其他的流程。
-  **pre_controller**
   在您的控制器呼叫之前執行，所有的基礎類都已載入，路由和安全檢查也已經完成。
-  **post_controller_constructor**
   在您的控制器執行緒化之後立即執行，控制器的任何成員函數都還尚未呼叫。
-  **post_controller**
   在您的控制器完全執行結束時執行。
-  **display_override**
   覆蓋 ``_display()`` 成員函數，該成員函數用於在系統執行結束時向瀏覽器發送最終的頁面結果。
   這可以讓您有自己的顯示頁面的成員函數。注意您可能需要使用 ``$this->CI =& get_instance()``
   成員函數來讀取 CI 超級物件，以及使用 ``$this->CI->output->get_output()`` 成員函數來
   讀取最終的顯示資料。
-  **cache_override**
   使用您自己的成員函數來替代 :doc:`輸出類 <../libraries/output>` 中的 ``_display_cache()``
   成員函數，這讓您有自己的快取顯示機制。
-  **post_system**
   在最終的頁面發送到瀏覽器之後、在系統的最後期被呼叫。
