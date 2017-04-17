###########################
使用 CodeIgniter 類庫
###########################

所有的系統類庫都位於 *system/libraries/* 資料夾下，大多數情況下，在使用之前，
您要先在 :doc:`控制器 <controllers>` 中初始化它，使用下面的成員函數::

	$this->load->library('class_name');

'class_name' 是您想要呼叫的類庫名稱，例如，要載入 :doc:`表單驗證類庫 
<../libraries/form_validation>`，您可以這樣做::

	$this->load->library('form_validation');

一旦類庫被載入，您就可以依據該類庫的用戶指南中介紹的成員函數去使用它了。

另外，多個類庫可以通過一個陣列來同時載入。

例如::

	$this->load->library(array('email', 'table'));

建立您自己的類庫
===========================

請閱讀用戶指南中關於 :doc:`建立您自己的類庫 <creating_libraries>` 部分。