#####################
模板解析類
#####################

模板解析類可以對您檢視文件中的偽變數進行簡單的取代，它可以解析簡單的變數和變數標籤對。

如果您從沒使用過模板引擎，下面是個範例，偽變數名稱使用大括號括起來::

	<html>
		<head>
			<title>{blog_title}</title>
		</head>
		<body>
			<h3>{blog_heading}</h3>

		{blog_entries}
			<h5>{title}</h5>
			<p>{body}</p>
		{/blog_entries}

		</body>
	</html>

這些變數並不是真正的 PHP 變數，只是普通的文字，這樣能讓您的模板（檢視文件）中沒有任何 PHP 程式碼。

.. note:: CodeIgniter **並沒有** 讓您必須使用這個類，因為直接在檢視中使用純 PHP 可能速度會更快點。
	儘管如此，一些開發者還是喜歡使用模板引擎，他們可能是和一些其他的不熟悉 PHP 的設計師共同工作。

.. important:: 模板解析類 **不是** 一個全面的模板解析方案，我們讓它保持簡潔，為了達到更高的性能。

.. contents::
  :local:

.. raw:: html

  <div class="custom-index container"></div>

*******************************
使用模板解析類
*******************************

初始化類
======================

跟 CodeIgniter 中的其他類一樣，可以在您的控制器中使用 ``$this->load->library()`` 
成員函數載入模板解析類::

	$this->load->library('parser');

一旦載入，模板解析類就可以像下面這樣使用::

	$this->parser

解析模板
=================

您可以使用 ``parse()`` 成員函數來解析（或顯示）簡單的模板，如下所示::

	$data = array(
		'blog_title' => 'My Blog Title',
		'blog_heading' => 'My Blog Heading'
	);

	$this->parser->parse('blog_template', $data);

第一個參數為 :doc:`檢視文件 <../general/views>` 的名稱（在這個範例裡，文件名為 blog_template.php），
第二個參數為一個關聯陣列，它包含了要對模板進行取代的資料。上例中，模板將包含兩個變數：
{blog_title} 和 {blog_heading} 。

沒有必要對 $this->parser->parse() 成員函數傳回的結果進行 echo 或其他的處理，它會自動的儲存到輸出類，
以待發送給瀏覽器。但是，如果您希望它將資料傳回而不是存到輸出類裡去，您可以將第三個參數設定為 TRUE ::

	$string = $this->parser->parse('blog_template', $data, TRUE);

變數對
==============

上面的範例可以允許取代簡單的變數，但是如果您想重複某一塊程式碼，並且每次重複的值都不同又該怎麼辦呢？
看下我們一開始的時候展示那個模板範例::

	<html>
		<head>
			<title>{blog_title}</title>
		</head>
		<body>
			<h3>{blog_heading}</h3>

		{blog_entries}
			<h5>{title}</h5>
			<p>{body}</p>
		{/blog_entries}

		</body>
	</html>

在上面的程式碼中，您會發現一對變數：{blog_entries} data... {/blog_entries} 。這個範例的意思是，
這個變數對之間的整個資料塊將重複多次，重複的次數取決於 "blog_entries" 參數中元素的個數。

解析變數對和上面的解析單個變數的程式碼完全一樣，除了一點，您需要依據變數對的資料使用一個多維的陣列，
像下面這樣::

	$this->load->library('parser');

	$data = array(
		'blog_title'   => 'My Blog Title',
		'blog_heading' => 'My Blog Heading',
		'blog_entries' => array(
			array('title' => 'Title 1', 'body' => 'Body 1'),
			array('title' => 'Title 2', 'body' => 'Body 2'),
			array('title' => 'Title 3', 'body' => 'Body 3'),
			array('title' => 'Title 4', 'body' => 'Body 4'),
			array('title' => 'Title 5', 'body' => 'Body 5')
		)
	);

	$this->parser->parse('blog_template', $data);

如果您的變數對資料來自於資料庫查詢結果，那麼它已經是一個多維陣列了，您可以簡單的使用資料庫的
``result_array()`` 成員函數::

	$query = $this->db->query("SELECT * FROM blog");

	$this->load->library('parser');

	$data = array(
		'blog_title'   => 'My Blog Title',
		'blog_heading' => 'My Blog Heading',
		'blog_entries' => $query->result_array()
	);

	$this->parser->parse('blog_template', $data);

使用說明
===========

如果您傳入的某些參數在模板中沒用到，它們將被忽略::

	$template = 'Hello, {firstname} {lastname}';
	$data = array(
		'title' => 'Mr',
		'firstname' => 'John',
		'lastname' => 'Doe'
	);
	$this->parser->parse_string($template, $data);

	// Result: Hello, John Doe

如果您的模板中用到了某個變數，但是您傳入的參數中沒有，將直接顯示出原始的偽變數::

	$template = 'Hello, {firstname} {initials} {lastname}';
	$data = array(
		'title' => 'Mr',
		'firstname' => 'John',
		'lastname' => 'Doe'
	);
	$this->parser->parse_string($template, $data);

	// Result: Hello, John {initials} Doe

如果您的模板中需要使用某個陣列變數，但是您傳入的參數是個字元串類型，那麼變數對的起始標籤將會被取代，
但是結束標籤不會被正確顯示::

	$template = 'Hello, {firstname} {lastname} ({degrees}{degree} {/degrees})';
	$data = array(
		'degrees' => 'Mr',
		'firstname' => 'John',
		'lastname' => 'Doe',
		'titles' => array(
			array('degree' => 'BSc'),
			array('degree' => 'PhD')
		)
	);
	$this->parser->parse_string($template, $data);

	// Result: Hello, John Doe (Mr{degree} {/degrees})

如果您的某個單一變數的名稱和變數對中的某個變數名稱一樣，顯示結果可能會不對::

	$template = 'Hello, {firstname} {lastname} ({degrees}{degree} {/degrees})';
	$data = array(
		'degree' => 'Mr',
		'firstname' => 'John',
		'lastname' => 'Doe',
		'degrees' => array(
			array('degree' => 'BSc'),
			array('degree' => 'PhD')
		)
	);
	$this->parser->parse_string($template, $data);

	// Result: Hello, John Doe (Mr Mr )

檢視片段
==============

您沒必要在您的檢視文件中使用變數對來實現重複，您也可以在變數對之間使用一個檢視片段，
在控制器，而不是檢視文件中，來控制重複。

下面是一個在檢視中實現重複的範例::

	$template = '<ul>{menuitems}
		<li><a href="{link}">{title}</a></li>
	{/menuitems}</ul>';

	$data = array(
		'menuitems' => array(
			array('title' => 'First Link', 'link' => '/first'),
			array('title' => 'Second Link', 'link' => '/second'),
		)
	);
	$this->parser->parse_string($template, $data);

結果::

	<ul>
		<li><a href="/first">First Link</a></li>
		<li><a href="/second">Second Link</a></li>
	</ul>

下面是一個在控制器中利用檢視片段來實現重複的範例::

	$temp = '';
	$template1 = '<li><a href="{link}">{title}</a></li>';
	$data1 = array(
		array('title' => 'First Link', 'link' => '/first'),
		array('title' => 'Second Link', 'link' => '/second'),
	);

	foreach ($data1 as $menuitem)
	{
		$temp .= $this->parser->parse_string($template1, $menuitem, TRUE);
	}

	$template = '<ul>{menuitems}</ul>';
	$data = array(
		'menuitems' => $temp
	);
	$this->parser->parse_string($template, $data);

結果::

	<ul>
		<li><a href="/first">First Link</a></li>
		<li><a href="/second">Second Link</a></li>
	</ul>

***************
類參考
***************

.. php:class:: CI_Parser

	.. php:method:: parse($template, $data[, $return = FALSE])

		:param	string	$template: Path to view file
		:param	array	$data: Variable data
		:param	bool	$return: Whether to only return the parsed template
		:returns:	Parsed template string
		:rtype:	string

		依據提供的路徑和變數解析一個模板。

	.. php:method:: parse_string($template, $data[, $return = FALSE])

		:param	string	$template: Path to view file
		:param	array	$data: Variable data
		:param	bool	$return: Whether to only return the parsed template
		:returns:	Parsed template string
		:rtype:	string

		該成員函數和 ``parse()`` 成員函數一樣，只是它接受一個字元串作為模板，而不是去載入檢視文件。

	.. php:method:: set_delimiters([$l = '{'[, $r = '}']])

		:param	string	$l: Left delimiter
		:param	string	$r: Right delimiter
		:rtype: void

		設定模板中偽變數的分割符（起始標籤和結束標籤）。
