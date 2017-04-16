#########################
使用 CodeIgniter 驅動器
#########################

驅動器是一種特殊類型的類庫，它有一個父類和任意多個子類。子類可以存取父類，
但不能存取兄弟類。在您的 :doc:`控制器 <controllers>` 中，驅動器為您的類庫提供了
一種優雅的語法，從而不用將它們拆成很多離散的類。

驅動器位於 *system/libraries/* 目錄，每個驅動器都有一個獨立的目錄，目錄名和
驅動器父類的類名一致，在該目錄下還有一個子目錄，命名為 drivers，用於存放
所有子類的文件。

要使用一個驅動器，您可以在控制器中使用下面的成員函數來進行初始化::

	$this->load->driver('class_name');

class_name 是您想要呼叫的驅動器類名，例如，您要載入名為 Some_parent 的驅動器，
可以這樣::

	$this->load->driver('some_parent');

然後就可以像下面這樣呼叫該類的成員函數::

	$this->some_parent->some_method();

而對於那些子類，我們不用初始化，可以直接通過父類呼叫了::

	$this->some_parent->child_one->some_method();
	$this->some_parent->child_two->another_method();

建立您自己的驅動器
=========================

請閱讀用戶指南中關於如何 :doc:`建立您自己的驅動器 <creating_drivers>` 部分。
