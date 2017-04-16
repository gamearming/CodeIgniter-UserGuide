#######################
相容性函數
#######################

CodeIgniter 提供了一系列相容性函數可以讓您使用，它們只有在高版本的 PHP 中才有，
或者需要相依其他的擴展才有。

由於是自己實現的，這些函數本身也可能有它自己的相依性，但如果您的 PHP 中不提供這些函數時，
這些函數還是有用的。

.. note:: 和 :doc:`公共函數 <common_functions>` 一樣，相容性函數也一直可以存取，只要滿足了他們的相依條件。

.. contents::
  :local:

.. raw:: html

  <div class="custom-index container"></div>

****************
密碼哈希
****************

這幾個相容性函數移植了 PHP 標準的 `密碼哈希擴展 <http://php.net/password>`_ 的實現，
這些函數只有在 PHP 5.5 以後的版本中才有。

相依性
============

- PHP 5.3.7
- ``crypt()`` 函數需支援 ``CRYPT_BLOWFISH``

常數
=========

- ``PASSWORD_BCRYPT``
- ``PASSWORD_DEFAULT``

函數參考
==================

.. php:function:: password_get_info($hash)

	:param	string	$hash: Password hash
	:returns:	Information about the hashed password
	:rtype:	array

	更多資訊，請參考 `PHP 手冊中的 password_get_info() 函數 <http://php.net/password_get_info>`_

.. php:function:: password_hash($password, $algo[, $options = array()])

	:param	string	$password: Plain-text password
	:param	int	$algo: Hashing algorithm
	:param	array	$options: Hashing options
	:returns:	Hashed password or FALSE on failure
	:rtype:	string

	更多資訊，請參考 `PHP 手冊中的 password_hash() 函數 <http://php.net/password_hash>`_

	.. note:: 除非提供了您自己的有效的 Salt，該函數會相依於一個可用的 CSPRNG 源（密碼學安全的偽隨機數產生器），
		下面清單中的每一個都可以滿足這點：
		- ``mcrypt_create_iv()`` with ``MCRYPT_DEV_URANDOM``
		- ``openssl_random_pseudo_bytes()``
		- /dev/arandom
		- /dev/urandom

.. php:function:: password_needs_rehash()

	:param	string	$hash: Password hash
	:param	int	$algo: Hashing algorithm
	:param	array	$options: Hashing options
	:returns:	TRUE if the hash should be rehashed to match the given algorithm and options, FALSE otherwise
	:rtype:	bool

	更多資訊，請參考 `PHP 手冊中的 password_needs_rehash() 函數 <http://php.net/password_needs_rehash>`_

.. php:function:: password_verify($password, $hash)

	:param	string	$password: Plain-text password
	:param	string	$hash: Password hash
	:returns:	TRUE if the password matches the hash, FALSE if not
	:rtype:	bool

	更多資訊，請參考 `PHP 手冊中的 password_verify() 函數 <http://php.net/password_verify>`_

*********************
哈希（資訊摘要）
*********************

相容性函數移植了 ``hash_equals()`` 和 ``hash_pbkdf2()`` 的實現，
這兩函數分別在 PHP 5.6 和 PHP 5.5 以後的版本中才有。

相依性
============

- 無

函數參考
==================

.. php:function:: hash_equals($known_string, $user_string)

	:param	string	$known_string: Known string
	:param	string	$user_string: User-supplied string
	:returns:	TRUE if the strings match, FALSE otherwise
	:rtype:	string

	更多資訊，請參考 `PHP 手冊中的 hash_equals() 函數 <http://php.net/hash_equals>`_

.. php:function:: hash_pbkdf2($algo, $password, $salt, $iterations[, $length = 0[, $raw_output = FALSE]])

	:param	string	$algo: Hashing algorithm
	:param	string	$password: Password
	:param	string	$salt: Hash salt
	:param	int	$iterations: Number of iterations to perform during derivation
	:param	int	$length: Output string length
	:param	bool	$raw_output: Whether to return raw binary data
	:returns:	Password-derived key or FALSE on failure
	:rtype:	string

	更多資訊，請參考 `PHP 手冊中的 hash_pbkdf2() 函數 <http://php.net/hash_pbkdf2>`_

****************
多字節字元串
****************

這一系列相容性函數提供了對 PHP 的 `多字節字元串擴展 <http://php.net/mbstring>`_ 的有限支援，
由於可選的解決成員函數有限，所以只有幾個函數是可用的。

.. note:: 如果沒有指定字元集參數，預設使用 ``$config['charset']`` 設定。

相依性
============

- `iconv <http://php.net/iconv>`_ 擴展

.. important:: 這個相依是可選的，無論 iconv 擴展是否存在，這些函數都已經定義了，
	如果 iconv 擴展不可用，它們會降級到非多字節字元串的函數版本。

.. important:: 當設定了字元集時，該字元集必須被 iconv 支援，並且要設定成它可以識別的格式。

.. note:: 如果您需要判斷是否支援真正的多字節字元串擴展，可以使用 ``MB_ENABLED`` 常數。

函數參考
==================

.. php:function:: mb_strlen($str[, $encoding = NULL])

	:param	string	$str: Input string
	:param	string	$encoding: Character set
	:returns:	Number of characters in the input string or FALSE on failure
	:rtype:	string

	更多資訊，請參考 `PHP 手冊中的 mb_strlen() 函數 <http://php.net/mb_strlen>`_

.. php:function:: mb_strpos($haystack, $needle[, $offset = 0[, $encoding = NULL]])

	:param	string	$haystack: String to search in
	:param	string	$needle: Part of string to search for
	:param	int	$offset: Search offset
	:param	string	$encoding: Character set
	:returns:	Numeric character position of where $needle was found or FALSE if not found
	:rtype:	mixed

	更多資訊，請參考 `PHP 手冊中的 mb_strpos() 函數 <http://php.net/mb_strpos>`_

.. php:function:: mb_substr($str, $start[, $length = NULL[, $encoding = NULL]])

	:param	string	$str: Input string
	:param	int	$start: Position of first character
	:param	int	$length: Maximum number of characters
	:param	string	$encoding: Character set
	:returns:	Portion of $str specified by $start and $length or FALSE on failure
	:rtype:	string

	更多資訊，請參考 `PHP 手冊中的 mb_substr() 函數 <http://php.net/mb_substr>`_

******************
標準函數
******************

這一系列相容性函數提供了一些高版本的 PHP 中才有的標準函數。

相依性
============

- None

函數參考
==================

.. php:function:: array_column(array $array, $column_key[, $index_key = NULL])

	:param	array	$array: Array to fetch results from
	:param	mixed	$column_key: Key of the column to return values from
	:param	mixed	$index_key: Key to use for the returned values
	:returns:	An array of values representing a single column from the input array
	:rtype:	array

	更多資訊，請參考 `PHP 手冊中的 array_column() 函數 <http://php.net/array_column>`_

.. php:function:: hex2bin($data)

	:param	array	$data: Hexadecimal representation of data
	:returns:	Binary representation of the given data
	:rtype:	string

	更多資訊，請參考 `PHP 手冊中的 hex2bin() 函數 <http://php.net/hex2bin>`_
