################
CodeIgniter URL
################

預設情況下，CodeIgniter 中的 URL 被設計成對搜索引擎和人類友好。
不同於使用標準的 「查詢字元串」 成員函數，CodeIgniter 使用基於段的成員函數::

	example.com/news/article/my_article

.. note:: 在 CodeIgniter 中也可以使用查詢字元串的成員函數，參見下文。

URI 分段
============

如果遵循模型-檢視-控制器模式，那麼 URI 中的每一段通常表示下面的含義::

	example.com/class/function/ID

#. 第一段表示要呼叫的控制器 **類** ；
#. 第二段表示要呼叫的類中的 **函數** 或 **成員函數** ；
#. 第三段以及後面的段代表傳給控制器的參數，如 ID 或其他任何變數；

:doc:`URI 類 <../libraries/uri>` 和 :doc:`URL 輔助函數 <../helpers/url_helper>`
包含了一些函數可以讓您更容易的處理 URI 資料，另外，您的 URL 可以通過 
:doc:`URI 路由 <routing>` 進行重定向從而得到更大的靈活性。

移除 URL 中的 index.php
===========================

預設情況，您的 URL 中會包含 **index.php** 文件::

	example.com/index.php/news/article/my_article

如果您的 Apache 伺服器啟用了 *mod_rewrite* ，您可以簡單的通過一個 .htaccess
文件再加上一些簡單的規則就可以移除 index.php 了。下面是這個文件的一個範例，
其中使用了 "否定條件" 來排除某些不需要重定向的項目::

  RewriteEngine On
  RewriteCond %{REQUEST_FILENAME} !-f
  RewriteCond %{REQUEST_FILENAME} !-d
  RewriteRule ^(.*)$ index.php/$1 [L]


在上面的範例中，除已存在的資料夾和文件，其他的 HTTP 請求都會經過您的 index.php 文件。

.. note:: 這些規則並不是對所有 Web 伺服器都有效。

.. note:: 確保使用上面的規則排除掉您希望能直接存取到的資源。

加入 URL 後綴
===================

在您的 **config/config.php** 文件中您可以指定一個後綴，CodeIgniter
產生 URL 時會自動加入上它。例如，一個像這樣的 URL::

	example.com/index.php/products/view/shoes

您可以加入一個後綴，如：**.html** ，這樣頁面看起來就是這個樣子::

	example.com/index.php/products/view/shoes.html

啟用查詢字元串
======================

有些時候，您可能更喜歡使用查詢字元串格式的 URL::

	index.php?c=products&m=view&id=345

CodeIgniter 也支援這個格式，您可以在 **application/config.php** 設定文件中啟用它。
打開您的設定文件，查找下面這幾項::

	$config['enable_query_strings'] = FALSE;
	$config['controller_trigger'] = 'c';
	$config['function_trigger'] = 'm';

您只要把 "enable_query_strings" 參數設為 TRUE 即可啟用該功能。然後通過您設定的
trigger 關鍵字來存取您的控制器和成員函數::

	index.php?c=controller&m=method

.. note:: 如果您使用查詢字元串格式的 URL，您就必須自己手工構造 URL 而不能使用 URL 
	輔助函數了（以及其他產生 URL 相關的庫，例如表單輔助函數），這是由於這些庫只能處理
	分段格式的 URL 。