################
路徑輔助函數
################

路徑輔助函數文件包含了用於處理服務端文件路徑的一些函數。

.. contents::
  :local:

.. raw:: html

  <div class="custom-index container"></div>

載入輔助函數
===================

該輔助函數通過下面的程式碼載入::

	$this->load->helper('path');

可用函數
===================

該輔助函數有下列可用函數：

.. php:function:: set_realpath($path[, $check_existance = FALSE])

	:param	string	$path: Path
	:param	bool	$check_existance: Whether to check if the path actually exists
	:returns:	An absolute path
	:rtype:	string

	該函數傳回指定路徑在服務端的絕對路徑（不是符號路徑或相對路徑），
	可選的第二個參數用於指定當文件路徑不存在時是否報錯。

	Examples::

		$file = '/etc/php5/apache2/php.ini';
		echo set_realpath($file); // Prints '/etc/php5/apache2/php.ini'

		$non_existent_file = '/path/to/non-exist-file.txt';
		echo set_realpath($non_existent_file, TRUE);	// Shows an error, as the path cannot be resolved
		echo set_realpath($non_existent_file, FALSE);	// Prints '/path/to/non-exist-file.txt'

		$directory = '/etc/php5';
		echo set_realpath($directory);	// Prints '/etc/php5/'

		$non_existent_directory = '/path/to/nowhere';
		echo set_realpath($non_existent_directory, TRUE);	// Shows an error, as the path cannot be resolved
		echo set_realpath($non_existent_directory, FALSE);	// Prints '/path/to/nowhere'