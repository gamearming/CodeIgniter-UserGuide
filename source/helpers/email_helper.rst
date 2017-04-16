############
郵件輔助函數
############

郵件輔助函數文件包含了用於處理郵件的一些函數。欲瞭解關於郵件更全面的解決方案，
可以參考 CodeIgniter 的 :doc:`Email 類 <../libraries/email>` 。

.. important:: 不鼓勵繼續使用郵件輔助函數，這個庫目前僅是為了向前相容而存在。

.. contents::
  :local:

.. raw:: html

  <div class="custom-index container"></div>

載入輔助函數
===================

該輔助函數通過下面的程式碼載入::

	$this->load->helper('email');

可用函數
===================

該輔助函數有下列可用函數：

.. php:function:: valid_email($email)

	:param	string	$email: E-mail address
	:returns:	TRUE if a valid email is supplied, FALSE otherwise
	:rtype:	bool

	檢查 Email 地址格式是否正確，注意該函數只是簡單的檢查它的格式是否正確，
	並不能保證該 Email 地址能接受到郵件。

	Example::

		if (valid_email('email@somesite.com'))
		{
			echo 'email is valid';
		}
		else
		{
			echo 'email is not valid';
		}

	.. note:: 該函數實際上就是呼叫 PHP 原生的 ``filter_var()`` 函數而已::

		(bool) filter_var($email, FILTER_VALIDATE_EMAIL);

.. php:function:: send_email($recipient, $subject, $message)

	:param	string	$recipient: E-mail address
	:param	string	$subject: Mail subject
	:param	string	$message: Message body
	:returns:	TRUE if the mail was successfully sent, FALSE in case of an error
	:rtype:	bool

	使用 PHP 函數 `mail() <http://php.net/function.mail>`_ 發送郵件。

	.. note:: 該函數實際上就是呼叫 PHP 原生的 ``mail()`` 函數而已

		::

			mail($recipient, $subject, $message);

	欲瞭解關於郵件更全面的解決方案，可以參考 CodeIgniter 的 :doc:`Email 類 <../libraries/email>` 。