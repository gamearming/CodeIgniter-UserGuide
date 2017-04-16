###############
安全輔助函數
###############

安全輔助函數文件包含了一些和安全相關的函數。

.. contents::
  :local:

.. raw:: html

  <div class="custom-index container"></div>

載入輔助函數
===================

該輔助函數通過下面的程式碼載入::

	$this->load->helper('security');

可用函數
===================

該輔助函數有下列可用函數：

.. php:function:: xss_clean($str[, $is_image = FALSE])

	:param	string	$str: Input data
	:param	bool	$is_image: Whether we're dealing with an image
	:returns:	XSS-clean string
	:rtype:	string

	該函數提供了 XSS 攻擊的過濾。

	它是 ``CI_Input::xss_clean()`` 函數的別名，更多資訊，請查閱 :doc:`輸入類 <../libraries/input>` 文件。

.. php:function:: sanitize_filename($filename)

	:param	string	$filename: Filename
	:returns:	Sanitized file name
	:rtype:	string

	該函數提供了 目錄遍歷 攻擊的防護。

	它是 ``CI_Security::sanitize_filename()`` 函數的別名，更多資訊，請查閱 :doc:`安全類 <../libraries/security>` 文件。


.. php:function:: do_hash($str[, $type = 'sha1'])

	:param	string	$str: Input
	:param	string	$type: Algorithm
	:returns:	Hex-formatted hash
	:rtype:	string

	該函數可計算單向散列，一般用於對密碼進行加密，預設使用 SHA1 。

	您可以前往 `hash_algos() <http://php.net/function.hash_algos>`_ 查看所有支援的算法清單。

	舉例::

		$str = do_hash($str); // SHA1
		$str = do_hash($str, 'md5'); // MD5

	.. note:: 這個函數前身為 ``dohash()``，已廢棄。

	.. note:: 這個函數也不建議使用，使用原生的 ``hash()`` 函數替代。


.. php:function:: strip_image_tags($str)

	:param	string	$str: Input string
	:returns:	The input string with no image tags
	:rtype:	string

	該安全函數從一個字元串中剝除 image 標籤，它將 image 標籤轉為純圖片的 URL 文字。

	舉例::

		$string = strip_image_tags($string);

	它是 ``CI_Security::strip_image_tags()`` 函數的別名，更多資訊，請查閱 :doc:`安全類 <../libraries/security>` 文件。


.. php:function:: encode_php_tags($str)

	:param	string	$str: Input string
	:returns:	Safely formatted string
	:rtype:	string

	該安全函數將 PHP 標籤轉換為實體物件。

	.. note:: 如果您使用函數 :php:func:`xss_clean()` ，會自動轉換。

	舉例::

		$string = encode_php_tags($string);