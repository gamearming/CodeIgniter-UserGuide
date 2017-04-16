#################
文字輔助函數
#################

文字輔助函數文件包含了一些幫助您處理文字的函數。

.. contents::
  :local:

.. raw:: html

  <div class="custom-index container"></div>

載入輔助函數
===================

該輔助函數通過下面的程式碼載入::

	$this->load->helper('text');

可用函數
===================

該輔助函數有下列可用函數：

.. php:function:: word_limiter($str[, $limit = 100[, $end_char = '…']])

	:param	string	$str: Input string
	:param	int	$limit: Limit
	:param	string	$end_char: End character (usually an ellipsis)
	:returns:	Word-limited string
	:rtype:	string

	依據指定的 *單詞* 個數裁剪字元串。例如::

		$string = "Here is a nice text string consisting of eleven words.";
		$string = word_limiter($string, 4);
		// Returns:  Here is a nice

	第三個參數用於給裁剪的字元串設定一個可選的後綴，預設使用省略號。


.. php:function:: character_limiter($str[, $n = 500[, $end_char = '…']])

	:param	string	$str: Input string
	:param	int	$n: Number of characters
	:param	string	$end_char: End character (usually an ellipsis)
	:returns:	Character-limited string
	:rtype:	string

	依據指定的 *字元* 個數裁剪字元串。它會保證單詞的完整性，所以最終產生的
	字元串長度和您指定的長度有可能會有出入。

	例如::

		$string = "Here is a nice text string consisting of eleven words.";
		$string = character_limiter($string, 20);
		// Returns:  Here is a nice text string

	第三個參數用於給裁剪的字元串設定一個可選的後綴，如果沒該參數，預設使用省略號。

	.. note:: 如果您需要將字元串精確的裁剪到指定長度，請參見下面的 :php:func:`ellipsize()` 函數。

.. php:function:: ascii_to_entities($str)

	:param	string	$str: Input string
	:returns:	A string with ASCII values converted to entities
	:rtype:	string

	將 ASCII 字元轉換為字元實體，包括高位 ASCII 和 Microsoft Word 中的特殊字元，
	在 Web 頁面中使用這些字元可能會導致問題。轉換為字元實體後，它們就可以
	不受瀏覽器設定的影響正確的顯示出來，也能可靠的儲存到到資料庫中。本函數相依於
	您的伺服器支援的字元集，所以它可能並不能保證 100% 可靠，但在大多數情況下，
	它都能正確的識別這些特殊字元（例如重音字元）。

	例如::

		$string = ascii_to_entities($string);

.. php:function::entities_to_ascii($str[, $all = TRUE])

	:param	string	$str: Input string
	:param	bool	$all: Whether to convert unsafe entities as well
	:returns:	A string with HTML entities converted to ASCII characters
	:rtype:	string

	該函數和 :php:func:`ascii_to_entities()` 恰恰相反，它將字元實體轉換為 ASCII 字元。

.. php:function:: convert_accented_characters($str)

	:param	string	$str: Input string
	:returns:	A string with accented characters converted
	:rtype:	string

	將高位 ASCII 字元轉換為與之相等的普通 ASCII 字元，當您的 URL 中需要使用
	非英語字元，而您的 URL 又設定了只允許出現普通 ASCII 字元時很有用。

	例如::

		$string = convert_accented_characters($string);

	.. note:: 該函數使用了 `application/config/foreign_chars.php` 設定文件來決定
		將什麼字元轉換為什麼字元。

.. php:function:: word_censor($str, $censored[, $replacement = ''])

	:param	string	$str: Input string
	:param	array	$censored: List of bad words to censor
	:param	string	$replacement: What to replace bad words with
	:returns:	Censored string
	:rtype:	string

	對字元串中出現的敏感詞進行審查。第一個參數為原始字元串，第二個參數
	為一個陣列，包含您要停用的單詞，第三個參數（可選）可以設定將出現
	的敏感詞取代成什麼，如果未設定，預設取代為磅字元：#### 。

	例如::

		$disallowed = array('darn', 'shucks', 'golly', 'phooey');
		$string = word_censor($string, $disallowed, 'Beep!');

.. php:function:: highlight_code($str)

	:param	string	$str: Input string
	:returns:	String with code highlighted via HTML
	:rtype:	string

	對一段程式碼（PHP、HTML 等）進行著色。例如::

		$string = highlight_code($string);

	該函數使用了 PHP 的 ``highlight_string()`` 函數，所以著色的顏色是在 php.ini 文件中設定的。


.. php:function:: highlight_phrase($str, $phrase[, $tag_open = '<mark>'[, $tag_close = '</mark>']])

	:param	string	$str: Input string
	:param	string	$phrase: Phrase to highlight
	:param	string	$tag_open: Opening tag used for the highlight
	:param	string	$tag_close: Closing tag for the highlight
	:returns:	String with a phrase highlighted via HTML
	:rtype:	string

	對字元串內的一個短語進行突出顯示。第一個參數是原始字元串，
	第二個參數是您想要突出顯示的短語。如果要用 HTML 標籤對短語進行標記，
	那麼第三個和第四個參數分別是您想要對短語使用的 HTML 開始和結束標籤。

	例如::

		$string = "Here is a nice text string about nothing in particular.";
		echo highlight_phrase($string, "nice text", '<span style="color:#990000;">', '</span>');

	上面的程式碼將輸出::

		Here is a <span style="color:#990000;">nice text</span> string about nothing in particular.

	.. note:: 該函數預設是使用 ``<strong>`` 標籤，老版本的瀏覽器可能不支援 ``<mark>`` 
		這個 HTML5 新標籤，所以如果您想支援這些老的瀏覽器，推薦您在您的樣式文件
		中加入如下 CSS 程式碼::

			mark {
				background: #ff0;
				color: #000;
			};

.. php:function:: word_wrap($str[, $charlim = 76])

	:param	string	$str: Input string
	:param	int	$charlim: Character limit
	:returns:	Word-wrapped string
	:rtype:	string

	依據指定的 *字元* 數目對文字進行換行操作，並且保持單詞的完整性。

	例如::

		$string = "Here is a simple string of text that will help us demonstrate this function.";
		echo word_wrap($string, 25);

		// Would produce:  
		// Here is a simple string
		// of text that will help us
		// demonstrate this
		// function.

.. php:function:: ellipsize($str, $max_length[, $position = 1[, $ellipsis = '&hellip;']])

	:param	string	$str: Input string
	:param	int	$max_length: String length limit
	:param	mixed	$position: Position to split at (int or float)
	:param	string	$ellipsis: What to use as the ellipsis character
	:returns:	Ellipsized string
	:rtype:	string

	該函數移除字元串中出現的標籤，並依據指定的長度裁剪字元串，並插入省略號。

	第一個參數是要處理的字元串，第二個參數為最終處理完後的字元串長度，
	第三個參數為插入省略號的位置，值為 0-1 表示從左到右。例如設定為 1
	省略號將插入到字元串的右側，0.5 將插入到中間，0 將插入到左側。

	第四個參數是可選的，表示省略號的類型，預設是 &hellip; 。

	例如::

		$str = 'this_string_is_entirely_too_long_and_might_break_my_design.jpg';
		echo ellipsize($str, 32, .5);

	輸出結果::

		this_string_is_e&hellip;ak_my_design.jpg