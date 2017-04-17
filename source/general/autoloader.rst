######################
自動載入資源
######################

CodeIgniter 的"自動載入"特性可以允許系統每次執行時自動初始化類庫、輔助函數和模型。
如果您需要在整個應用程式中全區使用某些資源，為方便起見可以考慮自動載入它們。

支援自動載入的有下面這些：

-  *libraries/* 資料夾下的核心類
-  *helpers/* 資料夾下的輔助函數
-  *config/* 資料夾下的用戶自定義設定文件
-  *system/language/* 資料夾下的語言文件
-  *models/* 資料夾下的模型類

要實現自動載入資源，您可以打開 **application/config/autoload.php** 文件，然後將
您需要自動載入的項加入到 autoload 陣列中。您可以在該文件中的每種類型的 autoload 
陣列的註釋中找到相應的提示。

.. note:: 加入 autoload 陣列時不用包含文件擴展名（.php）

另外，如果您想讓 CodeIgniter 使用 `Composer <https://getcomposer.org/>`_ 的自動載入，
只需將 **application/config/config.php** 設定文件中的 ``$config['composer_autoload']`` 
設定為 ``TRUE`` 或者設定為您自定義的路徑。