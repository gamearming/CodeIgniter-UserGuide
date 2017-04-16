###########
Email 類
###########

CodeIgniter 擁有強大的 Email 類支援以下特性：

-  多協議：Mail、Sendmail 和 SMTP
-  SMTP 協議支援 TLS 和 SSL 加密
-  多個收件人
-  抄送（CC）和密送（BCC）
-  HTML 格式郵件 或 純文字郵件
-  附件
-  自動換行
-  優先級
-  密送批處理模式（BCC Batch Mode），大郵件清單將被分成小批次密送
-  Email 調試工具

.. contents::
  :local:

.. raw:: html

  <div class="custom-index container"></div>

***********************
使用 Email 類
***********************

發送 Email
=============

發送郵件不僅很簡單，而且您可以通過參數或通過設定文件設定發送郵件的不同選項。

下面是個簡單的範例，用於演示如何發送郵件。注意：這個範例假設您是在某個 :doc:`控制器 <../general/controllers>`
裡面發送郵件。

::

	$this->load->library('email');

	$this->email->from('your@example.com', 'Your Name');
	$this->email->to('someone@example.com');
	$this->email->cc('another@another-example.com');
	$this->email->bcc('them@their-example.com');

	$this->email->subject('Email Test');
	$this->email->message('Testing the email class.');

	$this->email->send();

設定 Email 參數
=========================

有 21 種不同的參數可以用來對您發送的郵件進行設定。您可以像下面這樣手工設定它們，
或者通過設定文件自動載入，見下文：

通過向郵件初始化函數傳遞一個包含參數的陣列來設定參數，下面是個如何設定參數的範例::

	$config['protocol'] = 'sendmail';
	$config['mailpath'] = '/usr/sbin/sendmail';
	$config['charset'] = 'iso-8859-1';
	$config['wordwrap'] = TRUE;

	$this->email->initialize($config);

.. note:: 如果您不設定，大多數參數將使用預設值。

在設定文件中設定 Email 參數
------------------------------------------

如果您不喜歡使用上面的成員函數來設定參數，您可以將它們放到設定文件中。您只需要簡單的建立一個新文件
email.php ，將 $config 陣列放到該文件，然後儲存到 config/email.php ，這樣它將會自動被載入。
如果您使用設定文件的方式來設定參數，您就不需要使用 ``$this->email->initialize()`` 成員函數了。

Email 參數
=================

下表為發送郵件時所有可用的參數。

=================== ====================== ============================ =======================================================================
參數                  預設值                  選項                              描述
=================== ====================== ============================ =======================================================================
**useragent**       CodeIgniter            None                         用戶代理（user agent）
**protocol**        mail                   mail, sendmail, or smtp      郵件發送協議
**mailpath**        /usr/sbin/sendmail     None                         伺服器上 Sendmail 的實際路徑
**smtp_host**       No Default             None                         SMTP 伺服器地址
**smtp_user**       No Default             None                         SMTP 用戶名
**smtp_pass**       No Default             None                         SMTP 密碼
**smtp_port**       25                     None                         SMTP 端口
**smtp_timeout**    5                      None                         SMTP 超時時間（單位：秒）
**smtp_keepalive**  FALSE                  TRUE or FALSE (boolean)      是否啟用 SMTP 持久連接
**smtp_crypto**     No Default             tls or ssl                   SMTP 加密方式
**wordwrap**        TRUE                   TRUE or FALSE (boolean)      是否啟用自動換行
**wrapchars**       76                                                  自動換行時每行的最大字元數
**mailtype**        text                   text or html                 郵件類型。如果發送的是 HTML 郵件，必須是一個完整的網頁，
                                                                        確保網頁中沒有使用相對路徑的鏈接和圖片地址，它們在郵件中不能正確顯示。
**charset**         ``$config['charset']``                              字元集（utf-8, iso-8859-1 等）
**validate**        FALSE                  TRUE or FALSE (boolean)      是否驗證郵件地址
**priority**        3                      1, 2, 3, 4, 5                Email 優先級（1 = 最高. 5 = 最低. 3 = 正常）
**crlf**            \\n                    "\\r\\n" or "\\n" or "\\r"   換行字元（使用 "\r\n" 以遵守 RFC 822）
**newline**         \\n                    "\\r\\n" or "\\n" or "\\r"   換行字元（使用 "\r\n" 以遵守 RFC 822）
**bcc_batch_mode**  FALSE                  TRUE or FALSE (boolean)      是否啟用密送批處理模式（BCC Batch Mode）
**bcc_batch_size**  200                    None                         使用密送批處理時每一批郵件的數量
**dsn**             FALSE                  TRUE or FALSE (boolean)      是否啟用伺服器提示消息
=================== ====================== ============================ =======================================================================

取消自動換行
========================

如果您啟用了自動換行（推薦遵守 RFC 822），然後您的郵件中又有一個超長的鏈接，那麼它也會被自動換行，
會導致收件人無法點擊該鏈接。CodeIgniter 允許您停用部分內容的自動換行，像下面這樣::

	The text of your email that
	gets wrapped normally.

	{unwrap}http://example.com/a_long_link_that_should_not_be_wrapped.html{/unwrap}

	More text that will be
	wrapped normally.


在您不想自動換行的內容前後使用 {unwrap} {/unwrap} 包起來。

***************
類參考
***************

.. php:class:: CI_Email

	.. php:method:: from($from[, $name = ''[, $return_path = NULL]])

		:param	string	$from: "From" e-mail address
		:param	string	$name: "From" display name
		:param	string	$return_path: Optional email address to redirect undelivered e-mail to
		:returns:	CI_Email instance (method chaining)
		:rtype:	CI_Email

		設定發件人 email 地址和名稱::

			$this->email->from('you@example.com', 'Your Name');

		您還可以設定一個 Return-Path 用於重定向未收到的郵件::

			$this->email->from('you@example.com', 'Your Name', 'returned_emails@example.com');

		.. note:: 如果您使用的是 'smtp' 協議，不能使用 Return-Path 。

	.. php:method:: reply_to($replyto[, $name = ''])

		:param	string	$replyto: E-mail address for replies
		:param	string	$name: Display name for the reply-to e-mail address
		:returns:	CI_Email instance (method chaining)
		:rtype:	CI_Email

		設定郵件回復地址，如果沒有提供這個資訊，將會使用 :meth:from 函數中的值。例如::

			$this->email->reply_to('you@example.com', 'Your Name');

	.. php:method:: to($to)

		:param	mixed	$to: Comma-delimited string or an array of e-mail addresses
		:returns:	CI_Email instance (method chaining)
		:rtype:	CI_Email

		設定收件人 email 地址，地址可以是單個、一個以逗號分隔的清單或是一個陣列::

			$this->email->to('someone@example.com');

		::

			$this->email->to('one@example.com, two@example.com, three@example.com');

		::

			$this->email->to(
				array('one@example.com', 'two@example.com', 'three@example.com')
			);

	.. php:method:: cc($cc)

		:param	mixed	$cc: Comma-delimited string or an array of e-mail addresses
		:returns:	CI_Email instance (method chaining)
		:rtype:	CI_Email

		設定抄送（CC）的 email 地址，和 "to" 成員函數一樣，地址可以是單個、一個以逗號分隔的清單或是一個陣列。

	.. php:method:: bcc($bcc[, $limit = ''])

		:param	mixed	$bcc: Comma-delimited string or an array of e-mail addresses
		:param	int	$limit: Maximum number of e-mails to send per batch
		:returns:	CI_Email instance (method chaining)
		:rtype:	CI_Email

		設定密送（BCC）的 email 地址，和 "to" 成員函數一樣，地址可以是單個、一個以逗號分隔的清單或是一個陣列。

		如果設定了 ``$limit`` 參數，將啟用批處理模式，批處理模式可以同時發送一批郵件，每一批不超過設定的 ``$limit`` 值。

	.. php:method:: subject($subject)

		:param	string	$subject: E-mail subject line
		:returns:	CI_Email instance (method chaining)
		:rtype:	CI_Email

		設定 email 主題::

			$this->email->subject('This is my subject');

	.. php:method:: message($body)

		:param	string	$body: E-mail message body
		:returns:	CI_Email instance (method chaining)
		:rtype:	CI_Email

		設定 email 正文部分::

			$this->email->message('This is my message');

	.. php:method:: set_alt_message($str)

		:param	string	$str: Alternative e-mail message body
		:returns:	CI_Email instance (method chaining)
		:rtype:	CI_Email

		設定可選的 email 正文部分::

			$this->email->set_alt_message('This is the alternative message');

		如果您發送的是 HTML 格式的郵件，可以設定一個可選的正文部分。對於那些設定了不接受 HTML 格式的郵件的人來說，
		可以顯示一段備選的不包含 HTML 格式的文字。如果您沒有設定該參數，CodeIgniter 會自動從 HTML 格式郵件中刪掉 HTML 標籤。

	.. php:method:: set_header($header, $value)

		:param	string	$header: Header name
		:param	string	$value: Header value
		:returns:	CI_Email instance (method chaining)
		:rtype: CI_Email

		向 email 加入額外的頭::

			$this->email->set_header('Header1', 'Value1');
			$this->email->set_header('Header2', 'Value2');

	.. php:method:: clear([$clear_attachments = FALSE])

		:param	bool	$clear_attachments: Whether or not to clear attachments
		:returns:	CI_Email instance (method chaining)
		:rtype: CI_Email

		將所有的 email 變數清空，當您在一個循環中發送郵件時，這個成員函數可以讓您在每次發郵件之前將變數重置。

		::

			foreach ($list as $name => $address)
			{
				$this->email->clear();

				$this->email->to($address);
				$this->email->from('your@example.com');
				$this->email->subject('Here is your info '.$name);
				$this->email->message('Hi '.$name.' Here is the info you requested.');
				$this->email->send();
			}

		如果將參數設定為 TRUE ，郵件的附件也會被清空。

			$this->email->clear(TRUE);

	.. php:method:: send([$auto_clear = TRUE])

		:param	bool	$auto_clear: Whether to clear message data automatically
		:returns:	TRUE on success, FALSE on failure
		:rtype:	bool

		發送 email ，依據成功或失敗傳回布林值 TRUE 或 FALSE ，可以在條件語句中使用::

			if ( ! $this->email->send())
			{
				// Generate error
			}

		如果發送成功，該成員函數將會自動清除所有的參數。如果不想清除，可以將參數置為 FALSE ::

		 	if ($this->email->send(FALSE))
		 	{
		 		// Parameters won't be cleared
		 	}

		.. note:: 為了使用 ``print_debugger()`` 成員函數，您必須避免清空 email 的參數。

	.. php:method:: attach($filename[, $disposition = ''[, $newname = NULL[, $mime = '']]])

		:param	string	$filename: File name
		:param	string	$disposition: 'disposition' of the attachment. Most
			email clients make their own decision regardless of the MIME
			specification used here. https://www.iana.org/assignments/cont-disp/cont-disp.xhtml
		:param	string	$newname: Custom file name to use in the e-mail
		:param	string	$mime: MIME type to use (useful for buffered data)
		:returns:	CI_Email instance (method chaining)
		:rtype:	CI_Email

		加入附件，第一個參數為文件的路徑。要加入多個附件，可以呼叫該成員函數多次。例如::

			$this->email->attach('/path/to/photo1.jpg');
			$this->email->attach('/path/to/photo2.jpg');
			$this->email->attach('/path/to/photo3.jpg');

		要讓附件使用預設的 Content-Disposition（預設為：attachment）將第二個參數留空，
		您也可以使用其他的 Content-Disposition ::

			$this->email->attach('image.jpg', 'inline');

		另外，您也可以使用 URL::

			$this->email->attach('http://example.com/filename.pdf');

		如果您想自定義文件名，可以使用第三個參數::

			$this->email->attach('filename.pdf', 'attachment', 'report.pdf');

		如果您想使用一段字元串來代替物理文件，您可以將第一個參數設定為該字元串，第三個參數設定為文件名，
		第四個參數設定為 MIME 類型::

			$this->email->attach($buffer, 'attachment', 'report.pdf', 'application/pdf');

	.. php:method:: attachment_cid($filename)

		:param	string	$filename: Existing attachment filename
		:returns:	Attachment Content-ID or FALSE if not found
		:rtype:	string

		設定並傳回一個附件的 Content-ID ，可以讓您將附件（圖片）內聯顯示到 HTML 正文中去。
		第一個參數必須是一個已經加入到附件中的文件名。
		::

			$filename = '/img/photo1.jpg';
			$this->email->attach($filename);
			foreach ($list as $address)
			{
				$this->email->to($address);
				$cid = $this->email->attachment_cid($filename);
				$this->email->message('<img src="cid:'. $cid .'" alt="photo1" />');
				$this->email->send();
			}

		.. note:: 每個 email 的 Content-ID 都必須重新建立，為了保證唯一性。

	.. php:method:: print_debugger([$include = array('headers', 'subject', 'body')])

		:param	array	$include: Which parts of the message to print out
		:returns:	Formatted debug data
		:rtype:	string

		傳回一個包含了所有的伺服器資訊、email 頭部資訊、以及 email 資訊的字元串。用於調試。

		您可以指定只傳回消息的哪個部分，有效值有：**headers** 、 **subject** 和 **body** 。

		例如::

			// You need to pass FALSE while sending in order for the email data
			// to not be cleared - if that happens, print_debugger() would have
			// nothing to output.
			$this->email->send(FALSE);

			// Will only print the email headers, excluding the message subject and body
			$this->email->print_debugger(array('headers'));

		.. note:: 預設情況，所有的資料都會被打印出來。
