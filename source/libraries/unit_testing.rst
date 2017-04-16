##################
單元測試類
##################

單元測試是一種為您的應用程式中的每個函數編寫測試的軟件開發成員函數。如果您還不熟悉這個概念，
您應該先去 Google 一下。

CodeIgniter 的單元測試類非常簡單，由一個測試成員函數和兩個顯示結果的成員函數組成。
它沒打算成為一個完整的測試套件，只是提供一個簡單的機制來測試您的程式碼是否
產生了正確的資料類型和結果。

.. contents::
  :local:

.. raw:: html

  <div class="custom-index container"></div>

******************************
使用單元測試類庫
******************************

初始化類
======================

正如 CodeIgniter 中的其他類一樣，在您的控制器中使用 ``$this->load->library()``
成員函數來初始化單元測試類::

	$this->load->library('unit_test');

初始化之後，單元測試類的物件就可以這樣存取::

	$this->unit

執行測試
=============

要執行一個測試用例，需要提供一個測試和一個期望結果，像下面這樣::

	$this->unit->run('test', 'expected result', 'test name', 'notes');

其中，test 是您希望測試的程式碼的結果，expected result 是期望傳回的結果，test name 是可選的，
您可以為您的測試取一個名字，notes 是可選的，可以填些備註資訊。例如::

	$test = 1 + 1;

	$expected_result = 2;

	$test_name = 'Adds one plus one';

	$this->unit->run($test, $expected_result, $test_name);

期望的結果可以是字面量匹配（a literal match），也可以是資料類型匹配（a data type match）。
下面是字面量匹配的範例::

	$this->unit->run('Foo', 'Foo');

下面是資料類型匹配的範例::

	$this->unit->run('Foo', 'is_string');

注意第二個參數 "is_string" ，這讓成員函數測試傳回的結果是否是字元串類型。以下是可用的資料類型的清單：

-  is_object
-  is_string
-  is_bool
-  is_true
-  is_false
-  is_int
-  is_numeric
-  is_float
-  is_double
-  is_array
-  is_null
-  is_resource

產生報告
==================

您可以在每個測試之後顯示出測試的結果，也可以先執行幾個測試，然後在最後產生一份測試結果的報告。
要簡單的顯示出測試結果，可以直接在 run 成員函數的前面使用 echo::

	echo $this->unit->run($test, $expected_result);

要顯示一份所有測試的完整報告，使用如下程式碼::

	echo $this->unit->report();

這份報告會以 HTML 的表格形式顯示出來，如果您喜歡讀取原始的資料，可以通過下面的程式碼得到一個陣列::

	echo $this->unit->result();

嚴格模式
===========

預設情況下，單元測試類在字面量匹配時是鬆散的類型匹配。看下面這個範例::

	$this->unit->run(1, TRUE);

正在測試的結果是一個數字，期望的結果是一個布爾型。但是，由於 PHP 的鬆散資料類型，
如果使用一般的比較操作符的話，上面的測試結果將會是 TRUE 。

	if (1 == TRUE) echo 'This evaluates as true';

如果願意的話，您可以將單元測試設定為嚴格模式，它不僅會比較兩個資料的值，
而且還會比較兩個資料的資料類型::

	if (1 === TRUE) echo 'This evaluates as FALSE';

使用如下程式碼啟用嚴格模式::

	$this->unit->use_strict(TRUE);

啟用/停用單元測試
===============================

如果您希望在您的程式碼中保留一些測試，只在需要的時候才被執行，可以使用下面的程式碼停用單元測試::

	$this->unit->active(FALSE);

單元測試結果顯示
=================

單元測試的結果預設顯示如下幾項：

-  Test Name (test_name)
-  Test Datatype (test_datatype)
-  Expected Datatype (res_datatype)
-  Result (result)
-  File Name (file)
-  Line Number (line)
-  Any notes you entered for the test (notes)

您可以使用 $this->unit->set_test_items() 成員函數自定義要顯示哪些結果，例如，
您只想顯示出測試名和測試的結果：

自定義顯示測試結果
---------------------------

::

	$this->unit->set_test_items(array('test_name', 'result'));

建立模板
-------------------

如果您想讓您的測試結果以不同於預設的格式顯示出來，您可以設定您自己的模板，
這裡是一個簡單的模板範例，注意那些必須的偽變數::

	$str = '
	<table border="0" cellpadding="4" cellspacing="1">
	{rows}
		<tr>
			<td>{item}</td>
			<td>{result}</td>
		</tr>
	{/rows}
	</table>';

	$this->unit->set_template($str);

.. note:: 您的模板必須在執行測試 **之前** 被定義。

***************
類參考
***************

.. php:class:: CI_Unit_test

	.. php:method:: set_test_items($items)

		:param array $items: List of visible test items
		:returns: void

		設定要在測試的結果中顯示哪些項，有效的選項有：

		  - test_name
		  - test_datatype
		  - res_datatype
		  - result
		  - file
		  - line
		  - notes

	.. php:method:: run($test[, $expected = TRUE[, $test_name = 'undefined'[, $notes = '']]])

		:param	mixed	$test: Test data
		:param	mixed	$expected: Expected result
		:param	string	$test_name: Test name
		:param	string	$notes: Any notes to be attached to the test
		:returns:	Test report
		:rtype:	string

		執行單元測試。

	.. php:method:: report([$result = array()])

		:param	array	$result: Array containing tests results
		:returns:	Test report
		:rtype:	string

		依據已執行的測試產生一份測試結果的報告。

	.. php:method:: use_strict([$state = TRUE])

		:param	bool	$state: Strict state flag
		:rtype:	void

		在測試中啟用或停用嚴格比較模式。

	.. php:method:: active([$state = TRUE])

		:param	bool	$state: Whether to enable testing
		:rtype:	void

		啟用或停用單元測試。

	.. php:method:: result([$results = array()])

		:param	array	$results: Tests results list
		:returns:	Array of raw result data
		:rtype:	array

		傳回原始的測試結果資料。

	.. php:method:: set_template($template)

		:param	string	$template: Test result template
		:rtype:	void

		設定顯示測試結果資料的模板。
