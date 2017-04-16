###################
購物車類
###################

購物車類允許項目被加入到 session 中，session 在用戶瀏覽您的網站期間都保持有效狀態。
這些項目能夠以標準的 "購物車" 格式被檢索和顯示，並允許用戶更新數量或者從購物車中移除項目。

.. important:: 購物車類已經廢棄，請不要使用。目前保留它只是為了向前相容。

請注意購物車類只提供核心的 "購物車" 功能。它不提供配送、信用卡授權或者其它處理組件。

.. contents::
  :local:

.. raw:: html

  <div class="custom-index container"></div>

********************
使用購物車類
********************

初始化購物車類
====================================

.. important:: 購物車類利用 CodeIgniter 的 :doc:`Session 類 <sessions>` 把購物車資訊儲存到資料庫中，
	所以在使用購物車類之前，您必須根據 :doc:`Session 類文件 <sessions>` 中的說明來建立資料庫表，
	並且在 application/config/config.php 文件中把 Session 相關參數設定為使用資料庫。

為了在您的控制器構造函數中初始化購物車類，請使用 $this->load->library 函數::

	$this->load->library('cart');

一旦載入，就可以通過呼叫 $this->cart 來使用購物車物件了::

	$this->cart

.. note:: 購物車類會自動載入和初始化 Session 類，因此除非您在別處要用到 session，否則您不需要再次載入 Session 類。

將一個項目加入到購物車
==========================

要加入項目到購物車，只需將一個包含了商品資訊的陣列傳遞給 ``$this->cart->insert()`` 函數即可，就像下面這樣::

	$data = array(
		'id'      => 'sku_123ABC',
		'qty'     => 1,
		'price'   => 39.95,
		'name'    => 'T-Shirt',
		'options' => array('Size' => 'L', 'Color' => 'Red')
	);

	$this->cart->insert($data);

.. important:: 上面的前四個陣列索引（id、qty、price 和 name）是 **必需的** 。
	如果缺少其中的任何一個，資料將不會被儲存到購物車中。第5個索引（options）
	是可選的。當您的商品包含一些相關的選項資訊時，您就可以使用它。
	正如上面所顯示的那樣，請使用一個陣列來儲存選項資訊。

五個保留的索引分別是：

-  **id** - 您的商店裡的每件商品都必須有一個唯一的標識符。典型的標識符是庫存量單位（SKU）或者其它類似的標識符。
-  **qty** - 購買的數量。
-  **price** - 商品的價格。
-  **name** - 商品的名稱。
-  **options** - 標識商品的任何附加屬性。必須通過陣列來傳遞。

除以上五個索引外，還有兩個保留字：rowid 和 subtotal。它們是購物車類內部使用的，
因此，往購物車中插入資料時，請不要使用這些詞作為索引。

您的陣列可能包含附加的資料。您的陣列中包含的所有資料都會被儲存到 session 中。
然而，最好的方式是標準化您所有商品的資料，這樣更方便您在表格中顯示它們。

::

	$data = array(
		'id'      => 'sku_123ABC',
		'qty'     => 1,
		'price'   => 39.95,
		'name'    => 'T-Shirt',
		'coupon'	 => 'XMAS-50OFF'
	);

	$this->cart->insert($data);

如果成功的插入一條資料後，``insert()`` 成員函數將會傳回一個 id 值（ $rowid ）。

將多個項目加入到購物車
=================================

通過下面這種多維陣列的方式，可以一次性加入多個產品到購物車中。
當您希望允許用戶選擇同一頁面中的多個項目時，這就非常有用了。

::

	$data = array(
		array(
			'id'      => 'sku_123ABC',
			'qty'     => 1,
			'price'   => 39.95,
			'name'    => 'T-Shirt',
			'options' => array('Size' => 'L', 'Color' => 'Red')
		),
		array(
			'id'      => 'sku_567ZYX',
			'qty'     => 1,
			'price'   => 9.95,
			'name'    => 'Coffee Mug'
		),
		array(
			'id'      => 'sku_965QRS',
			'qty'     => 1,
			'price'   => 29.95,
			'name'    => 'Shot Glass'
		)
	);

	$this->cart->insert($data);

顯示購物車
===================

為了顯示購物車的資料，您得建立一個 :doc:`檢視文件 </general/views>`，它的程式碼類似於下面這個。

請注意這個範例使用了 :doc:`表單輔助函數 </helpers/form_helper>` 。

::

	<?php echo form_open('path/to/controller/update/method'); ?>

	<table cellpadding="6" cellspacing="1" style="width:100%" border="0">

	<tr>
		<th>QTY</th>
		<th>Item Description</th>
		<th style="text-align:right">Item Price</th>
		<th style="text-align:right">Sub-Total</th>
	</tr>

	<?php $i = 1; ?>

	<?php foreach ($this->cart->contents() as $items): ?>

		<?php echo form_hidden($i.'[rowid]', $items['rowid']); ?>

		<tr>
			<td><?php echo form_input(array('name' => $i.'[qty]', 'value' => $items['qty'], 'maxlength' => '3', 'size' => '5')); ?></td>
			<td>
				<?php echo $items['name']; ?>

				<?php if ($this->cart->has_options($items['rowid']) == TRUE): ?>

					<p>
						<?php foreach ($this->cart->product_options($items['rowid']) as $option_name => $option_value): ?>

							<strong><?php echo $option_name; ?>:</strong> <?php echo $option_value; ?><br />

						<?php endforeach; ?>
					</p>

				<?php endif; ?>

			</td>
			<td style="text-align:right"><?php echo $this->cart->format_number($items['price']); ?></td>
			<td style="text-align:right">$<?php echo $this->cart->format_number($items['subtotal']); ?></td>
		</tr>

	<?php $i++; ?>

	<?php endforeach; ?>

	<tr>
		<td colspan="2"> </td>
		<td class="right"><strong>Total</strong></td>
		<td class="right">$<?php echo $this->cart->format_number($this->cart->total()); ?></td>
	</tr>

	</table>

	<p><?php echo form_submit('', 'Update your Cart'); ?></p>

更新購物車
=================

為了更新購物車中的資訊，您必須將一個包含了 Row ID 和數量的陣列傳遞給 ``$this->cart->update()`` 函數。

.. note:: 如果數量被設定為 0 ，那麼購物車中對應的項目會被移除。

::

	$data = array(
		'rowid' => 'b99ccdf16028f015540f341130b6d8ec',
		'qty'   => 3
	);

	$this->cart->update($data);

	// Or a multi-dimensional array

	$data = array(
		array(
			'rowid'   => 'b99ccdf16028f015540f341130b6d8ec',
			'qty'     => 3
		),
		array(
			'rowid'   => 'xw82g9q3r495893iajdh473990rikw23',
			'qty'     => 4
		),
		array(
			'rowid'   => 'fh4kdkkkaoe30njgoe92rkdkkobec333',
			'qty'     => 2
		)
	);

	$this->cart->update($data);

您也可以更新任何一個在新增購物車時定義的屬性，如：options、price 或其他用戶自定義字段。

::

	$data = array(
		'rowid'  => 'b99ccdf16028f015540f341130b6d8ec',
		'qty'    => 1,
		'price'	 => 49.95,
		'coupon' => NULL
	);

	$this->cart->update($data);

什麼是 Row ID?  
*****************

當一個項目被加入到購物車時，程序所產生的那個唯一的標識符就是 row ID。
建立唯一 ID 的理由是，當購物車中相同的商品有不同的選項時，購物車就能夠對它們進行管理。

比如說，有人購買了兩件相同的 T-shirt （相同的商品ID），但是尺寸不同。
商品 ID （以及其它屬性）都會完全一樣，因為它們是相同的 T-shirt ，
它們唯一的差別就是尺寸不同。因此購物車必須想辦法來區分它們，
這樣才能獨立地管理這兩件尺寸不同的 T-shirt 。而基於商品 ID 
和其它相關選項資訊來建立一個唯一的 "row ID" 就能解決這個問題。

在幾乎所有情況下，更新購物車都將是用戶通過 "查看購物車" 頁面來實現的，因此對開發者來說，
不必太擔心 "row ID" ，只要保證您的 "查看購物車" 頁面中的一個隱藏表單字段包含了這個資訊，
並且確保它能被傳遞給表單送出時所呼叫的更新函數就行了。
請仔細分析上面的 "查看購物車" 頁面的結構以讀取更多資訊。

***************
類參考
***************

.. php:class:: CI_Cart

	.. attribute:: $product_id_rules = '\.a-z0-9_-'

		用於驗證商品 ID 有效性的正則表達式規則，預設是：字母、數字、連字元（-）、下劃線（_）、句點（.）

	.. attribute:: $product_name_rules	= '\w \-\.\:'

		用於驗證商品 ID 和商品名有效性的正則表達式規則，預設是：字母、數字、連字元（-）、下劃線（_）、冒號（:）、句點（.）

	.. attribute:: $product_name_safe = TRUE

		是否只接受安全的商品名稱，預設為 TRUE 。


	.. php:method:: insert([$items = array()])

		:param	array	$items: Items to insert into the cart
		:returns:	TRUE on success, FALSE on failure
		:rtype:	bool

		將項目加入到購物車並儲存到 session 中，依據成功或失敗傳回 TRUE 或 FALSE 。


	.. php:method:: update([$items = array()])

		:param	array	$items: Items to update in the cart
		:returns:	TRUE on success, FALSE on failure
		:rtype:	bool

		該成員函數用於更新購物車中某個項目的屬性。一般情況下，它會在 "查看購物車" 頁面被呼叫，
		例如用戶在下單之前修改商品數量。參數是個陣列，陣列的每一項必須包含 rowid 。

	.. php:method:: remove($rowid)

		:param	int	$rowid: ID of the item to remove from the cart
		:returns:	TRUE on success, FALSE on failure
		:rtype:	bool

		依據 ``$rowid`` 從購物車中移除某個項目。

	.. php:method:: total()

		:returns:	Total amount
		:rtype:	int

		顯示購物車總額。


	.. php:method:: total_items()

		:returns:	Total amount of items in the cart
		:rtype:	int

		顯示購物車中商品數量。


	.. php:method:: contents([$newest_first = FALSE])

		:param	bool	$newest_first: Whether to order the array with newest items first
		:returns:	An array of cart contents
		:rtype:	array

		傳回一個陣列，包含購物車的所有資訊。參數為布林值，用於控制陣列的排序方式。
		TRUE 為按購物車裡的項目從新到舊排序，FALSE 為從舊到新。

	.. php:method:: get_item($row_id)

		:param	int	$row_id: Row ID to retrieve
		:returns:	Array of item data
		:rtype:	array

		依據指定的 ``$rowid`` 傳回購物車中該項的資訊，如果不存在，傳回 FALSE 。

	.. php:method:: has_options($row_id = '')

		:param	int	$row_id: Row ID to inspect
		:returns:	TRUE if options exist, FALSE otherwise
		:rtype:	bool

		如果購物車的某項包含 options 則傳回 TRUE 。該成員函數可以用在針對 ``contents()`` 成員函數的循環中，
		您需要指定項目的 rowid ，正如上文 "顯示購物車" 的範例中那樣。

	.. php:method:: product_options([$row_id = ''])

		:param	int	$row_id: Row ID
		:returns:	Array of product options
		:rtype:	array

		該成員函數傳回購物車中某個商品的 options 陣列。該成員函數可以用在針對 ``contents()`` 成員函數的循環中，
		您需要指定項目的 rowid ，正如上文 "顯示購物車" 的範例中那樣。

	.. php:method:: destroy()

		:rtype: void

		清空購物車。該函數一般在用戶訂單處理完成之後呼叫。
