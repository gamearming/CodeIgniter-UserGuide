################
文件輔助函數
################

文件輔助函數文件包含了一些幫助您處理文件的函數。

.. contents::
  :local:

.. raw:: html

  <div class="custom-index container"></div>

載入輔助函數
===================

該輔助函數通過下面的程式碼載入::

	$this->load->helper('file');

可用函數
===================

該輔助函數有下列可用函數：

.. php:function:: read_file($file)

	:param	string	$file: File path
	:returns:	File contents or FALSE on failure
	:rtype:	string

	傳回指定文件的內容。

	例如::

		$string = read_file('./path/to/file.php');

	可以是相對路徑或絕對路徑，如果失敗傳回 FALSE 。

	.. note:: 路徑是相對於您網站的 index.php 文件的，而不是相對於控制器或檢視文件。
		這是因為 CodeIgniter 使用的前端控制器，所以所有的路徑都是相對於 index.php 所在路徑。

	.. note:: 該函數已廢棄，使用 PHP 的原生函數 ``file_get_contents()`` 代替。

	.. important:: 如果您的伺服器設定了 **open_basedir** 限制，該函數可能無法存取限制之外的文件。

.. php:function:: write_file($path, $data[, $mode = 'wb'])

	:param	string	$path: File path
	:param	string	$data: Data to write to file
	:param	string	$mode: ``fopen()`` mode
	:returns:	TRUE if the write was successful, FALSE in case of an error
	:rtype:	bool

	向指定文件中寫入資料，如果文件不存在，則建立該文件。

	例如::

		$data = 'Some file data';
		if ( ! write_file('./path/to/file.php', $data))
		{     
			echo 'Unable to write the file';
		}
		else
		{     
			echo 'File written!';
		}

	您還可以通過第三個參數設定寫模式::

		write_file('./path/to/file.php', $data, 'r+');

	預設的模式的 'wb' ，請閱讀 `PHP 用戶指南 <http://php.net/manual/en/function.fopen.php>`_ 
	瞭解寫模式的選項。

	.. note: 為了保證該函數成功寫入文件，必須要有寫入該文件的權限。如果文件不存在，
		那麼該文件所處資料夾必須是可寫的。

	.. note:: 路徑是相對於您網站的 index.php 文件的，而不是相對於控制器或檢視文件。
		這是因為 CodeIgniter 使用的前端控制器，所以所有的路徑都是相對於 index.php 所在路徑。

	.. note:: 該函數在寫入文件時會申請一個排他性鎖。

.. php:function:: delete_files($path[, $del_dir = FALSE[, $htdocs = FALSE]])

	:param	string	$path: Directory path
	:param	bool	$del_dir: Whether to also delete directories
	:param	bool	$htdocs: Whether to skip deleting .htaccess and index page files
	:returns:	TRUE on success, FALSE in case of an error
	:rtype:	bool

	刪除指定路徑下的所有文件。

	例如::

		delete_files('./path/to/directory/');

	如果第二個參數設定為 TRUE ，那麼指定路徑下的文件夾也一併刪除。

	例如::

		delete_files('./path/to/directory/', TRUE);

	.. note:: 要被刪除的文件必須是目前系統用戶所有或者是目前用戶對之具有寫權限。

.. php:function:: get_filenames($source_dir[, $include_path = FALSE])

	:param	string	$source_dir: Directory path
	:param	bool	$include_path: Whether to include the path as part of the filenames
	:returns:	An array of file names
	:rtype:	array

	讀取指定資料夾下所有文件名組成的陣列。如果需要完整路徑的文件名，
	可以將第二個參數設定為 TRUE 。

	例如::

		$controllers = get_filenames(APPPATH.'controllers/');

.. php:function:: get_dir_file_info($source_dir, $top_level_only)

	:param	string	$source_dir: Directory path
	:param	bool	$top_level_only: Whether to look only at the specified directory (excluding sub-directories)
	:returns:	An array containing info on the supplied directory's contents
	:rtype:	array

	讀取指定資料夾下所有文件資訊組成的陣列，包括文件名、文件大小、日期 和 權限。
	預設不包含子資料夾下的文件資訊，如有需要，可以設定第二個參數為 FALSE ，這可能會是一個耗時的操作。

	例如::

		$models_info = get_dir_file_info(APPPATH.'models/');

.. php:function:: get_file_info($file[, $returned_values = array('name', 'server_path', 'size', 'date')])

	:param	string	$file: File path
	:param	array	$returned_values: What type of info to return
	:returns:	An array containing info on the specified file or FALSE on failure
	:rtype:	array

	讀取指定文件的資訊，包括文件名、路徑、文件大小，修改日期等。第二個參數可以用於
	聲明只傳回回您想要的資訊。

	第二個參數 ``$returned_values`` 有效的值有：`name`、`size`、`date`、`readable`、`writeable`、
	`executable` 和 `fileperms` 。

.. php:function:: get_mime_by_extension($filename)

	:param	string	$filename: File name
	:returns:	MIME type string or FALSE on failure
	:rtype:	string

	依據 *config/mimes.php* 文件中的設定將文件擴展名轉換為 MIME 類型。
	如果無法判斷 MIME 類型或 MIME 設定文件讀取失敗，則傳回 FALSE 。

	::

		$file = 'somefile.png';
		echo $file.' is has a mime type of '.get_mime_by_extension($file);

	.. note:: 這個函數只是一種簡便的判斷 MIME 類型的成員函數，並不準確，所以
		請不要用於安全相關的地方。

.. php:function:: symbolic_permissions($perms)

	:param	int	$perms: Permissions
	:returns:	Symbolic permissions string
	:rtype:	string

	將文件權限的數字格式（例如 ``fileperms()`` 函數的傳回值）轉換為標準的符號格式。

	::

		echo symbolic_permissions(fileperms('./index.php'));  // -rw-r--r--

.. php:function:: octal_permissions($perms)

	:param	int	$perms: Permissions
	:returns:	Octal permissions string
	:rtype:	string

	將文件權限的數字格式（例如 ``fileperms()`` 函數的傳回值）轉換為三個字元的八進製表示格式。

	::

		echo octal_permissions(fileperms('./index.php')); // 644