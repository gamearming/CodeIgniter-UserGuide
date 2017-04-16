#################
日曆類
#################

使用日曆類可以讓您動態的建立日曆，並且可以使用日曆模板來格式化顯示您的日曆，
允許您 100% 的控制它設計的每個方面。另外，您還可以向日曆的單元格傳遞資料。

.. contents::
  :local:

.. raw:: html

  <div class="custom-index container"></div>

***************************
使用日曆類
***************************

初始化類
======================

跟 CodeIgniter 中的其他類一樣，可以在您的控制器中使用 ``$this->load->library()``
成員函數載入日曆類::

	$this->load->library('calendar');

一旦載入，日曆類就可以像下面這樣使用::

	$this->calendar

顯示一個日曆
=====================

這裡是一個簡單的範例，告訴您如何去顯示一個日曆::

	$this->load->library('calendar');
	echo $this->calendar->generate();

上面的程式碼將依據您伺服器時間建立一個目前月/年的日曆。要顯示一個指定月和年的日曆，
您要傳遞這些資訊到日曆產生函數:

	$this->load->library('calendar');
	echo $this->calendar->generate(2006, 6);

上面的程式碼將建立一個顯示 2006 年 6 月的日曆，第一個參數指定了年，第二個參數指定了月。

傳資料到單元格
===================================

如果需要加入資料到日曆的單元格中，就要建立一個關聯陣列，這個陣列中索引是想加入資料的日期，
陣列對應的值是想加入的資料。該陣列通過日曆產生函數的第三個參數被傳入，參考下面這個範例::

	$this->load->library('calendar');

	$data = array(
		3  => 'http://example.com/news/article/2006/06/03/',
		7  => 'http://example.com/news/article/2006/06/07/',
		13 => 'http://example.com/news/article/2006/06/13/',
		26 => 'http://example.com/news/article/2006/06/26/'
	);

	echo $this->calendar->generate(2006, 6, $data);

使用上面的範例，天數為 3、7、13 和 26 將變成鏈接指向您提供的 URL 。

.. note:: 預設情況下，系統假定您的陣列中包含了鏈接。在下面介紹日曆模板的部分，
	您會看到您可以自定義處理傳入日曆單元格的資料，所以您可以傳不同類型的資訊。

設定顯示參數
===========================

有 8 種不同的參數可以讓您設定日曆的各個方面，您可以通過載入函數的第二個參數來設定參數。
例如::

	$prefs = array(
		'start_day'    => 'saturday',
		'month_type'   => 'long',
		'day_type'     => 'short'
	);

	$this->load->library('calendar', $prefs);

	echo $this->calendar->generate();

上面的程式碼將顯示一個日曆從禮拜六開始，使用用完整的月份標題和縮寫的天數格式。
更多參數資訊請看下面。

======================  =================  ============================================  ===================================================================
參數                    預設值              選項                                         描述
======================  =================  ============================================  ===================================================================
**template**           	None               None                                          字元串或陣列，包含了您的日曆模板，見下面的模板部分。
**local_time**        	time()             None                                          目前時間的 Unix 時間戳。
**start_day**           sunday             Any week day (sunday, monday, tuesday, etc.)  指定每週的第一天是周幾。
**month_type**          long               long, short                                   月份的顯示樣式（long = January, short = Jan）
**day_type**            abr                long, short, abr                              星期的顯示樣式（long = Sunday, short = Sun, abr = Su）
**show_next_prev**      FALSE              TRUE/FALSE (boolean)                          是否顯示 "上個月" 和 "下個月" 鏈接，見下文。
**next_prev_url**       controller/method  A URL                                         設定 "上個月" 和 "下個月" 的鏈接地址。
**show_other_days**     FALSE              TRUE/FALSE (boolean)                          是否顯示第一周和最後一周相鄰月份的日期。
======================  =================  ============================================  ===================================================================


顯示下一月/上一月鏈接
=================================

要讓您的日曆通過下一月/上一月鏈接動態的減少/增加，可以仿照下面的範例建立您的日曆::

	$prefs = array(
		'show_next_prev'  => TRUE,
		'next_prev_url'   => 'http://example.com/index.php/calendar/show/'
	);

	$this->load->library('calendar', $prefs);

	echo $this->calendar->generate($this->uri->segment(3), $this->uri->segment(4));

在上面的範例中，您會注意到這幾點：

-  "show_next_prev" 參數必須設定為 TRUE
-  "next_prev_url" 參數必須設定一個 URL ，如果不設定，會預設使用目前的 **控制器/成員函數**
-  通過 URI 的段將 "年" 和 "月" 參數傳遞給日曆產生函數（日曆類會自動加入 "年" 和 "月" 到您提供的 URL）

建立一個日曆模板
============================

通過建立一個日曆模板您能夠 100% 的控制您的日曆的設計。當使用字元串方式設定模板時，
日曆的每一部分都要被放在一對偽變數中，像下面這樣::

	$prefs['template'] = '

		{table_open}<table border="0" cellpadding="0" cellspacing="0">{/table_open}

		{heading_row_start}<tr>{/heading_row_start}

		{heading_previous_cell}<th><a href="{previous_url}">&lt;&lt;</a></th>{/heading_previous_cell}
		{heading_title_cell}<th colspan="{colspan}">{heading}</th>{/heading_title_cell}
		{heading_next_cell}<th><a href="{next_url}">&gt;&gt;</a></th>{/heading_next_cell}

		{heading_row_end}</tr>{/heading_row_end}

		{week_row_start}<tr>{/week_row_start}
		{week_day_cell}<td>{week_day}</td>{/week_day_cell}
		{week_row_end}</tr>{/week_row_end}

		{cal_row_start}<tr>{/cal_row_start}
		{cal_cell_start}<td>{/cal_cell_start}
		{cal_cell_start_today}<td>{/cal_cell_start_today}
		{cal_cell_start_other}<td class="other-month">{/cal_cell_start_other}

		{cal_cell_content}<a href="{content}">{day}</a>{/cal_cell_content}
		{cal_cell_content_today}<div class="highlight"><a href="{content}">{day}</a></div>{/cal_cell_content_today}

		{cal_cell_no_content}{day}{/cal_cell_no_content}
		{cal_cell_no_content_today}<div class="highlight">{day}</div>{/cal_cell_no_content_today}

		{cal_cell_blank}&nbsp;{/cal_cell_blank}

		{cal_cell_other}{day}{/cal_cel_other}

		{cal_cell_end}</td>{/cal_cell_end}
		{cal_cell_end_today}</td>{/cal_cell_end_today}
		{cal_cell_end_other}</td>{/cal_cell_end_other}
		{cal_row_end}</tr>{/cal_row_end}

		{table_close}</table>{/table_close}
	';

	$this->load->library('calendar', $prefs);

	echo $this->calendar->generate();

當使用陣列方式設定模板時，您需要傳遞 `key => value` 鍵值對，您可以只設定您想設定的參數，
其他沒有設定的參數會使用日曆類的預設值代替。

範例::

	$prefs['template'] = array(
		'table_open'           => '<table class="calendar">',
		'cal_cell_start'       => '<td class="day">',
		'cal_cell_start_today' => '<td class="today">'
	);

	$this->load->library('calendar', $prefs);

	echo $this->calendar->generate();

***************
類參考
***************

.. php:class:: CI_Calendar

	.. php:method:: initialize([$config = array()])

		:param	array	$config: Configuration parameters
		:returns:	CI_Calendar instance (method chaining)
		:rtype:	CI_Calendar

		初始化日曆類參數，輸入參數為一個關聯陣列，包含了日曆的顯示參數。

	.. php:method:: generate([$year = ''[, $month = ''[, $data = array()]]])

		:param	int	$year: Year
		:param	int	$month: Month
		:param	array	$data: Data to be shown in the calendar cells
		:returns:	HTML-formatted calendar
		:rtype:	string

		產生日曆。


	.. php:method:: get_month_name($month)

		:param	int	$month: Month
		:returns:	Month name
		:rtype:	string

		提供數字格式的月份，傳回月份的名稱。

	.. php:method:: get_day_names($day_type = '')

		:param	string	$day_type: 'long', 'short', or 'abr'
		:returns:	Array of day names
		:rtype:	array

		依據類型傳回一個包含星期名稱（Sunday、Monday 等等）的陣列，類型有：long、short 和 abr 。
		如果沒有指定 ``$day_type`` 參數（或該參數無效），成員函數預設使用 abr（縮寫） 格式。

	.. php:method:: adjust_date($month, $year)

		:param	int	$month: Month
		:param	int	$year: Year
		:returns:	An associative array containing month and year
		:rtype:	array

		該成員函數調整日期確保日期有效。例如，如果您將月份設定為 13 ，年份將自動加 1 ，並且月份變為一月::

			print_r($this->calendar->adjust_date(13, 2014));

		輸出::

			Array
			(    
				[month] => '01'
				[year] => '2015'
			)

	.. php:method:: get_total_days($month, $year)

		:param	int	$month: Month
		:param	int	$year: Year
		:returns:	Count of days in the specified month
		:rtype:	int

		讀取指定月的天數::

			echo $this->calendar->get_total_days(2, 2012);
			// 29

		.. note:: 該成員函數是 :doc:`日期輔助函數 <../helpers/date_helper>` 的 :php:func:`days_in_month()` 函數的別名。

	.. php:method:: default_template()

		:returns:	An array of template values
		:rtype:	array

		預設的模板，當您沒有使用您自己的模板時將會使用該成員函數。


	.. php:method:: parse_template()

		:returns:	CI_Calendar instance (method chaining)
		:rtype:	CI_Calendar

		解析模板中的偽變數 ``{pseudo-variables}`` 顯示日曆。
