############
陣列輔助函數
############

陣列輔助函數文件包含了一些幫助您處理陣列的函數。

.. contents::
  :local:

.. raw:: html

  <div class="custom-index container"></div>

載入輔助函數
===================

該輔助函數通過下面的程式碼載入::

	$this->load->helper('array');


可用函數
===================

該輔助函數有下列可用函數：

.. php:function:: element($item, $array[, $default = NULL])

	:param	string	$item: Item to fetch from the array
	:param	array	$array: Input array
	:param	bool	$default: What to return if the array isn't valid
	:returns:	NULL on failure or the array item.
	:rtype:	mixed

	該函數通過索引讀取陣列中的元素。它會測試索引是否設定並且有值，如果有值，
	函數將傳回該值，如果沒有值，預設傳回 NULL 或傳回通過第三個參數設定的預設值。

	範例::

		$array = array(
			'color'	=> 'red',
			'shape'	=> 'round',
			'size'	=> ''
		);

		echo element('color', $array); // returns "red"
		echo element('size', $array, 'foobar'); // returns "foobar"


.. php:function:: elements($items, $array[, $default = NULL])

	:param	string	$item: Item to fetch from the array
	:param	array	$array: Input array
	:param	bool	$default: What to return if the array isn't valid
	:returns:	NULL on failure or the array item.
	:rtype:	mixed

	該函數通過多個索引讀取陣列中的多個元素。它會測試每一個索引是否設定並且有值，
	如果其中某個索引沒有值，傳回結果中該索引所對應的元素將被置為 NULL ，或者
	通過第三個參數設定的預設值。

	範例::

		$array = array(
			'color' => 'red',
			'shape' => 'round',
			'radius' => '10',
			'diameter' => '20'
		);

		$my_shape = elements(array('color', 'shape', 'height'), $array);

	上面的函數傳回的結果如下::

		array(
			'color' => 'red',
			'shape' => 'round',
			'height' => NULL
		);

	您可以通過第三個參數設定任何您想要設定的預設值。
	::

		 $my_shape = elements(array('color', 'shape', 'height'), $array, 'foobar');

	上面的函數傳回的結果如下::

		array(     
			'color' 	=> 'red',
			'shape' 	=> 'round',
			'height'	=> 'foobar'
		);

	當您需要將 ``$_POST`` 陣列傳遞到您的模型中時這將很有用，這可以防止用戶發送額外的資料
	被寫入到您的資料庫。

	::

		$this->load->model('post_model');
		$this->post_model->update(
			elements(array('id', 'title', 'content'), $_POST)
		);

	從上例中可以看出，只有 id、title、content 三個字段被更新。


.. php:function:: random_element($array)

	:param	array	$array: Input array
	:returns:	A random element from the array
	:rtype:	mixed

	傳入一個陣列，並傳回陣列中隨機的一個元素。

	使用範例::

		$quotes = array(
			"I find that the harder I work, the more luck I seem to have. - Thomas Jefferson",
			"Don't stay in bed, unless you can make money in bed. - George Burns",
			"We didn't lose the game; we just ran out of time. - Vince Lombardi",
			"If everything seems under control, you're not going fast enough. - Mario Andretti",
			"Reality is merely an illusion, albeit a very persistent one. - Albert Einstein",
			"Chance favors the prepared mind - Louis Pasteur"
		);

		echo random_element($quotes);