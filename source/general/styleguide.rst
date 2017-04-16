###############
PHP 開發規範
###############


CodeIgniter 的開發遵循本頁所描述的編碼規範，我們也推薦在您自己的應用程式開發中使用
這些規範，但不做強求。

.. contents:: 目錄

文件格式
===========

文件應該儲存為 Unicode（UTF-8）編碼格式，*不要使用* 字節序標記（BOM），和 UTF-16 和 UTF-32 不一樣，
UTF-8 編碼格式的文件不需要指定字節序。而且 BOM 會在 PHP 的輸出中產生副作用，
它會阻止應用程式設定它的頭資訊。另外，所有的換行字元應該使用 Unix 格式換行字元（LF）。

以下是在一些常見的文字編輯器中更改這些設定的成員函數。針對您的編輯器，成員函數也許會有所不同，
請參考您的編輯器的說明。

TextMate
''''''''

#. 打開應用程式設定
#. 點擊 "高級" ，切換到 "儲存" 標籤頁。
#. 在 "文件編碼" 中，選擇 "UTF-8（推薦）"
#. 在 "換行字元" 中，選擇 "LF（推薦）"
#. *可選*：如果您想對現有文件也能自動作此設定，勾上 "同時應用到已有文件" 選項

BBEdit
''''''

#. 打開應用程式設定
#. 選擇左側的 "文字編碼"
#. 在 "新文件的預設編碼"，選擇 "Unicode (UTF-8, no BOM)"
#. *可選*：在 "如果無法檢測文件編碼，使用..."，選擇 "Unicode (UTF-8, no BOM)"
#. 選擇左側的 "文字文件"
#. 在 "預設的換行字元" 中，選擇 "Mac OS X and Unix (LF)"

PHP 結束標籤
===============

PHP 結束標籤 **?>** 對於 PHP 解析器來說是可選的，但是只要使用了，結束標籤之後的空格
有可能會導致不想要的輸出，這個空格可能是由開發者或者用戶又或者 FTP 應用程式引入的，
甚至可能導致出現 PHP 錯誤，如果設定了不顯示 PHP 錯誤，就會出現空白頁面。基於這個原因，
所有的 PHP 文件將不使用結束標籤，而是以一個空行代替。

文件的命名
===========

類文件的命名必須以大寫字母開頭，其他文件（設定文件，檢視，一般的腳本文件等）的命名是全小寫。

**錯誤的**::

	somelibrary.php
	someLibrary.php
	SOMELIBRARY.php
	Some_Library.php

	Application_config.php
	Application_Config.php
	applicationConfig.php

**正確的**::

	Somelibrary.php
	Some_library.php

	applicationconfig.php
	application_config.php

另外，類文件的名稱必須和類的名稱保持一致，例如，如果您有一個類名為 `Myclass` ，
那麼文件名應該是 **Myclass.php** 。

類和成員函數的命名
=======================

類名必須以大寫字母開頭，多個單詞之間使用下劃線分割，不要使用駝峰命名法。

**錯誤的**::

	class superclass
	class SuperClass

**正確的**::

	class Super_class

::

	class Super_class {

		public function __construct()
		{

		}
	}

類的成員函數應該使用全小寫，並且應該明確指出該成員函數的功能，最好包含一個動詞。
避免使用冗長的名稱，多個單詞之間使用下劃線分割。

**錯誤的**::

	function fileproperties()		// not descriptive and needs underscore separator
	function fileProperties()		// not descriptive and uses CamelCase
	function getfileproperties()		// Better!  But still missing underscore separator
	function getFileProperties()		// uses CamelCase
	function get_the_file_properties_from_the_file()	// wordy

**正確的**::

	function get_file_properties()	// descriptive, underscore separator, and all lowercase letters

變數的命名
==============

變數的命名規則和類成員函數的命名規則非常接近，使用全小寫，使用下劃線分割，
並且應該明確指出該變數的用途。非常短的無意義的變數只應該在 for
循環中作為迭代器使用。

**錯誤的**::

	$j = 'foo';		// single letter variables should only be used in for() loops
	$Str			// contains uppercase letters
	$bufferedText		// uses CamelCasing, and could be shortened without losing semantic meaning
	$groupid		// multiple words, needs underscore separator
	$name_of_last_city_used	// too long

**正確的**::

	for ($j = 0; $j < 10; $j++)
	$str
	$buffer
	$group_id
	$last_city

註釋
==========

通常情況下，應該多寫點註釋，這不僅可以向那些缺乏經驗的程序員描述程式碼的流程和意圖，
而且當您幾個月後再回過頭來看自己的程式碼時仍能幫您很好的理解。
註釋並沒有強制規定的格式，但是我們建議以下的形式。

`DocBlock <http://manual.phpdoc.org/HTMLSmartyConverter/HandS/phpDocumentor/tutorial_phpDocumentor.howto.pkg.html#basics.docblock>`_
風格的註釋，寫在類、成員函數和屬性定義的前面，可以被 IDE 識別::

	/**
	 * Super Class
	 *
	 * @package	Package Name
	 * @subpackage	Subpackage
	 * @category	Category
	 * @author	Author Name
	 * @link	http://example.com
	 */
	class Super_class {

::

	/**
	 * Encodes string for use in XML
	 *
	 * @param	string	$str	Input string
	 * @return	string
	 */
	function xml_encode($str)

::

	/**
	 * Data for class manipulation
	 *
	 * @var	array
	 */
	public $data = array();

單行註釋應該和程式碼合在一起，大塊的註釋和程式碼之間應該留一個空行。

::

	// break up the string by newlines
	$parts = explode("\n", $str);

	// A longer comment that needs to give greater detail on what is
	// occurring and why can use multiple single-line comments.  Try to
	// keep the width reasonable, around 70 characters is the easiest to
	// read.  Don't hesitate to link to permanent external resources
	// that may provide greater detail:
	//
	// http://example.com/information_about_something/in_particular/

	$parts = $this->foo($parts);

常數
=========

常數遵循和變數一樣的命名規則，除了它需要全部大寫。**盡量使用 CodeIgniter 已經定義好的常數，
如：SLASH、LD、RD、PATH_CACHE 等。**

**錯誤的**::

	myConstant	// missing underscore separator and not fully uppercase
	N		// no single-letter constants
	S_C_VER		// not descriptive
	$str = str_replace('{foo}', 'bar', $str);	// should use LD and RD constants

**正確的**::

	MY_CONSTANT
	NEWLINE
	SUPER_CLASS_VERSION
	$str = str_replace(LD.'foo'.RD, 'bar', $str);

TRUE、FALSE 和 NULL
=====================

**TRUE** 、 **FALSE** 和 **NULL** 這幾個關鍵字全部使用大寫。

**錯誤的**::

	if ($foo == true)
	$bar = false;
	function foo($bar = null)

**正確的**::

	if ($foo == TRUE)
	$bar = FALSE;
	function foo($bar = NULL)

邏輯操作符
=================

不要使用 ``||`` 操作符，它在一些設備上看不清（可能看起來像是數字 11），
使用 ``&&`` 操作符比使用 ``AND`` 要好一點，但是兩者都可以接受。
另外，在 ``!`` 操作符的前後都應該加一個空格。

**錯誤的**::

	if ($foo || $bar)
	if ($foo AND $bar)  // okay but not recommended for common syntax highlighting applications
	if (!$foo)
	if (! is_array($foo))

**正確的**::

	if ($foo OR $bar)
	if ($foo && $bar) // recommended
	if ( ! $foo)
	if ( ! is_array($foo))


對傳回值進行比較以及類型轉換
=======================================

有一些 PHP 函數在失敗時傳回 FALSE ，但是也可能會傳回 "" 或 0 這樣的有效值，
這些值在鬆散類型比較時和 FALSE 是相等的。所以當您在條件中使用這些傳回值作比較時，
一定要使用嚴格類型比較，確保傳回值確實是您想要的，而不是鬆散類型的其他值。

在檢查您自己的傳回值和變數時也要遵循這種嚴格的方式，必要時使用 **===** 和 **!==** 。

**錯誤的**::

	// If 'foo' is at the beginning of the string, strpos will return a 0,
	// resulting in this conditional evaluating as TRUE
	if (strpos($str, 'foo') == FALSE)

**正確的**::

	if (strpos($str, 'foo') === FALSE)

**錯誤的**::

	function build_string($str = "")
	{
		if ($str == "")	// uh-oh!  What if FALSE or the integer 0 is passed as an argument?
		{

		}
	}

**正確的**::

	function build_string($str = "")
	{
		if ($str === "")
		{

		}
	}

另外關於 `類型轉換 <http://php.net/manual/en/language.types.type-juggling.php#language.types.typecasting>`_ 的資訊也將很有用。
類型轉換會對變數產生一點輕微的影響，但可能也是期望的。例如 NULL 和 布林值 FALSE 會轉換為空字元串，
數字 0 （和其他數字）將會轉換為數字字元串，布林值 TRUE 會變成 "1"::

	$str = (string) $str; // cast $str as a string

調試程式碼
==============

不要在您的送出中包含調試程式碼，就算是註釋掉了也不行。
像 ``var_dump()`` 、 ``print_r()`` 、 ``die()`` 和 ``exit()`` 這樣的函數，都不應該包含在您的程式碼裡，
除非它們用於除調試之外的其他特殊用途。

文件中的空格
===================

PHP 起始標籤的前面和結束標籤的後面都不要留空格，輸出是被快取的，所以如果您的文件中有空格的話，
這些空格會在 CodeIgniter 輸出它的內容之前被輸出，從而會導致錯誤，而且也會導致 CodeIgniter
無法發送正確的頭資訊。

相容性
=============

CodeIgniter 推薦使用 PHP 5.6 或更新版本，但是它還得同時相容 PHP 5.3.7。
您的程式碼要麼提供適當的回退來相容這點，要麼提供一些可選的功能，當不相容時能安靜的退出而不影響用戶的程序。

另外，不要使用那些需要額外安裝的庫的 PHP 函數，除非您能給出當該函數不存在時，有其他的函數能替代它。

一個類一個文件
==================

除非幾個類是*緊密相關的*，否則每個類應該唯一使用一個文件。
在 CodeIgniter 中一個文件包含多個類的一個範例是 Xmlrpc 類文件。

空格
==========

在程式碼中使用製表符（tab）來代替空格，這雖然看起來是一件小事，但是使用製表符代替空格，
可以讓開發者閱讀您程式碼的時候，可以依據他們的喜好在他們的程序中自定義縮進。
此外還有一個好處是，這樣文件可以更緊湊一點，也就是本來是四個空格字元，
現在只要一個製表符就可以了。

換行
===========

文件必須使用 Unix 的換行格式儲存。這對於那些在 Windows 環境下的開發者可能是個問題，
但是不管在什麼環境下，您都應該確認下您的文字編輯器已經設定好使用 Unix 換行字元了。

程式碼縮進
==============

使用 Allman 程式碼縮進風格。除了類的定義之外，其他的所有大括號都應該獨佔一行，
並且和它對應的控制語句保持相同的縮進。

**錯誤的**::

	function foo($bar) {
		// ...
	}

	foreach ($arr as $key => $val) {
		// ...
	}

	if ($foo == $bar) {
		// ...
	} else {
		// ...
	}

	for ($i = 0; $i < 10; $i++)
		{
		for ($j = 0; $j < 10; $j++)
			{
			// ...
			}
		}

	try {
		// ...
	}
	catch() {
		// ...
	}

**正確的**::

	function foo($bar)
	{
		// ...
	}

	foreach ($arr as $key => $val)
	{
		// ...
	}

	if ($foo == $bar)
	{
		// ...
	}
	else
	{
		// ...
	}

	for ($i = 0; $i < 10; $i++)
	{
		for ($j = 0; $j < 10; $j++)
		{
			// ...
		}
	}

	try
	{
		// ...
	}
	catch()
	{
		// ...
	}

中括號和小括號內的空格
===============================

一般情況下，使用中括號和小括號的時候不應該使用多餘的空格。
唯一的例外是，在那些接受一個括號和參數的 PHP 的控制結構（declare、do-while、elseif、for、
foreach、if、switch、while）的後面應該加一個空格，這樣做可以和函數區分開來，並增加可讀性。

**錯誤的**::

	$arr[ $foo ] = 'foo';

**正確的**::

	$arr[$foo] = 'foo'; // no spaces around array keys

**錯誤的**::

	function foo ( $bar )
	{

	}

**正確的**::

	function foo($bar) // no spaces around parenthesis in function declarations
	{

	}

**錯誤的**::

	foreach( $query->result() as $row )

**正確的**::

	foreach ($query->result() as $row) // single space following PHP control structures, but not in interior parenthesis

本地化文字
==============

CodeIgniter 的類庫應該盡可能的使用相應的語言文件。

**錯誤的**::

	return "Invalid Selection";

**正確的**::

	return $this->lang->line('invalid_selection');

私有成員函數和變數
=============================

那些只能在內部存取的成員函數和變數，例如供共有成員函數使用的那些工具成員函數或輔助函數，應該以下劃線開頭。

::

	public function convert_text()
	private function _convert_text()

PHP 錯誤
==========

執行程式碼時不應該出現任何錯誤資訊，並不是把警告和提示資訊關掉來滿足這一點。
例如，絕不要直接存取一個您沒設定過的變數（例如，``$_POST`` 陣列），
您應該先使用 ``isset()`` 函數判斷下。

確保您的開發環境對所有人都開啟了錯誤報告，PHP 環境的 display_errors 參數也開啟了，
您可以通過下面的程式碼來檢查::

	if (ini_get('display_errors') == 1)
	{
		exit "Enabled";
	}

有些伺服器上 *display_errors* 參數可能是停用的，而且您沒有權限修改 php.ini 文件，
您可以使用下面的成員函數來啟用它::

	ini_set('display_errors', 1);

.. note:: 使用 ``ini_set()`` 函數在執行時設定 `display_errors
	<http://php.net/manual/en/errorfunc.configuration.php#ini.display-errors>`_
	參數和通過 php.ini 設定文件來設定是不一樣的，換句話說，當出現致命錯誤（fatal errors）時，這種成員函數沒用。

短標記
===============

使用 PHP 的完整標記，防止伺服器不支援短標記（ *short_open_tag* ）參數。

**錯誤的**::

	<? echo $foo; ?>

	<?=$foo?>

**正確的**::

	<?php echo $foo; ?>

.. note:: PHP 5.4 下 **<?=** 標記是永遠可用的。

每行只有一條語句
======================

切記不要在同一行內寫多條語句。

**錯誤的**::

	$foo = 'this'; $bar = 'that'; $bat = str_replace($foo, $bar, $bag);

**正確的**::

	$foo = 'this';
	$bar = 'that';
	$bat = str_replace($foo, $bar, $bag);

字元串
=======

字元串使用單引號引起來，當字元串中有變數時使用雙引號，並且使用大括號將變數包起來。
另外，當字元串中有單引號時，也應該使用雙引號，這樣就不用使用轉義符。

**錯誤的**::

	"My String"					// no variable parsing, so no use for double quotes
	"My string $foo"				// needs braces
	'SELECT foo FROM bar WHERE baz = \'bag\''	// ugly

**正確的**::

	'My String'
	"My string {$foo}"
	"SELECT foo FROM bar WHERE baz = 'bag'"

SQL 查詢
===========

SQL 關鍵字永遠使用大寫：SELECT、INSERT、UPDATE、WHERE、AS、JOIN、ON、IN 等。

考慮到易讀性，把長的查詢分成多行，最好是每行只有一個從句或子從句。

**錯誤的**::

	// keywords are lowercase and query is too long for
	// a single line (... indicates continuation of line)
	$query = $this->db->query("select foo, bar, baz, foofoo, foobar as raboof, foobaz from exp_pre_email_addresses
	...where foo != 'oof' and baz != 'zab' order by foobaz limit 5, 100");

**正確的**::

	$query = $this->db->query("SELECT foo, bar, baz, foofoo, foobar AS raboof, foobaz
					FROM exp_pre_email_addresses
					WHERE foo != 'oof'
					AND baz != 'zab'
					ORDER BY foobaz
					LIMIT 5, 100");

缺省的函數參數
==========================

適當的時候，提供函數參數的缺省值，這有助於防止因錯誤的函數呼叫引起的PHP錯誤，
另外提供常見的備選值可以節省幾行程式碼。例如::

	function foo($bar = '', $baz = FALSE)
