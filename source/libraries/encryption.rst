##################
加密類（新版）
##################

.. important:: 絕不要使用這個類或其他任何加密類來進行密碼處理！密碼應該是被 *哈希* ，您應該使用 PHP 自帶的 `密碼哈希擴展 <http://php.net/password>`_ 。


加密類提供了雙向資料加密的方式，為了實現密碼學意義上的安全，它使用了一些並非在所有系統上都可用的 PHP 的擴展，
要使用這個類，您的系統上必須安裝了下面的擴展：

- `OpenSSL <http://php.net/openssl>`_
- `MCrypt <http://php.net/mcrypt>`_ （要支援 `MCRYPT_DEV_URANDOM`）

只要有一點不滿足，我們就無法為您提供足夠高的安全性。

.. contents::
  :local:

.. raw:: html

  <div class="custom-index container"></div>

****************************
使用加密類
****************************

初始化類
======================

正如 CodeIgniter 中的其他類一樣，在您的控制器中使用 ``$this->load->library()``
成員函數來初始化加密類::

	$this->load->library('encryption');

初始化之後，加密類的物件就可以這樣存取::

	$this->encryption

預設行為
================

預設情況下，加密類會通過您設定的 *encryption_key* 參數和 SHA512 HMAC 認證，
使用 AES-128 算法的 CBC 模式。

.. note:: 選擇使用 AES-128 算法不僅是因為它已經被證明相當強壯，
	而且它也已經在不同的加密軟件和編程語言 API 中廣泛的使用了。

但是要注意的是，*encryption_key* 參數的用法可能並不是您想的那樣。

如果您對密碼學有點熟悉的話，您應該知道，使用 HMAC 算法認證也需要使用一個密鑰，
而在加密的過程和認證的過程中使用相同的密鑰可不是個好的做法。

正因為此，程序會從您的設定的 *encryption_key* 參數中派生出兩個密鑰來：
一個用於加密，另一個用於認證。這其實是通過一種叫做 `HKDF <http://en.wikipedia.org/wiki/HKDF>`_
（HMAC-based Key Derivation Function）的技術實現的。

設定 encryption_key 參數
===========================

加密密鑰 *encryption key* 是用於控制加密過程的一小段資訊，使用它可以對普通文字進行加密和解密。
這個過程可以保證只有您能對資料進行解密，其他人是看不到您的資料的，這其中的關鍵就是加密密鑰。
如果您使用了一個密鑰來加密資料，那麼就只能通過這個密鑰來解密，所以您不僅應該仔細選擇您的密鑰，
還應該好好的保管好它，不要忘記了。

還有一點要注意的是，為了確保最高的安全性，這個密鑰不僅 *應該* 越強壯越好，而且 *應該* 經常修改。
不過這在現實中很難做到，也不好實現，所以 CodeIgniter 提供了一個設定參數用於設定您的密鑰，
這個密鑰（幾乎）每次都會用到。

不用說，您應該小心保管好您的密鑰，如果有人得到了您的密鑰，那麼資料就能很容易的被解密。
如果您的伺服器不在您的控制之下，想保證您的密鑰絕對安全是不可能的，
所以在在您使用密鑰對敏感資料（例如信用卡號碼）進行加密之前，請再三斟酌。

您的加密密鑰的長度 **必須** 滿足正在使用的加密算法允許的長度。例如，AES-128 算法最長支援
128 位（16 字節）。下面有一個表列出了不同算法支援的密鑰長度。

您所使用的密鑰應該越隨機越好，它不能是一個普通的文字字元串，經過哈希函數處理過也不行。
為了產生一個合適的密鑰，您應該使用加密類提供的 ``create_key()`` 成員函數::

	// $key will be assigned a 16-byte (128-bit) random key
	$key = $this->encryption->create_key(16);

密鑰可以儲存在 *application/config/config.php* 設定文件中，或者您也可以設計您自己的儲存機制，
然後加密解密的時候動態的去讀取它。

如果要儲存在設定文件 *application/config/config.php* 中，可以打開該文件，然後設定::

	$config['encryption_key'] = 'YOUR KEY';

您會發現 ``create_key()`` 成員函數傳回的是二進制資料，沒辦法複製粘貼，所以您可能還需要使用
``bin2hex()`` 、 ``hex2bin()`` 或 Base64 編碼來更好的處理密鑰資料。例如::

	// Get a hex-encoded representation of the key:
	$key = bin2hex($this->encryption->create_key(16));

	// Put the same value in your config with hex2bin(),
	// so that it is still passed as binary to the library:
	$config['encryption_key'] = hex2bin(<your hex-encoded key>);

.. _ciphers-and-modes:

支援的加密算法和模式
======================================

可移植的算法（Portable ciphers）
--------------------------------

因為 MCrypt 和 OpenSSL （我們也稱之為「驅動」）支援的加密算法不同，而且實現方式也不太一樣，
CodeIgniter 將它們設計成一種可移植的方式來使用，換句話說，您可以交換使用它們兩個，
至少對它們兩個驅動都支援的算法來說是這樣。

而且 CodeIgniter 的實現也和其他編程語言和類庫的標準實現一致。

下面是可移植算法的清單，其中 "CodeIgniter 名稱" 一欄就是您在使用加密類的時候使用的名稱：

======================== ================== ============================ ===============================
算法名稱                 CodeIgniter 名稱   密鑰長度 （位 / 字節）       支援的模式
======================== ================== ============================ ===============================
AES-128 / Rijndael-128   aes-128            128 / 16                     CBC, CTR, CFB, CFB8, OFB, ECB
AES-192                  aes-192            192 / 24                     CBC, CTR, CFB, CFB8, OFB, ECB
AES-256                  aes-256            256 / 32                     CBC, CTR, CFB, CFB8, OFB, ECB
DES                      des                56 / 7                       CBC, CFB, CFB8, OFB, ECB
TripleDES                tripledes          56 / 7, 112 / 14, 168 / 21   CBC, CFB, CFB8, OFB
Blowfish                 blowfish           128-448 / 16-56              CBC, CFB, OFB, ECB
CAST5 / CAST-128         cast5              88-128 / 11-16               CBC, CFB, OFB, ECB
RC4 / ARCFour            rc4                40-2048 / 5-256              Stream
======================== ================== ============================ ===============================

.. important:: 由於 MCrypt 的內部實現，如果您提供了一個長度不合適的密鑰，它會使用另一種不同的算法來加密，
	這將和您設定的算法不一致，所以要特別注意這一點！

.. note:: 上表中還有一點要澄清，Blowfish、CAST5 和 RC4 算法支援可變長度的密鑰，也就是說，
	只要密鑰的長度在指定範圍內都是可以的。

.. note:: 儘管 CAST5 支援的密鑰的長度可以小於 128 位（16 字節），其實實際上，依據 `RFC 2144
	<http://tools.ietf.org/rfc/rfc2144.txt>`_ 我們知道，它會用 0 進行補齊到最大長度。

.. note:: Blowfish 算法支援最短 32 位（4 字節）的密鑰，但是經過我們的測試發現，只有密鑰長度大於等於 128 位（16 字節）
	時，才可以很好的同時支援 MCrypt 和 OpenSSL ，再說，設定這麼短的密鑰也不是好的做法。

特定驅動的算法（Driver-specific ciphers）
----------------------------------------------

正如前面所說，MCrypt 和 OpenSSL 支援不同的加密算法，所以您也可以選擇下面這些只針對某一特定驅動的算法。
但是為了移植性考慮，而且這些算法也沒有經過徹底測試，我們並不建議您使用這些算法。

============== ========= ============================== =========================================
算法名稱       驅動      密鑰長度 （位 / 字節）         支援的模式
============== ========= ============================== =========================================
AES-128        OpenSSL   128 / 16                       CBC, CTR, CFB, CFB8, OFB, ECB, XTS
AES-192        OpenSSL   192 / 24                       CBC, CTR, CFB, CFB8, OFB, ECB, XTS
AES-256        OpenSSL   256 / 32                       CBC, CTR, CFB, CFB8, OFB, ECB, XTS
Rijndael-128   MCrypt    128 / 16, 192 / 24, 256 / 32   CBC, CTR, CFB, CFB8, OFB, OFB8, ECB
Rijndael-192   MCrypt    128 / 16, 192 / 24, 256 / 32   CBC, CTR, CFB, CFB8, OFB, OFB8, ECB
Rijndael-256   MCrypt    128 / 16, 192 / 24, 256 / 32   CBC, CTR, CFB, CFB8, OFB, OFB8, ECB
GOST           MCrypt    256 / 32                       CBC, CTR, CFB, CFB8, OFB, OFB8, ECB
Twofish        MCrypt    128 / 16, 192 / 24, 256 / 32   CBC, CTR, CFB, CFB8, OFB, OFB8, ECB
CAST-128       MCrypt    40-128 / 5-16                  CBC, CTR, CFB, CFB8, OFB, OFB8, ECB
CAST-256       MCrypt    128 / 16, 192 / 24, 256 / 32   CBC, CTR, CFB, CFB8, OFB, OFB8, ECB
Loki97         MCrypt    128 / 16, 192 / 24, 256 / 32   CBC, CTR, CFB, CFB8, OFB, OFB8, ECB
SaferPlus      MCrypt    128 / 16, 192 / 24, 256 / 32   CBC, CTR, CFB, CFB8, OFB, OFB8, ECB
Serpent        MCrypt    128 / 16, 192 / 24, 256 / 32   CBC, CTR, CFB, CFB8, OFB, OFB8, ECB
XTEA           MCrypt    128 / 16                       CBC, CTR, CFB, CFB8, OFB, OFB8, ECB
RC2            MCrypt    8-1024 / 1-128                 CBC, CTR, CFB, CFB8, OFB, OFB8, ECB
RC2            OpenSSL   8-1024 / 1-128                 CBC, CFB, OFB, ECB
Camellia-128   OpenSSL   128 / 16                       CBC, CFB, CFB8, OFB, ECB
Camellia-192   OpenSSL   192 / 24                       CBC, CFB, CFB8, OFB, ECB
Camellia-256   OpenSSL   256 / 32                       CBC, CFB, CFB8, OFB, ECB
Seed           OpenSSL   128 / 16                       CBC, CFB, OFB, ECB
============== ========= ============================== =========================================

.. note:: 如果您要使用這些算法，您只需將它的名稱以小寫形式傳遞給加密類即可。

.. note:: 您可能已經注意到，所有的 AES 算法（以及 Rijndael-128 算法）也在上面的可移植算法清單中出現了，
	這是因為這些算法支援不同的模式。還有很重要的一點是，在使用 128 位的密鑰時，AES-128 和 Rijndael-128
	算法其實是一樣的。

.. note:: CAST-128 / CAST-5 算法也在兩個表格都出現了，這是因為當密鑰長度小於等於 80 位時，
	OpenSSL 的實現貌似有問題。

.. note:: 清單中可以看到 RC2 算法同時被 MCrypt 和 OpenSSL 支援，但是兩個驅動對它的實現方式是不一樣的，
	而且也是不能移植的。我們只找到了一條關於這個的不確定的消息可能是 MCrypt 的實現有問題。

.. _encryption-modes:

加密模式
----------------

加密算法的不同模式有著不同的特性，它們有著不同的目的，有的可能比另一些更強壯，有的可能速度更快，
有的可能提供了額外的功能。
我們並不打算深入研究這個，這應該是密碼學專家做的事。下表將向我們普通的用戶列出一些簡略的參考資訊。
如果您是個初學者，直接使用 CBC 模式就可以了，一般情況下它已經足夠強壯和安全，並且已經被廣泛接受。

=========== ================== ================= ===================================================================================================================================================
模式名稱    CodeIgniter 名稱   支援的驅動        備註
=========== ================== ================= ===================================================================================================================================================
CBC         cbc                MCrypt, OpenSSL   安全的預設選擇
CTR         ctr                MCrypt, OpenSSL   理論上比 CBC 更好，但並沒有廣泛使用
CFB         cfb                MCrypt, OpenSSL   N/A
CFB8        cfb8               MCrypt, OpenSSL   和 CFB 一樣，但是使用 8 位模式（不推薦）
OFB         ofb                MCrypt, OpenSSL   N/A
OFB8        ofb8               MCrypt            和 OFB 一樣，但是使用 8 位模式（不推薦）
ECB         ecb                MCrypt, OpenSSL   忽略 IV （不推薦）
XTS         xts                OpenSSL           通常用來加密可隨機存取的資料，如 RAM 或 硬盤
Stream      stream             MCrypt, OpenSSL   這其實並不是一種模式，只是表明使用了流加密，通常在 算法+模式 的初始化過程中會用到。
=========== ================== ================= ===================================================================================================================================================

消息長度
==============

有一點對您來說可能很重要，加密的字元串通常要比原始的文字字元串要長（取決於算法）。

這個會取決於加密所使用的算法，加入到密文上的 IV ，以及加入的 HMAC 認證資訊。
另外，為了保證傳輸的安全性，加密消息還會被 Base64 編碼。

當您選擇資料儲存機制時請記住這一點，例如 Cookie 只能儲存 4k 的資訊。

.. _configuration:

設定類庫
=======================

考慮到可用性，性能，以及一些歷史原因，加密類使用了和老的 :doc:`加密類 <encrypt>` 一樣的驅動、
加密算法、模式 和 密鑰。

上面的 "預設行為" 一節已經提到，系統將自動檢測驅動（OpenSSL 優先級要高點），使用 CBC 模式的
AES-128 算法，以及 ``$config['encryption_key']`` 參數。

如果您想改變這點，您需要使用 ``initialize()`` 成員函數，它的參數為一個關聯陣列，每一項都是可選：

======== ===============================================
選項     可能的值
======== ===============================================
driver   'mcrypt', 'openssl'
cipher   算法名稱（參見 :ref:`ciphers-and-modes`）
mode     加密模式（參見 :ref:`encryption-modes`）
key      加密密鑰
======== ===============================================

例如，如果您想將加密算法和模式改為 AES-126 CTR ，可以這樣::

	$this->encryption->initialize(
		array(
			'cipher' => 'aes-256',
			'mode' => 'ctr',
			'key' => '<a 32-character random string>'
		)
	);

另外，我們也可以設定一個密鑰，如前文所說，針對所使用的算法選擇一個合適的密鑰非常重要。

我們還可以修改驅動，如果您兩種驅動都支援，但是出於某種原因您想使用 MCrypt 來替代 OpenSSL ::

	// Switch to the MCrypt driver
	$this->encryption->initialize(array('driver' => 'mcrypt'));

	// Switch back to the OpenSSL driver
	$this->encryption->initialize(array('driver' => 'openssl'));

對資料進行加密與解密
==============================

使用已設定好的參數來對資料進行加密和解密是非常簡單的，您只要將字元串傳給 ``encrypt()``
和/或 ``decrypt()`` 成員函數即可::

	$plain_text = 'This is a plain-text message!';
	$ciphertext = $this->encryption->encrypt($plain_text);

	// Outputs: This is a plain-text message!
	echo $this->encryption->decrypt($ciphertext);

這樣就行了！加密類會為您完成所有必須的操作並確保安全，您根本不用關係細節。

.. important:: 兩個成員函數在遇到錯誤時都會傳回 FALSE ，如果是 ``encrypt()`` 傳回 FALSE ，
	那麼只可能是設定參數錯了。在生產程式碼中一定要對 ``decrypt()`` 成員函數進行檢查。

實現原理
------------

如果您非要知道整個過程的實現步驟，下面是內部的實現：

- ``$this->encryption->encrypt($plain_text)``

  #. 通過 HKDF 和 SHA-512 摘要算法，從您設定的 *encryption_key* 參數中讀取兩個密鑰：加密密鑰 和 HMAC 密鑰。

  #. 產生一個隨機的初始向量（IV）。

  #. 使用上面的加密密鑰和 IV ，通過 AES-128 算法的 CBC 模式（或其他您設定的算法和模式）對資料進行加密。

  #. 將 IV 附加到密文後。

  #. 對結果進行 Base64 編碼，這樣就可以安全的儲存和傳輸它，而不用擔心字元集問題。

  #. 使用 HMAC 密鑰產生一個 SHA-512 HMAC 認證消息，附加到 Base64 字元串後，以保證資料的完整性。

- ``$this->encryption->decrypt($ciphertext)``

  #. 通過 HKDF 和 SHA-512 摘要算法，從您設定的 *encryption_key* 參數中讀取兩個密鑰：加密密鑰 和 HMAC 密鑰。
     由於 *encryption_key* 不變，所以產生的結果和上面 ``encrypt()`` 成員函數產生的結果是一樣的，否則您沒辦法解密。

  #. 檢查字元串的長度是否足夠長，並從字元串中分離出 HMAC ，然後驗證是否一致（這可以防止時序攻擊（timing attack）），
     如果驗證失敗，傳回 FALSE 。

  #. 進行 Base64 解碼。

  #. 從密文中分離出 IV ，並使用 IV 和 加密密鑰對資料進行解密。

.. _custom-parameters:

使用自定義參數
-----------------------

假設您需要和另一個系統交互，這個系統不受您的控制，而且它使用了其他的成員函數來加密資料，
加密的方式和我們上面介紹的流程不一樣。

在這種情況下，加密類允許您修改它的加密和解密的流程，這樣您就可以簡單的調整成自己的解決方案。

.. note:: 通過這種方式，您可以不用在設定文件中設定 *encryption_key* 就能使用加密類。

您所需要做的就是傳一個包含一些參數的關聯陣列到 ``encrypt()`` 或 ``decrypt()`` 成員函數，下面是個範例::

	// Assume that we have $ciphertext, $key and $hmac_key
	// from on outside source

	$message = $this->encryption->decrypt(
		$ciphertext,
		array(
			'cipher' => 'blowfish',
			'mode' => 'cbc',
			'key' => $key,
			'hmac_digest' => 'sha256',
			'hmac_key' => $hmac_key
		)
	);

在上面的範例中，我們對一段使用 CBC 模式的 Blowfish 算法加密的消息進行解密，並使用 SHA-256 HMAC 認證方式。

.. important:: 注意在這個範例中 'key' 和 'hmac_key' 參數都要指定，當使用自定義參數時，加密密鑰和 HMAC 密鑰
	不再是預設的那樣從設定參數中自動讀取的了。

下面是所有可用的選項。

但是，除非您真的需要這樣做，並且您知道您在做什麼，否則我們建議您不要修改加密的流程，因為這會影響安全性，
所以請謹慎對待。

============= =============== ============================= ======================================================
選項          預設值          必須的 / 可選的               描述
============= =============== ============================= ======================================================
cipher        N/A             Yes                           加密算法（參見 :ref:`ciphers-and-modes`）
mode          N/A             Yes                           加密模式（參見 :ref:`encryption-modes`）
key           N/A             Yes                           加密密鑰
hmac          TRUE            No                            是否使用 HMAC
                                                            布林值，如果為 FALSE ，*hmac_digest* 和 *hmac_key* 將被忽略
hmac_digest   sha512          No                            HMAC 消息摘要算法（參見 :ref:`digests`）
hmac_key      N/A             Yes，除非 *hmac* 設為 FALSE   HMAC 密鑰
raw_data      FALSE           No                            加密文字是否保持原樣
                                                            布林值，如果為 TRUE ，將不執行 Base64 編碼和解碼操作
                                                            HMAC 也不會是十六進制字元串
============= =============== ============================= ======================================================

.. important:: ``encrypt()`` and ``decrypt()`` will return FALSE if
	a mandatory parameter is not provided or if a provided
	value is incorrect. This includes *hmac_key*, unless *hmac*
	is set to FALSE.

.. _digests:

支援的 HMAC 認證算法
----------------------------------------

對於 HMAC 消息認證，加密類支援使用 SHA-2 家族的算法：

=========== ==================== ============================
算法        原始長度（字節）     十六進制編碼長度（字節）
=========== ==================== ============================
sha512      64                   128
sha384      48                   96
sha256      32                   64
sha224      28                   56
=========== ==================== ============================

之所以沒有包含一些其他的流行算法，例如 MD5 或 SHA1 ，是因為這些算法目前已被證明不夠安全，
我們並不鼓勵使用它們。如果您非要使用這些算法，簡單的使用 PHP 的原生函數
`hash_hmac() <http://php.net/manual/en/function.hash-hmac.php>`_ 也可以。

當未來出現廣泛使用的更好的算法時，我們自然會將其加入進去。

***************
類參考
***************

.. php:class:: CI_Encryption

	.. php:method:: initialize($params)

		:param	array	$params: Configuration parameters
		:returns:	CI_Encryption instance (method chaining)
		:rtype:	CI_Encryption

		初始化加密類的設定，使用不同的驅動，算法，模式 或 密鑰。

		例如::

			$this->encryption->initialize(
				array('mode' => 'ctr')
			);

		請參考 :ref:`configuration` 一節瞭解詳細資訊。

	.. php:method:: encrypt($data[, $params = NULL])

		:param	string	$data: Data to encrypt
		:param	array	$params: Optional parameters
		:returns:	Encrypted data or FALSE on failure
		:rtype:	string

		對輸入資料進行加密，並傳回密文。

		例如::

			$ciphertext = $this->encryption->encrypt('My secret message');

		請參考 :ref:`custom-parameters` 一節瞭解更多參數資訊。

	.. php:method:: decrypt($data[, $params = NULL])

		:param	string	$data: Data to decrypt
		:param	array	$params: Optional parameters
		:returns:	Decrypted data or FALSE on failure
		:rtype:	string

		對輸入資料進行解密，並傳回解密後的文字。

		例如::

			echo $this->encryption->decrypt($ciphertext);

		請參考 :ref:`custom-parameters` 一節瞭解更多參數資訊。

	.. php:method:: create_key($length)

		:param	int	$length: Output length
		:returns:	A pseudo-random cryptographic key with the specified length, or FALSE on failure
		:rtype:	string

		從操作系統讀取隨機資料（例如 /dev/urandom），並產生加密密鑰。

	.. php:method:: hkdf($key[, $digest = 'sha512'[, $salt = NULL[, $length = NULL[, $info = '']]]])

		:param	string	$key: Input key material
		:param	string	$digest: A SHA-2 family digest algorithm
		:param	string	$salt: Optional salt
		:param	int	$length: Optional output length
		:param	string	$info: Optional context/application-specific info
		:returns:	A pseudo-random key or FALSE on failure
		:rtype:	string

		從一個密鑰產生另一個密鑰（較弱的密鑰）。

		這是內部使用的一個成員函數，用於從設定的 *encryption_key* 參數產生一個加密密鑰和 HMAC 密鑰。

		將這個成員函數公開，是為了可能會在其他地方使用到。關於這個算法的描述可以看
		`RFC 5869 <https://tools.ietf.org/rfc/rfc5869.txt>`_ 。

		和 RFC 5869 描述不同的是，這個成員函數不支援 SHA1 。

		例如::

			$hmac_key = $this->encryption->hkdf(
				$key,
				'sha512',
				NULL,
				NULL,
				'authentication'
			);

			// $hmac_key is a pseudo-random key with a length of 64 bytes
