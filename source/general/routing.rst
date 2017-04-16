###########
URI 路由
###########

一般情況下，一個 URL 字串和它對應的控制器中類和成員函數是一一對應的關係。
URL 中的每一段通常遵循下面的規則::

	example.com/class/function/id/

但是有時候，您可能想改變這種對應關係，呼叫一個不同的類和成員函數，而不是
URL 中對應的那樣。

例如，假設您希望您的 URL 變成下面這樣::

	example.com/product/1/
	example.com/product/2/
	example.com/product/3/
	example.com/product/4/

URL 的第二段通常表示成員函數的名稱，但在上面的範例中，第二段是一個商品 ID ，
為了實現這一點，CodeIgniter 允許您重新定義 URL 的處理流程。

設定您自己的路由規則
==============================

路由規則定義在 *application/config/routes.php* 文件中，在這個文件中您會
發現一個名為 ``$route`` 的陣列，利用它您可以設定您自己的路由規則。
在路由規則中您可以使用萬用字元或正則表達式。

萬用字元
=========

一個典型的使用萬用字元的路由規則如下::

	$route['product/:num'] = 'catalog/product_lookup';

在一個路由規則中，陣列的鍵表示要符合的 URI ，而陣列的值表示要重定向的位置。
上面的範例中，如果 URL 的第一段是字串 "product" ，第二段是個數字，那麼，
將呼叫 "catalog" 類的 "product_lookup" 成員函數。

您可以使用純字串符合，或者使用下面兩種萬用字元：

**(:num)** 符合只含有數字的一段。
**(:any)** 符合含有任意字元的一段。（除了 '/' 字元，因為它是段與段之間的分隔字元）

.. note:: 萬用字元實際上是正則表達式的別名，**:any** 會被轉換為 **[^/]+** ，
	**:num** 會被轉換為 **[0-9]+** 。

.. note:: 路由規則將按照它們定義的順序執行，前面的規則優先級高於後面的規則。

.. note:: 路由規則並不是過濾器！設定一個這樣的路由：'foo/bar/(:num)' ，
	 *Foo* 控制器的 *bar* 成員函數還是有可能會通過一個非數字的參數被呼叫
	 （如果這個路由也是合法的話）。

範例
========

這裡是一些路由的範例::

	$route['journals'] = 'blogs';

URL 的第一段是單詞 "journals" 時，將重定向到 "blogs" 類。

::

	$route['blog/joe'] = 'blogs/users/34';

URL 包含 blog/joe 的話，將重定向到 "blogs" 類和 "users" 成員函數。ID 參數設為 "34" 。

::

	$route['product/(:any)'] = 'catalog/product_lookup';

URL 的第一段是 "product" ，第二段是任意字元時，將重定向到 "catalog" 類的
"product_lookup" 成員函數。

::

	$route['product/(:num)'] = 'catalog/product_lookup_by_id/$1';

URL 的第一段是 "product" ，第二段是數字時，將重定向到 "catalog" 類的
"product_lookup_by_id" 成員函數，並將第二段的數字作為參數傳遞給它。

.. important:: 不要在前面或後面加反斜線（'/'）。

正則表達式
===================

如果您喜歡，您可以在路由規則中使用正則表達式。任何有效的正則表達式都是
允許的，包括逆向引用。

.. note:: 如果您使用逆向引用，您需要使用美元符號代替雙斜線語法。

一個典型的使用正則表達式的路由規則看起來像下面這樣::

	$route['products/([a-z]+)/(\d+)'] = '$1/id_$2';

上例中，一個類似於 products/shirts/123 這樣的 URL 將會重定向到 "shirts"
控制器的 "id_123" 成員函數。

With regular expressions, you can also catch multiple segments at once.

例如，當一個用戶存取您的 Web 應用中的某個受密碼保護的頁面時，如果他沒有
登陸，會先跳轉到登陸頁面，您希望在他們在成功登陸後重定向回剛才那個頁面，
那麼這個範例會很有用::

	$route['login/(.+)'] = 'auth/login/$1';

.. note:: In the above example, if the ``$1`` placeholder contains a
	slash, it will still be split into multiple parameters when
	passed to ``Auth::login()``.

如果您還不知道正則表達式，可以存取 `regular-expressions.info <http://www.regular-expressions.info/>`_ 開始學習一下。

.. note:: 您也可以在您的路由規則中混用萬用字元和正則表達式。

回調函數
=========

您可以在路由規則中使用回調函數來處理逆向引用。例如::

	$route['products/([a-zA-Z]+)/edit/(\d+)'] = function ($product_type, $id)
	{
		return 'catalog/product_edit/' . strtolower($product_type) . '/' . $id;
	};

在路由中使用 HTTP 動詞
==========================

還可以在您的路由規則中使用 HTTP 動詞（請求成員函數），當您在建立 RESTful 應用時特別有用。
您可以使用標準的 HTTP 動詞（GET、PUT、POST、DELETE、PATCH），也可以使用自定義的動詞
（例如：PURGE），不區分大小寫。您需要做的就是在路由陣列後面再加一個鍵，鍵名為 HTTP
動詞。例如::

	$route['products']['put'] = 'product/insert';

上例中，當發送 PUT 請求到 "products" 這個 URI 時，將會呼叫 ``Product::insert()`` 成員函數。

::

	$route['products/(:num)']['DELETE'] = 'product/delete/$1';

當發送 DELETE 請求到第一段為 "products" ，第二段為數字這個 URL時，將會呼叫
``Product::delete()`` 成員函數，並將數字作為第一個參數。

當然，使用 HTTP 動詞是可選的。

保留路由
===============

有下面三個保留路由::

	$route['default_controller'] = 'welcome';

This route points to the action that should be executed if the URI contains
no data, which will be the case when people load your root URL.
The setting accepts a **controller/method** value and ``index()`` would be
the default method if you don't specify one. In the above example, it is
``Welcome::index()`` that would be called.

.. note:: You can NOT use a directory as a part of this setting!

You are encouraged to always have a default route as otherwise a 404 page
will appear by default.

::

	$route['404_override'] = '';

這個路由表示當用戶請求了一個不存在的頁面時該載入哪個控制器，它將會覆蓋預設的 404 錯誤頁面。Same per-directory rules as with 'default_controller' apply here as well. ``show_404()`` 函數不會受影響，它還是會繼續載入 *application/views/errors/* 目錄下的預設的 *error_404.php* 文件。

::

	$route['translate_uri_dashes'] = FALSE;

從它的布林值就能看出來這其實並不是一個路由，這個選項可以自動的將 URL
中的控制器和成員函數中的連字元（'-'）轉換為下劃線（'_'），當您需要這樣時，
它可以讓您少寫很多路由規則。由於連字元不是一個有效的類名或成員函數名，
如果您不使用它的話，將會引起一個嚴重錯誤。

.. important:: 保留的路由規則必須位於任何一般的萬用字元或正則路由的前面。
