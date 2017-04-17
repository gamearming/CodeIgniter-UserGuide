###################
以 CLI 方式執行
###################

除了從瀏覽器中通過 URL 來呼叫程序的 :doc:`控制器 <./controllers>` 之外，
您也可以通過 CLI （命令列界面）的方式來呼叫。

.. contents:: 資料夾

什麼是 CLI ？
================

CLI （命令列界面）是一種基於文字的和計算機交互的方式。 更多資訊，
請查看 `維基百科 <http://en.wikipedia.org/wiki/Command-line_interface>`_ 。

為什麼使用命令列？
=============================

雖然不是很明顯，但是有很多情況下我們需要使用命令列來執行 CodeIgniter。

-  使用 cron 定時執行任務，而不需要使用 *wget* 或 *curl*
-  通過函數 :php:func:`is_cli()` 的傳回值來讓您的 cron 頁面不能通過 URL 存取到
-  製作交互式的任務，例如：設定權限，清除快取，備份等等
-  與其他語言進行集成，例如可以通過 C++ 呼叫一條指令來執行您模型中的程式碼。

讓我們試一試：Hello World！
=============================

讓我們先建立一個簡單的控制器，打開您的文字編輯器，新建一個文件並命名為
Tools.php，然後輸入如下的程式碼::

	<?php
	class Tools extends CI_Controller {

		public function message($to = 'World')
		{
			echo "Hello {$to}!".PHP_EOL;
		}
	}

然後將文件儲存到 *application/controllers/* 資料夾下。

現在您可以通過類似下面的 URL 來存取它::

	example.com/index.php/tools/message/to

或者，我們可以通過 CLI 來存取。在 Mac/Linux 下您可以打開一個終端，在 Windows 下您可以打開 「執行」，然後輸入 "cmd"，進入 CodeIgniter 項目所在的資料夾。

.. code-block:: bash

	$ cd /path/to/project;
	$ php index.php tools message

如果您操作正確，您應該會看到 *Hello World!* 。

.. code-block:: bash

	$ php index.php tools message "John Smith"

這裡我們傳一個參數給它，這和使用 URL 參數是一樣的。"John Smith"
被作為參數傳入並顯示出::

	Hello John Smith!

就這麼簡單！
============

簡單來說，這就是您需要知道的關於如何在命令列中使用控制器的所有事情了。
記住，這只是一個普通的控制器，所以路由和 ``_remap`` 也照樣工作。
