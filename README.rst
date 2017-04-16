.. image:: https://travis-ci.org/CodeIgniter_-Chinese/CodeIgniter_-user-guide.svg?branch=master 
   :target: https://travis-ci.org/CodeIgniter_-Chinese/CodeIgniter_-user-guide

#########################
CodeIgniter_ 使用手冊
#########################

********
安裝步驟
********
CodeIgniter_ 使用手冊是採用 sphinx_ 軟體進行管理，並可以產生各種不同的格式。
而書面內容則採用 ReStructured_ 文字格式書寫，非常適合作為電子書。

安裝需求
========
sphinx_ 軟體相依於 Python_，如果您的作業系統是 `OS X`_，則已經安裝 Python_ 。
請在``終端機/主控台``視窗中執行 python 命令，確認 Python_ 版本是否為 2.7.2 以上版本，
如果不是或未安裝請到 `Python 2.7.2`_ 下載並``安裝/更新``。

安裝步驟
========
1. 安裝 easy_install_
   
   - pip_ install --upgrade pip
   - pip_ install -r requirements.txt  
2. easy_install sphinx_
3. easy_install sphinxcontrib-phpdomain_
4. 安裝 CI Lexer (語法解析器，請詳閱 *cilexer/README* )，它可以對 PHP、HTML、CSS 和 JavaScript 程式碼做醒目提示。
5. cd user_guide_src
6. ``make html``


譯註：

1. Ubuntu 系統上安裝 easy_install 可以直接： ``sudo apt-get install Python -setuptools``
2. easy_install 需要 root 權限，前面加上 sudo

新增及編輯文件
==============
如果要新增或修改使用手冊，程式碼都存放在 source_ 資料夾，建議您跟其它版本管理一樣，在 *develop* 倉庫發送 pull request 到 feature 分支。

如何產生 HTML 文件？
=======================
產生 HTML 文件非常簡單， cd user_guide_src 資料夾，執行 make html 進行編譯。

編譯完成後，使用手冊、圖片等相關資料都會存放於 *build/html* 資料夾，除了第一次編譯外，以後再編譯只會針對修改的文件進行重編譯，可以節省很多時間。

如果想重新編譯一次，只需刪除 *build* 資料夾後，再執行 make html 即可。

不想自己編譯？
==============
如果不想自己編譯，可以在以下連結下載：

#. `PDF 使用手冊`_
#. `HTML 使用手冊`_
#. `Epub 使用手冊`_

********
風格指南
********
使用 sphinx_ 為 CodeIgniter_ 編寫文件，請參考 文件規範_ 一節。


.. _OS X:                    https://www.apple.com/tw/macos/how-to-upgrade/
.. _CodeIgniter:             https://CodeIgniter.com/
.. _CodeIgniter 使用手冊:    https://readthedocs.org/projects/codeigniter-userguide/
.. _PDF 使用手冊:            https://readthedocs.org/projects/codeigniter-userguide/downloads/pdf/latest/
.. _HTML 使用手冊:           https://readthedocs.org/projects/codeigniter-userguide/downloads/htmlzip/latest/
.. _Epub 使用手冊:           https://readthedocs.org/projects/codeigniter-userguide/downloads/epub/latest/
.. _CodeIgniter ie:          https://github.com/codeigniter-id/user-guide/

.. _easy_install:            http://peak.telecommunity.com/DevCenter/EasyInstall#installing-easy-install
.. _pip:                     https://pypi.python.org/pypi/pip/
.. _sphinx:                  http://tw.sphinx-doc.org/
.. _sphinxcontrib-phpdomain: https://pypi.python.org/pypi/sphinxcontrib-phpdomain
.. _ReStructured:            http://sphinx.pocoo.org/rest.html
.. _Python:                  http://python.org/
.. _Python 2.7.2:            http://python.org/download/releases/2.7.2/

.. _source:                  /source
.. _文件規範:                  /source/documentation/index.rst


