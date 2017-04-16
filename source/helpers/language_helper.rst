###############
語言輔助函數
###############

語言輔助函數文件包含了用於處理語言文件的一些函數。

.. contents::
  :local:

.. raw:: html

  <div class="custom-index container"></div>

載入輔助函數
===================

該輔助函數通過下面的程式碼載入::

	$this->load->helper('language');

可用函數
===================

該輔助函數有下列可用函數：

.. php:function:: lang($line[, $for = ''[, $attributes = array()]])

	:param	string	$line: Language line key
	:param	string	$for: HTML "for" attribute (ID of the element we're creating a label for)
	:param	array	$attributes: Any additional HTML attributes
	:returns:	The language line; in an HTML label tag, if the ``$for`` parameter is not empty
	:rtype:	string

	此函數使用簡單的語法從已載入的語言文件中傳回一行文字。
	這種簡單的寫法在檢視文件中可能比呼叫 ``CI_Lang::line()`` 更順手。

	Examples::

		echo lang('language_key');
		// Outputs: Language line

		echo lang('language_key', 'form_item_id', array('class' => 'myClass'));
		// Outputs: <label for="form_item_id" class="myClass">Language line</label>
