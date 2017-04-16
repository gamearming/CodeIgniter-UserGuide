##############################
處理多環境
##############################

開發者常常希望當系統執行在開發環境或生產環境中時能有不同的行為，
例如，在開發環境如果程序能輸出詳細的錯誤資訊將非常有用，但是在
生產環境這將造成一些安全問題。

ENVIRONMENT 常數
========================

CodeIgniter 預設使用 ``$_SERVER['CI_ENV']`` 的值作為 ENVIRONMENT 常數，
如果 $_SERVER['CI_ENV'] 的值沒有設定，則設定為 'development'。在 index.php
文件的頂部，您可以看到::

	define('ENVIRONMENT', isset($_SERVER['CI_ENV']) ? $_SERVER['CI_ENV'] : 'development');

$_SERVER['CI_ENV'] 的值可以在 .htaccess 文件或 Apache 的設定文件中
使用 `SetEnv <https://httpd.apache.org/docs/2.2/mod/mod_env.html#setenv>`_
命令進行設定，Nginx 或其他 Web 伺服器也有類似的設定成員函數。
或者您可以直接刪掉這個邏輯，依據伺服器的 IP 地址來設定該常數。

使用這個常數，除了會影響到一些基本的框架行為外（見下一節），
您還可以在開發過程中使用它來區分目前執行的是什麼環境。

對預設框架行為的影響
=====================================

CodeIgniter 系統中有幾個地方用到了 ENVIRONMENT 常數。這一節將描述
它對框架行為有哪些影響。

錯誤報告
---------------

如果將 ENVIRONMENT 常數設定為 'development' ，當發生 PHP 
錯誤時錯誤資訊會顯示到瀏覽器上。與之相對的，如果將常數設定為
'production' 錯誤輸出則會被停用。在生產環境停用錯誤輸出是個
:doc:`不錯的安全實踐 <security>`。

設定文件
-------------------

另外，CodeIgniter 還可以依據不同的環境載入不同的設定文件，
這在處理例如不同環境下有著不同的 API Key 的情況時相當有用。
這在 :doc:`設定類 <../libraries/config>` 文件中的「環境」一節有著更詳細的介紹。
