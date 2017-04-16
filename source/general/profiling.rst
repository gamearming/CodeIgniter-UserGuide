##########################
程序分析
##########################

分析器類會在頁面下方顯示基準測試結果，執行過的 SQL 語句，
以及 $_POST 資料。這些資訊有助於開發過程中的調試和最佳化。

初始化類
======================

.. important:: 這個類無須初始化，如果已按照下面的方式啟用，
	他將被 :doc:`輸出類 <../libraries/output>` 自動載入。

啟用分析器
=====================

要啟用分析器，您可以在您的 :doc:`控制器 <controllers>`
成員函數的任何位置加入一行下面的程式碼::

	$this->output->enable_profiler(TRUE);

當啟用之後，將會產生一份報告插入到頁面的最底部。

使用下面的成員函數停用分析器::

	$this->output->enable_profiler(FALSE);

設定基準測試點
========================

為了讓分析器編譯並顯示您的基準測試資料，您必須使用特定的語法
來命名基準點。

請閱讀 :doc:`基準測試類 <../libraries/benchmark>` 中關於設定基準點的資料。

啟用和停用分析器中的字段
========================================

分析器中的每個字段都可以通過設定相應的控制變數為 TRUE 或 FALSE
來啟用或停用。有兩種成員函數來實現，其中的一種成員函數是：
在 *application/config/profiler.php* 文件裡設定全區的預設值。

例如::

	$config['config']          = FALSE;
	$config['queries']         = FALSE;

另一種成員函數是：在您的控制器裡通過呼叫 :doc:`輸出類 <../libraries/output>`
的 set_profiler_sections()  函數來覆蓋全區設定和預設設定::

	$sections = array(
		'config'  => TRUE,
		'queries' => TRUE
	);

	$this->output->set_profiler_sections($sections);

下表列出了可用的分析器字段和用來存取這些字段的 key 。

======================= =================================================================== ========
Key                     Description                                                         Default
======================= =================================================================== ========
**benchmarks**          在各個計時點花費的時間以及總時間           TRUE
**config**              CodeIgniter 設定變數                                        TRUE
**controller_info**     被請求的控制器類和呼叫的成員函數                           TRUE
**get**                 請求中的所有 GET 資料                                  TRUE
**http_headers**        本次請求的 HTTP 頭部                            TRUE
**memory_usage**        本次請求消耗的記憶體（單位字節）          TRUE
**post**                請求中的所有 POST 資料                                 TRUE
**queries**             列出所有執行的資料庫查詢，以及執行時間  TRUE
**uri_string**          本次請求的 URI                                      TRUE
**session_data**        目前會話中儲存的資料                                  TRUE
**query_toggle_count**  指定顯示多少個資料庫查詢，剩下的則預設折疊起來   25
======================= =================================================================== ========

.. note:: 在您的資料庫設定文件中停用 :doc:`save_queries </database/configuration>` 參數
	也可以停用資料庫查詢相關的分析器，上面說的 'queries' 字段就沒用了。
	您可以通過 ``$this->db->save_queries = TRUE;`` 來覆寫該設定。
	另外，停用這個設定也會導致您無法查看查詢語句以及
	`last_query <database/helpers>` 。