###############
HTML 輔助函數
###############

HTML 輔助函數文件包含了用於處理 HTML 的一些函數。

.. contents::
  :local:

.. raw:: html

  <div class="custom-index container"></div>

載入輔助函數
===================

該輔助函數通過下面的程式碼載入::

	$this->load->helper('html');

可用函數
===================

該輔助函數有下列可用函數：

.. php:function:: heading([$data = ''[, $h = '1'[, $attributes = '']]])

	:param	string	$data: Content
	:param	string	$h: Heading level
	:param	mixed	$attributes: HTML attributes
	:returns:	HTML heading tag
	:rtype:	string

	用於建立 HTML 標題標籤，第一個參數為標題內容，第二個參數為標題大小。例如::

		echo heading('Welcome!', 3);

	上面程式碼將產生：<h3>Welcome!</h3>

	另外，為了向標題標籤加入屬性，例如 HTML class、id 或內聯樣式，可以通過第三個參數傳一個字元串或者一個陣列::

		echo heading('Welcome!', 3, 'class="pink"');
		echo heading('How are you?', 4, array('id' => 'question', 'class' => 'green'));

	上面程式碼將產生：

	.. code-block:: html

		<h3 class="pink">Welcome!<h3>
		<h4 id="question" class="green">How are you?</h4>

.. php:function:: img([$src = ''[, $index_page = FALSE[, $attributes = '']]])

	:param	string	$src: Image source data
	:param	bool	$index_page: Whether to treat $src as a routed URI string
	:param	array	$attributes: HTML attributes
	:returns:	HTML image tag
	:rtype:	string

	用於產生 HTML <img /> 標籤，第一個參數為圖片地址，例如::

		echo img('images/picture.jpg'); // gives <img src="http://site.com/images/picture.jpg" />

	第二個參數可選，其值為 TRUE 或 FALSE，用於指定是否在產生的圖片地址中加入由 ``$config['index_page']`` 所設定的起始頁面。
	一般來說，當您使用媒體控制器時才使用這個::

		echo img('images/picture.jpg', TRUE); // gives <img src="http://site.com/index.php/images/picture.jpg" alt="" />

	另外，您也可以通過向 ``img()`` 函數傳遞一個關聯陣列來完全控制所有的屬性和值，如果沒有提供 *alt* 屬性，
	CodeIgniter 預設使用一個空字元串。

	例如::

		$image_properties = array(
			'src' 	=> 'images/picture.jpg',
			'alt' 	=> 'Me, demonstrating how to eat 4 slices of pizza at one time',
			'class' => 'post_images',
			'width' => '200',
			'height'=> '200',
			'title' => 'That was quite a night',
			'rel' 	=> 'lightbox'
		);

		img($image_properties);
		// <img src="http://site.com/index.php/images/picture.jpg" alt="Me, demonstrating how to eat 4 slices of pizza at one time" class="post_images" width="200" height="200" title="That was quite a night" rel="lightbox" />

.. php:function:: link_tag([$href = ''[, $rel = 'stylesheet'[, $type = 'text/css'[, $title = ''[, $media = ''[, $index_page = FALSE]]]]]])

	:param	string	$href: What are we linking to
	:param	string	$rel: Relation type
	:param	string	$type: Type of the related document
	:param	string	$title: Link title
	:param	string	$media: Media type
	:param	bool	$index_page: Whether to treat $src as a routed URI string
	:returns:	HTML link tag
	:rtype:	string

	用於產生 HTML <link /> 標籤，這在產生樣式的 link 標籤時很有用，當然也可以產生其他的 link 標籤。
	參數為 *href* ，後面的是可選的：*rel* 、 *type* 、 *title* 、 *media* 和 *index_page* 。

	*index_page* 參數是個布林值，用於指定是否在 *href* 鏈接中加入由 ``$config['index_page']`` 所設定的起始頁面。

	例如::

		echo link_tag('css/mystyles.css');
		// gives <link href="http://site.com/css/mystyles.css" rel="stylesheet" type="text/css" />

	另一個範例::

		echo link_tag('favicon.ico', 'shortcut icon', 'image/ico');
		// <link href="http://site.com/favicon.ico" rel="shortcut icon" type="image/ico" />

		echo link_tag('feed', 'alternate', 'application/rss+xml', 'My RSS Feed');
		// <link href="http://site.com/feed" rel="alternate" type="application/rss+xml" title="My RSS Feed" />

	另外，您也可以通過向 ``link()`` 函數傳遞一個關聯陣列來完全控制所有的屬性和值::

		$link = array(
			'href'	=> 'css/printer.css',
			'rel'	=> 'stylesheet',
			'type'	=> 'text/css',
			'media'	=> 'print'
		);

		echo link_tag($link);
		// <link href="http://site.com/css/printer.css" rel="stylesheet" type="text/css" media="print" />


.. php:function:: ul($list[, $attributes = ''])

	:param	array	$list: List entries
	:param	array	$attributes: HTML attributes
	:returns:	HTML-formatted unordered list
	:rtype:	string

	用於產生 HTML 無序清單（<ul>），參數為簡單的陣列或者多維陣列。例如::

		$list = array(
			'red',
			'blue',
			'green',
			'yellow'
		);

		$attributes = array(
			'class'	=> 'boldlist',
			'id'	=> 'mylist'
		);

		echo ul($list, $attributes);

	上面的程式碼將產生：

	.. code-block:: html

		<ul class="boldlist" id="mylist">
			<li>red</li>
			<li>blue</li>
			<li>green</li>
			<li>yellow</li>
		</ul>

	下面是個更複雜的範例，使用了多維陣列::

		$attributes = array(
			'class'	=> 'boldlist',
			'id'	=> 'mylist'
		);

		$list = array(
			'colors'  => array(
				'red',
				'blue',
				'green'
			),
			'shapes'  => array(
				'round',
				'square',
				'circles' => array(
					'ellipse',
					'oval',
					'sphere'
				)
			),
			'moods'  => array(
				'happy',
				'upset' => array(
					'defeated' => array(
						'dejected',
						'disheartened',
						'depressed'
					),
					'annoyed',
					'cross',
					'angry'
				)
			)
		);

		echo ul($list, $attributes);

	上面的程式碼將產生：

	.. code-block:: html

		<ul class="boldlist" id="mylist">
			<li>colors
				<ul>
					<li>red</li>
					<li>blue</li>
					<li>green</li>
				</ul>
			</li>
			<li>shapes
				<ul>
					<li>round</li>
					<li>suare</li>
					<li>circles
						<ul>
							<li>elipse</li>
							<li>oval</li>
							<li>sphere</li>
						</ul>
					</li>
				</ul>
			</li>
			<li>moods
				<ul>
					<li>happy</li>
					<li>upset
						<ul>
							<li>defeated
								<ul>
									<li>dejected</li>
									<li>disheartened</li>
									<li>depressed</li>
								</ul>
							</li>
							<li>annoyed</li>
							<li>cross</li>
							<li>angry</li>
						</ul>
					</li>
				</ul>
			</li>
		</ul>

.. php:function:: ol($list, $attributes = '')

	:param	array	$list: List entries
	:param	array	$attributes: HTML attributes
	:returns:	HTML-formatted ordered list
	:rtype:	string

	和 :php:func:`ul()` 函數一樣，只是它產生的是有序清單（ <ol> ）。

.. php:function:: meta([$name = ''[, $content = ''[, $type = 'name'[, $newline = "\n"]]]])

	:param	string	$name: Meta name
	:param	string	$content: Meta content
	:param	string	$type: Meta type
	:param	string	$newline: Newline character
	:returns:	HTML meta tag
	:rtype:	string

	用於產生 meta 標籤，您可以傳遞一個字元串參數，或者一個陣列，或者一個多維陣列。

	例如::

		echo meta('description', 'My Great site');
		// Generates:  <meta name="description" content="My Great Site" />

		echo meta('Content-type', 'text/html; charset=utf-8', 'equiv');
		// Note the third parameter.  Can be "equiv" or "name"
		// Generates:  <meta http-equiv="Content-type" content="text/html; charset=utf-8" />

		echo meta(array('name' => 'robots', 'content' => 'no-cache'));
		// Generates:  <meta name="robots" content="no-cache" />

		$meta = array(
			array(
				'name' => 'robots',
				'content' => 'no-cache'
			),
			array(
				'name' => 'description',
				'content' => 'My Great Site'
			),
			array(
				'name' => 'keywords',
				'content' => 'love, passion, intrigue, deception'
			),
			array(
				'name' => 'robots',
				'content' => 'no-cache'
			),
			array(
				'name' => 'Content-type',
				'content' => 'text/html; charset=utf-8', 'type' => 'equiv'
			)
		);

		echo meta($meta);
		// Generates:
		// <meta name="robots" content="no-cache" />
		// <meta name="description" content="My Great Site" />
		// <meta name="keywords" content="love, passion, intrigue, deception" />
		// <meta name="robots" content="no-cache" />
		// <meta http-equiv="Content-type" content="text/html; charset=utf-8" />


.. php:function:: doctype([$type = 'xhtml1-strict'])

	:param	string	$type: Doctype name
	:returns:	HTML DocType tag
	:rtype:	string

	用於產生 DTD （文件類型聲明，document type declaration），預設使用的是 XHTML 1.0 Strict ，但是您也可以選擇其他的。

	例如::

		echo doctype(); // <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">

		echo doctype('html4-trans'); // <!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">

	下表是可選的文件類型，它是可設定的，您可以在 application/config/doctypes.php 文件中找到它。

	=============================== =================== ==================================================================================================================================================
	文件類型                        選項                 結果
	=============================== =================== ==================================================================================================================================================
	XHTML 1.1                       xhtml11             <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
	XHTML 1.0 Strict                xhtml1-strict       <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
	XHTML 1.0 Transitional          xhtml1-trans        <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
	XHTML 1.0 Frameset              xhtml1-frame        <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Frameset//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-frameset.dtd">
	XHTML Basic 1.1                 xhtml-basic11       <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML Basic 1.1//EN" "http://www.w3.org/TR/xhtml-basic/xhtml-basic11.dtd">
	HTML 5                          html5               <!DOCTYPE html>
	HTML 4 Strict                   html4-strict        <!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
	HTML 4 Transitional             html4-trans         <!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
	HTML 4 Frameset                 html4-frame         <!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN" "http://www.w3.org/TR/html4/frameset.dtd">
	MathML 1.01                     mathml1             <!DOCTYPE math SYSTEM "http://www.w3.org/Math/DTD/mathml1/mathml.dtd">
	MathML 2.0                      mathml2             <!DOCTYPE math PUBLIC "-//W3C//DTD MathML 2.0//EN" "http://www.w3.org/Math/DTD/mathml2/mathml2.dtd">
	SVG 1.0                         svg10               <!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.0//EN" "http://www.w3.org/TR/2001/REC-SVG-20010904/DTD/svg10.dtd">
	SVG 1.1 Full                    svg11               <!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1//EN" "http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd">
	SVG 1.1 Basic                   svg11-basic         <!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1 Basic//EN" "http://www.w3.org/Graphics/SVG/1.1/DTD/svg11-basic.dtd">
	SVG 1.1 Tiny                    svg11-tiny          <!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1 Tiny//EN" "http://www.w3.org/Graphics/SVG/1.1/DTD/svg11-tiny.dtd">
	XHTML+MathML+SVG (XHTML host)   xhtml-math-svg-xh   <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1 plus MathML 2.0 plus SVG 1.1//EN" "http://www.w3.org/2002/04/xhtml-math-svg/xhtml-math-svg.dtd">
	XHTML+MathML+SVG (SVG host)     xhtml-math-svg-sh   <!DOCTYPE svg:svg PUBLIC "-//W3C//DTD XHTML 1.1 plus MathML 2.0 plus SVG 1.1//EN" "http://www.w3.org/2002/04/xhtml-math-svg/xhtml-math-svg.dtd">
	XHTML+RDFa 1.0                  xhtml-rdfa-1        <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML+RDFa 1.0//EN" "http://www.w3.org/MarkUp/DTD/xhtml-rdfa-1.dtd">
	XHTML+RDFa 1.1                  xhtml-rdfa-2        <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML+RDFa 1.1//EN" "http://www.w3.org/MarkUp/DTD/xhtml-rdfa-2.dtd">
	=============================== =================== ==================================================================================================================================================

.. php:function:: br([$count = 1])

	:param	int	$count: Number of times to repeat the tag
	:returns:	HTML line break tag
	:rtype:	string

	依據指定的個數產生多個換行標籤（ <br /> ）。
	例如::

		echo br(3);

	上面的程式碼將產生：

	.. code-block:: html

		<br /><br /><br />

	.. note:: 該函數已經廢棄，請使用原生的 ``str_repeat()`` 函數代替。

.. php:function:: nbs([$num = 1])

	:param	int	$num: Number of space entities to produce
	:returns:	A sequence of non-breaking space HTML entities
	:rtype:	string

	依據指定的個數產生多個不換行空格（&nbsp;）。
	例如::

		echo nbs(3);

	上面的程式碼將產生：

	.. code-block:: html

		&nbsp;&nbsp;&nbsp;

	.. note:: 該函數已經廢棄，請使用原生的 ``str_repeat()`` 函數代替。
