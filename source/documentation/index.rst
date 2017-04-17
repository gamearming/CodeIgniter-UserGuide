#################################
編寫 CodeIgniter 的文件
#################################

CodeIgniter 使用 Sphinx 來產生多種不同格式的文件，並採用 reStructuredText 語法來編寫。
如果您熟悉 Markdown 或 Textile ，您會很快上手 reStructuredText 。我們的目標是可讀性
以及對用戶的友好性，儘管是非常技術性的文件，但讀它的永遠是人類！

每一頁都應該包含該頁的一個資料夾，就像下面這樣。它是通過下面的程式碼自動建立的：

::

	.. contents::
		:local:

	.. raw:: html

	<div class="custom-index container"></div>

.. contents::
  :local:

.. raw:: html

  <div class="custom-index container"></div>

其中的 <div> 標籤採用了原始的 HTML 語法，它是文件中的一個佔位符，用於 JavaScript
動態的加入目前頁面上的任何成員函數和函數。

**************
所需工具
**************

要產生 HTML、ePub、PDF 等等這些格式的文件，您需要先安裝 Sphinx 和 Sphinx 的 phpdomain
擴展，並確保您已經安裝了 Python 。然後安裝 CI Lexer for Pygments ，它可以正確的高亮
頁面中的程式碼。

.. code-block:: bash

	easy_install "sphinx==1.2.3"
	easy_install "sphinxcontrib-phpdomain==0.1.3.post1"

然後按照 :samp:`cilexer` 資料夾下的 README 文件的提示，來安裝 CI Lexer 。

*****************************************
頁面標題、小節標題 和 子標題
*****************************************

在一個頁面中標題可以用於對內容進行排序，將內容分成章節，而且還可以用於自動產生
頁面資料夾以及整個文件的資料夾。可以使用特定的某些字元作為下劃線來表示標題，主標題
（例如頁面標題和小節標題）還需要使用上劃線，其他的標題只需要使用下劃線即可。
層次結構如下::

	# 頁面標題（帶上劃線）
	* 小節標題（帶上劃線）
	= 子標題
	- 子子標題
	^ 子子子標題
	" 子子子子標題 (!)

使用 :download:`TextMate ELDocs Bundle <./ELDocs.tmbundle.zip>` 可以用下面這些 tab
快捷鍵快速建立這些標題::

	title->

		##########
		Page Title
		##########

	sec->

		*************
		Major Section
		*************

	sub->

		Subsection
		==========

	sss->

		SubSubSection
		-------------

	ssss->

		SubSubSubSection
		^^^^^^^^^^^^^^^^

	sssss->

		SubSubSubSubSection (!)
		"""""""""""""""""""""""

********************
為成員函數編寫文件
********************

當您為其他開發者編寫類或成員函數的文件時，Sphinx 提供了一些指令可以幫您簡單快速的完成。
例如，看下面的 ReST 語法：

.. code-block:: rst

	.. php:class:: Some_class

		.. php:method:: some_method ( $foo [, $bar [, $bat]])

			This function will perform some action. The ``$bar`` array must contain
			a something and something else, and along with ``$bat`` is an optional
			parameter.

			:param int $foo: the foo id to do something in
			:param mixed $bar: A data array that must contain a something and something else
			:param bool $bat: whether or not to do something
			:returns: FALSE on failure, TRUE if successful
			:rtype: bool

			::

				$this->load->library('some_class');

				$bar = array(
					'something'		=> 'Here is this parameter!',
					'something_else'	=> 42
				);

				$bat = $this->some_class->should_do_something();

				if ($this->some_class->some_method(4, $bar, $bat) === FALSE)
				{
					show_error('An Error Occurred Doing Some Method');
				}

			.. note:: Here is something that you should be aware of when using some_method().
					For real.

			See also :meth:`Some_class::should_do_something`


		.. php:method:: should_do_something()

			:returns: Whether or not something should be done
			:rtype: bool


它產生的文件如下所示：

.. php:class:: Some_class


	.. php:method:: some_method ( $foo [, $bar [, $bat]])

		This function will perform some action. The ``$bar`` array must contain
		a something and something else, and along with ``$bat`` is an optional
		parameter.

		:param int $foo: the foo id to do something in
		:param mixed $bar: A data array that must contain a something and something else
		:param bool $bat: whether or not to do something
		:returns: FALSE on failure, TRUE if successful
		:rtype: bool

		::

			$this->load->library('some_class');

			$bar = array(
				'something'		=> 'Here is this parameter!',
				'something_else'	=> 42
			);

			$bat = $this->some_class->should_do_something();

			if ($this->some_class->some_method(4, $bar, $bat) === FALSE)
			{
				show_error('An Error Occurred Doing Some Method');
			}

		.. note:: Here is something that you should be aware of when using some_method().
				For real.

		See also :meth:`Some_class::should_do_something`


	.. php:method:: should_do_something()

		:returns: Whether or not something should be done
		:rtype: bool
