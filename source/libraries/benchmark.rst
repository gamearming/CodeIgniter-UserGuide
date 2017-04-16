##################
基準測試類
##################

CodeIgniter 有一個一直都是啟用狀態的基準測試類，用於計算兩個標記點之間的時間差。

.. note:: 該類是由系統自動載入，無需手動載入。

另外，基準測試總是在框架被呼叫的那一刻開始，在輸出類向瀏覽器發送最終的檢視之前結束。
這樣可以顯示出整個系統執行的精確時間。

.. contents::
  :local:

.. raw:: html

  <div class="custom-index container"></div>

*************************
使用基準測試類
*************************

基準測試類可以在您的 :doc:`控制器 </general/controllers>`、:doc:`檢視 </general/views>`
以及 :doc:`模型 </general/models>` 中使用。

使用流程如下：

#. 標記一個起始點
#. 標記一個結束點
#. 使用 elapsed_time 函數計算時間差。

這裡是個真實的程式碼範例::

	$this->benchmark->mark('code_start');

	// Some code happens here

	$this->benchmark->mark('code_end');

	echo $this->benchmark->elapsed_time('code_start', 'code_end');

.. note:: "code_start" 和 "code_end" 這兩個單詞是隨意的，它們只是兩個用於標記
	的單詞而已，您可以任意使用其他您想使用的單詞，另外，您也可以設定多個標記點。
	看如下範例::

		$this->benchmark->mark('dog');

		// Some code happens here

		$this->benchmark->mark('cat');

		// More code happens here

		$this->benchmark->mark('bird');

		echo $this->benchmark->elapsed_time('dog', 'cat');
		echo $this->benchmark->elapsed_time('cat', 'bird');
		echo $this->benchmark->elapsed_time('dog', 'bird');


在 性能分析器 中使用基準測試點
====================================

如果您希望您的基準測試資料顯示在 :doc:`性能分析器 </general/profiling>` 中，
那麼您的標記點就需要成對出現，而且標記點名稱需要以 _start 和 _end 結束，
每一對的標記點名稱應該一致。例如::

	$this->benchmark->mark('my_mark_start');

	// Some code happens here...

	$this->benchmark->mark('my_mark_end');

	$this->benchmark->mark('another_mark_start');

	// Some more code happens here...

	$this->benchmark->mark('another_mark_end');

閱讀 :doc:`性能分析器 </general/profiling>` 頁面瞭解更多資訊。

顯示總執行時間
===============================

如果您想顯示從 CodeIgniter 執行開始到最終結果輸出到瀏覽器之間花費的總時間，
只需簡單的將下面這行程式碼放入您的檢視文件中::

	<?php echo $this->benchmark->elapsed_time();?>

您大概也注意到了，這個成員函數和上面範例中的介紹的那個計算兩個標記點之間時間差的成員函數是一樣的，
只是不帶任何參數。當不設參數時，CodeIgniter 在向瀏覽器輸出最終結果之前不會停止計時，所以
無論您在哪裡使用該成員函數，輸出的計時結果都是總執行時間。

如果您不喜歡純 PHP 語法的話，也可以在您的檢視中使用另一種偽變數的方式來顯示總執行時間::

	{elapsed_time}

.. note:: 如果您想在您的控制器成員函數中進行基準測試，您需要設定您自己的標記起始點和結束點。

顯示記憶體佔用
=============================

如果您的 PHP 在安裝時使用了 --enable-memory-limit 參數進行編譯，您就可以在您的檢視文件中
使用下面這行程式碼來顯示整個系統所佔用的記憶體大小::

	<?php echo $this->benchmark->memory_usage();?>

.. note:: 這個成員函數只能在檢視文件中使用，顯示的結果代表整個應用所佔用的記憶體大小。

如果您不喜歡純 PHP 語法的話，也可以在您的檢視中使用另一種偽變數的方式來顯示佔用的記憶體大小::

	{memory_usage}


***************
類參考
***************

.. php:class:: CI_Benchmark

	.. php:method:: mark($name)

		:param	string	$name: the name you wish to assign to your marker
		:rtype:	void

		設定一個基準測試的標記點。

	.. php:method:: elapsed_time([$point1 = ''[, $point2 = ''[, $decimals = 4]]])

		:param	string	$point1: a particular marked point
		:param	string	$point2: a particular marked point
		:param	int	$decimals: number of decimal places for precision
		:returns:	Elapsed time
		:rtype:	string

		計算並傳回兩個標記點之間的時間差。

		如果第一個參數為空，成員函數將傳回 ``{elapsed_time}`` 偽變數。這用於在檢視中
		顯示整個系統的執行時間，輸出類將在最終輸出時使用真實的總執行時間取代掉這個偽變數。


	.. php:method:: memory_usage()

		:returns:	Memory usage info
		:rtype:	string

		只是簡單的傳回 ``{memory_usage}`` 偽變數。

		該成員函數可以在檢視的任意位置使用，直到最終輸出頁面時 :doc:`輸出類 <output>`
		才會將真實的值取代掉這個偽變數。