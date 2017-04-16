################
日期輔助函數
################

日期輔助函數文件包含了一些幫助您處理日期的函數。

.. contents::
  :local:

.. raw:: html

  <div class="custom-index container"></div>

載入輔助函數
===================

該輔助函數通過下面的程式碼載入::

	$this->load->helper('date');

可用函數
===================

該輔助函數有下列可用函數：

.. php:function:: now([$timezone = NULL])

	:param	string	$timezone: Timezone
	:returns:	UNIX timestamp
	:rtype:	int

	依據伺服器的本地時間，以及一個 PHP 支援的時區參數或設定文件中的 "基準時間" 參數傳回目前時間的 UNIX 時間戳，
	如果您不打算設定 "基準時間" （如果您的站點允許用戶設定他們自己的時區，您通常需要設定這個），
	該函數就和 PHP 的 ``time()`` 函數沒什麼區別。
	::

		echo now('Australia/Victoria');

	如果沒有指定時區，該函數將使用 **time_reference** 參數呼叫 ``time()`` 函數。

.. php:function:: mdate([$datestr = ''[, $time = '']])

	:param	string	$datestr: Date string
	:param	int	$time: UNIX timestamp
	:returns:	MySQL-formatted date
	:rtype:	string

	該函數和 PHP 的 `date() <http://php.net/manual/en/function.date.php>`_ 函數一樣，
	但是它支援 MySQL 風格的日期格式，在程式碼之前使用百分號，例如：`%Y %m %d`

	使用這個函數的好處是您不用關心去轉義那些不是日期程式碼的字元，如果使用 ``date()`` 函數時，您就要這麼做。

	例如::

		$datestring = 'Year: %Y Month: %m Day: %d - %h:%i %a';
		$time = time();
		echo mdate($datestring, $time);

	如果第二個參數沒有提供一個時間，那麼預設會使用目前時間。

.. php:function:: standard_date([$fmt = 'DATE_RFC822'[, $time = NULL]])

	:param	string	$fmt: Date format
	:param	int	$time: UNIX timestamp
	:returns:	Formatted date or FALSE on invalid format
	:rtype:	string

	產生標準格式的時間字元串。

	例如::

		$format = 'DATE_RFC822';
		$time = time();
		echo standard_date($format, $time);

	.. note:: 該函數已經廢棄，請使用原生的 ``date()`` 函數和
		`時間格式化常數 <https://secure.php.net/manual/en/class.datetime.php#datetime.constants.types>`_
		替代::

			echo date(DATE_RFC822, time());

	**支援的格式：**

	===============	=======================	======================================
	Constant        Description             Example
	===============	=======================	======================================
	DATE_ATOM       Atom                    2005-08-15T16:13:03+0000
	DATE_COOKIE     HTTP Cookies            Sun, 14 Aug 2005 16:13:03 UTC
	DATE_ISO8601    ISO-8601                2005-08-14T16:13:03+00:00
	DATE_RFC822     RFC 822                 Sun, 14 Aug 05 16:13:03 UTC
	DATE_RFC850     RFC 850                 Sunday, 14-Aug-05 16:13:03 UTC
	DATE_RFC1036    RFC 1036                Sunday, 14-Aug-05 16:13:03 UTC
	DATE_RFC1123    RFC 1123                Sun, 14 Aug 2005 16:13:03 UTC
	DATE_RFC2822    RFC 2822                Sun, 14 Aug 2005 16:13:03 +0000
	DATE_RSS        RSS                     Sun, 14 Aug 2005 16:13:03 UTC
	DATE_W3C        W3C                     2005-08-14T16:13:03+0000
	===============	=======================	======================================

.. php:function:: local_to_gmt([$time = ''])

	:param	int	$time: UNIX timestamp
	:returns:	UNIX timestamp
	:rtype:	int

	將時間轉換為 GMT 時間。

	例如::

		$gmt = local_to_gmt(time());

.. php:function:: gmt_to_local([$time = ''[, $timezone = 'UTC'[, $dst = FALSE]]])

	:param	int	$time: UNIX timestamp
	:param	string	$timezone: Timezone
	:param	bool	$dst: Whether DST is active
	:returns:	UNIX timestamp
	:rtype:	int

	依據指定的時區和 DST （夏令時，Daylight Saving Time） 將 GMT 時間轉換為本地時間。

	例如::

		$timestamp = 1140153693;
		$timezone  = 'UM8';
		$daylight_saving = TRUE;
		echo gmt_to_local($timestamp, $timezone, $daylight_saving);


	.. note:: 時區清單請參見本頁末尾。

.. php:function:: mysql_to_unix([$time = ''])

	:param	string	$time: MySQL timestamp
	:returns:	UNIX timestamp
	:rtype:	int

	將 MySQL 時間戳轉換為 UNIX 時間戳。

	例如::

		$unix = mysql_to_unix('20061124092345');

.. php:function:: unix_to_human([$time = ''[, $seconds = FALSE[, $fmt = 'us']]])

	:param	int	$time: UNIX timestamp
	:param	bool	$seconds: Whether to show seconds
	:param	string	$fmt: format (us or euro)
	:returns:	Formatted date
	:rtype:	string

	將 UNIX 時間戳轉換為方便人類閱讀的格式，如下::

		YYYY-MM-DD HH:MM:SS AM/PM

	這在當您需要在一個表單字段中顯示日期時很有用。

	格式化後的時間可以帶也可以不帶秒數，也可以設定成歐洲或美國時間格式。
	如果只指定了一個時間參數，將使用不帶秒數的美國時間格式。

	例如::

		$now = time();
		echo unix_to_human($now); // U.S. time, no seconds
		echo unix_to_human($now, TRUE, 'us'); // U.S. time with seconds
		echo unix_to_human($now, TRUE, 'eu'); // Euro time with seconds

.. php:function:: human_to_unix([$datestr = ''])

	:param	int	$datestr: Date string
	:returns:	UNIX timestamp or FALSE on failure
	:rtype:	int

	該函數和 :php:func:`unix_to_human()` 函數相反，將一個方便人類閱讀的時間格式轉換為 UNIX 時間戳。
	這在當您需要在一個表單字段中顯示日期時很有用。如果輸入的時間不同於上面的格式，函數傳回 FALSE 。

	例如::

		$now = time();
		$human = unix_to_human($now);
		$unix = human_to_unix($human);

.. php:function:: nice_date([$bad_date = ''[, $format = FALSE]])

	:param	int	$bad_date: The terribly formatted date-like string
	:param	string	$format: Date format to return (same as PHP's ``date()`` function)
	:returns:	Formatted date
	:rtype:	string

	該函數解析一個沒有格式化過的數字格式的日期，並將其轉換為格式化的日期。它也能解析格式化好的日期。

	預設該函數將傳回 UNIX 時間戳，您也可以提供一個格式化字元串給第二個參數（和 PHP 的 ``date()`` 函數一樣）。

	例如::

		$bad_date = '199605';
		// Should Produce: 1996-05-01
		$better_date = nice_date($bad_date, 'Y-m-d');

		$bad_date = '9-11-2001';
		// Should Produce: 2001-09-11
		$better_date = nice_date($bad_date, 'Y-m-d');

	.. note:: This function is DEPRECATED. Use PHP's native `DateTime class
		<https://secure.php.net/datetime>`_ instead.

.. php:function:: timespan([$seconds = 1[, $time = ''[, $units = '']]])

	:param	int	$seconds: Number of seconds
	:param	string	$time: UNIX timestamp
	:param	int	$units: Number of time units to display
	:returns:	Formatted time difference
	:rtype:	string

	將一個 UNIX 時間戳轉換為以下這種格式::

		1 Year, 10 Months, 2 Weeks, 5 Days, 10 Hours, 16 Minutes

	第一個參數為一個 UNIX 時間戳，第二個參數是一個比第一個參數大的 UNIX 時間戳。
	第三個參數可選，用於限制要顯示的時間單位個數。

	如果第二個參數為空，將使用目前時間。

	這個函數最常見的用途是，顯示從過去某個時間點到目前時間經過了多少時間。

	例如::

		$post_date = '1079621429';
		$now = time();
		$units = 2;
		echo timespan($post_date, $now, $units);

	.. note:: 該函數產生的本文可以在語言文件 `language/<your_lang>/date_lang.php` 中找到。

.. php:function:: days_in_month([$month = 0[, $year = '']])

	:param	int	$month: a numeric month
	:param	int	$year: a numeric year
	:returns:	Count of days in the specified month
	:rtype:	int

	傳回指定某個月的天數，會考慮閏年。

	例如::

		echo days_in_month(06, 2005);

	如果第二個參數為空，將使用今年。

	.. note:: 該函數其實是原生的 ``cal_days_in_month()`` 函數的別名，如果它可用的話。

.. php:function:: date_range([$unix_start = ''[, $mixed = ''[, $is_unix = TRUE[, $format = 'Y-m-d']]]])

	:param	int	$unix_start: UNIX timestamp of the range start date
	:param	int	$mixed: UNIX timestamp of the range end date or interval in days
	:param	bool	$is_unix: set to FALSE if $mixed is not a timestamp
	:param	string	$format: Output date format, same as in ``date()``
	:returns:	An array of dates
	:rtype:	array

	傳回某一段時間的日期清單。

	例如::

		$range = date_range('2012-01-01', '2012-01-15');
		echo "First 15 days of 2012:";
		foreach ($range as $date)
		{
			echo $date."\n";
		}

.. php:function:: timezones([$tz = ''])

	:param	string	$tz: A numeric timezone
	:returns:	Hour difference from UTC
	:rtype:	int

	依據指定的時區（可用的時區清單參見下文的 "時區參考"）傳回它的 UTC 時間偏移。

	例如::

		echo timezones('UM5');


	這個函數和 :php:func:`timezone_menu()` 函數一起使用時很有用。

.. php:function:: timezone_menu([$default = 'UTC'[, $class = ''[, $name = 'timezones'[, $attributes = '']]]])

	:param	string	$default: Timezone
	:param	string	$class: Class name
	:param	string	$name: Menu name
	:param	mixed	$attributes: HTML attributes
	:returns:	HTML drop down menu with time zones
	:rtype:	string

	該函數用於產生一個時區下拉菜單，像下面這樣。

	.. raw:: html

		<form action="#">
			<select name="timezones">
				<option value='UM12'>(UTC -12:00) Baker/Howland Island</option>
				<option value='UM11'>(UTC -11:00) Samoa Time Zone, Niue</option>
				<option value='UM10'>(UTC -10:00) Hawaii-Aleutian Standard Time, Cook Islands, Tahiti</option>
				<option value='UM95'>(UTC -9:30) Marquesas Islands</option>
				<option value='UM9'>(UTC -9:00) Alaska Standard Time, Gambier Islands</option>
				<option value='UM8'>(UTC -8:00) Pacific Standard Time, Clipperton Island</option>
				<option value='UM7'>(UTC -7:00) Mountain Standard Time</option>
				<option value='UM6'>(UTC -6:00) Central Standard Time</option>
				<option value='UM5'>(UTC -5:00) Eastern Standard Time, Western Caribbean Standard Time</option>
				<option value='UM45'>(UTC -4:30) Venezuelan Standard Time</option>
				<option value='UM4'>(UTC -4:00) Atlantic Standard Time, Eastern Caribbean Standard Time</option>
				<option value='UM35'>(UTC -3:30) Newfoundland Standard Time</option>
				<option value='UM3'>(UTC -3:00) Argentina, Brazil, French Guiana, Uruguay</option>
				<option value='UM2'>(UTC -2:00) South Georgia/South Sandwich Islands</option>
				<option value='UM1'>(UTC -1:00) Azores, Cape Verde Islands</option>
				<option value='UTC' selected='selected'>(UTC) Greenwich Mean Time, Western European Time</option>
				<option value='UP1'>(UTC +1:00) Central European Time, West Africa Time</option>
				<option value='UP2'>(UTC +2:00) Central Africa Time, Eastern European Time, Kaliningrad Time</option>
				<option value='UP3'>(UTC +3:00) Moscow Time, East Africa Time</option>
				<option value='UP35'>(UTC +3:30) Iran Standard Time</option>
				<option value='UP4'>(UTC +4:00) Azerbaijan Standard Time, Samara Time</option>
				<option value='UP45'>(UTC +4:30) Afghanistan</option>
				<option value='UP5'>(UTC +5:00) Pakistan Standard Time, Yekaterinburg Time</option>
				<option value='UP55'>(UTC +5:30) Indian Standard Time, Sri Lanka Time</option>
				<option value='UP575'>(UTC +5:45) Nepal Time</option>
				<option value='UP6'>(UTC +6:00) Bangladesh Standard Time, Bhutan Time, Omsk Time</option>
				<option value='UP65'>(UTC +6:30) Cocos Islands, Myanmar</option>
				<option value='UP7'>(UTC +7:00) Krasnoyarsk Time, Cambodia, Laos, Thailand, Vietnam</option>
				<option value='UP8'>(UTC +8:00) Australian Western Standard Time, Beijing Time, Irkutsk Time</option>
				<option value='UP875'>(UTC +8:45) Australian Central Western Standard Time</option>
				<option value='UP9'>(UTC +9:00) Japan Standard Time, Korea Standard Time, Yakutsk Time</option>
				<option value='UP95'>(UTC +9:30) Australian Central Standard Time</option>
				<option value='UP10'>(UTC +10:00) Australian Eastern Standard Time, Vladivostok Time</option>
				<option value='UP105'>(UTC +10:30) Lord Howe Island</option>
				<option value='UP11'>(UTC +11:00) Srednekolymsk Time, Solomon Islands, Vanuatu</option>
				<option value='UP115'>(UTC +11:30) Norfolk Island</option>
				<option value='UP12'>(UTC +12:00) Fiji, Gilbert Islands, Kamchatka Time, New Zealand Standard Time</option>
				<option value='UP1275'>(UTC +12:45) Chatham Islands Standard Time</option>
				<option value='UP13'>(UTC +13:00) Phoenix Islands Time, Tonga</option>
				<option value='UP14'>(UTC +14:00) Line Islands</option>
			</select>
		</form>


	當您的站點允許用戶選擇自己的本地時區時，這個菜單會很有用。

	第一個參數為菜單預設選定的時區，例如，要設定太平洋時間為預設值，您可以這樣::

		echo timezone_menu('UM8');

	菜單中的值請參見下面的時區參考。

	第二個參數用於為菜單設定一個 CSS 類名。

	第四個參數用於為產生的 select 標籤設定一個或多個屬性。

	.. note:: 菜單中的文字可以在語言文件 `language/<your_lang>/date_lang.php` 中找到。

時區參考
==================

下表列出了每個時區和它所對應的位置。

注意，為了表述清晰和格式工整，有些位置資訊做了適當的刪減。

===========     =====================================================================
時區            位置
===========     =====================================================================
UM12            (UTC - 12:00) 貝克島、豪蘭島
UM11            (UTC - 11:00) 薩摩亞時區、紐埃
UM10            (UTC - 10:00) 夏威夷-阿留申標準時間、庫克群島
UM95            (UTC - 09:30) 馬克薩斯群島
UM9             (UTC - 09:00) 阿拉斯加標準時間、甘比爾群島
UM8             (UTC - 08:00) 太平洋標準時間、克利珀頓島
UM7             (UTC - 07:00) 山區標準時間
UM6             (UTC - 06:00) 中部標準時間
UM5             (UTC - 05:00) 東部標準時間、西加勒比
UM45            (UTC - 04:30) 委內瑞拉標準時間
UM4             (UTC - 04:00) 大西洋標準時間、東加勒比
UM35            (UTC - 03:30) 紐芬蘭標準時間
UM3             (UTC - 03:00) 阿根廷、巴西、法屬圭亞那、烏拉圭
UM2             (UTC - 02:00) 南喬治亞島、南桑威奇群島
UM1             (UTC -1:00) 亞速爾群島、佛得角群島
UTC             (UTC) 格林尼治標準時間、西歐時間
UP1             (UTC +1:00) 中歐時間、西非時間
UP2             (UTC +2:00) 中非時間、東歐時間
UP3             (UTC +3:00) 莫斯科時間、東非時間
UP35            (UTC +3:30) 伊朗標準時間
UP4             (UTC +4:00) 阿塞拜疆標準時間、薩馬拉時間
UP45            (UTC +4:30) 阿富汗
UP5             (UTC +5:00) 巴基斯坦標準時間、葉卡捷琳堡時間
UP55            (UTC +5:30) 印度標準時間、斯里蘭卡時間
UP575           (UTC +5:45) 尼泊爾時間
UP6             (UTC +6:00) 孟加拉國標準時間、不丹時間、鄂木斯克時間
UP65            (UTC +6:30) 可可島、緬甸
UP7             (UTC +7:00) 克拉斯諾亞爾斯克時間、柬埔寨、老撾、泰國、越南
UP8             (UTC +8:00) 澳大利亞西部標準時間、北京時間
UP875           (UTC +8:45) 澳大利亞中西部標準時間
UP9             (UTC +9:00) 日本標準時間、韓國標準時間、雅庫茨克
UP95            (UTC +9:30) 澳大利亞中部標準時間
UP10            (UTC +10:00) 澳大利亞東部標準時間、海參崴時間
UP105           (UTC +10:30) 豪勳爵島
UP11            (UTC +11:00) 中科雷姆斯克時間、所羅門群島、瓦努阿圖
UP115           (UTC +11:30) 諾福克島
UP12            (UTC +12:00) 斐濟、吉爾伯特群島、堪察加半島、新西蘭
UP1275          (UTC +12:45) 查塔姆群島標準時間
UP13            (UTC +13:00) 鳳凰島、湯加
UP14            (UTC +14:00) 萊恩群島
===========     =====================================================================
