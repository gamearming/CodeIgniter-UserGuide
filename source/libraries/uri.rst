#########
URI 類
#########

URI 類用於幫助您從 URI 字元串中讀取資訊，如果您使用 URI 路由，
您也可以從路由後的 URI 中讀取資訊。

.. note:: 該類由系統自己載入，無需手工載入。

.. contents::
  :local:

.. raw:: html

  <div class="custom-index container"></div>

***************
類參考
***************

.. php:class:: CI_URI

	.. php:method:: segment($n[, $no_result = NULL])

		:param	int	$n: Segment index number
		:param	mixed	$no_result: What to return if the searched segment is not found
		:returns:	Segment value or $no_result value if not found
		:rtype:	mixed

		用於從 URI 中讀取指定段。參數 n 為您希望讀取的段序號，URI 的段從左到右進行編號。
		例如，如果您的完整 URL 是這樣的::

			http://example.com/index.php/news/local/metro/crime_is_up

		那麼您的每個分段如下::

		#. news
		#. local
		#. metro
		#. crime_is_up

		第二個參數為可選的，預設為 NULL ，它用於設定當所請求的段不存在時的傳回值。
		例如，如下程式碼在失敗時將傳回數字 0 ::

			$product_id = $this->uri->segment(3, 0);

		它可以避免您寫出類似於下面這樣的程式碼::

			if ($this->uri->segment(3) === FALSE)
			{
				$product_id = 0;
			}
			else
			{
				$product_id = $this->uri->segment(3);
			}

	.. php:method:: rsegment($n[, $no_result = NULL])

		:param	int	$n: Segment index number
		:param	mixed	$no_result: What to return if the searched segment is not found
		:returns:	Routed segment value or $no_result value if not found
		:rtype:	mixed

		當您使用 CodeIgniter 的 :doc:`URI 路由 <../general/routing>` 功能時，該成員函數和 ``segment()`` 類似，
		只是它用於從路由後的 URI 中讀取指定段。

	.. php:method:: slash_segment($n[, $where = 'trailing'])

		:param	int	$n: Segment index number
		:param	string	$where: Where to add the slash ('trailing' or 'leading')
		:returns:	Segment value, prepended/suffixed with a forward slash, or a slash if not found
		:rtype:	string

		該成員函數和 ``segment()`` 類似，只是它會依據第二個參數在傳回結果的前面或/和後面加入斜線。
		如果第二個參數未設定，斜線會加入到後面。例如::

			$this->uri->slash_segment(3);
			$this->uri->slash_segment(3, 'leading');
			$this->uri->slash_segment(3, 'both');

		傳回結果：

		#. segment/
		#. /segment
		#. /segment/

	.. php:method:: slash_rsegment($n[, $where = 'trailing'])

		:param	int	$n: Segment index number
		:param	string	$where: Where to add the slash ('trailing' or 'leading')
		:returns:	Routed segment value, prepended/suffixed with a forward slash, or a slash if not found
		:rtype:	string

		當您使用 CodeIgniter 的 :doc:`URI 路由 <../general/routing>` 功能時，該成員函數和 ``slash_segment()`` 類似，
		只是它用於從路由後的 URI 傳回結果的前面或/和後面加入斜線。

	.. php:method:: uri_to_assoc([$n = 3[, $default = array()]])

		:param	int	$n: Segment index number
		:param	array	$default: Default values
		:returns:	Associative URI segments array
		:rtype:	array

		該成員函數用於將 URI 的段轉換為一個包含鍵值對的關聯陣列。如下 URI::

			index.php/user/search/name/joe/location/UK/gender/male

		使用這個成員函數您可以將 URI 轉為如下的陣列原型::

			[array]
			(
				'name'		=> 'joe'
				'location'	=> 'UK'
				'gender'	=> 'male'
			)

		您可以通過第一個參數設定一個位移，預設值為 3 ，這是因為您的 URI 的前兩段通常都是控制器和成員函數。
		例如::

			$array = $this->uri->uri_to_assoc(3);
			echo $array['name'];

		第二個參數用於設定預設的鍵名，這樣即使 URI 中缺少某個鍵名，也能保證傳回的陣列中包含該索引。
		例如::

			$default = array('name', 'gender', 'location', 'type', 'sort');
			$array = $this->uri->uri_to_assoc(3, $default);

		如果某個您設定的預設鍵名在 URI 中不存在，陣列中的該索引值將設定為 NULL 。

		另外，如果 URI 中的某個鍵沒有相應的值與之對應（例如 URI 的段數為奇數），
		陣列中的該索引值也將設定為 NULL 。

	.. php:method:: ruri_to_assoc([$n = 3[, $default = array()]])

		:param	int	$n: Segment index number
		:param	array	$default: Default values
		:returns:	Associative routed URI segments array
		:rtype:	array

		當您使用 CodeIgniter 的 :doc:`URI 路由 <../general/routing>` 功能時，該成員函數和 ``uri_to_assoc()`` 類似，
		只是它用於將路由後的 URI 的段轉換為一個包含鍵值對的關聯陣列。

	.. php:method:: assoc_to_uri($array)

		:param	array	$array: Input array of key/value pairs
		:returns:	URI string
		:rtype:	string

		依據輸入的關聯陣列產生一個 URI 字元串，陣列的鍵將包含在 URI 的字元串中。例如::

			$array = array('product' => 'shoes', 'size' => 'large', 'color' => 'red');
			$str = $this->uri->assoc_to_uri($array);

			// Produces: product/shoes/size/large/color/red

	.. php:method:: uri_string()

		:returns:	URI string
		:rtype:	string

		傳回一個相對的 URI 字元串，例如，如果您的完整 URL 為::

			http://example.com/index.php/news/local/345

		該成員函數傳回::

			news/local/345

	.. php:method:: ruri_string()

		:returns:	Routed URI string
		:rtype:	string

		當您使用 CodeIgniter 的 :doc:`URI 路由 <../general/routing>` 功能時，該成員函數和 ``uri_string()`` 類似，
		只是它用於傳回路由後的 URI 。

	.. php:method:: total_segments()

		:returns:	Count of URI segments
		:rtype:	int

		傳回 URI 的總段數。

	.. php:method:: total_rsegments()

		:returns:	Count of routed URI segments
		:rtype:	int

		當您使用 CodeIgniter 的 :doc:`URI 路由 <../general/routing>` 功能時，該成員函數和 ``total_segments()`` 類似，
		只是它用於傳回路由後的 URI 的總段數。

	.. php:method:: segment_array()

		:returns:	URI segments array
		:rtype:	array

		傳回 URI 所有的段組成的陣列。例如::

			$segs = $this->uri->segment_array();

			foreach ($segs as $segment)
			{
				echo $segment;
				echo '<br />';
			}

	.. php:method:: rsegment_array()

		:returns:	Routed URI segments array
		:rtype:	array

		當您使用 CodeIgniter 的 :doc:`URI 路由 <../general/routing>` 功能時，該成員函數和 ``segment_array()`` 類似，
		只是它用於傳回路由後的 URI 的所有的段組成的陣列。
