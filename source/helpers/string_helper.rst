###################
字元串輔助函數
###################

字元串輔助函數文件包含了一些幫助您處理字元串的函數。

.. important:: Please note that these functions are NOT intended, nor
	suitable to be used for any kind of security-related logic.

.. contents::
  :local:

.. raw:: html

  <div class="custom-index container"></div>

載入輔助函數
===================

該輔助函數通過下面的程式碼載入::

	$this->load->helper('string');

可用函數
===================

該輔助函數有下列可用函數：

.. php:function:: random_string([$type = 'alnum'[, $len = 8]])

	:param	string	$type: Randomization type
	:param	int	$len: Output string length
	:returns:	A random string
	:rtype:	string

	依據您所指定的類型和長度產生一個隨機字元串。可用於產生密碼或隨機字元串。

	第一個參數指定字元串類型，第二個參數指定其長度。有下列幾種字元串類型可供選擇：

	-  **alpha**: 只含有大小寫字母的字元串
	-  **alnum**: 含有大小寫字母以及數字的字元串
	-  **basic**: 依據 ``mt_rand()`` 函數產生的一個隨機數字
	-  **numeric**: 數字字元串
	-  **nozero**: 數字字元串（不含零）
	-  **md5**: 依據 ``md5()`` 產生的一個加密的隨機數字（長度固定為 32）
	-  **sha1**: 依據 ``sha1()`` 產生的一個加密的隨機數字（長度固定為 40）

	使用範例::

		echo random_string('alnum', 16);

	.. note:: *unique* 和 *encrypt* 類型已經廢棄，它們只是 *md5* 和 *sha1* 的別名。

.. php:function:: increment_string($str[, $separator = '_'[, $first = 1]])

	:param	string	$str: Input string
	:param	string	$separator: Separator to append a duplicate number with
	:param	int	$first: Starting number
	:returns:	An incremented string
	:rtype:	string

	自增字元串是指向字元串尾部加入一個數字，或者對這個數字進行自增。
	這在產生文件的拷貝時非常有用，或者向資料庫中某列（例如 title 或 slug）加入重複的內容，
	但是這一列設定了唯一索引時。

	使用範例::

		echo increment_string('file', '_'); // "file_1"
		echo increment_string('file', '-', 2); // "file-2"
		echo increment_string('file_4'); // "file_5"


.. php:function:: alternator($args)

	:param	mixed	$args: A variable number of arguments
	:returns:	Alternated string(s)
	:rtype:	mixed

	當執行一個循環時，讓兩個或兩個以上的條目輪流使用。範例::

		for ($i = 0; $i < 10; $i++)
		{     
			echo alternator('string one', 'string two');
		}

	您可以加入任意多個參數，每一次循環後下一個條目將成為傳回值。

	::

		for ($i = 0; $i < 10; $i++)
		{     
			echo alternator('one', 'two', 'three', 'four', 'five');
		}

	.. note:: 如果要多次呼叫該函數，可以簡單的通過不帶參數重新初始化下。

.. php:function:: repeater($data[, $num = 1])

	:param	string	$data: Input
	:param	int	$num: Number of times to repeat
	:returns:	Repeated string
	:rtype:	string

	重複產生您的資料。例如::

		$string = "\n";
		echo repeater($string, 30);

	上面的程式碼會產生 30 個空行。

	.. note:: 該函數已經廢棄，使用原生的 ``str_repeat()`` 函數替代。


.. php:function:: reduce_double_slashes($str)

	:param	string	$str: Input string
	:returns:	A string with normalized slashes
	:rtype:	string

	將字元串中的雙斜線（'//'）轉換為單斜線（'/'），但不轉換 URL 協議中的雙斜線（例如：http://）

	範例::

		$string = "http://example.com//index.php";
		echo reduce_double_slashes($string); // results in "http://example.com/index.php"


.. php:function:: strip_slashes($data)

	:param	mixed	$data: Input string or an array of strings
	:returns:	String(s) with stripped slashes
	:rtype:	mixed

	移除一個字元串陣列中的所有斜線。

	範例::

		$str = array(
			'question'  => 'Is your name O\'reilly?',
			'answer' => 'No, my name is O\'connor.'
		);

		$str = strip_slashes($str);

	上面的程式碼將傳回下面的陣列::

		array(
			'question'  => "Is your name O'reilly?",
			'answer' => "No, my name is O'connor."
		);

	.. note:: 由於歷史原因，該函數也接受一個字元串參數，這時該函數就相當於 ``stripslashes()`` 的別名。

.. php:function:: trim_slashes($str)

	:param	string	$str: Input string
	:returns:	Slash-trimmed string
	:rtype:	string

	移除字元串開頭和結尾的所有斜線。例如::

		$string = "/this/that/theother/";
		echo trim_slashes($string); // results in this/that/theother

	.. note:: 該函數已廢棄，使用原生的 ``trim()`` 函數代替：
		|
		| trim($str, '/');

.. php:function:: reduce_multiples($str[, $character = ''[, $trim = FALSE]])

	:param	string	$str: Text to search in
	:param	string	$character: Character to reduce
	:param	bool	$trim: Whether to also trim the specified character
	:returns:	Reduced string
	:rtype:	string

	移除字元串中重複出現的某個指定字元。例如::

		$string = "Fred, Bill,, Joe, Jimmy";
		$string = reduce_multiples($string,","); //results in "Fred, Bill, Joe, Jimmy"

	如果設定第三個參數為 TRUE ，該函數將移除出現在字元串首尾的指定字元。例如::

		$string = ",Fred, Bill,, Joe, Jimmy,";
		$string = reduce_multiples($string, ", ", TRUE); //results in "Fred, Bill, Joe, Jimmy"

.. php:function:: quotes_to_entities($str)

	:param	string	$str: Input string
	:returns:	String with quotes converted to HTML entities
	:rtype:	string

	將字元串中的單引號和雙引號轉換為相應的 HTML 實體。例如::

		$string = "Joe's \"dinner\"";
		$string = quotes_to_entities($string); //results in "Joe&#39;s &quot;dinner&quot;"


.. php:function:: strip_quotes($str)

	:param	string	$str: Input string
	:returns:	String with quotes stripped
	:rtype:	string

	移除字元串中出現的單引號和雙引號。例如::

		$string = "Joe's \"dinner\"";
		$string = strip_quotes($string); //results in "Joes dinner"