##########################
管理您的應用程式
##########################

預設情況下，CodeIgniter 假設您只有一個應用程式，被放置在
*application/* 資料夾下。但是，您完全可以擁有多個程序並讓
它們共享一份 CodeIgniter 。您甚至也可以對您的應用程式資料夾
改名，或將其移到其他的位置。

重命名應用程式資料夾
==================================

如果您想重命名應用程式資料夾，您只需在重命名之後打開 index.php
文件將 ``$application_folder`` 變數改成新的名字::

	$application_folder = 'application';

移動應用程式資料夾
=====================================

您可以將您的應用程式資料夾移動到除 Web 根資料夾之外的其他位置，
移到之後您需要打開 index.php 文件將 ``$application_folder``
變數改成新的位置（使用 **絕對路徑** ）::

	$application_folder = '/path/to/your/application';

在一個 CodeIgniter 下執行多個應用程式
===============================================================

如果您希望在一個 CodeIgniter 下管理多個不同的應用程式，只需簡單的
將 application 資料夾下的所有文件放置到每個應用程式獨立的子資料夾下即可。

例如，您要建立兩個應用程式："foo" 和 "bar"，您可以像下面這樣組織您的資料夾結構::

	applications/foo/
	applications/foo/config/
	applications/foo/controllers/
	applications/foo/libraries/
	applications/foo/models/
	applications/foo/views/
	applications/bar/
	applications/bar/config/
	applications/bar/controllers/
	applications/bar/libraries/
	applications/bar/models/
	applications/bar/views/

要選擇使用某個應用程式時，您需要打開 index.php 文件然後設定 ``$application_folder``
變數。例如，選擇使用 "foo" 這個應用，您可以這樣::

	$application_folder = 'applications/foo';

.. note:: 您的每一個應用程式都需要一個它自己的 index.php 文件來呼叫它，
	您可以隨便對 index.php 文件進行命名。
