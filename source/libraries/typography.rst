################
排版類
################

排版類提供了一些成員函數用於幫助您格式化文字。

.. contents::
  :local:

.. raw:: html

  <div class="custom-index container"></div>

**************************
使用排版類
**************************

初始化該類
======================

跟 CodeIgniter 中的其他類一樣，可以在您的控制器中使用 ``$this->load->library()`` 
成員函數載入排版類::

	$this->load->library('typography');

一旦載入，排版類就可以像下面這樣使用::

	$this->typography

***************
類參考
***************

.. php:class:: CI_Typography

	.. attribute:: $protect_braced_quotes = FALSE

		當排版類和 :doc:`模板解析器類 <parser>` 同時使用時，經常需要保護大括號中的的單引號和雙引號不被轉換。
		要保護這個，將 ``protect_braced_quotes`` 屬性設定為 TRUE 。

		使用範例::

			$this->load->library('typography');
			$this->typography->protect_braced_quotes = TRUE;

	.. method auto_typography($str[, $reduce_linebreaks = FALSE])

		:param	string	$str: Input string
		:param	bool	$reduce_linebreaks: Whether to reduce consequitive linebreaks
		:returns:	HTML typography-safe string
		:rtype:	string

		格式化文字以便糾正語義和印刷錯誤的 HTML 程式碼。按如下規則格式化輸入的字元串：

		 -  將段落使用 <p></p> 包起來（看起來像是用兩個換行字元把段落分隔開似的）。
		 -  除了出現 <pre> 標籤外，所有的單個換行字元被轉換為 <br />。
		 -  塊級元素如 <div> 標籤，不會被段落包住，但是如果他們包含文字的話文字會被段落包住。
		 -  除了出現在標籤中的引號外，引號會被轉換成正確的實體。
		 -  撇號被轉換為相應的實體。
		 -  雙破折號（像 -- 或--）被轉換成 em — 破折號。
		 -  三個連續的點也會被轉換為省略號… 。
		 -  句子後連續的多個空格將被轉換為 &nbsp; 以便在網頁中顯示。

		使用範例::

			$string = $this->typography->auto_typography($string);

		第二個可選參數用於是否將多於兩個連續的換行字元壓縮成兩個，傳入 TRUE 啟用壓縮換行::

			$string = $this->typography->auto_typography($string, TRUE);

		.. note:: 格式排版可能會消耗大量處理器資源，特別是在排版大量內容時。
			如果您選擇使用這個函數的話，您可以考慮使用 `快取 <../general/caching>`。

	.. php:method:: format_characters($str)

		:param	string	$str: Input string
		:returns:	Formatted string
		:rtype:	string

		該成員函數和上面的 ``auto_typography()`` 類似，但是它只對字元進行處理：

		 -  除了出現在標籤中的引號外，引號會被轉換成正確的實體。
		 -  撇號被轉換為相應的實體。
		 -  雙破折號（像 -- 或--）被轉換成 em — 破折號。
		 -  三個連續的點也會被轉換為省略號… 。
		 -  句子後連續的多個空格將被轉換為 &nbsp; 以便在網頁中顯示。

		使用範例::

			$string = $this->typography->format_characters($string);

	.. php:method:: nl2br_except_pre($str)

		:param	string	$str: Input string
		:returns:	Formatted string
		:rtype:	string

		將換行字元轉換為 <br /> 標籤，忽略 <pre> 標籤中的換行字元。除了對 <pre> 
		標籤中的換行處理有所不同之外，這個函數和 PHP 函數 ``nl2br()`` 是完全一樣的。

		使用範例::

			$string = $this->typography->nl2br_except_pre($string);