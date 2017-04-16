#########################
安裝說明
#########################

通過下面四步來安裝 CodeIgniter：

#. 解壓縮安裝包；
#. 將 CodeIgniter 文件夾及裡面的文件上傳到伺服器，通常 *index.php* 文件將位於網站的根目錄；
#. 使用文字編輯器打開 *application/config/config.php* 文件設定您網站的根 URL，如果您想使用加密或會話，在這裡設定上您的加密密鑰；
#. 如果您打算使用資料庫，打開 *application/config/database.php* 文件設定資料庫參數。

如果您想通過隱藏 CodeIgniter 的文件位置來增加安全性，您可以將 system 和 application 目錄修改為其他的名字，然後打開主目錄下的 *index.php* 文件將 ``$system_path`` 和 ``$application_folder`` 兩個變數設定為您修改的名字。

為了達到更好的安全性，system 和 application 目錄都應該放置在 Web 根目錄之外，這樣它們就不能通過瀏覽器直接存取。CodeIgniter 預設在每個目錄下都包含了一個 *.htaccess* 文件，用於阻止直接存取，但是最好還是將它們移出能公開存取的地方，防止出現 Web 伺服器設定更改或者 *.htaccess* 文件不被支援這些情況。

如果您想讓 views 目錄保持公開，也可以將您的 views 目錄移出 application 目錄。

移動完目錄之後，打開 index.php 文件，分別設定好 ``$system_path`` 、 ``$application_folder`` 和 ``$view_folder`` 三個變數的值，最好設定成絕對路徑，例如：「*/www/MyUser/system*」。

在生產環境還要額外再多一步，就是停用 PHP 錯誤報告以及所有其他僅在開發環境使用的功能。在 CodeIgniter 中，可以通過設定 ``ENVIRONMENT`` 常數來做到這一點，這在 :doc:`安全 <../general/security>` 這篇指南中有著更詳細的介紹。

以上就是全部安裝過程！

如果您剛剛接觸 CodeIgniter，請閱讀用戶指南的 :doc:`開始 <../overview/getting_started>` 部分，學習如何構造動態的 PHP 應用，開始享受吧！

.. toctree::
	:hidden:
	:titlesonly:

	downloads
	self
	upgrading
	troubleshooting
