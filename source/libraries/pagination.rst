################
分頁類
################

CodeIgniter 的分頁類非常容易使用，而且它 100% 可定制，可以通過動態的參數，
也可以通過儲存在設定文件中的參數。

.. contents::
  :local:

.. raw:: html

  <div class="custom-index container"></div>

如果您還不熟悉 "分頁" 這個詞，它指的是用於您在頁面之間進行導航的鏈接。像下面這樣::

	« First  < 1 2 3 4 5 >  Last »

*******
範例
*******

下面是一個簡單的範例，如何在您的 :doc:`控制器 <../general/controllers>` 成員函數中建立分頁::

	$this->load->library('pagination');

	$config['base_url'] = 'http://example.com/index.php/test/page/';
	$config['total_rows'] = 200;
	$config['per_page'] = 20;

	$this->pagination->initialize($config);

	echo $this->pagination->create_links();

說明
=====

如上所示，``$config`` 陣列包含了您的設定參數，被傳遞到 ``$this->pagination->initialize()`` 成員函數。
另外還有二十幾個設定參數您可以選擇，但是最少您只需要這三個設定參數。下面是這幾個參數的含義：

-  **base_url** 這是一個指向您的分頁所在的控制器類/成員函數的完整的 URL ，在上面的這個範例裡，
   它指向了一個叫 "Test" 的控制器和它的一個叫 "Page" 的成員函數。記住，如果您需要一個不同格式的 URL ，
   您可以 :doc:`重新路由 <../general/routing>` 。
-  **total_rows** 這個數字表示您需要做分頁的資料的總行數。通常這個數值是您查詢資料庫得到的資料總量。
-  **per_page** 這個數字表示每個頁面中希望展示的數量，在上面的那個範例中，每頁顯示 20 個項目。

當您沒有分頁需要顯示時，``create_links()`` 成員函數會傳回一個空的字元串。

在設定文件中設定參數
====================================

如果您不喜歡用以上的成員函數進行參數設定，您可以將參數儲存到設定文件中。
簡單地建立一個名為 pagination.php 的文件，把 $config 陣列加到這個文件中，
然後將文件儲存到 *application/config/pagination.php* 。這樣它就可以自動被呼叫。
用這個成員函數，您不再需要使用 ``$this->pagination->initialize`` 成員函數。

**************************
自定義分頁
**************************

下面是所有的參數清單，可以傳遞給 initialization 成員函數來定制您喜歡的顯示效果。

**$config['uri_segment'] = 3;**

分頁成員函數自動檢測您 URI 的哪一段包含頁數，如果您的情況不一樣，您可以明確指定它。

**$config['num_links'] = 2;**

放在您目前頁碼的前面和後面的「數字」鏈接的數量。比方說值為 2 就會在每一邊放置兩個數字鏈接，
就像此頁頂端的範例鏈接那樣。

**$config['use_page_numbers'] = TRUE;**

預設分頁的 URL 中顯示的是您目前正在從哪條記錄開始分頁，如果您希望顯示實際的頁數，將該參數設定為 TRUE 。

**$config['page_query_string'] = TRUE;**

預設情況下，分頁類假設您使用 :doc:`URI 段 <../general/urls>` ，並像這樣構造您的鏈接：

	http://example.com/index.php/test/page/20

如果您把 ``$config['enable_query_strings']`` 設定為 TRUE，您的鏈接將自動地被重寫成查詢字元串格式。
這個選項也可以被明確地設定，把 ``$config['page_query_string']`` 設定為 TRUE，分頁鏈接將變成：

	http://example.com/index.php?c=test&m=page&per_page=20

請注意，"per_page" 是預設傳遞的查詢字元串，但也可以使用 ``$config['query_string_segment'] = '您的字元串'``
來設定。

**$config['reuse_query_string'] = FALSE;**

預設情況下您的查詢字元串參數會被忽略，將這個參數設定為 TRUE ，將會將查詢字元串參數加入到 URI 分段的後面
以及 URL 後綴的前面。::

	http://example.com/index.php/test/page/20?query=search%term

這可以讓您混合使用 :doc:`URI 分段 <../general/urls>` 和 查詢字元串參數，這在 3.0 之前的版本中是不行的。

**$config['prefix'] = '';**

給路徑加入一個自定義前綴，前綴位於偏移段的前面。

**$config['suffix'] = '';**

給路徑加入一個自定義後綴，後綴位於偏移段的後面。

**$config['use_global_url_suffix'] = FALSE;**

當該參數設定為 TRUE 時，會使用 **application/config/config.php** 設定文件中定義的 ``$config['url_suffix']`` 參數
**重寫** ``$config['suffix']`` 的值。

***********************
加入封裝標籤
***********************

如果您希望在整個分頁的周圍用一些標籤包起來，您可以通過下面這兩個參數：

**$config['full_tag_open'] = '<p>';**

起始標籤放在所有結果的左側。

**$config['full_tag_close'] = '</p>';**

結束標籤放在所有結果的右側。

**************************
自定義第一個鏈接
**************************

**$config['first_link'] = 'First';**

左邊第一個鏈接顯示的文字，如果您不想顯示該鏈接，將其設定為 FALSE 。

.. note:: 該參數的值也可以通過語言文件來翻譯。

**$config['first_tag_open'] = '<div>';**

第一個鏈接的起始標籤。

**$config['first_tag_close'] = '</div>';**

第一個鏈接的結束標籤。

**$config['first_url'] = '';**

可以為第一個鏈接設定一個自定義的 URL 。

*************************
自定義最後一個鏈接
*************************

**$config['last_link'] = 'Last';**

右邊最後一個鏈接顯示的文字，如果您不想顯示該鏈接，將其設定為 FALSE 。

.. note:: 該參數的值也可以通過語言文件來翻譯。

**$config['last_tag_open'] = '<div>';**

最後一個鏈接的起始標籤。

**$config['last_tag_close'] = '</div>';**

最後一個鏈接的結束標籤。

***************************
自定義下一頁鏈接
***************************

**$config['next_link'] = '&gt;';**

下一頁鏈接顯示的文字，如果您不想顯示該鏈接，將其設定為 FALSE 。

.. note:: 該參數的值也可以通過語言文件來翻譯。

**$config['next_tag_open'] = '<div>';**

下一頁鏈接的起始標籤。

**$config['next_tag_close'] = '</div>';**

下一頁鏈接的結束標籤。

*******************************
自定義上一頁鏈接
*******************************

**$config['prev_link'] = '&lt;';**

上一頁鏈接顯示的文字，如果您不想顯示該鏈接，將其設定為 FALSE 。

.. note:: 該參數的值也可以通過語言文件來翻譯。

**$config['prev_tag_open'] = '<div>';**

上一頁鏈接的起始標籤。

**$config['prev_tag_close'] = '</div>';**

上一頁鏈接的結束標籤。

***********************************
自定義目前頁面鏈接
***********************************

**$config['cur_tag_open'] = '<b>';**

目前頁鏈接的起始標籤。

**$config['cur_tag_close'] = '</b>';**

目前頁鏈接的結束標籤。

****************************
自定義數字鏈接
****************************

**$config['num_tag_open'] = '<div>';**

數字鏈接的起始標籤。

**$config['num_tag_close'] = '</div>';**

數字鏈接的結束標籤。

****************
隱藏數字鏈接
****************

如果您不想顯示數字鏈接（例如您只想顯示上一頁和下一頁鏈接），您可以通過下面的程式碼來阻止它顯示::

	 $config['display_pages'] = FALSE;

****************************
給鏈接加入屬性
****************************

如果您想為分頁類產生的每個鏈接加入額外的屬性，您可以通過鍵值對設定 "attributes" 參數::

	// Produces: class="myclass"
	$config['attributes'] = array('class' => 'myclass');

.. note:: 以前的通過 "anchor_class" 參數來設定 class 屬性的成員函數已經廢棄。

*****************************
停用 "rel" 屬性
*****************************

預設 rel 屬性會被自動的被加入到合適的鏈接上，如果由於某些原因，您想停用它，您可以用下面的成員函數：

::

	$config['attributes']['rel'] = FALSE;

***************
類參考
***************

.. php:class:: CI_Pagination

	.. php:method:: initialize([$params = array()])

		:param	array	$params: Configuration parameters
		:returns:	CI_Pagination instance (method chaining)
		:rtype:	CI_Pagination

		使用提供的參數初始化分頁類。

	.. php:method:: create_links()

		:returns:	HTML-formatted pagination
		:rtype:	string

		傳回分頁的程式碼，包含產生的鏈接。如果只有一個頁面，將傳回空字元串。
