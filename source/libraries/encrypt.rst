#############
加密類
#############

加密類提供了雙向資料加密的方式，它相依於 PHP 的 Mcrypt 擴展，所以要有 
Mcrypt 擴展才能執行。

.. important:: 這個類庫已經廢棄，保留只是為了向前相容。請使用新的 
	:doc:`加密類 <encryption>` 。

.. contents::
  :local:

.. raw:: html

  <div class="custom-index container"></div>

*************************
使用加密類
*************************

設定您的密鑰
================

**密鑰** 是對字元串進行加密或解密的一段資訊片段。實際上，您設定的密鑰
是 **唯一** 能解密通過該密鑰加密的資料，所以一定要慎重選擇您的密鑰，
而且如果您打算對持久資料進行加密的話，您最好不要修改密鑰。

不用說，您應該小心保管好您的密鑰，如果有人得到了您的密鑰，那麼資料就能
很容易的被解密。如果您的伺服器不在您的控制之下，想保證您的密鑰絕對安全
是不可能的，所以在在您使用密鑰對敏感資料（例如信用卡號碼）進行加密之前，
請再三斟酌。

為了最大程度的利用加密算法，您的密鑰最好使用32位長度（256字節），為了
保證安全性，密鑰字元串應該越隨機越好，包含數字、大寫和小寫字元， 
**不應該** 直接使用一個簡單的字元串。

您的密鑰可以儲存在 **application/config/config.php** 文件中，或者使用您
自己設計的儲存機制也行，然後在加解密時動態的取出密鑰。

如果要通過文件 **application/config/config.php** 來儲存您的密鑰，那麼打開
該文件然後設定::

	$config['encryption_key'] = "YOUR KEY";

消息長度
==============

有一點很重要，您應該知道，通過加密成員函數產生的消息長度大概會比原始的消息長
2.6 倍。舉個範例來說，如果您要加密的字元串是 "my super secret data" ，它
的長度為 21 字元，那麼加密之後的字元串的長度大約為 55 字元（這裡之所以說
「大約」 是因為加密字元串以 64 位為單位非線性增長）。當您選擇資料儲存機制時
請記住這一點，例如 Cookie 只能儲存 4k 的資訊。

初始化類
======================

正如 CodeIgniter 中的其他類一樣，在您的控制器中使用 ``$this->load->library()``
成員函數來初始化加密類::

	$this->load->library('encrypt');

初始化之後，加密類的物件就可以這樣存取::

	$this->encrypt

***************
類參考
***************

.. php:class:: CI_Encrypt

	.. php:method:: encode($string[, $key = ''])

		:param	string	$string: Data to encrypt
		:param	string	$key: Encryption key
		:returns:	Encrypted string
		:rtype:	string

		執行資料加密，並傳回加密後的字元串。例如::

			$msg = 'My secret message';

			$encrypted_string = $this->encrypt->encode($msg);

		如果您不想使用設定文件中的密鑰，您也可以將您的密鑰通過第二個可選參數傳入::

			$msg = 'My secret message';
			$key = 'super-secret-key';

			$encrypted_string = $this->encrypt->encode($msg, $key);

	.. php:method:: decode($string[, $key = ''])

		:param	string	$string: String to decrypt
		:param	string	$key: Encryption key
		:returns:	Plain-text string
		:rtype:	string

		解密一個已加密的字元串。例如::

			$encrypted_string = 'APANtByIGI1BpVXZTJgcsAG8GZl8pdwwa84';

			$plaintext_string = $this->encrypt->decode($encrypted_string);

		如果您不想使用設定文件中的密鑰，您也可以將您的密鑰通過第二個可選參數傳入::

			$msg = 'My secret message';
			$key = 'super-secret-key';

			$encrypted_string = $this->encrypt->decode($msg, $key);

	.. php:method:: set_cipher($cipher)

		:param	int	$cipher: Valid PHP MCrypt cypher constant
		:returns:	CI_Encrypt instance (method chaining)
		:rtype:	CI_Encrypt

		設定一個 Mcrypt 加密算法，預設情況下，使用的是 ``MCRYPT_RIJNDAEL_256`` ，例如::

			$this->encrypt->set_cipher(MCRYPT_BLOWFISH);

		存取 php.net 讀取一份 `可用的加密算法清單 <http://php.net/mcrypt>`_ 。

		如果您想測試下您的伺服器是否支援 MCrypt ，您可以::

			echo extension_loaded('mcrypt') ? 'Yup' : 'Nope';

	.. php:method:: set_mode($mode)

		:param	int	$mode: Valid PHP MCrypt mode constant
		:returns:	CI_Encrypt instance (method chaining)
		:rtype:	CI_Encrypt

		設定一個 Mcrypt 加密模式，預設情況下，使用的是 **MCRYPT_MODE_CBC** ，例如::

			$this->encrypt->set_mode(MCRYPT_MODE_CFB);

		存取 php.net 讀取一份 `可用的加密模式清單 <http://php.net/mcrypt>`_ 。

	.. php:method:: encode_from_legacy($string[, $legacy_mode = MCRYPT_MODE_ECB[, $key = '']])

		:param	string	$string: String to encrypt
		:param	int	$legacy_mode: Valid PHP MCrypt cipher constant
		:param	string	$key: Encryption key
		:returns:	Newly encrypted string
		:rtype:	string

		允許您重新加密在 CodeIgniter 1.x 下加密的資料，這樣可以和 CodeIgniter 2.x 的
		加密類庫保持相容。只有當您的加密資料是永久的儲存在諸如文件或資料庫中時，並且
		您的伺服器支援 Mcrypt ，您才可能需要使用這個成員函數。如果您只是在諸如會話資料
		或其他臨時性的資料中使用加密的話，那麼您根本用不到它。儘管如此，使用 2.x 版本
		之前的加密庫加密的會話資料由於不能被解密，會話會被銷毀。

		.. important::
			**為什麼只是提供了一個重新加密的成員函數，而不是繼續支援原有的加密成員函數呢？**
			這是因為 CodeIgniter 2.x 中的加密庫不僅在性能和安全性上有所提高，而且我們
			並不提倡繼續使用老版本的加密成員函數。當然如果您願意的話，您完全可以擴展加密庫，
			使用老的加密成員函數來替代新的加密成員函數，無縫的相容 CodeIgniter 1.x 加密資料。
			但是作為一個開發者，作出這樣的決定還是應該小心謹慎。

		::

			$new_data = $this->encrypt->encode_from_legacy($old_encrypted_string);

		======================    ===============    =======================================================================
		參數                      預設值             描述
		======================    ===============    =======================================================================
		**$orig_data**            n/a                使用 CodeIgniter 1.x 加密過的原始資料
		**$legacy_mode**          MCRYPT_MODE_ECB    產生原始資料時使用的 Mcrypt 加密模式，CodeIgniter 1.x 預設使用的是 MCRYPT_MODE_ECB ，
		                                             如果不指定該參數的話，將預設使用該方式。
		**$key**                  n/a                加密密鑰，這個值通常在上面所說的設定文件裡。
		======================    ===============    =======================================================================
