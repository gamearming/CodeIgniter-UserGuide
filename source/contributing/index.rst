##################################
向 CodeIgniter 貢獻您的力量
##################################

.. toctree::
	:titlesonly:

	../documentation/index
	../DCO

CodeIgniter 是一個社區驅動的項目，它會接受從社區裡貢獻的文件和程式碼。
這些貢獻都是通過 GitHub 上 `CodeIgniter 程式碼倉庫 <https://github.com/bcit-ci/CodeIgniter>`_
的 Issues 或者 `Pull Requests <https://help.github.com/articles/using-pull-requests/>`_
的形式來完成的。

Issues 是一種快速送出 bug 的方式，如果您發現了一個 CodeIgniter 的 bug 或文件錯誤，那麼請先
看看下面這幾點：

- 是否已經存在一個打開的 Issue
- 該 Issue 是否已經被修復了（檢查下 delevop 分支的程式碼，或者已關閉的 Issues）
- 這個 bug 很明顯您一個人就能修復嗎？

送出 Issues 是非常有用的，但是更好的做法是發起一個 Pull Request ，具體的做法是先 fork
主倉庫的程式碼，然後將修改的程式碼送出到您自己的副本中。這需要您會使用版本控制系統 Git 。

*******
支援
*******

請注意，GitHub 並不是用來回答一般的技術支援類問題的！If you are having trouble using a feature of CodeIgniter, ask for help on our
`forums <http://forum.codeigniter.com/>`_ instead.

If you are not sure whether you are using something correctly or if you
have found a bug, again - please ask on the forums first.

********
安全
********

Did you find a security issue in CodeIgniter?

Please *don't* disclose it publicly, but e-mail us at security@codeigniter.com,
or report it via our page on `HackerOne <https://hackerone.com/codeigniter>`_.

If you've found a critical vulnerability, we'd be happy to credit you in our
`ChangeLog <../changelog>`.

****************************
送出好問題的技巧
****************************

使用描述性的標題（如：解析器類在處理逗號時出錯），而不是使用模糊不清的標題（如：我的程式碼出錯了）

在一份報告中只送出一個問題。

在問題中指出 CodeIgniter 的版本（如：3.0-develop），以及出問題的組件（如果您知道的話）（如：解析器類）

解釋清楚您希望出現什麼結果，以及目前出現的結果是什麼。
如果有錯誤資訊的話，並附上錯誤資訊和堆棧資訊。

如果有助於闡述您的問題的話，您可以包含少量的程式碼片段。
如果有大量的程式碼或截圖的話，可以使用類似於 pastebin 或者 dropbox 這樣的服務，不要在問題報告中包含這些內容。
為這些內容設定一個合理的過期時間，至少在問題被解決或關閉之前確保它們能存取。

如果您知道如何修復該問題，您可以 fork 並在您自己的分支中修改，然後送出一個 pull request 。
並將上面說的問題報告作為 pull request 的一部分。

如果能在問題報告中描述問題重現的詳細步驟，那將是極好的。
如果您還能提供一個單元測試用例來重現該錯誤，那將更好，因為這給了修復這個問題的人一個更清晰的目標。


**********
指導手冊
**********

這裡是如何送出 Pull Requests 的一些指南，如果您送出的 Pull Requests 沒有遵循這篇指南中提出的這些，
您的送出可能會被拒絕並要求您重新送出。這可能聽起來有點難，但是為了保證我們的程式碼質量這是必須要做的。

PHP 程式碼規範
==============

所有的程式碼都必須符合 :doc:`程式碼規範指南 <../general/styleguide>`，它其實就是
`Allman 縮進風格 <https://en.wikipedia.org/wiki/Indent_style#Allman_style>`_
加上下劃線規則以及可讀的操作符。遵循程式碼規則可以讓程式碼的風格保持一致，同時也意味著代的更可讀性更好。

文件
=============

如果您的修改同時也需要在文件中另加說明，那麼您也需要在文件中加上它。新的類、成員函數、參數、預設值的修改
等等這些都需要對文件做相應的調整。每一處修改也必須要在程式碼的變更日誌（change-log）中進行更新。另外，
PHP 的文件註釋塊（PHPDoc blocks）也要修改。

相容性
=============

CodeIgniter 推薦使用 PHP 5.6 或更高的版本，但是同時它也對 PHP 5.3.7 保持相容，所以所有送出的程式碼都必須
滿足這一點。如果您用到了 PHP 5.4 （或以上版本）中的函數或新特性，這些程式碼需要回退到 PHP 5.3.7 版本的。

分支
=========

CodeIgniter 使用了 `Git-Flow <http://nvie.com/posts/a-successful-git-branching-model/>`_ 分支模型，
這要求所有的 pull request 應該送出到 develop 分支，develop 分支是正在開發的打算在下一版發佈的分支，
master 分支總是包含最新的穩定版並保持乾淨，這樣可以在例如出現緊急安全漏洞時快速的在 master 分支程式碼
上打上補丁並發佈新的版本，而無需擔心新加的功能會影響它。正是因為這個原因，所有的送出都應該在 develop
分支，發送到 master 分支的送出會被自動關閉。如果您的送出中包含多處修改，請將每一個修改都放到您獨立的分支中。

一次只做一件事：一個 pull request 應該只包含一個修改。這不是意味著說一次送出，而是一次修改（儘管大多數時候
一次送出就是一次修改）。這樣做的原因是如果您在同一個 pull request 中修改了 X 和 Y ，但是我們希望能合併 X
同時不想合併 Y ，這時我們就無法合併您的請求。您可以使用 Git-Flow 分支模型為每一個功能建立一個獨立的分支，
然後送出兩個請求。

簽名
=======

您必須對您的工作進行簽名，保證這些工作是您原創的或者不是您原創的但是您有將它們加入到開源項目中的權利。
在 Git 中籤名並沒有得到足夠重視，所以您幾乎用不到 `--signoff` 參數，但是在您送出程式碼到 CodeIgniter 時，
必須使用該參數。

.. code-block:: bash

	git commit --signoff

或簡寫：

.. code-block:: bash

	git commit -s

這個命令會依據您 git 的設定資訊在您的送出中加入簽名，例如：

	Signed-off-by: John Q Public <john.public@example.com>

如果您正在使用 Tower 客戶端，在送出窗口中會有一個 "Sign-Off" 復選框，或者您可以將 ``git commit`` 設定成
``git commit -s`` 的別名，這樣您就不用關心送出中的簽名了。

通過這種方式對您的工作進行簽名，說明您將遵守 DCO （Developer's Certificate of Origin），:doc:`/DCO`
申明的目前版本位於這份文件的根資料夾下。
