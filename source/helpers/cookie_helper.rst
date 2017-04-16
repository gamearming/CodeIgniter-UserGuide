###################
Cookie 輔助函數
###################

Cookie 輔助函數文件包含了一些幫助您處理 Cookie 的函數。

.. contents::
  :local:

.. raw:: html

  <div class="custom-index container"></div>

載入輔助函數
===================

該輔助函數通過下面的程式碼載入::

	$this->load->helper('cookie');

可用函數
===================

該輔助函數有下列可用函數：

.. php:function:: set_cookie($name[, $value = ''[, $expire = ''[, $domain = ''[, $path = '/'[, $prefix = ''[, $secure = FALSE[, $httponly = FALSE]]]]]]])

	:param	mixed	$name: Cookie name *or* associative array of all of the parameters available to this function
	:param	string	$value: Cookie value
	:param	int	$expire: Number of seconds until expiration
	:param	string	$domain: Cookie domain (usually: .yourdomain.com)
	:param	string	$path: Cookie path
	:param	string	$prefix: Cookie name prefix
	:param	bool	$secure: Whether to only send the cookie through HTTPS
	:param	bool	$httponly: Whether to hide the cookie from JavaScript
	:rtype:	void

	該輔助函數提供給您一種更友好的語法來設定瀏覽器 Cookie，參考
	:doc:`輸入類 <../libraries/input>` 讀取它的詳細用法，另外，它是
	``CI_Input::set_cookie()`` 函數的別名。

.. php:function:: get_cookie($index[, $xss_clean = NULL])

	:param	string	$index: Cookie name
	:param	bool	$xss_clean: Whether to apply XSS filtering to the returned value
	:returns:	The cookie value or NULL if not found
	:rtype:	mixed

	該輔助函數提供給您一種更友好的語法來讀取瀏覽器 Cookie，參考
	:doc:`輸入類 <../libraries/input>` 讀取它的詳細用法，同時，這個函數
	和 ``CI_Input::cookie()`` 函數非常類似，只是它會依據設定文件
	*application/config/config.php* 中的 ``$config['cookie_prefix']`` 參數
	來作為 Cookie 的前綴。

.. php:function:: delete_cookie($name[, $domain = ''[, $path = '/'[, $prefix = '']]])

	:param	string	$name: Cookie name
	:param	string	$domain: Cookie domain (usually: .yourdomain.com)
	:param	string	$path: Cookie path
	:param	string	$prefix: Cookie name prefix
	:rtype:	void

	刪除一條 Cookie，只需要傳入 Cookie 名即可，也可以設定路徑或其他參數
	來刪除特定 Cookie。
	::

		delete_cookie('name');

	這個函數和 ``set_cookie()`` 比較類似，只是它並不提供 Cookie 的值和
	過期時間等參數。第一個參數也可以是個陣列，包含多個要刪除的 Cookie 。
	另外，您也可以像下面這樣刪除特定條件的 Cookie 。
	::

		delete_cookie($name, $domain, $path, $prefix);
