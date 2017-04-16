#########
FTP 類
#########

CodeIgniter 的 FTP 類允許您傳輸文件至遠程伺服器，也可以對遠程文件進行移動、重命名或刪除操作。
FTP 類還提供了一個 "鏡像" 功能，允許您將您本地的一個目錄通過 FTP 整個的同步到遠程伺服器上。

.. note:: 只支援標準的 FTP 協議，不支援 SFTP 和 SSL FTP 。

.. contents::
  :local:

.. raw:: html

  <div class="custom-index container"></div>

**************************
使用 FTP 類
**************************

初始化類
======================

正如 CodeIgniter 中的其他類一樣，在您的控制器中使用 ``$this->load->library()``
成員函數來初始化 FTP 類::

	$this->load->library('ftp');

初始化之後，FTP 類的物件就可以這樣存取::

	$this->ftp

使用範例
==============

在這個範例中，首先建立一個到 FTP 伺服器的連接，接著讀取一個本地文件然後以 ASCII 
模式上傳到伺服器上。文件的權限被設定為 755 。
::

	$this->load->library('ftp');

	$config['hostname'] = 'ftp.example.com';
	$config['username'] = 'your-username';
	$config['password'] = 'your-password';
	$config['debug']	= TRUE;

	$this->ftp->connect($config);

	$this->ftp->upload('/local/path/to/myfile.html', '/public_html/myfile.html', 'ascii', 0775);

	$this->ftp->close();

下面的範例從 FTP 伺服器上讀取文件清單。
::

	$this->load->library('ftp');

	$config['hostname'] = 'ftp.example.com';
	$config['username'] = 'your-username';
	$config['password'] = 'your-password';
	$config['debug']	= TRUE;

	$this->ftp->connect($config);

	$list = $this->ftp->list_files('/public_html/');

	print_r($list);

	$this->ftp->close();

下面的範例在 FTP 伺服器上建立了一個本地目錄的鏡像。
::

	$this->load->library('ftp');

	$config['hostname'] = 'ftp.example.com';
	$config['username'] = 'your-username';
	$config['password'] = 'your-password';
	$config['debug']	= TRUE;

	$this->ftp->connect($config);

	$this->ftp->mirror('/path/to/myfolder/', '/public_html/myfolder/');

	$this->ftp->close();

***************
類參考
***************

.. php:class:: CI_FTP

	.. php:method:: connect([$config = array()])

		:param	array	$config: Connection values
		:returns:	TRUE on success, FALSE on failure
		:rtype:	bool

		連接並登入到 FTP 伺服器，通過向函數傳遞一個陣列來設定連接參數，或者您可以把這些參數儲存在一個設定文件中。

		下面範例演示了如何手動設定參數::

			$this->load->library('ftp');

			$config['hostname'] = 'ftp.example.com';
			$config['username'] = 'your-username';
			$config['password'] = 'your-password';
			$config['port']     = 21;
			$config['passive']  = FALSE;
			$config['debug']    = TRUE;

			$this->ftp->connect($config);

		**在設定文件中設定 FTP 參數**

		如果您喜歡，您可以把 FTP 參數儲存在一個設定文件中，只需建立一個名為 ftp.php 的文件，
		然後把 $config 陣列加入到該文件中，然後將文件儲存到 *application/config/ftp.php* ，
		它就會自動被讀取。

		**可用的連接選項**

		============== =============== =============================================================================
		選項名稱        預設值           描述
		============== =============== =============================================================================
		**hostname**   n/a             FTP 主機名（通常類似於這樣：ftp.example.com）
		**username**   n/a             FTP 用戶名
		**password**   n/a             FTP 密碼
		**port**       21              FTP 服務端口
		**debug**      FALSE           TRUE/FALSE (boolean): 是否開啟調試模式，顯示錯誤資訊
		**passive**    TRUE            TRUE/FALSE (boolean): 是否使用被動模式
		============== =============== =============================================================================

	.. php:method:: upload($locpath, $rempath[, $mode = 'auto'[, $permissions = NULL]])

		:param	string	$locpath: Local file path
		:param	string	$rempath: Remote file path
		:param	string	$mode: FTP mode, defaults to 'auto' (options are: 'auto', 'binary', 'ascii')
		:param	int	$permissions: File permissions (octal)
		:returns:	TRUE on success, FALSE on failure
		:rtype:	bool

		將一個文件上傳到您的伺服器上。必須指定本地路徑和遠程路徑這兩個參數，而傳輸模式和權限設定這兩個參數則是可選的。例如:

			$this->ftp->upload('/local/path/to/myfile.html', '/public_html/myfile.html', 'ascii', 0775);

		如果使用了 auto 模式，將依據源文件的擴展名來自動選擇傳輸模式。

		設定權限必須使用一個 八進制 的權限值。

	.. php:method:: download($rempath, $locpath[, $mode = 'auto'])

		:param	string	$rempath: Remote file path
		:param	string	$locpath: Local file path
		:param	string	$mode: FTP mode, defaults to 'auto' (options are: 'auto', 'binary', 'ascii')
		:returns:	TRUE on success, FALSE on failure
		:rtype:	bool

		從您的伺服器下載一個文件。必須指定遠程路徑和本地路徑，傳輸模式是可選的。例如：

			$this->ftp->download('/public_html/myfile.html', '/local/path/to/myfile.html', 'ascii');

		如果使用了 auto 模式，將依據源文件的擴展名來自動選擇傳輸模式。

		如果下載失敗（包括 PHP 沒有寫入本地文件的權限）函數將傳回 FALSE 。

	.. php:method:: rename($old_file, $new_file[, $move = FALSE])

		:param	string	$old_file: Old file name
		:param	string	$new_file: New file name
		:param	bool	$move: Whether a move is being performed
		:returns:	TRUE on success, FALSE on failure
		:rtype:	bool

		允許您重命名一個文件。需要指定原文件的文件路徑和名稱，以及新的文件路徑和名稱。
		::

			// Renames green.html to blue.html
			$this->ftp->rename('/public_html/foo/green.html', '/public_html/foo/blue.html');

	.. php:method:: move($old_file, $new_file)

		:param	string	$old_file: Old file name
		:param	string	$new_file: New file name
		:returns:	TRUE on success, FALSE on failure
		:rtype:	bool

		允許您移動一個文件。需要指定原路徑和目的路徑::

			// Moves blog.html from "joe" to "fred"
			$this->ftp->move('/public_html/joe/blog.html', '/public_html/fred/blog.html');

		.. note:: 如果目的文件名和原文件名不同，文件將會被重命名。

	.. php:method:: delete_file($filepath)

		:param	string	$filepath: Path to file to delete
		:returns:	TRUE on success, FALSE on failure
		:rtype:	bool

		用於刪除一個文件。需要提供原文件的路徑。
		::

			 $this->ftp->delete_file('/public_html/joe/blog.html');

	.. php:method:: delete_dir($filepath)

		:param	string	$filepath: Path to directory to delete
		:returns:	TRUE on success, FALSE on failure
		:rtype:	bool

		用於刪除一個目錄以及該目錄下的所有文件。需要提供目錄的路徑（以斜線結尾）。

		.. important:: 使用該成員函數要非常小心！
			它會遞歸的刪除目錄下的所有內容，包括子目錄和所有文件。請確保您提供的路徑是正確的。
			您可以先使用 ``list_files()`` 成員函數來驗證下路徑是否正確。

		::

			 $this->ftp->delete_dir('/public_html/path/to/folder/');

	.. php:method:: list_files([$path = '.'])

		:param	string	$path: Directory path
		:returns:	An array list of files or FALSE on failure
		:rtype:	array

		用於讀取伺服器上某個目錄的文件清單，您需要指定目錄路徑。
		::

			$list = $this->ftp->list_files('/public_html/');
			print_r($list);

	.. php:method:: mirror($locpath, $rempath)

		:param	string	$locpath: Local path
		:param	string	$rempath: Remote path
		:returns:	TRUE on success, FALSE on failure
		:rtype:	bool

		遞歸的讀取文字的一個目錄和它下面的所有內容（包括子目錄），然後通過 FTP 在遠程伺服器上建立一個鏡像。
		無論原文件的路徑和目錄結構是什麼樣的，都會在遠程伺服器上一模一樣的重建。您需要指定一個原路徑和目的路徑::

			 $this->ftp->mirror('/path/to/myfolder/', '/public_html/myfolder/');

	.. php:method:: mkdir($path[, $permissions = NULL])

		:param	string	$path: Path to directory to create
		:param	int	$permissions: Permissions (octal)
		:returns:	TRUE on success, FALSE on failure
		:rtype:	bool

		用於在伺服器上建立一個目錄。需要指定目錄的路徑並以斜線結尾。

		還可以通過第二個參數傳遞一個 八進制的值 設定權限。
		::

			// Creates a folder named "bar"
			$this->ftp->mkdir('/public_html/foo/bar/', 0755);

	.. php:method:: chmod($path, $perm)

		:param	string	$path: Path to alter permissions for
		:param	int	$perm: Permissions (octal)
		:returns:	TRUE on success, FALSE on failure
		:rtype:	bool

		用於設定文件權限。需要指定您想修改權限的文件或目錄的路徑::

			// Chmod "bar" to 755
			$this->ftp->chmod('/public_html/foo/bar/', 0755);

	.. php:method:: changedir($path[, $suppress_debug = FALSE])

		:param	string	$path: Directory path
		:param	bool	$suppress_debug: Whether to turn off debug messages for this command
		:returns:	TRUE on success, FALSE on failure
		:rtype:	bool

		用於修改目前工作目錄到指定路徑。

		如果您希望使用這個成員函數作為 ``is_dir()`` 的一個替代，``$suppress_debug`` 參數將很有用。

	.. php:method:: close()

		:returns:	TRUE on success, FALSE on failure
		:rtype:	bool

		斷開和伺服器的連接。當您上傳完畢時，建議使用這個函數。
