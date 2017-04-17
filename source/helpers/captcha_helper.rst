##############
驗證碼輔助函數
##############

驗證碼輔助函數文件包含了一些幫助您建立驗證碼圖片的函數。

.. contents::
  :local:

.. raw:: html

  <div class="custom-index container"></div>

載入輔助函數
===================

該輔助函數通過下面的程式碼載入::

	$this->load->helper('captcha');

使用驗證碼輔助函數
========================

輔助函數載入之後您可以像下面這樣產生一個驗證碼圖片::

	$vals = array(
		'word'		=> 'Random word',
		'img_path'	=> './captcha/',
		'img_url'	=> 'http://example.com/captcha/',
		'font_path'	=> './path/to/fonts/texb.ttf',
		'img_width'	=> '150',
		'img_height'	=> 30,
		'expiration'	=> 7200,
		'word_length'	=> 8,
		'font_size'	=> 16,
		'img_id'	=> 'Imageid',
		'pool'		=> '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ',

		// White background and border, black text and red grid
		'colors'	=> array(
			'background' => array(255, 255, 255),
			'border' => array(255, 255, 255),
			'text' => array(0, 0, 0),
			'grid' => array(255, 40, 40)
		)
	);

	$cap = create_captcha($vals);
	echo $cap['image'];

-  驗證碼輔助函數需要使用 GD 圖像庫。
-  只有 **img_path** 和 **img_url** 這兩個參數是必須的。
-  如果沒有提供 **word** 參數，該函數將產生一個隨機的 ASCII 字元串。
   您也可以使用自己的詞庫，從裡面隨機挑選。
-  如果您不設定 TRUE TYPE 字體（譯者註：是主要的三種計算機矢量字體之一）的路徑，將使用 GD 預設的字體。
-  "captcha" 資料夾必須是可寫的。
-  **expiration** 參數表示驗證碼圖片在刪除之前將保留多久（單位為秒），預設保留 2 小時。
-  **word_length** 預設值為 8， **pool** 預設值為 '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'
-  **font_size** 預設值為 16，GD 庫的字體對大小有限制，如果字體大小需要更大一點的話可以設定一種 TRUE TYPE 字體。
-  **img_id** 將會設定為驗證碼圖片的 "id" 。
-  **colors** 陣列中如果有某個顏色未設定，將使用預設顏色。

加入到資料庫
-----------------

使用驗證碼函數是為了防止用戶胡亂送出，要做到這一點，您需要將 ``create_captcha()`` 函數傳回的資訊儲存到資料庫中。
然後，等用戶送出表單資料時，通過資料庫中儲存的資料進行驗證，並確保它沒有過期。

這裡是資料表的一個範例::

	CREATE TABLE captcha (  
		captcha_id bigint(13) unsigned NOT NULL auto_increment,  
		captcha_time int(10) unsigned NOT NULL,  
		ip_address varchar(45) NOT NULL,  
		word varchar(20) NOT NULL,  
		PRIMARY KEY `captcha_id` (`captcha_id`),  
		KEY `word` (`word`)
	);

這裡是使用資料庫的範例。在顯示驗證碼的那個頁面，您的程式碼類似於下面這樣::

	$this->load->helper('captcha');
	$vals = array(     
		'img_path'	=> './captcha/',     
		'img_url'	=> 'http://example.com/captcha/'     
	);

	$cap = create_captcha($vals);
	$data = array(     
		'captcha_time'	=> $cap['time'],     
		'ip_address'	=> $this->input->ip_address(),     
		'word'		=> $cap['word']     
	);

	$query = $this->db->insert_string('captcha', $data);
	$this->db->query($query);

	echo 'Submit the word you see below:';
	echo $cap['image'];
	echo '<input type="text" name="captcha" value="" />';

然後在處理用戶送出的頁面，處理如下::

	// First, delete old captchas
	$expiration = time() - 7200; // Two hour limit
	$this->db->where('captcha_time < ', $expiration)
		->delete('captcha');

	// Then see if a captcha exists:
	$sql = 'SELECT COUNT(*) AS count FROM captcha WHERE word = ? AND ip_address = ? AND captcha_time > ?';
	$binds = array($_POST['captcha'], $this->input->ip_address(), $expiration);
	$query = $this->db->query($sql, $binds);
	$row = $query->row();

	if ($row->count == 0)
	{     
		echo 'You must submit the word that appears in the image.';
	}

可用函數
===================

該輔助函數有下列可用函數：

.. php:function:: create_captcha([$data = ''[, $img_path = ''[, $img_url = ''[, $font_path = '']]]])

	:param	array	$data: Array of data for the CAPTCHA
	:param	string	$img_path: Path to create the image in
	:param	string	$img_url: URL to the CAPTCHA image folder
	:param	string	$font_path: Server path to font
	:returns:	array('word' => $word, 'time' => $now, 'image' => $img)
	:rtype:	array

	依據您提供的一系列參數產生一張驗證碼圖片，傳回包含此圖片資訊的陣列。

	::

		array(
			'image'	=> IMAGE TAG
			'time'	=> TIMESTAMP (in microtime)
			'word'	=> CAPTCHA WORD
		)

	**image** 就是一個 image 標籤::

		<img src="http://example.com/captcha/12345.jpg" width="140" height="50" />

	**time** 是一個毫秒級的時間戳，作為圖片的文件名（不帶擴展名）。就像這樣：1139612155.3422

	**word** 是驗證碼圖片中的文字，如果在函數的參數中沒有指定 word 參數，這將是一個隨機字元串。