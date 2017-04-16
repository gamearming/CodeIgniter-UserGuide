########
疑難解答
########

如果您發現無論輸入什麼 URL 都只顯示預設頁面的話，那麼可能是您的伺服器不支援 PATH_INFO 變數，該變數用來提供搜索引擎友好的 URL 。
解決這個問題的第一步是打開 *application/config/config.php* 文件，
找到 URI Protocol 資訊，依據註釋提示，該值可以有幾種不同的設定方式，
您可以逐個嘗試一下。
如果還是不起作用，您需要讓 CodeIgniter 強制在您的 URL 中加入一個問號，
要做到這點，您可以打開 *application/config/config.php* 文件，
然後將下面的程式碼::

	$config['index_page'] = "index.php";

修改為這樣::

	$config['index_page'] = "index.php?";
