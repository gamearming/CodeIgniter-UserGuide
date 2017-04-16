################
目錄輔助函數
################

目錄輔助函數文件包含了一些幫助您處理目錄的函數。

.. contents::
  :local:

.. raw:: html

  <div class="custom-index container"></div>

載入輔助函數
===================

該輔助函數通過下面的程式碼載入::

	$this->load->helper('directory');

可用函數
===================

該輔助函數有下列可用函數：

.. php:function:: directory_map($source_dir[, $directory_depth = 0[, $hidden = FALSE]])

	:param	string	$source_dir: Path to the source directory
	:param	int	$directory_depth: Depth of directories to traverse (0 = fully recursive, 1 = current dir, etc)
	:param	bool	$hidden: Whether to include hidden directories
	:returns:	An array of files
	:rtype:	array

	舉例::

		$map = directory_map('./mydirectory/');

	.. note:: 路徑總是相對於您的 index.php 文件。

	如果目錄內含有子目錄，也將被列出。您可以使用第二個參數（整數）
	來控制遞歸的深度。如果深度為 1，則只列出根目錄::

		$map = directory_map('./mydirectory/', 1);

	預設情況下，傳回的陣列中不會包括那些隱藏文件。如果需要顯示隱藏的文件，
	您可以設定第三個參數為 true ::

		$map = directory_map('./mydirectory/', FALSE, TRUE);

	每一個目錄的名字都將作為陣列的索引，目錄所包含的文件將以數字作為索引。
	下面有個典型的陣列範例::

		Array (
			[libraries] => Array
				(
					[0] => benchmark.html
					[1] => config.html
					["database/"] => Array
						(
							[0] => query_builder.html
							[1] => binds.html
							[2] => configuration.html
							[3] => connecting.html
							[4] => examples.html
							[5] => fields.html
							[6] => index.html
							[7] => queries.html
						)
					[2] => email.html
					[3] => file_uploading.html
					[4] => image_lib.html
					[5] => input.html
					[6] => language.html
					[7] => loader.html
					[8] => pagination.html
					[9] => uri.html
				)