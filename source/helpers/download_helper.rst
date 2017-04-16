###############
下載輔助函數
###############

下載輔助函數文件包含了下載相關的一些函數。

.. contents::
  :local:

.. raw:: html

  <div class="custom-index container"></div>

載入輔助函數
===================

該輔助函數通過下面的程式碼載入::

	$this->load->helper('download');

可用函數
===================

該輔助函數有下列可用函數：

.. php:function:: force_download([$filename = ''[, $data = ''[, $set_mime = FALSE]]])

	:param	string	$filename: Filename
	:param	mixed	$data: File contents
	:param	bool	$set_mime: Whether to try to send the actual MIME type
	:rtype:	void

	產生 HTTP 頭強制下載資料到客戶端，這在實現文件下載時很有用。
	第一個參數為下載文件名稱，第二個參數為文件資料。

	如果第二個參數為空，並且 ``$filename`` 參數是一個存在並可讀的文件路徑，
	那麼這個文件的內容將被下載。

	如果第三個參數設定為 TRUE，那麼將發送文件實際的 MIME 類型（依據文件的擴展名），
	這樣您的瀏覽器會依據該 MIME 類型來處理。

	Example::

		$data = 'Here is some text!';
		$name = 'mytext.txt';
		force_download($name, $data);

	下載一個伺服器上已存在的文件的範例如下::

		// Contents of photo.jpg will be automatically read
		force_download('/path/to/photo.jpg', NULL);