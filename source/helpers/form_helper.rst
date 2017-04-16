###############
表單輔助函數
###############

表單輔助函數包含了一些函數用於幫助您處理表單。

.. contents::
  :local:

.. raw:: html

  <div class="custom-index container"></div>

載入輔助函數
===================

使用下面的程式碼來載入表單輔助函數::

	$this->load->helper('form');

對域值轉義
=====================

您可能會需要在表單元素中使用 HTML 或者諸如引號這樣的字元，為了安全性，
您需要使用 :doc:`通用函數 <../general/common_functions>` :func:`html_escape()` 。

考慮下面這個範例::

	$string = 'Here is a string containing "quoted" text.';

	<input type="text" name="myfield" value="<?php echo $string; ?>" />

因為上面的字元串中包含了一對引號，它會破壞表單，使用 :php:func:`html_escape()`
函數可以對 HTML 的特殊字元進行轉義，從而可以安全的在域值中使用字元串::

	<input type="text" name="myfield" value="<?php echo html_escape($string); ?>" />

.. note:: 如果您使用了這個頁面上介紹的任何一個函數，表單的域值會被自動轉義，
	所以您無需再呼叫這個函數。只有在您建立自己的表單元素時需要使用它。

可用函數
===================

該輔助函數有下列可用函數：

.. php:function:: form_open([$action = ''[, $attributes = ''[, $hidden = array()]]])

	:param	string	$action: Form action/target URI string
	:param	array	$attributes: HTML attributes
	:param	array	$hidden: An array of hidden fields' definitions
	:returns:	An HTML form opening tag
	:rtype:	string

	產生一個 form 起始標籤，並且它的 action URL 會依據您的設定文件自動產生。
	您還可以給表單加入屬性和隱藏域，另外，它還會依據您設定文件中的字元集參數
	自動產生 `accept-charset` 屬性。

	使用該函數來產生標籤比您自己寫 HTML 程式碼最大的好處是：當您的 URL 變動時，
	它可以提供更好的可移植性。

	這裡是個簡單的範例::

		echo form_open('email/send');

	上面的程式碼會建立一個表單，它的 action 為根 URL 加上 "email/send"，向下面這樣::

		<form method="post" accept-charset="utf-8" action="http://example.com/index.php/email/send">

	**加入屬性**

		可以通過第二個參數傳遞一個關聯陣列來加入屬性，例如::

			$attributes = array('class' => 'email', 'id' => 'myform');
			echo form_open('email/send', $attributes);

		另外，第二個參數您也可以直接使用字元串::

			echo form_open('email/send', 'class="email" id="myform"');

		上面的程式碼會建立一個類似於下面的表單::

			<form method="post" accept-charset="utf-8" action="http://example.com/index.php/email/send" class="email" id="myform">

	**加入隱藏域**

		可以通過第三個參數傳遞一個關聯陣列來加入隱藏域，例如::

			$hidden = array('username' => 'Joe', 'member_id' => '234');
			echo form_open('email/send', '', $hidden);

		您可以使用一個空值跳過第二個參數。

		上面的程式碼會建立一個類似於下面的表單::

			<form method="post" accept-charset="utf-8" action="http://example.com/index.php/email/send">
				<input type="hidden" name="username" value="Joe" />
				<input type="hidden" name="member_id" value="234" />


.. php:function:: form_open_multipart([$action = ''[, $attributes = array()[, $hidden = array()]]])

	:param	string	$action: Form action/target URI string
	:param	array	$attributes: HTML attributes
	:param	array	$hidden: An array of hidden fields' definitions
	:returns:	An HTML multipart form opening tag
	:rtype:	string

	這個函數和上面的 :php:func:`form_open()` 函數完全一樣，
	只是它會給表單加入一個 *multipart* 屬性，在您使用表單上傳文件時必須使用它。


.. php:function:: form_hidden($name[, $value = ''])

	:param	string	$name: Field name
	:param	string	$value: Field value
	:returns:	An HTML hidden input field tag
	:rtype:	string

	產生隱藏域。您可以使用名稱和值兩個參數來建立一個隱藏域::

		form_hidden('username', 'johndoe');
		// Would produce: <input type="hidden" name="username" value="johndoe" />

	... 或者您可以使用一個關聯陣列，來產生多個隱藏域::

		$data = array(
			'name'	=> 'John Doe',
			'email'	=> 'john@example.com',
			'url'	=> 'http://example.com'
		);

		echo form_hidden($data);

		/*
			Would produce:
			<input type="hidden" name="name" value="John Doe" />
			<input type="hidden" name="email" value="john@example.com" />
			<input type="hidden" name="url" value="http://example.com" />
		*/

	您還可以向第二個參數傳遞一個關聯陣列::

		$data = array(
			'name'	=> 'John Doe',
			'email'	=> 'john@example.com',
			'url'	=> 'http://example.com'
		);

		echo form_hidden('my_array', $data);

		/*
			Would produce:

			<input type="hidden" name="my_array[name]" value="John Doe" />
			<input type="hidden" name="my_array[email]" value="john@example.com" />
			<input type="hidden" name="my_array[url]" value="http://example.com" />
		*/

	如果您想建立帶有其他屬性的隱藏域，可以這樣::

		$data = array(
			'type'	=> 'hidden',
			'name'	=> 'email',
			'id'	=> 'hiddenemail',
			'value'	=> 'john@example.com',
			'class'	=> 'hiddenemail'
		);

		echo form_input($data);

		/*
			Would produce:

			<input type="hidden" name="email" value="john@example.com" id="hiddenemail" class="hiddenemail" />
		*/

.. php:function:: form_input([$data = ''[, $value = ''[, $extra = '']]])

	:param	array	$data: Field attributes data
	:param	string	$value: Field value
	:param	mixed	$extra: Extra attributes to be added to the tag either as an array or a literal string
	:returns:	An HTML text input field tag
	:rtype:	string

	用於產生標準的文字輸入框，您可以簡單的使用文字域的名稱和值::

		echo form_input('username', 'johndoe');

	或者使用一個關聯陣列，來包含任何您想要的資料::

		$data = array(
			'name'		=> 'username',
			'id'		=> 'username',
			'value'		=> 'johndoe',
			'maxlength'	=> '100',
			'size'		=> '50',
			'style'		=> 'width:50%'
		);

		echo form_input($data);

		/*
			Would produce:

			<input type="text" name="username" value="johndoe" id="username" maxlength="100" size="50" style="width:50%"  />
		*/

	如果您還希望能包含一些額外的資料，例如 JavaScript ，您可以通過第三個參數傳一個字元串::

		$js = 'onClick="some_function()"';
		echo form_input('username', 'johndoe', $js);

	Or you can pass it as an array::

		$js = array('onClick' => 'some_function();');
		echo form_input('username', 'johndoe', $js);

.. php:function:: form_password([$data = ''[, $value = ''[, $extra = '']]])

	:param	array	$data: Field attributes data
	:param	string	$value: Field value
	:param	mixed	$extra: Extra attributes to be added to the tag either as an array or a literal string
	:returns:	An HTML password input field tag
	:rtype:	string

	該函數和上面的 :php:func:`form_input()` 函數一樣，只是產生的輸入框為 "password" 類型。


.. php:function:: form_upload([$data = ''[, $value = ''[, $extra = '']]])

	:param	array	$data: Field attributes data
	:param	string	$value: Field value
	:param	mixed	$extra: Extra attributes to be added to the tag either as an array or a literal string
	:returns:	An HTML file upload input field tag
	:rtype:	string

	該函數和上面的 :php:func:`form_input()` 函數一樣，只是產生的輸入框為 "file" 類型，
	可以用來上傳文件。


.. php:function:: form_textarea([$data = ''[, $value = ''[, $extra = '']]])

	:param	array	$data: Field attributes data
	:param	string	$value: Field value
	:param	mixed	$extra: Extra attributes to be added to the tag either as an array or a literal string
	:returns:	An HTML textarea tag
	:rtype:	string

	該函數和上面的 :php:func:`form_input()` 函數一樣，只是產生的輸入框為 "textarea" 類型。

	.. note:: 對於 textarea 類型的輸入框，您可以使用 *rows* 和 *cols* 屬性，
		來代替上面範例中的 *maxlength* 和 *size* 屬性。

.. php:function:: form_dropdown([$name = ''[, $options = array()[, $selected = array()[, $extra = '']]]])

	:param	string	$name: Field name
	:param	array	$options: An associative array of options to be listed
	:param	array	$selected: List of fields to mark with the *selected* attribute
	:param	mixed	$extra: Extra attributes to be added to the tag either as an array or a literal string
	:returns:	An HTML dropdown select field tag
	:rtype:	string

	用於產生一個標準的下拉框域。第一個參數為域的名稱，第二個參數為一個關聯陣列，
	包含所有的選項，第三個參數為您希望預設選中的值。您也可以把第三個參數設定成
	一個包含多個值的陣列，CodeIgniter 將會為您產生多選下拉框。

	例如::

		$options = array(
			'small'		=> 'Small Shirt',
			'med'		=> 'Medium Shirt',
			'large'		=> 'Large Shirt',
			'xlarge'	=> 'Extra Large Shirt',
		);

		$shirts_on_sale = array('small', 'large');
		echo form_dropdown('shirts', $options, 'large');

		/*
			Would produce:

			<select name="shirts">
				<option value="small">Small Shirt</option>
				<option value="med">Medium  Shirt</option>
				<option value="large" selected="selected">Large Shirt</option>
				<option value="xlarge">Extra Large Shirt</option>
			</select>
		*/

		echo form_dropdown('shirts', $options, $shirts_on_sale);

		/*
			Would produce:

			<select name="shirts" multiple="multiple">
				<option value="small" selected="selected">Small Shirt</option>
				<option value="med">Medium  Shirt</option>
				<option value="large" selected="selected">Large Shirt</option>
				<option value="xlarge">Extra Large Shirt</option>
			</select>
		*/

	如果您希望為起始標籤 <select> 加入一些額外的資料，例如 id 屬性或 JavaScript ，
	您可以通過第四個參數傳一個字元串::

		$js = 'id="shirts" onChange="some_function();"';
		echo form_dropdown('shirts', $options, 'large', $js);

	Or you can pass it as an array::

		$js = array(
			'id'       => 'shirts',
			'onChange' => 'some_function();'
		);
		echo form_dropdown('shirts', $options, 'large', $js);

	如果您傳遞的 ``$options`` 陣列是個多維陣列，``form_dropdown()`` 函數將會產生帶
	<optgroup> 的下拉框，並使用陣列的鍵作為 label 。


.. php:function:: form_multiselect([$name = ''[, $options = array()[, $selected = array()[, $extra = '']]]])

	:param	string	$name: Field name
	:param	array	$options: An associative array of options to be listed
	:param	array	$selected: List of fields to mark with the *selected* attribute
	:param	mixed	$extra: Extra attributes to be added to the tag either as an array or a literal string
	:returns:	An HTML dropdown multiselect field tag
	:rtype:	string

	用於產生一個標準的多選下拉框。第一個參數為域的名稱，第二個參數為一個關聯陣列，
	包含所有的選項，第三個參數為您希望預設選中的一個或多個值。

	參數的用法和上面的 :php:func:`form_dropdown()` 函數一樣，只是域的名稱需要使用
	陣列語法，例如：foo[]


.. php:function:: form_fieldset([$legend_text = ''[, $attributes = array()]])

	:param	string	$legend_text: Text to put in the <legend> tag
	:param	array	$attributes: Attributes to be set on the <fieldset> tag
	:returns:	An HTML fieldset opening tag
	:rtype:	string

	用於產生 fieldset 和 legend 域。

	例如::

		echo form_fieldset('Address Information');
		echo "<p>fieldset content here</p>\n";
		echo form_fieldset_close();

		/*
			Produces:

				<fieldset>
					<legend>Address Information</legend>
						<p>form content here</p>
				</fieldset>
		*/

	和其他的函數類似，您也可以通過給第二個參數傳一個關聯陣列來加入額外的屬性::

		$attributes = array(
			'id'	=> 'address_info',
			'class'	=> 'address_info'
		);

		echo form_fieldset('Address Information', $attributes);
		echo "<p>fieldset content here</p>\n";
		echo form_fieldset_close();

		/*
			Produces:

			<fieldset id="address_info" class="address_info">
				<legend>Address Information</legend>
				<p>form content here</p>
			</fieldset>
		*/


.. php:function:: form_fieldset_close([$extra = ''])

	:param	string	$extra: Anything to append after the closing tag, *as is*
	:returns:	An HTML fieldset closing tag
	:rtype:	string


	用於產生結束標籤 </fieldset> ，使用這個函數唯一的一個好處是，
	它可以在結束標籤的後面加上一些其他的資料。例如：

	::

		$string = '</div></div>';
		echo form_fieldset_close($string);
		// Would produce: </fieldset></div></div>


.. php:function:: form_checkbox([$data = ''[, $value = ''[, $checked = FALSE[, $extra = '']]]])

	:param	array	$data: Field attributes data
	:param	string	$value: Field value
	:param	bool	$checked: Whether to mark the checkbox as being *checked*
	:param	mixed	$extra: Extra attributes to be added to the tag either as an array or a literal string
	:returns:	An HTML checkbox input tag
	:rtype:	string

	用於產生一個復選框，例如::

		echo form_checkbox('newsletter', 'accept', TRUE);
		// Would produce:  <input type="checkbox" name="newsletter" value="accept" checked="checked" />

	第三個參數為布林值 TRUE 或 FALSE ，用於指定復選框預設是否為選定狀態。

	和其他函數一樣，您可以傳一個屬性的陣列給它::

		$data = array(
			'name'		=> 'newsletter',
			'id'		=> 'newsletter',
			'value'		=> 'accept',
			'checked'	=> TRUE,
			'style'		=> 'margin:10px'
		);

		echo form_checkbox($data);
		// Would produce: <input type="checkbox" name="newsletter" id="newsletter" value="accept" checked="checked" style="margin:10px" />

	另外，如果您希望向標籤中加入額外的資料如 JavaScript ，也可以傳一個字元串給第四個參數::

		$js = 'onClick="some_function()"';
		echo form_checkbox('newsletter', 'accept', TRUE, $js);

	Or you can pass it as an array::

		$js = array('onClick' => 'some_function();');
		echo form_checkbox('newsletter', 'accept', TRUE, $js);

.. php:function:: form_radio([$data = ''[, $value = ''[, $checked = FALSE[, $extra = '']]]])

	:param	array	$data: Field attributes data
	:param	string	$value: Field value
	:param	bool	$checked: Whether to mark the radio button as being *checked*
	:param	mixed	$extra: Extra attributes to be added to the tag either as an array or a literal string
	:returns:	An HTML radio input tag
	:rtype:	string

	該函數和 :php:func:`form_checkbox()` 函數完全一樣，只是它產生的是單選框。


.. php:function:: form_label([$label_text = ''[, $id = ''[, $attributes = array()]]])

	:param	string	$label_text: Text to put in the <label> tag
	:param	string	$id: ID of the form element that we're making a label for
	:param	string	$attributes: HTML attributes
	:returns:	An HTML field label tag
	:rtype:	string

	產生 <label> 標籤，例如::

		echo form_label('What is your Name', 'username');
		// Would produce:  <label for="username">What is your Name</label>

	和其他的函數一樣，如果您想加入額外的屬性的話，可以傳一個關聯陣列給第三個參數。

	例如::

		$attributes = array(
			'class' => 'mycustomclass',
			'style' => 'color: #000;'
		);

		echo form_label('What is your Name', 'username', $attributes);
		// Would produce:  <label for="username" class="mycustomclass" style="color: #000;">What is your Name</label>


.. php:function:: form_submit([$data = ''[, $value = ''[, $extra = '']]])

	:param	string	$data: Button name
	:param	string	$value: Button value
	:param	mixed	$extra: Extra attributes to be added to the tag either as an array or a literal string
	:returns:	An HTML input submit tag
	:rtype:	string

	用於產生一個標準的送出按鈕。例如::

		echo form_submit('mysubmit', 'Submit Post!');
		// Would produce:  <input type="submit" name="mysubmit" value="Submit Post!" />

	和其他的函數一樣，如果您想加入額外的屬性的話，可以傳一個關聯陣列給第一個參數，
	第三個參數可以向表單加入額外的資料，例如 JavaScript 。


.. php:function:: form_reset([$data = ''[, $value = ''[, $extra = '']]])

	:param	string	$data: Button name
	:param	string	$value: Button value
	:param	mixed	$extra: Extra attributes to be added to the tag either as an array or a literal string
	:returns:	An HTML input reset button tag
	:rtype:	string

	用於產生一個標準的重置按鈕。用法和 :func:`form_submit()` 函數一樣。


.. php:function:: form_button([$data = ''[, $content = ''[, $extra = '']]])

	:param	string	$data: Button name
	:param	string	$content: Button label
	:param	mixed	$extra: Extra attributes to be added to the tag either as an array or a literal string
	:returns:	An HTML button tag
	:rtype:	string

	用於產生一個標準的按鈕，您可以簡單的使用名稱和內容來產生按鈕::

		echo form_button('name','content');
		// Would produce: <button name="name" type="button">Content</button>

	或者使用一個關聯陣列，來包含任何您想要的資料::

		$data = array(
			'name'		=> 'button',
			'id'		=> 'button',
			'value'		=> 'true',
			'type'		=> 'reset',
			'content'	=> 'Reset'
		);

		echo form_button($data);
		// Would produce: <button name="button" id="button" value="true" type="reset">Reset</button>

	如果您還希望能包含一些額外的資料，例如 JavaScript ，您可以通過第三個參數傳一個字元串::

		$js = 'onClick="some_function()"';
		echo form_button('mybutton', 'Click Me', $js);


.. php:function:: form_close([$extra = ''])

	:param	string	$extra: Anything to append after the closing tag, *as is*
	:returns:	An HTML form closing tag
	:rtype:	string

	用於產生結束標籤 </form> ，使用這個函數唯一的一個好處是，
	它可以在結束標籤的後面加上一些其他的資料。例如：

		$string = '</div></div>';
		echo form_close($string);
		// Would produce:  </form> </div></div>


.. php:function:: set_value($field[, $default = ''[, $html_escape = TRUE]])

	:param	string	$field: Field name
	:param	string	$default: Default value
	:param  bool	$html_escape: Whether to turn off HTML escaping of the value
	:returns:	Field value
	:rtype:	string

	用於您顯示 input 或者 textarea 類型的輸入框的值。您必須在第一個參數中指定名稱，
	第二個參數是可選的，允許您設定一個預設值，第三個參數也是可選，可以停用對值的轉義，
	當您在和 :php:func:`form_input()` 函數一起使用時，可以避免重複轉義。

	例如::

		<input type="text" name="quantity" value="<?php echo set_value('quantity', '0'); ?>" size="50" />

	當上面的表單元素第一次載入時將會顯示「0」。

	.. note:: If you've loaded the :doc:`表單驗證類 <../libraries/form_validation>` and
		have set a validation rule for the field name in use with this helper, then it will
		forward the call to the :doc:`表單驗證類 <../libraries/form_validation>`'s
		own ``set_value()`` method. Otherwise, this function looks in ``$_POST`` for the
		field value.

.. php:function:: set_select($field[, $value = ''[, $default = FALSE]])

	:param	string	$field: Field name
	:param	string	$value: Value to check for
	:param	string	$default: Whether the value is also a default one
	:returns:	'selected' attribute or an empty string
	:rtype:	string

	如果您使用 <select> 下拉菜單，此函數允許您顯示選中的菜單項。

	第一個參數為下拉菜單的名稱，第二個參數必須包含每個菜單項的值。
	第三個參數是可選的，用於設定菜單項是否為預設選中狀態（TRUE / FALSE）。

	例如::

		<select name="myselect">
			<option value="one" <?php echo  set_select('myselect', 'one', TRUE); ?> >One</option>
			<option value="two" <?php echo  set_select('myselect', 'two'); ?> >Two</option>
			<option value="three" <?php echo  set_select('myselect', 'three'); ?> >Three</option>
		</select>

.. php:function:: set_checkbox($field[, $value = ''[, $default = FALSE]])

	:param	string	$field: Field name
	:param	string	$value: Value to check for
	:param	string	$default: Whether the value is also a default one
	:returns:	'checked' attribute or an empty string
	:rtype:	string

	允許您顯示一個處於送出狀態的復選框。

	第一個參數必須包含此復選框的名稱，第二個參數必須包含它的值，
	第三個參數是可選的，用於設定復選框是否為預設選中狀態（TRUE / FALSE）。

	例如::

		<input type="checkbox" name="mycheck" value="1" <?php echo set_checkbox('mycheck', '1'); ?> />
		<input type="checkbox" name="mycheck" value="2" <?php echo set_checkbox('mycheck', '2'); ?> />

.. php:function:: set_radio($field[, $value = ''[, $default = FALSE]])

	:param	string	$field: Field name
	:param	string	$value: Value to check for
	:param	string	$default: Whether the value is also a default one
	:returns:	'checked' attribute or an empty string
	:rtype:	string

	允許您顯示那些處於送出狀態的單選框。
	該函數和上面的 :php:func:`set_checkbox()` 函數一樣。

	例如::

		<input type="radio" name="myradio" value="1" <?php echo  set_radio('myradio', '1', TRUE); ?> />
		<input type="radio" name="myradio" value="2" <?php echo  set_radio('myradio', '2'); ?> />

	.. note:: 如果您正在使用表單驗證類，您必須為您的每一個表單域指定一個規則，
		即使是空的，這樣可以確保 ``set_*()`` 函數能正常執行。
		這是因為如果定義了一個表單驗證物件，``set_*()`` 函數的控制權將移交到表單驗證類，
		而不是輔助函數函數。

.. php:function:: form_error([$field = ''[, $prefix = ''[, $suffix = '']]])

	:param	string	$field:	Field name
	:param	string	$prefix: Error opening tag
	:param	string	$suffix: Error closing tag
	:returns:	HTML-formatted form validation error message(s)
	:rtype:	string

	從 :doc:`表單驗證類 <../libraries/form_validation>` 傳回驗證錯誤消息，
	並附上驗證出錯的域的名稱，您可以設定錯誤消息的起始和結束標籤。

	例如::

		// Assuming that the 'username' field value was incorrect:
		echo form_error('myfield', '<div class="error">', '</div>');

		// Would produce: <div class="error">Error message associated with the "username" field.</div>


.. php:function:: validation_errors([$prefix = ''[, $suffix = '']])

	:param	string	$prefix: Error opening tag
	:param	string	$suffix: Error closing tag
	:returns:	HTML-formatted form validation error message(s)
	:rtype:	string

	和 :php:func:`form_error()` 函數類似，傳回所有 :doc:`表單驗證類 <../libraries/form_validation>`
	產生的錯誤資訊，您可以為為每個錯誤消息設定起始和結束標籤。

	例如::

		echo validation_errors('<span class="error">', '</span>');

		/*
			Would produce, e.g.:

			<span class="error">The "email" field doesn't contain a valid e-mail address!</span>
			<span class="error">The "password" field doesn't match the "repeat_password" field!</span>

		 */

.. php:function:: form_prep($str)

	:param	string	$str: Value to escape
	:returns:	Escaped value
	:rtype:	string

	允許您在表單元素中安全的使用 HTML 和例如引號這樣的字元，而不用擔心對表單造成破壞。

	.. note:: 如果您使用了這個頁面上介紹的任何一個函數，表單的域值會被自動轉義，
		所以您無需再呼叫這個函數。只有在您建立自己的表單元素時需要使用它。

	.. note:: 該函數已經廢棄，現在只是 :doc:`通用函數 <../general/common_functions>` :func:`html_escape()`
		的一個別名，請使用 :func:`html_escape()` 代替它。
