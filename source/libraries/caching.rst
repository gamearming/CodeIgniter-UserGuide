##############
快取驅動器
##############

CodeIgniter 提供了幾種最常用的快速快取的封裝，除了基於文件的快取，
其他的快取都需要對伺服器進行特殊的設定，如果設定不正確，將會拋出
一個致命錯誤異常（Fatal Exception）。

.. contents::
  :local:

.. raw:: html

  <div class="custom-index container"></div>

*************
使用範例
*************

下面的範例程式碼用於載入快取驅動器，使用 `APC <#alternative-php-cache-apc-caching>`_ 作為快取，如果 APC 在伺服器環境下不可用，將降級到基於文件的快取。

::

	$this->load->driver('cache', array('adapter' => 'apc', 'backup' => 'file'));

	if ( ! $foo = $this->cache->get('foo'))
	{
		echo 'Saving to the cache!<br />';
		$foo = 'foobarbaz!';

		// Save into the cache for 5 minutes
		$this->cache->save('foo', $foo, 300);
	}

	echo $foo;

您也可以設定 **key_prefix** 參數來給快取名加入前綴，當您在同一個環境下執行多個應用時，它可以避免衝突。

::

	$this->load->driver('cache',
		array('adapter' => 'apc', 'backup' => 'file', 'key_prefix' => 'my_')
	);

	$this->cache->get('foo'); // Will get the cache entry named 'my_foo'

***************
類參考
***************

.. php:class:: CI_Cache

	.. php:method:: is_supported($driver)

		:param	string	$driver: the name of the caching driver
		:returns:	TRUE if supported, FALSE if not
		:rtype:	bool

		當使用 ``$this->cache->get()`` 成員函數來存取驅動器時該成員函數會被自動呼叫，但是，如果您使用了某些個人的驅動器，
		應該先呼叫該成員函數確保這個驅動器在伺服器環境下是否被支援。
		::

			if ($this->cache->apc->is_supported())
			{
				if ($data = $this->cache->apc->get('my_cache'))
				{
					// do things.
				}
			}

	.. php:method:: get($id)

		:param	string	$id: Cache item name
		:returns:	Item value or FALSE if not found
		:rtype:	mixed

		該成員函數用於從快取中讀取一項條目，如果讀取的條目不存在，成員函數傳回 FALSE 。
		::

			$foo = $this->cache->get('my_cached_item');

	.. php:method:: save($id, $data[, $ttl = 60[, $raw = FALSE]])

		:param	string	$id: Cache item name
		:param	mixed	$data: the data to save
		:param	int	$ttl: Time To Live, in seconds (default 60)
		:param	bool	$raw: Whether to store the raw value
		:returns:	TRUE on success, FALSE on failure
		:rtype:	string

		該成員函數用於將一項條目儲存到快取中，如果儲存失敗，成員函數傳回 FALSE 。
		::

			$this->cache->save('cache_item_id', 'data_to_cache');

		.. note:: 參數 ``$raw`` 只有在使用 APC 和 Memcache 快取時才有用，
			它用於 ``increment()`` 和 ``decrement()`` 成員函數。

	.. php:method:: delete($id)

		:param	string	$id: name of cached item
		:returns:	TRUE on success, FALSE on failure
		:rtype:	bool

		該成員函數用於從快取中刪除一項指定條目，如果刪除失敗，成員函數傳回 FALSE 。
		::

			$this->cache->delete('cache_item_id');

	.. php:method:: increment($id[, $offset = 1])

		:param	string	$id: Cache ID
		:param	int	$offset: Step/value to add
		:returns:	New value on success, FALSE on failure
		:rtype:	mixed

		對快取中的值執行原子自增操作。
		::

			// 'iterator' has a value of 2

			$this->cache->increment('iterator'); // 'iterator' is now 3

			$this->cache->increment('iterator', 3); // 'iterator' is now 6

	.. php:method:: decrement($id[, $offset = 1])

		:param	string	$id: Cache ID
		:param	int	$offset: Step/value to reduce by
		:returns:	New value on success, FALSE on failure
		:rtype:	mixed

		對快取中的值執行原子自減操作。
		::

			// 'iterator' has a value of 6

			$this->cache->decrement('iterator'); // 'iterator' is now 5

			$this->cache->decrement('iterator', 2); // 'iterator' is now 3

	.. php:method:: clean()

		:returns:	TRUE on success, FALSE on failure
		:rtype:	bool

		該成員函數用於清空整個快取，如果清空失敗，成員函數傳回 FALSE 。
		::

			$this->cache->clean();

	.. php:method:: cache_info()

		:returns:	Information on the entire cache database
		:rtype:	mixed

		該成員函數傳回整個快取的資訊。
		::

			var_dump($this->cache->cache_info());

		.. note:: 傳回的資訊以及資料結構取決於使用的快取驅動器。

	.. php:method:: get_metadata($id)

		:param	string	$id: Cache item name
		:returns:	Metadata for the cached item
		:rtype:	mixed

		該成員函數用於讀取快取中某個指定條目的詳細資訊。
		::

			var_dump($this->cache->get_metadata('my_cached_item'));

		.. note:: 傳回的資訊以及資料結構取決於使用的快取驅動器。

*******
驅動器
*******

可選 PHP 快取（APC）
===================================

上述所有成員函數都可以直接使用，而不用在載入驅動器時指定 adapter 參數，如下所示::

	$this->load->driver('cache');
	$this->cache->apc->save('foo', 'bar', 10);

關於 APC 的更多資訊，請參閱 `http://php.net/apc <http://php.net/apc>`_

基於文件的快取
==================

和輸出類的快取不同的是，基於文件的快取支援只快取檢視的某一部分。使用這個快取時要注意，
確保對您的應用程式進行基準測試，因為當磁盤 I/O 頻繁時可能對快取有負面影響。

上述所有成員函數都可以直接使用，而不用在載入驅動器時指定 adapter 參數，如下所示::

	$this->load->driver('cache');
	$this->cache->file->save('foo', 'bar', 10);

Memcached 快取
=================

可以在 memcached.php 設定文件中指定多個 Memcached 伺服器，設定文件位於 
*application/config/* 資料夾。

上述所有成員函數都可以直接使用，而不用在載入驅動器時指定 adapter 參數，如下所示::

	$this->load->driver('cache');
	$this->cache->memcached->save('foo', 'bar', 10);

關於 Memcached 的更多資訊，請參閱 `http://php.net/memcached <http://php.net/memcached>`_

WinCache 快取
================

在 Windows 下，您還可以使用 WinCache 快取。

上述所有成員函數都可以直接使用，而不用在載入驅動器時指定 adapter 參數，如下所示::

	$this->load->driver('cache');
	$this->cache->wincache->save('foo', 'bar', 10);

關於 WinCache 的更多資訊，請參閱 `http://php.net/wincache <http://php.net/wincache>`_

Redis 快取
=============

Redis 是一個在記憶體中以鍵值形式儲存資料的快取，使用 LRU（最近最少使用算法）快取模式，
要使用它，您需要先安裝 `Redis 伺服器和 phpredis 擴展 <https://github.com/phpredis/phpredis>`_ 。

連接 Redis 伺服器的設定資訊必須儲存到 application/config/redis.php 文件中，可用參數有::
	
	$config['socket_type'] = 'tcp'; //`tcp` or `unix`
	$config['socket'] = '/var/run/redis.sock'; // in case of `unix` socket type
	$config['host'] = '127.0.0.1';
	$config['password'] = NULL;
	$config['port'] = 6379;
	$config['timeout'] = 0;

上述所有成員函數都可以直接使用，而不用在載入驅動器時指定 adapter 參數，如下所示::

	$this->load->driver('cache');
	$this->cache->redis->save('foo', 'bar', 10);

關於 Redis 的更多資訊，請參閱 `http://redis.io <http://redis.io>`_

虛擬快取（Dummy Cache）
==========================

這是一個永遠不會命中的快取，它不儲存資料，但是它允許您在當使用的快取在您的環境下不被支援時，
仍然保留使用快取的程式碼。
