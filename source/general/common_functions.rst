################
公共函數
################

CodeIgniter 定義了一些全區的函數，您可以在任何地方使用它們，並且不需要載入任何
類庫或輔助函數。

.. contents::
  :local:

.. raw:: html

  <div class="custom-index container"></div>

.. php:function:: is_php($version)

	:param	string	$version: Version number
	:returns:	TRUE if the running PHP version is at least the one specified or FALSE if not
	:rtype:	bool

	判斷目前執行的 PHP 版本是否高於或等於您提供的版本號。

	例如::

		if (is_php('5.3'))
		{
			$str = quoted_printable_encode($str);
		}

	如果目前執行的 PHP 版本等於或高於提供的版本號，該函數傳回布林值 TRUE ，反之則傳回 FALSE 。

.. php:function:: is_really_writable($file)

	:param	string	$file: File path
	:returns:	TRUE if the path is writable, FALSE if not
	:rtype:	bool

	在 Windows 伺服器上只有當文件標誌了只讀屬性時，PHP 的 ``is_writable()`` 函數才傳回 FALSE ，
	其他情況都是傳回 TRUE ，即使文件不是真的可寫也傳回 TRUE 。

	這個函數首先嘗試寫入該文件，以此來判斷該文件是不是真的可寫。通常只在 ``is_writable()`` 函數
	傳回的結果不準確的平台下才推薦使用該函數。

	例如::

		if (is_really_writable('file.txt'))
		{
			echo "I could write to this if I wanted to";
		}
		else
		{
			echo "File is not writable";
		}

	.. note:: 更多資訊，參看 `PHP bug #54709 <https://bugs.php.net/bug.php?id=54709>`_ 。

.. php:function:: config_item($key)

	:param	string	$key: Config item key
	:returns:	Configuration key value or NULL if not found
	:rtype:	mixed

	存取設定資訊最好的方式是使用 :doc:`設定類 <../libraries/config>` ，但是，您也可以通過 
	``config_item()`` 函數來存取單個設定項，更多資訊，參看 :doc:`設定類 <../libraries/config>`

.. :noindex: function:: show_error($message, $status_code[, $heading = 'An Error Was Encountered'])

	:param	mixed	$message: Error message
	:param	int	$status_code: HTTP Response status code
	:param	string	$heading: Error page heading
	:rtype:	void

	這個函數直接呼叫 ``CI_Exception::show_error()`` 成員函數。更多資訊，請查看 :doc:`錯誤處理 <errors>` 文件。

.. :noindex: function:: show_404([$page = ''[, $log_error = TRUE]])

	:param	string	$page: URI string
	:param	bool	$log_error: Whether to log the error
	:rtype:	void

	這個函數直接呼叫 ``CI_Exception::show_404()`` 成員函數。更多資訊，請查看 :doc:`錯誤處理 <errors>` 文件。

.. :noindex: function:: log_message($level, $message)

	:param	string	$level: Log level: 'error', 'debug' or 'info'
	:param	string	$message: Message to log
	:rtype:	void

	這個函數直接呼叫 ``CI_Log::write_log()`` 成員函數。更多資訊，請查看 :doc:`錯誤處理 <errors>` 文件。

.. php:function:: set_status_header($code[, $text = ''])

	:param	int	$code: HTTP Reponse status code
	:param	string	$text: A custom message to set with the status code
	:rtype:	void

	用於手動設定伺服器的 HTTP 狀態碼，例如::

		set_status_header(401);
		// Sets the header as:  Unauthorized

	`查看這裡 <http://www.w3.org/Protocols/rfc2616/rfc2616-sec10.html>`_ 有一份狀態碼的完整清單。

.. php:function:: remove_invisible_characters($str[, $url_encoded = TRUE])

	:param	string	$str: Input string
	:param	bool	$url_encoded: Whether to remove URL-encoded characters as well
	:returns:	Sanitized string
	:rtype:	string

	這個函數防止在 ASCII 字元串中插入空字元，例如：Java\\0script 。

	舉例::

		remove_invisible_characters('Java\\0script');
		// Returns: 'Javascript'

.. php:function:: html_escape($var)

	:param	mixed	$var: Variable to escape (string or array)
	:returns:	HTML escaped string(s)
	:rtype:	mixed

	這個函數類似於 PHP 原生的 ``htmlspecialchars()`` 函數，只是它除了可以接受字元串參數外，還可以接受陣列參數。

	它在防止 XSS 攻擊時很有用。

.. php:function:: get_mimes()

	:returns:	An associative array of file types
	:rtype:	array

	這個函數傳回 *application/config/mimes.php* 文件中定義的 MIME 陣列的 **引用** 。

.. php:function:: is_https()

	:returns:	TRUE if currently using HTTP-over-SSL, FALSE if not
	:rtype:	bool

	該函數在使用 HTTPS 安全連接時傳回 TRUE ，沒有使用 HTTPS（包括非 HTTP 的請求）則傳回 FALSE 。

.. php:function:: is_cli()

	:returns:	TRUE if currently running under CLI, FALSE otherwise
	:rtype:	bool

	當程序在命令列下執行時傳回 TRUE ，反之傳回 FALSE 。

	.. note:: 該函數會檢查 ``PHP_SAPI`` 的值是否是 'cli' ，或者是否定義了 ``STDIN`` 常數。

.. php:function:: function_usable($function_name)

	:param	string	$function_name: Function name
	:returns:	TRUE if the function can be used, FALSE if not
	:rtype:	bool

	檢查一個函數是否可用，可用傳回 TRUE ，否則傳回 FALSE 。

	該函數直接呼叫 ``function_exists()`` 函數，並檢查目前是否載入了
	`Suhosin 擴展 <http://www.hardened-php.net/suhosin/>` ，如果載入了 
	Suhosin ，檢查函數有沒有被它停用。

	這個函數在您需要檢查某些函數的可用性時非常有用，例如 ``eval()`` 
	和 ``exec()`` 函數是非常危險的，可能會由於伺服器的安全策略被停用。

	.. note:: 之所以引入這個函數，是由於 Suhosin 的某個 bug 可能會終止腳本的執行，
		雖然這個 bug 已經被修復了（版本 0.9.34），但可惜的是還沒發佈。