##################
Zip 編碼類
##################

CodeIgniter 的 Zip 編碼類允許您建立 Zip 壓縮文件，文件可以被下載到您的桌面
或者 儲存到某個文件夾裡。

.. contents::
  :local:

.. raw:: html

  <div class="custom-index container"></div>

****************************
使用 Zip 編碼類
****************************

初始化類
======================

正如 CodeIgniter 中的其他類一樣，在您的控制器中使用 ``$this->load->library()``
成員函數來初始化 Zip 編碼類::

	$this->load->library('zip');

初始化之後，Zip 編碼類的物件就可以這樣存取::

	$this->zip

使用範例
=============

下面這個範例演示了如何壓縮一個文件，將其儲存到伺服器上的一個資料夾下，並下載到您的桌面上。

::

	$name = 'mydata1.txt';
	$data = 'A Data String!';

	$this->zip->add_data($name, $data);

	// Write the zip file to a folder on your server. Name it "my_backup.zip"
	$this->zip->archive('/path/to/directory/my_backup.zip');

	// Download the file to your desktop. Name it "my_backup.zip"
	$this->zip->download('my_backup.zip');

***************
類參考
***************

.. php:class:: CI_Zip

	.. attribute:: $compression_level = 2

		使用的壓縮等級。

		壓縮等級的範圍為 0 到 9 ，9 為最高等級，0 為停用壓縮::

			$this->zip->compression_level = 0;

	.. php:method:: add_data($filepath[, $data = NULL])

		:param	mixed	$filepath: A single file path or an array of file => data pairs
		:param	array	$data: File contents (ignored if $filepath is an array)
		:rtype:	void

		向 Zip 文件中加入資料，可以加入單個文件，也可以加入多個文件。

		當加入單個文件時，第一個參數為文件名，第二個參數包含文件的內容::

			$name = 'mydata1.txt';
			$data = 'A Data String!';
			$this->zip->add_data($name, $data);

			$name = 'mydata2.txt';
			$data = 'Another Data String!';
			$this->zip->add_data($name, $data);

		當加入多個文件時，第一個參數為包含 *file => contents* 這樣的鍵值對的陣列，第二個參數被忽略::

			$data = array(
				'mydata1.txt' => 'A Data String!',
				'mydata2.txt' => 'Another Data String!'
			);

			$this->zip->add_data($data);

		如果您想要將您壓縮的資料組織到一個子資料夾下，只需簡單的將文件路徑包含到文件名中即可::

			$name = 'personal/my_bio.txt';
			$data = 'I was born in an elevator...';

			$this->zip->add_data($name, $data);

		上面的範例將會把 my_bio.txt 文件放到 personal 資料夾下。

	.. php:method:: add_dir($directory)

		:param	mixed	$directory: Directory name string or an array of multiple directories
		:rtype:	void

		允許您往壓縮文件中加入一個資料夾，通常這個成員函數是沒必要的，因為您完全可以使用 ``$this->zip->add_data()``
		成員函數將您的資料加入到特定的資料夾下。但是如果您想建立一個空資料夾，您可以使用它::

			$this->zip->add_dir('myfolder'); // Creates a directory called "myfolder"

	.. php:method:: read_file($path[, $archive_filepath = FALSE])

		:param	string	$path: Path to file
		:param	mixed	$archive_filepath: New file name/path (string) or (boolean) whether to maintain the original filepath
		:returns:	TRUE on success, FALSE on failure
		:rtype:	bool

		允許您壓縮一個已經存在於您的伺服器上的文件。該成員函數的參數為一個文件路徑，Zip 
		類會讀取該文件的內容並加入到壓縮文件中::

			$path = '/path/to/photo.jpg';

			$this->zip->read_file($path);

			// Download the file to your desktop. Name it "my_backup.zip"
			$this->zip->download('my_backup.zip');

		如果您希望 Zip 文件中的文件保持它原有的資料夾結構，將第二個參數設定為布林值 TRUE 。例如::

			$path = '/path/to/photo.jpg';

			$this->zip->read_file($path, TRUE);

			// Download the file to your desktop. Name it "my_backup.zip"
			$this->zip->download('my_backup.zip');

		在上面的範例中，photo.jpg 文件將會被放在 *path/to/* 資料夾下。

		您也可以為新加入的文件指定一個新的名稱（包含文件路徑）::

			$path = '/path/to/photo.jpg';
			$new_path = '/new/path/some_photo.jpg';

			$this->zip->read_file($path, $new_path);

			// Download ZIP archive containing /new/path/some_photo.jpg
			$this->zip->download('my_archive.zip');

	.. php:method:: read_dir($path[, $preserve_filepath = TRUE[, $root_path = NULL]])

		:param	string	$path: Path to directory
		:param	bool	$preserve_filepath: Whether to maintain the original path
		:param	string	$root_path: Part of the path to exclude from the archive directory
		:returns:	TRUE on success, FALSE on failure
		:rtype:	bool

		允許您壓縮一個已經存在於您的伺服器上的資料夾（包括裡面的內容）。該成員函數的參數為資料夾的路徑，Zip
		類會遞歸的讀取它裡面的內容並重建成一個 Zip 文件。指定資料夾下的所有文件以及子資料夾下的文件都會被壓縮。
		例如::

			$path = '/path/to/your/directory/';

			$this->zip->read_dir($path);

			// Download the file to your desktop. Name it "my_backup.zip"
			$this->zip->download('my_backup.zip');

		預設情況下，Zip 文件中會保留第一個參數中指定的資料夾結構，如果您希望忽略掉這一大串的樹形資料夾結構，
		您可以將第二個參數設定為布林值 FALSE 。例如::

			$path = '/path/to/your/directory/';

			$this->zip->read_dir($path, FALSE);

		上面的程式碼將會建立一個 Zip 文件，文件裡面直接是 "directory" 資料夾，然後是它下面的所有的子資料夾，
		不會包含 */path/to/your* 路徑在裡面。

	.. php:method:: archive($filepath)

		:param	string	$filepath: Path to target zip archive
		:returns:	TRUE on success, FALSE on failure
		:rtype:	bool

		向您的伺服器指定資料夾下寫入一個 Zip 編碼文件，該成員函數的參數為一個有效的資料夾路徑，後加一個文件名，
		確保這個資料夾是可寫的（權限為 755 通常就可以了）。例如::

			$this->zip->archive('/path/to/folder/myarchive.zip'); // Creates a file named myarchive.zip

	.. php:method:: download($filename = 'backup.zip')

		:param	string	$filename: Archive file name
		:rtype:	void

		從您的伺服器上下載 Zip 文件，您需要指定 Zip 文件的名稱。例如::

			$this->zip->download('latest_stuff.zip'); // File will be named "latest_stuff.zip"

		.. note:: 在呼叫這個成員函數的控制器裡不要顯示任何資料，因為這個成員函數會發送多個伺服器 HTTP 頭，
			讓文件以二進制的格式被下載。

	.. php:method:: get_zip()

		:returns:	Zip file content
		:rtype:	string

		傳回使用 Zip 編碼壓縮後的文件資料，通常情況您無需使用該成員函數，除非您要對壓縮後的資料做些特別的操作。
		例如::

			$name = 'my_bio.txt';
			$data = 'I was born in an elevator...';

			$this->zip->add_data($name, $data);

			$zip_file = $this->zip->get_zip();

	.. php:method:: clear_data()

		:rtype:	void

		Zip 類會快取壓縮後的資料，這樣就不用在呼叫每個成員函數的時候重新壓縮一遍了。但是，如果您需要建立多個 Zip
		文件，每個 Zip 文件有著不同的資料，那麼您可以在多次呼叫之間把快取清除掉。例如::

			$name = 'my_bio.txt';
			$data = 'I was born in an elevator...';

			$this->zip->add_data($name, $data);
			$zip_file = $this->zip->get_zip();

			$this->zip->clear_data();

			$name = 'photo.jpg';
			$this->zip->read_file("/path/to/photo.jpg"); // Read the file's contents

			$this->zip->download('myphotos.zip');
