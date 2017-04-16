#################
排版輔助函數
#################

排版輔助函數文件包含了文字排版相關的一些函數。

.. contents::
  :local:

.. raw:: html

  <div class="custom-index container"></div>

載入輔助函數
===================

該輔助函數通過下面的程式碼載入::

	$this->load->helper('typography');

可用函數
===================

該輔助函數有下列可用函數：

.. php:function:: auto_typography($str[, $reduce_linebreaks = FALSE])

	:param	string	$str: Input string
	:param	bool	$reduce_linebreaks: Whether to reduce multiple instances of double newlines to two
	:returns:	HTML-formatted typography-safe string
	:rtype: string

	格式化文字以便糾正語義和印刷錯誤的 HTML 程式碼。

	這個函數是 ``CI_Typography::auto_typography()`` 函數的別名。
	更多資訊，查看 :doc:`排版類 <../libraries/typography>` 。

	Usage example::

		$string = auto_typography($string);

	.. note:: 格式排版可能會消耗大量處理器資源，特別是在排版大量內容時。
		如果您選擇使用這個函數的話，您可以考慮使用 :doc:`快取 <../general/caching>`。


.. php:function:: nl2br_except_pre($str)

	:param	string	$str: Input string
	:returns:	String with HTML-formatted line breaks
	:rtype:	string

	將換行字元轉換為 <br /> 標籤，忽略 <pre> 標籤中的換行字元。除了對 <pre>
	標籤中的換行處理有所不同之外，這個函數和 PHP 函數 ``nl2br()`` 是完全一樣的。

	使用範例::

		$string = nl2br_except_pre($string);

.. php:function:: entity_decode($str, $charset = NULL)

	:param	string	$str: Input string
	:param	string	$charset: Character set
	:returns:	String with decoded HTML entities
	:rtype:	string

	這個函數是 ``CI_Security::entity_decode()`` 函數的別名。
	更多資訊，查看 :doc:`安全類 <../libraries/security>` 。
