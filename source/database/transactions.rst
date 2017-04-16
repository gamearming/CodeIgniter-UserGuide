############
事務
############

CodeIgniter 允許您在支援事務安全的表上使用事務。在 MySQL 中，您需要將
表的儲存引擎設定為 InnoDb 或 BDB，而不是通常我們使用的 MyISAM 。大多數
其他資料庫平台都原生支援事務。

如果您對事務還不熟悉，我們推薦針對您正在使用的資料庫，先在網上尋找一些
在線資源學習一下。下面將假設您已經明白事務的基本概念。

CodeIgniter 的事務成員函數
======================================

CodeIgniter 使用的事務處理成員函數與流行的資料庫類 ADODB 的處理成員函數非常相似。
我們選擇這種方式是因為它極大的簡化了事務的處理過程。大多數情況下，您只需
編寫兩行程式碼就行了。

傳統的事務處理需要實現大量的工作，您必須隨時跟蹤您的查詢，並依據查詢的成功
或失敗來決定送出還是回滾。當遇到嵌套查詢時將會更加麻煩。相比之下，我們實現了
一個智能的事務系統，它將自動的為您做這些工作。（您仍然可以選擇手工管理您的
事務，但這實在是沒啥好處）

執行事務
====================

要使用事務來執行您的查詢，您可以使用 $this->db->trans_start() 和
$this->db->trans_complete() 兩個成員函數，像下面這樣::

	$this->db->trans_start();
	$this->db->query('AN SQL QUERY...');
	$this->db->query('ANOTHER QUERY...');
	$this->db->query('AND YET ANOTHER QUERY...');
	$this->db->trans_complete();

在 start 和 complete 之間，您可以執行任意多個查詢，依據查詢執行
成功或失敗，系統將自動送出或回滾。

嚴格模式 （Strict Mode）
============================

CodeIgniter 預設使用嚴格模式執行所有的事務，在嚴格模式下，如果您正在
執行多組事務，只要有一組失敗，所有組都會被回滾。如果停用嚴格模式，那麼
每一組都被視為獨立的組，這意味著其中一組失敗不會影響其他的組。

嚴格模式可以用下面的成員函數停用::

	$this->db->trans_strict(FALSE);

錯誤處理
===============

如果您的資料庫設定文件 config/database.php 中啟用了錯誤報告（db_debug = TRUE），
當送出沒有成功時，您會看到一條標準的錯誤資訊。如果沒有啟用錯誤報告，
您可以像下面這樣來管理您的錯誤::

	$this->db->trans_start();
	$this->db->query('AN SQL QUERY...');
	$this->db->query('ANOTHER QUERY...');
	$this->db->trans_complete();

	if ($this->db->trans_status() === FALSE)
	{
		// generate an error... or use the log_message() function to log your error
	}

停用事務
=====================

如果您要停用事務，可以使用 ``$this->db->trans_off()`` 成員函數來實現::

	$this->db->trans_off();

	$this->db->trans_start();
	$this->db->query('AN SQL QUERY...');
	$this->db->trans_complete();

當事務被停用時，您的查詢會自動送出，就跟沒有使用事務一樣， ``trans_start()`` 和 ``trans_complete()`` 等成員函數呼叫也將被忽略。

測試模式（Test Mode）
======================

您可以選擇性的將您的事務系統設定為 「測試模式」，這將導致您的所有
查詢都被回滾，就算查詢成功執行也一樣。要使用 「測試模式」，您只需要
將 $this->db->trans_start() 函數的第一個參數設定為 TRUE 即可::

	$this->db->trans_start(TRUE); // Query will be rolled back
	$this->db->query('AN SQL QUERY...');
	$this->db->trans_complete();

手工執行事務
=============================

如果您想手工執行事務，可以像下面這樣做::

	$this->db->trans_begin();

	$this->db->query('AN SQL QUERY...');
	$this->db->query('ANOTHER QUERY...');
	$this->db->query('AND YET ANOTHER QUERY...');

	if ($this->db->trans_status() === FALSE)
	{
		$this->db->trans_rollback();
	}
	else
	{
		$this->db->trans_commit();
	}

.. note:: 手動執行事務時，請務必使用 $this->db->trans_begin() 成員函數，
	**而不是** $this->db->trans_start() 成員函數。
