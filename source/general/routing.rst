###########
URI 路由規則
###########
一般而言 URL 字串與對應控制器中的類別和成員函數之間是一對一的關係。

通常 URL 中的片段會遵循下列規則::

	example.com/class/function/id/

如果您想改變這種對應關係，呼叫不同的類別和成員函數，而不是原本 URL 中的對應關係。

例如： 假設您希望 URL 使用以下列格式::

	example.com/product/1/
	example.com/product/2/
	example.com/product/3/
	example.com/product/4/

正常狀況下 URL 的第二段是保留給成員函數的名稱，但在上面的範例中，第二段是商品 ID，為了實現這點，CodeIgniter 允許您重新定義 URL 的處理流程。

設定自己的路由規則
==============================
路由規則定義在 *application/config/routes.php* 檔案中，在裡面您會發現 ``$route`` 的陣列，利用它就可以指定自己的路由規則，規則中可以使用萬用字元或正則表達式。

萬用字元
=========
典型萬用字元的路由規則如下::

	$route['product/:num'] = 'catalog/product_lookup';

在路由規則中，陣列的鍵值表示要比對的 URI，而陣列的值表示要轉向的目標。
上例中如果 URL 第一段是字串 "product"，第二段是個數字，那麼將呼叫 "catalog" 類別的 "product_lookup" 成員函數。
您可以使用純文字或下面兩種萬用字元來比對：

**(:num)** 只比對數字段。
**(:any)** 比對除了 '/' 字元的任意字元段。(因為 '/' 是段與段之間的分隔字元)

.. note:: -  萬用字元實際上是正則表達式的別名，**:any** 會被轉換為 **[^/]+** 而 **:num** 會被轉換為 **[0-9]+**。
          -  路由規則將按照被定義的順序執行，前面的規則優先於後面的規則。
          - 路由規則不是篩選器！設定規則例如： 'foo/bar/(:num)' 如果是有效的路徑，不會阻止控制器 *Foo* 及成員函數 *bar* 被非數字的參數呼叫。

範例
========
這裡是一些路由的範例::

	$route['journals'] = 'blogs';

URL 第一段是使用純文字 "journals" 時，將轉向到 "blogs" 類別::

	$route['blog/joe'] = 'blogs/users/34';

URL 包含 blog/joe 的話，將轉向到 "blogs" 類別和 "users" 成員函數。ID 參數設為 "34"::

	$route['product/(:any)'] = 'catalog/product_lookup';

URL 第一段是 "product"，第二段是任意字元時，將轉向到 "catalog" 類別的 "product_lookup" 成員函數::

	$route['product/(:num)'] = 'catalog/product_lookup_by_id/$1';

URL 第一段是 "product"，第二段是數字時，將轉向到 "catalog" 類別的 "product_lookup_by_id" 成員函數，並將第二段的數字作為參數傳遞給它。

.. important:: 不要在前面或後面加反斜線('/')。

正則表達式
===================
如果您偏好使用正規表達式來定義路由規則，任何合法的正規式都允許使用，包括向後引用(back-reference)。

.. note:: 如果使用向後引用(back-reference)，必須使用美元符號取代雙斜線語法。

一個典型的正則表達式的路由規則如下::

	$route['products/([a-z]+)/(\d+)'] = '$1/id_$2';

上例中類似 products/shirts/123 的 URL 會轉向到 "shirts" 控制器中 "id_123" 的成員函數。
使用正則表達式，可以一次分隔多個區段的內容。
例如： 使用者想存取 Web 應用程式受密碼保護的頁面時，只有登入成功後，才轉向目標頁面否則回到登入頁面。

可以參考以下範例::

	$route['login/(.+)'] = 'auth/login/$1';

.. note:: 上例中，如果 ``$1`` 預留位置包含斜線，那麼當傳遞給 ``Auth::login()`` 時，仍然會被分割成多個參數。
	
如果您還不是很瞭解正規表達式，更多的正規表達式，請參閱 regular-expressions.info <http://www.regular-expressions.info/> 網站開始學習。

.. note:: 可以在您的路由規則中混用萬用字元和正則表達式。

回調函數
=========
在路由規則中使用回調函數來處理向後引用(back-reference)。

例如::

	$route['products/([a-zA-Z]+)/edit/(\d+)'] = function ($product_type, $id) {
		return 'catalog/product_edit/' . strtolower($product_type) . '/' . $id;
	};

在路由中使用 HTTP 動作 (GET、PUT、POST、DELETE、PATCH)
==========================
可以在路由規則中使用 HTTP 動作(請求成員函數)，特別是建立 RESTful 應用程式時特別有用。
使用標準的 HTTP 動作或自定義動作(例如： PURGE)，不區分大小寫。要做的是在路由陣列索引裡，將動作 名稱加進去。

例如::

	$route['products']['put'] = 'product/insert';

上例中，當發送 PUT 請求到 "products" 這個 URI 時，將會呼叫 ``Product::insert()`` 成員函數。

例如::

	$route['products/(:num)']['DELETE'] = 'product/delete/$1';

當發送 DELETE 請求到第一段為 "products" ，第二段為數字這個 URL 時，將會呼叫 ``Product::delete()`` 成員函數，並將數字作為第一個參數。

保留路由
===============
下面有三個保留的路由::

	$route['default_controller'] = 'welcome';
	
指定存取根 URL 時的預設控制器，表示 URI 裡沒有任何資料。	
在上例中 ``welcome::index()`` 類別將被呼叫，如果未設定 ``index()`` 則為預設成員函數::

.. note:: 不能使用資料夾作為此設定值！

建議設定一個控制器作為預設值，否則使用 404 錯誤頁面::

$route['404_override'] = '';	

取代預設的 404 錯誤頁面，由此設定覆寫的控制器，與 "default_controller" 相同的目錄規則也適用。
不會影響到 ``show_404()`` 函數，依舊載入預設的 *application/views/errors/error_404.php* 檔案::

	$route['translate_uri_dashes'] = FALSE;
	
由布林值就知道並不是路由，此選項能夠自動將 URL 控制器和成員函數中的連接字元 ('-') 取代成下劃線 ('_')。
可以讓您少寫很多路由規則，由於連接字元 ('-') 不是有效的類別或成員函式名稱，如果不使用這個設定將導致致命錯誤。

.. important:: 任何萬用字元或正規表達式路由，保留的路由一定要留著。
              



