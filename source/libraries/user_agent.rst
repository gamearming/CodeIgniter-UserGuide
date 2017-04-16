################
用戶代理類
################

用戶代理（User Agent）類提供了一些成員函數來幫助您識別正在存取您的站點的瀏覽器、
移動設備或機器人的資訊。另外，您還可以通過它讀取 referrer 資訊，以及
支援的語言和字元集資訊。

.. contents::
  :local:

.. raw:: html

  <div class="custom-index container"></div>

**************************
使用用戶代理類
**************************

初始化類
======================

正如 CodeIgniter 中的其他類一樣，在您的控制器中使用 ``$this->load->library()``
成員函數來初始化用戶代理類::

	$this->load->library('user_agent');

初始化之後，用戶代理類的物件就可以這樣存取::

	$this->agent

用戶代理的定義
======================

用戶代理的名稱定義在 application/config/user_agents.php 設定文件中。
您也可以依據需要向相應的陣列中加入您自己的用戶代理。

範例
=======

當用戶代理類初始化之後，它會嘗試判斷正在存取您的站點的是 Web 瀏覽器，還是移動設備，
或者是機器人。它還可以讀取平台的相關資訊。

::

	$this->load->library('user_agent');

	if ($this->agent->is_browser())
	{
		$agent = $this->agent->browser().' '.$this->agent->version();
	}
	elseif ($this->agent->is_robot())
	{
		$agent = $this->agent->robot();
	}
	elseif ($this->agent->is_mobile())
	{
		$agent = $this->agent->mobile();
	}
	else
	{
		$agent = 'Unidentified User Agent';
	}

	echo $agent;

	echo $this->agent->platform(); // Platform info (Windows, Linux, Mac, etc.)

***************
類參考
***************

.. php:class:: CI_User_agent

	.. php:method:: is_browser([$key = NULL])

		:param	string	$key: Optional browser name
		:returns:	TRUE if the user agent is a (specified) browser, FALSE if not
		:rtype:	bool

		判斷用戶代理是否為某個已知的 Web 瀏覽器，傳回布林值 TRUE 或 FALSE 。
		::

			if ($this->agent->is_browser('Safari'))
			{
				echo 'You are using Safari.';
			}
			elseif ($this->agent->is_browser())
			{
				echo 'You are using a browser.';
			}

		.. note:: 這個範例中的 "Safari" 字元串是設定文件中定義的 browser 陣列的一個元素，您可以在
			**application/config/user_agents.php** 文件中找到它，如果需要的話，您可以對其進行加入或修改。

	.. php:method:: is_mobile([$key = NULL])

		:param	string	$key: Optional mobile device name
		:returns:	TRUE if the user agent is a (specified) mobile device, FALSE if not
		:rtype:	bool

		判斷用戶代理是否為某個已知的移動設備，傳回布林值 TRUE 或 FALSE 。
		::

			if ($this->agent->is_mobile('iphone'))
			{
				$this->load->view('iphone/home');
			}
			elseif ($this->agent->is_mobile())
			{
				$this->load->view('mobile/home');
			}
			else
			{
				$this->load->view('web/home');
			}

	.. php:method:: is_robot([$key = NULL])

		:param	string	$key: Optional robot name
		:returns:	TRUE if the user agent is a (specified) robot, FALSE if not
		:rtype:	bool

		判斷用戶代理是否為某個已知的機器人，傳回布林值 TRUE 或 FALSE 。

		.. note:: 用戶代理類只定義了一些常見的機器人，它並不是完整的機器人清單，因為可能存在上百個不同的機器人，
			遍歷這個清單效率會很低。如果您發現某個機器人經常存取您的站點，並且它不在這個清單中，您可以將其加入到文件
			**application/config/user_agents.php** 中。

	.. php:method:: is_referral()

		:returns:	TRUE if the user agent is a referral, FALSE if not
		:rtype:	bool

		判斷用戶代理是否為從另一個網站跳過來的（Referer 為另一個網站），傳回布林值 TRUE 或 FALSE 。

	.. php:method:: browser()

		:returns:	Detected browser or an empty string
		:rtype:	string

		傳回目前正在瀏覽您的站點的瀏覽器名稱。

	.. php:method:: version()

		:returns:	Detected browser version or an empty string
		:rtype:	string

		傳回目前正在瀏覽您的站點的瀏覽器版本號。

	.. php:method:: mobile()

		:returns:	Detected mobile device brand or an empty string
		:rtype:	string

		傳回目前正在瀏覽您的站點的移動設備名稱。

	.. php:method:: robot()

		:returns:	Detected robot name or an empty string
		:rtype:	string

		傳回目前正在瀏覽您的站點的機器人名稱。

	.. php:method:: platform()

		:returns:	Detected operating system or an empty string
		:rtype:	string

		傳回目前正在瀏覽您的站點的平台（Linux、Windows、OSX 等）。

	.. php:method:: referrer()

		:returns:	Detected referrer or an empty string
		:rtype:	string

		如果用戶代理引用了另一個站點，傳回 referrer 。一般您會像下面這樣做::

			if ($this->agent->is_referral())
			{
				echo $this->agent->referrer();
			}

	.. php:method:: agent_string()

		:returns:	Full user agent string or an empty string
		:rtype:	string

		傳回完整的用戶代理字元串，一般字元串的格式如下::

			Mozilla/5.0 (Macintosh; U; Intel Mac OS X; en-US; rv:1.8.0.4) Gecko/20060613 Camino/1.0.2

	.. php:method:: accept_lang([$lang = 'en'])

		:param	string	$lang: Language key
		:returns:	TRUE if provided language is accepted, FALSE if not
		:rtype:	bool

		判斷用戶代理是否支援某個語言。例如::

			if ($this->agent->accept_lang('en'))
			{
				echo 'You accept English!';
			}

		.. note:: 這個成員函數一般不太可靠，因為有些瀏覽器並不提供語言資訊，甚至在那些提供了語言資訊的瀏覽器中，也並不一定準確。

	.. php:method:: languages()

		:returns:	An array list of accepted languages
		:rtype:	array

		傳回一個陣列，包含用戶代理支援的所有語言。

	.. php:method:: accept_charset([$charset = 'utf-8'])

		:param	string	$charset: Character set
		:returns:	TRUE if the character set is accepted, FALSE if not
		:rtype:	bool

		判斷用戶代理是否支援某個字元集。例如::

			if ($this->agent->accept_charset('utf-8'))
			{
				echo 'You browser supports UTF-8!';
			}

		.. note:: 這個成員函數一般不太可靠，因為有些瀏覽器並不提供字元集資訊，甚至在那些提供了字元集資訊的瀏覽器中，也並不一定準確。

	.. php:method:: charsets()

		:returns:	An array list of accepted character sets
		:rtype:	array

		傳回一個陣列，包含用戶代理支援的所有字元集。

	.. php:method:: parse($string)

		:param	string	$string: A custom user-agent string
		:rtype:	void

		解析一個自定義的用戶代理字元串，而不是目前正在存取站點的用戶代理。
