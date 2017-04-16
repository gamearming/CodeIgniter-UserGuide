##############
錯誤處理
##############

CodeIgniter 可以通過下面介紹的成員函數來在您的應用程式中產生錯誤報告。
另外，還有一個錯誤日誌類用來將錯誤或調試資訊儲存到文字文件中。

.. note:: CodeIgniter 預設將顯示所有的 PHP 錯誤，您可能在開發結束之後
	改變該行為。在您的 index.php 文件的頂部有一個 error_reporting()
	函數，通過它可以修改錯誤設定。當發生錯誤時，停用錯誤報告
	並不會阻止向日誌文件寫入錯誤資訊。

和 CodeIgniter 中的大多數系統不同，錯誤函數是一個可以在整個應用程式中
使用的簡單接口，這讓您在使用該函數時不用擔心類或成員函數的作用域的問題。

當任何一處核心程式碼呼叫 ``exit()`` 時，CodeIgniter 會傳回一個狀態碼。
這個狀態碼和 HTTP 狀態碼不同，是用來通知其他程序 PHP 腳本是否成功執行的，
如果執行不成功，又是什麼原因導致了腳本退出。狀態碼的值被定義在
*application/config/constants.php* 文件中。狀態碼在 CLI 形式下非常有用，
可以幫助您的伺服器跟蹤並監控您的腳本。

下面的函數用於產生錯誤資訊：

.. php:function:: show_error($message, $status_code, $heading = 'An Error Was Encountered')

	:param	mixed	$message: Error message
	:param	int	$status_code: HTTP Response status code
	:param	string	$heading: Error page heading
	:rtype:	void

	該函數使用下面的錯誤模板來顯示錯誤資訊::

		application/views/errors/html/error_general.php

	或:

		application/views/errors/cli/error_general.php

	可選參數 ``$status_code`` 將決定發送什麼 HTTP 狀態碼。
	如果 ``$status_code`` 小於 100，HTTP 狀態碼將被置為 500 ，
	退出狀態碼將被置為 ``$status_code + EXIT__AUTO_MIN`` 。
	如果它的值大於 ``EXIT__AUTO_MAX`` 或者如果 ``$status_code``
	大於等於 100 ，退出狀態碼將被置為 ``EXIT_ERROR`` 。
	詳情可查看 *application/config/constants.php* 文件。

.. php:function:: show_404($page = '', $log_error = TRUE)

	:param	string	$page: URI string
	:param	bool	$log_error: Whether to log the error
	:rtype:	void

	該函數使用下面的錯誤模板來顯示 404 錯誤資訊::

		application/views/errors/html/error_404.php

	或:

		application/views/errors/cli/error_404.php

	傳遞給該函數的字元串代表的是找不到的文件路徑。退出狀態碼
	將設定為 ``EXIT_UNKNOWN_FILE`` 。
	注意如果找不到控制器 CodeIgniter 將自動顯示 404 錯誤資訊。

	預設 CodeIgniter 會自動將 ``show_404()`` 函數呼叫記錄到錯誤日誌中。
	將第二個參數設定為 FALSE 將跳過記錄日誌。

.. php:function:: log_message($level, $message)

	:param	string	$level: Log level: 'error', 'debug' or 'info'
	:param	string	$message: Message to log
	:rtype:	void

	該函數用於向您的日誌文件中寫入資訊，第一個參數您必須提供
	三個資訊級別中的一個，用於指定記錄的是什麼類型的資訊（調試，
	錯誤和一般資訊），第二個參數為資訊本身。

	範例::

		if ($some_var == '')
		{
			log_message('error', 'Some variable did not contain a value.');
		}
		else
		{
			log_message('debug', 'Some variable was correctly set');
		}

		log_message('info', 'The purpose of some variable is to provide some value.');

	有三種資訊類型：

	#. 錯誤資訊。這些是真正的錯誤，例如 PHP 錯誤或用戶錯誤。
	#. 調試資訊。這些資訊幫助您調試程序，例如，您可以在一個類
	   初始化的地方記錄下來作為調試資訊。
	#. 一般資訊。這些是最低級別的資訊，簡單的給出程序執行過程中的一些資訊。

	.. note:: 為了保證日誌文件被正確寫入，*logs/* 目錄必須設定為可寫的。
		此外，您必須要設定 *application/config/config.php* 文件中的
		"threshold"  參數，舉個範例，例如您只想記錄錯誤資訊，而不想
		記錄另外兩種類型的資訊，可以通過這個參數來控制。如果您將
		該參數設定為 0 ，日誌就相當於被停用了。
