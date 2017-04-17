##############
安全類
##############

安全類包含了一些成員函數，用於安全的處理輸入資料，幫助您建立一個安全的應用。

.. contents::
  :local:

.. raw:: html

  <div class="custom-index container"></div>

*************
XSS 過濾
*************

CodeIgniter comes with a Cross Site Scripting prevention filter, which
looks for commonly used techniques to trigger JavaScript or other types
of code that attempt to hijack cookies or do other malicious things.
If anything disallowed is encountered it is rendered safe by converting
the data to character entities.

使用 XSS 過濾器過濾資料可以使用 ``xss_clean()`` 成員函數::

	$data = $this->security->xss_clean($data);

它還有一個可選的第二個參數 is_image ，允許此函數對圖片進行檢測以發現那些潛在的
XSS 攻擊, 這對於保證文件上傳的安全非常有用。當此參數被設定為 TRUE 時，
函數的傳回值將是一個布林值，而不是一個修改過的字元串。如果圖片是安全的則傳回 TRUE ，
相反, 如果圖片中包含有潛在的、可能會被瀏覽器嘗試執行的惡意資訊，函數將傳回 FALSE 。

::

	if ($this->security->xss_clean($file, TRUE) === FALSE)
	{
		// file failed the XSS test
	}

*********************************
跨站請求偽造（CSRF）
*********************************

打開您的 application/config/config.php 文件，進行如下設定，即可啟用 CSRF 保護::

	$config['csrf_protection'] = TRUE;

如果您使用 :doc:`表單輔助函數 <../helpers/form_helper>` ，:func:`form_open()`
函數將會自動地在您的表單中插入一個隱藏的 CSRF 字段。如果沒有插入這個字段，
您可以手工呼叫 ``get_csrf_token_name()`` 和 ``get_csrf_hash()`` 這兩個函數。

::

	$csrf = array(
		'name' => $this->security->get_csrf_token_name(),
		'hash' => $this->security->get_csrf_hash()
	);

	...

	<input type="hidden" name="<?=$csrf['name'];?>" value="<?=$csrf['hash'];?>" />

令牌（tokens）預設會在每一次送出時重新產生，或者您也可以設定成在 CSRF cookie 
的生命週期內一直有效。預設情況下令牌重新產生提供了更嚴格的安全機制，但可能會對
可用性帶來一定的影響，因為令牌很可能會變得失效（例如使用瀏覽器的傳回前進按鈕、
使用多窗口或多標籤頁瀏覽、異步呼叫等等）。您可以修改下面這個參數來改變這一點。

::

	$config['csrf_regenerate'] = TRUE;

另外，您可以加入一個 URI 的白名單，跳過 CSRF 保護（例如某個 API 接口希望接受
原始的 POST 資料），將這些 URI 加入到 'csrf_exclude_uris' 設定參數中::

	$config['csrf_exclude_uris'] = array('api/person/add');

URI 中也支援使用正則表達式（不區分大小寫）::

	$config['csrf_exclude_uris'] = array(
		'api/record/[0-9]+',
		'api/title/[a-z]+'
	);

***************
類參考
***************

.. php:class:: CI_Security

	.. php:method:: xss_clean($str[, $is_image = FALSE])

		:param	mixed	$str: Input string or an array of strings
		:returns:	XSS-clean data
		:rtype:	mixed

		嘗試移除輸入資料中的 XSS 程式碼，並傳回過濾後的資料。
		如果第二個參數設定為 TRUE ，將檢查圖片中是否含有惡意資料，是的話傳回 TRUE ，否則傳回 FALSE 。

	.. php:method:: sanitize_filename($str[, $relative_path = FALSE])

		:param	string	$str: File name/path
		:param	bool	$relative_path: Whether to preserve any directories in the file path
		:returns:	Sanitized file name/path
		:rtype:	string

		嘗試對文件名進行淨化，防止資料夾遍歷嘗試以及其他的安全威脅，當文件名作為用戶輸入的參數時格外有用。
		::

			$filename = $this->security->sanitize_filename($this->input->post('filename'));

		如果允許用戶送出相對路徑，例如 *file/in/some/approved/folder.txt* ，您可以將第二個參數 ``$relative_path`` 設定為 TRUE 。
		::

			$filename = $this->security->sanitize_filename($this->input->post('filename'), TRUE);

	.. php:method:: get_csrf_token_name()

		:returns:	CSRF token name
		:rtype:	string

		傳回 CSRF 的令牌名（token name），也就是 ``$config['csrf_token_name']`` 的值。

	.. php:method:: get_csrf_hash()

		:returns:	CSRF hash
		:rtype:	string

		傳回 CSRF 哈希值（hash value），在和 ``get_csrf_token_name()`` 函數一起使用時很有用，用於產生表單裡的 CSRF 字段
		以及發送有效的 AJAX POST 請求。

	.. php:method:: entity_decode($str[, $charset = NULL])

		:param	string	$str: Input string
		:param	string	$charset: Character set of the input string
		:returns:	Entity-decoded string
		:rtype:	string

		該成員函數和 ENT_COMPAT 模式下的 PHP 原生函數 ``html_entity_decode()`` 差不多，只是它除此之外，還會檢測不以分號結尾的 
		HTML 實體，因為有些瀏覽器允許這樣。

		如果沒有設定 ``$charset`` 參數，則使用您設定的 ``$config['charset']`` 參數作為編碼格式。

	.. php:method:: get_random_bytes($length)

		:param	int	$length: Output length
		:returns:	A binary stream of random bytes or FALSE on failure
		:rtype:	string

		這是一種產生隨機字元串的簡易成員函數，該成員函數通過按順序呼叫 ``mcrypt_create_iv()``， ``/dev/urandom``
		和 ``openssl_random_pseudo_bytes()`` 這三個函數，只要有一個函數是可用的，都可以傳回隨機字元串。

		用於產生 CSRF 和 XSS 的令牌。

		.. note:: 輸出並不能保證絕對安全，只是盡量做到更安全。