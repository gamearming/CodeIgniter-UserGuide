#############
數字輔助函數
#############

數字輔助函數文件包含了用於處理數字的一些函數。

.. contents::
  :local:

.. raw:: html

  <div class="custom-index container"></div>

載入輔助函數
===================

該輔助函數通過下面的程式碼載入::

	$this->load->helper('number');

可用函數
===================

該輔助函數有下列可用函數：

.. php:function:: byte_format($num[, $precision = 1])

	:param	mixed	$num: Number of bytes
	:param	int	$precision: Floating point precision
	:returns:	Formatted data size string
	:rtype:	string

	依據數值大小以字節的形式格式化，並加入適合的縮寫單位。
	例如::

		echo byte_format(456); // Returns 456 Bytes
		echo byte_format(4567); // Returns 4.5 KB
		echo byte_format(45678); // Returns 44.6 KB
		echo byte_format(456789); // Returns 447.8 KB
		echo byte_format(3456789); // Returns 3.3 MB
		echo byte_format(12345678912345); // Returns 1.8 GB
		echo byte_format(123456789123456789); // Returns 11,228.3 TB

	可選的第二個參數允許您設定結果的精度::

		 echo byte_format(45678, 2); // Returns 44.61 KB

	.. note:: 這個函數產生的縮寫單位可以在 *language/<your_lang>/number_lang.php* 語言文件中找到。