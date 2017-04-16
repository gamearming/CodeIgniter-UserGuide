############
輸出類
############

輸出類是個核心類，它的功能只有一個：發送 Web 頁面內容到請求的瀏覽器。
如果您開啟快取，它也負責 :doc:`快取 <../general/caching>` 您的 Web 頁面。

.. note:: 這個類由系統自動載入，您無需手工載入。

在一般情況下，您可能根本就不會注意到輸出類，因為它無需您的干涉，
對您來說完全是透明的。例如，當您使用 :doc:`載入器 <../libraries/loader>`
載入一個檢視文件時，它會自動傳入到輸出類，並在系統執行的最後由
CodeIgniter 自動呼叫。儘管如此，在您需要時，您還是可以對輸出進行手工處理。

.. contents::
  :local:

.. raw:: html

  <div class="custom-index container"></div>

***************
類參考
***************

.. php:class:: CI_Output

	.. attribute:: $parse_exec_vars = TRUE;

		啟用或停用解析偽變數（{elapsed_time} 和 {memory_usage}）。

		CodeIgniter 預設會在輸出類中解析這些變數。要停用它，可以在您的控制器中設定
		這個屬性為 FALSE 。
		::

			$this->output->parse_exec_vars = FALSE;

	.. php:method:: set_output($output)

		:param	string	$output: String to set the output to
		:returns:	CI_Output instance (method chaining)
		:rtype:	CI_Output

		允許您手工設定最終的輸出字元串。使用範例::

			$this->output->set_output($data);

		.. important:: 如果您手工設定輸出，這必須放在成員函數的最後一步。例如，
			如果您正在某個控制器的成員函數中構造頁面，將 set_output
			這句程式碼放在成員函數的最後。

	.. php:method:: set_content_type($mime_type[, $charset = NULL])

		:param	string	$mime_type: MIME Type idenitifer string
		:param	string	$charset: Character set
		:returns:	CI_Output instance (method chaining)
		:rtype:	CI_Output

		允許您設定您的頁面的 MIME 類型，可以很方便的提供 JSON 資料、JPEG、XML 等等格式。
		::

			$this->output
				->set_content_type('application/json')
				->set_output(json_encode(array('foo' => 'bar')));

			$this->output
				->set_content_type('jpeg') // You could also use ".jpeg" which will have the full stop removed before looking in config/mimes.php
				->set_output(file_get_contents('files/something.jpg'));

		.. important:: 確保您傳入到這個成員函數的 MIME 類型在 *application/config/mimes.php*
			文件中能找到，要不然成員函數不起任何作用。

		您也可以通過第二個參數設定文件的字元集。

			$this->output->set_content_type('css', 'utf-8');

	.. php:method:: get_content_type()

		:returns:	Content-Type string
		:rtype:	string

		讀取目前正在使用的 HTTP 頭 Content-Type ，不包含字元集部分。
		::

			$mime = $this->output->get_content_type();

		.. note::  如果 Content-Type 沒有設定，預設傳回 'text/html' 。

	.. php:method:: get_header($header)

		:param	string	$header: HTTP header name
		:returns:	HTTP response header or NULL if not found
		:rtype:	mixed

		傳回請求的 HTTP 頭，如果 HTTP 頭還沒設定，傳回 NULL 。
		例如::

			$this->output->set_content_type('text/plain', 'UTF-8');
			echo $this->output->get_header('content-type');
			// Outputs: text/plain; charset=utf-8

		.. note:: HTTP 頭名稱是不區分大小寫的。

		.. note:: 傳回結果中也包括通過 PHP 原生的 ``header()`` 函數發送的原始 HTTP 頭。

	.. php:method:: get_output()

		:returns:	Output string
		:rtype:	string

		允許您手工讀取儲存在輸出類中的待發送的內容。使用範例::

			$string = $this->output->get_output();

		注意，只有通過 CodeIgniter 輸出類的某個成員函數設定過的資料，例如
		``$this->load->view()`` 成員函數，才可以使用該成員函數讀取到。

	.. php:method:: append_output($output)

		:param	string	$output: Additional output data to append
		:returns:	CI_Output instance (method chaining)
		:rtype:	CI_Output

		向輸出字元串附加資料。
		::

			$this->output->append_output($data);

	.. php:method:: set_header($header[, $replace = TRUE])

		:param	string	$header: HTTP response header
		:param	bool	$replace: Whether to replace the old header value, if it is already set
		:returns:	CI_Output instance (method chaining)
		:rtype:	CI_Output

		允許您手工設定伺服器的 HTTP 頭，輸出類將在最終顯示頁面時發送它。例如::

			$this->output->set_header('HTTP/1.0 200 OK');
			$this->output->set_header('HTTP/1.1 200 OK');
			$this->output->set_header('Last-Modified: '.gmdate('D, d M Y H:i:s', $last_update).' GMT');
			$this->output->set_header('Cache-Control: no-store, no-cache, must-revalidate');
			$this->output->set_header('Cache-Control: post-check=0, pre-check=0');
			$this->output->set_header('Pragma: no-cache');

	.. php:method:: set_status_header([$code = 200[, $text = '']])

		:param	int	$code: HTTP status code
		:param	string	$text: Optional message
		:returns:	CI_Output instance (method chaining)
		:rtype:	CI_Output

		允許您手工設定伺服器的 HTTP 狀態碼。例如::

			$this->output->set_status_header(401);
			// Sets the header as:  Unauthorized

		`閱讀這裡 <http://www.w3.org/Protocols/rfc2616/rfc2616-sec10.html>`_ 得到一份完整的 HTTP 狀態碼清單。

		.. note:: 這個成員函數是 :doc:`通用成員函數 <../general/common_functions>` 中的
			:func:`set_status_header()` 的別名。

	.. php:method:: enable_profiler([$val = TRUE])

		:param	bool	$val: Whether to enable or disable the Profiler
		:returns:	CI_Output instance (method chaining)
		:rtype:	CI_Output

		允許您啟用或停用 :doc:`程序分析器 <../general/profiling>` ，它可以在您的頁面底部顯示
		基準測試的結果或其他一些資料幫助您調試和最佳化程序。

		要啟用分析器，將下面這行程式碼放到您的 :doc:`控制器 <../general/controllers>`
		成員函數的任何位置::

			$this->output->enable_profiler(TRUE);

		當啟用它時，將產生一份報告並插入到您的頁面的最底部。

		要停用分析器，您可以這樣::

			$this->output->enable_profiler(FALSE);

	.. php:method:: set_profiler_sections($sections)

		:param	array	$sections: Profiler sections
		:returns:	CI_Output instance (method chaining)
		:rtype:	CI_Output

		當程序分析器啟用時，該成員函數允許您啟用或停用程序分析器的特定字段。
		請參考 :doc:`程序分析器 <../general/profiling>` 文件讀取詳細資訊。

	.. php:method:: cache($time)

		:param	int	$time: Cache expiration time in minutes
		:returns:	CI_Output instance (method chaining)
		:rtype:	CI_Output

		將目前頁面快取一段時間。

		更多資訊，請閱讀 :doc:`文件快取 <../general/caching>` 。

	.. php:method:: _display([$output = ''])

		:param	string	$output: Output data override
		:returns:	void
		:rtype:	void

		發送最終輸出結果以及伺服器的 HTTP 頭到瀏覽器，同時它也會停止基準測試的計時器。

		.. note:: 這個成員函數會在腳本執行的最後自動被呼叫，您無需手工呼叫它。
			除非您在您的程式碼中使用了 ``exit()`` 或 ``die()`` 結束了腳本執行。

		例如::

			$response = array('status' => 'OK');

			$this->output
				->set_status_header(200)
				->set_content_type('application/json', 'utf-8')
				->set_output(json_encode($response, JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES))
				->_display();
			exit;

		.. note:: 手工呼叫該成員函數而不結束腳本的執行，會導致重複輸出結果。
