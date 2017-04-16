############
XML 輔助函數
############

XML 輔助函數文件包含了用於處理 XML 資料的一些函數。

.. contents::
  :local:

.. raw:: html

  <div class="custom-index container"></div>

載入輔助函數
===================

該輔助函數通過下面的程式碼載入::

	$this->load->helper('xml');

可用函數
===================

該輔助函數有下列可用函數：

.. php:function:: xml_convert($str[, $protect_all = FALSE])

	:param string $str: the text string to convert
	:param bool $protect_all: Whether to protect all content that looks like a potential entity instead of just numbered entities, e.g. &foo;
	:returns: XML-converted string
	:rtype:	string

	將輸入字元串中的下列 XML 保留字元轉換為實體（Entity）：

	  - 和號：&
	  - 小於號和大於號：< >
	  - 單引號和雙引號：' "
	  - 減號：-

	如果 & 符號是作為實體編號的一部分，例如： ``&#123;`` ，該函數將不予處理。
	舉例::

		$string = '<p>Here is a paragraph & an entity (&#123;).</p>';
		$string = xml_convert($string);
		echo $string;

	輸出結果:

	.. code-block:: html

		&lt;p&gt;Here is a paragraph &amp; an entity (&#123;).&lt;/p&gt;