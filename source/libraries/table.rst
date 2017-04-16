################
HTML 表格類
################

表格類提供了一些成員函數用於依據陣列或資料庫結果集自動產生 HTML 的表格。

.. contents::
  :local:

.. raw:: html

  <div class="custom-index container"></div>

*********************
使用表格類
*********************

初始化類
======================

跟 CodeIgniter 中的其他類一樣，可以在您的控制器中使用 ``$this->load->library()`` 
成員函數載入表格類::

	$this->load->library('table');

一旦載入，表格類就可以像下面這樣使用::

	$this->table

範例
========

下面這個範例向您演示了如何通過多維陣列來建立一個表格。注意陣列的第一行將會變成
表格的表頭（或者您也可以通過下面介紹的 ``set_heading()`` 成員函數來設定您自己的表頭）。

::

	$this->load->library('table');

	$data = array(
		array('Name', 'Color', 'Size'),
		array('Fred', 'Blue', 'Small'),
		array('Mary', 'Red', 'Large'),
		array('John', 'Green', 'Medium')	
	);

	echo $this->table->generate($data);

下面這個範例是通過資料庫查詢結果來建立一個表格。表格類將使用查詢結果的列名自動產生表頭
（或者您也可以通過下面介紹的 ``set_heading()`` 成員函數來設定您自己的表頭）。

::

	$this->load->library('table');

	$query = $this->db->query('SELECT * FROM my_table');

	echo $this->table->generate($query);

下面這個範例演示了如何使用分開的參數來產生表格::

	$this->load->library('table');

	$this->table->set_heading('Name', 'Color', 'Size');

	$this->table->add_row('Fred', 'Blue', 'Small');
	$this->table->add_row('Mary', 'Red', 'Large');
	$this->table->add_row('John', 'Green', 'Medium');

	echo $this->table->generate();

下面這個範例和上面的一樣，但是它不是使用分開的參數，而是使用了陣列::

	$this->load->library('table');

	$this->table->set_heading(array('Name', 'Color', 'Size'));

	$this->table->add_row(array('Fred', 'Blue', 'Small'));
	$this->table->add_row(array('Mary', 'Red', 'Large'));
	$this->table->add_row(array('John', 'Green', 'Medium'));

	echo $this->table->generate();

修改表格樣式
===============================

表格類可以允許您設定一個表格的模板，您可以通過它設計表格的樣式，下面是模板的原型::

	$template = array(
		'table_open'		=> '<table border="0" cellpadding="4" cellspacing="0">',

		'thead_open'		=> '<thead>',
		'thead_close'		=> '</thead>',

		'heading_row_start'	=> '<tr>',
		'heading_row_end'	=> '</tr>',
		'heading_cell_start'	=> '<th>',
		'heading_cell_end'	=> '</th>',

		'tbody_open'		=> '<tbody>',
		'tbody_close'		=> '</tbody>',

		'row_start'		=> '<tr>',
		'row_end'		=> '</tr>',
		'cell_start'		=> '<td>',
		'cell_end'		=> '</td>',

		'row_alt_start'		=> '<tr>',
		'row_alt_end'		=> '</tr>',
		'cell_alt_start'	=> '<td>',
		'cell_alt_end'		=> '</td>',

		'table_close'		=> '</table>'
	);

	$this->table->set_template($template);

.. note:: 您會發現模板中有兩個 "row" 程式碼塊，它可以讓您的表格每行使用交替的顏色，
	或者其他的這種隔行的設計元素。

您不用設定整個模板，只需要設定您想修改的部分即可。在下面這個範例中，只有 table 的起始標籤需要修改::

	$template = array(
		'table_open' => '<table border="1" cellpadding="2" cellspacing="1" class="mytable">'
	);

	$this->table->set_template($template);
	
您也可以在設定文件中設定預設的模板。

***************
類參考
***************

.. php:class:: CI_Table

	.. attribute:: $function = NULL

		允許您指定一個原生的 PHP 函數或一個有效的函數陣列物件，該函數會作用於所有的單元格資料。
		::

			$this->load->library('table');

			$this->table->set_heading('Name', 'Color', 'Size');
			$this->table->add_row('Fred', '<strong>Blue</strong>', 'Small');

			$this->table->function = 'htmlspecialchars';
			echo $this->table->generate();

		上例中，所有的單元格資料都會先通過 PHP 的 :php:func:`htmlspecialchars()` 函數，結果如下::

			<td>Fred</td><td>&lt;strong&gt;Blue&lt;/strong&gt;</td><td>Small</td>

	.. php:method:: generate([$table_data = NULL])

		:param	mixed	$table_data: Data to populate the table rows with
		:returns:	HTML table
		:rtype:	string

		傳回產生的表格的字元串。 接受一個可選的參數，該參數可以是一個陣列或是從資料庫讀取的結果物件。

	.. php:method:: set_caption($caption)

		:param	string	$caption: Table caption
		:returns:	CI_Table instance (method chaining)
		:rtype:	CI_Table

		允許您給表格加入一個標題。
		::

			$this->table->set_caption('Colors');

	.. php:method:: set_heading([$args = array()[, ...]])

		:param	mixed	$args: An array or multiple strings containing the table column titles
		:returns:	CI_Table instance (method chaining)
		:rtype:	CI_Table

		允許您設定表格的表頭。您可以送出一個陣列或分開的參數：

			$this->table->set_heading('Name', 'Color', 'Size');

			$this->table->set_heading(array('Name', 'Color', 'Size'));

	.. php:method:: add_row([$args = array()[, ...]])

		:param	mixed	$args: An array or multiple strings containing the row values
		:returns:	CI_Table instance (method chaining)
		:rtype:	CI_Table

		允許您在您的表格中加入一行。您可以送出一個陣列或分開的參數：

			$this->table->add_row('Blue', 'Red', 'Green');

			$this->table->add_row(array('Blue', 'Red', 'Green'));

		如果您想要唯一設定一個單元格的屬性，您可以使用一個關聯陣列。關聯陣列的鍵名 **data** 定義了這個單元格的資料。
		其它的鍵值對 key => val 將會以 key='val' 的形式被加入為該單元格的屬性裡：

			$cell = array('data' => 'Blue', 'class' => 'highlight', 'colspan' => 2);
			$this->table->add_row($cell, 'Red', 'Green');

			// generates
			// <td class='highlight' colspan='2'>Blue</td><td>Red</td><td>Green</td>

	.. php:method:: make_columns([$array = array()[, $col_limit = 0]])

		:param	array	$array: An array containing multiple rows' data
		:param	int	$col_limit: Count of columns in the table
		:returns:	An array of HTML table columns
		:rtype:	array

		這個函數以一個一維陣列為輸入，建立一個多維陣列，它的深度（譯註：不是行數，而是每一行的元素個數）和列數一樣。
		這個函數可以把一個含有多個元素的陣列按指定列在表格中顯示出來。參考下面的範例:

			$list = array('one', 'two', 'three', 'four', 'five', 'six', 'seven', 'eight', 'nine', 'ten', 'eleven', 'twelve');

			$new_list = $this->table->make_columns($list, 3);

			$this->table->generate($new_list);

			// Generates a table with this prototype

			<table border="0" cellpadding="4" cellspacing="0">
			<tr>
			<td>one</td><td>two</td><td>three</td>
			</tr><tr>
			<td>four</td><td>five</td><td>six</td>
			</tr><tr>
			<td>seven</td><td>eight</td><td>nine</td>
			</tr><tr>
			<td>ten</td><td>eleven</td><td>twelve</td></tr>
			</table>


	.. php:method:: set_template($template)

		:param	array	$template: An associative array containing template values
		:returns:	TRUE on success, FALSE on failure
		:rtype:	bool

		允許您設定您的模板。您可以送出整個模板或部分模板。
		::

			$template = array(
				'table_open'  => '<table border="1" cellpadding="2" cellspacing="1" class="mytable">'
			);
		
			$this->table->set_template($template);

	.. php:method:: set_empty($value)

		:param	mixed	$value: Value to put in empty cells
		:returns:	CI_Table instance (method chaining)
		:rtype:	CI_Table

		用於設定當表格中的單元格為空時要顯示的預設值。例如，設定一個不換行空格（NBSP，non-breaking space）::

			$this->table->set_empty("&nbsp;");

	.. php:method:: clear()

		:returns:	CI_Table instance (method chaining)
		:rtype:	CI_Table

		使您能清除表格的表頭和行中的資料。如果您需要顯示多個有不同資料的表格，
		那麼您需要在每個表格產生之後呼叫這個函數來清除之前表格的資訊。例如：

			$this->load->library('table');

			$this->table->set_heading('Name', 'Color', 'Size');
			$this->table->add_row('Fred', 'Blue', 'Small');
			$this->table->add_row('Mary', 'Red', 'Large');
			$this->table->add_row('John', 'Green', 'Medium');

			echo $this->table->generate();

			$this->table->clear();

			$this->table->set_heading('Name', 'Day', 'Delivery');
			$this->table->add_row('Fred', 'Wednesday', 'Express');
			$this->table->add_row('Mary', 'Monday', 'Air');
			$this->table->add_row('John', 'Saturday', 'Overnight');

			echo $this->table->generate();
