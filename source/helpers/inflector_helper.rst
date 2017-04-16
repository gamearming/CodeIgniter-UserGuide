###################
Inflector 輔助函數
###################

Inflector 輔助函數文件包含了一些幫助您將 **英語** 單詞轉換為單複數或駝峰格式等等的函數。

.. contents::
  :local:

.. raw:: html

  <div class="custom-index container"></div>

載入輔助函數
===================

該輔助函數通過下面的程式碼載入::

	$this->load->helper('inflector');

可用函數
===================

該輔助函數有下列可用函數：

.. php:function:: singular($str)

	:param	string	$str: Input string
	:returns:	A singular word
	:rtype:	string

	將一個單詞的複數形式變為單數形式。例如::

		echo singular('dogs'); // Prints 'dog'

.. php:function:: plural($str)

	:param	string	$str: Input string
	:returns:	A plural word
	:rtype:	string

	將一個單詞的單數形式變為複數形式。例如::

		echo plural('dog'); // Prints 'dogs'

.. php:function:: camelize($str)

	:param	string	$str: Input string
	:returns:	Camelized string
	:rtype:	string

	將一個以空格或下劃線分隔的單詞轉換為駝峰格式。例如::

		echo camelize('my_dog_spot'); // Prints 'myDogSpot'

.. php:function:: underscore($str)

	:param	string	$str: Input string
	:returns:	String containing underscores instead of spaces
	:rtype:	string

	將以空格分隔的多個單詞轉換為下劃線分隔格式。例如::

		echo underscore('my dog spot'); // Prints 'my_dog_spot'

.. php:function:: humanize($str[, $separator = '_'])

	:param	string	$str: Input string
	:param	string	$separator: Input separator
	:returns:	Humanized string
	:rtype:	string

	將以下劃線分隔的多個單詞轉換為以空格分隔，並且每個單詞以大寫開頭。例如::

		echo humanize('my_dog_spot'); // Prints 'My Dog Spot'

	如果單詞是以連接符分割的，第二個參數傳入連接符::

		echo humanize('my-dog-spot', '-'); // Prints 'My Dog Spot'

.. php:function:: is_countable($word)

	:param	string	$word: Input string
	:returns:	TRUE if the word is countable or FALSE if not
	:rtype:	bool

	判斷某個單詞是否有複數形式。例如::

		is_countable('equipment'); // Returns FALSE
