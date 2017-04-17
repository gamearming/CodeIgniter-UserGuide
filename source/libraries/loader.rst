############
載入器類
############

載入器，顧名思義，是用於載入元素的，載入的元素可以是庫（類），:doc:`檢視文件 <../general/views>` ，
:doc:`驅動器 <../general/drivers>` ，:doc:`輔助函數 <../general/helpers>` ，
:doc:`模型 <../general/models>` 或其他您自己的文件。

.. note:: 該類由系統自動載入，您無需手工載入。

.. contents::
  :local:

.. raw:: html

  <div class="custom-index container"></div>

**********************
應用程式"包"
**********************

應用程式包（Package）可以很便捷的將您的應用部署在一個獨立的資料夾中，
以實現自己整套的類庫，模型，輔助函數，設定，文件和語言包。
建議將這些應用程式包放置在 application/third_party 資料夾下。
下面是一個簡單應用程式包的資料夾結構。

下面是一個名為 "Foo Bar" 的應用程式包資料夾的範例。

::

  /application/third_party/foo_bar

  config/
  helpers/
  language/
  libraries/
  models/

無論應用程式包是為了實現什麼樣的目的，它都包含了屬於自己的設定文件、
輔助函數、語言包、類庫和模型。如果要在您的控制器裡使用這些資源，
您首先需要告知載入器（Loader）從應用程式包載入資源，使用
``add_package_path()`` 成員函數來加入包的路徑。

包的檢視文件
------------------

預設情況下，當呼叫 ``add_package_path()`` 成員函數時，包的檢視文件路徑就設定好了。
檢視文件的路徑是通過一個循環來查找的，一旦找到第一個匹配的即載入該檢視。

在這種情況下，它可能在包內產生檢視命名衝突，並可能導致載入錯誤的包。
為了確保不會發生此類問題，在呼叫 ``add_package_path()`` 成員函數時，
可以將可選的第二個參數設定為 FALSE 。

::

  $this->load->add_package_path(APPPATH.'my_app', FALSE);
  $this->load->view('my_app_index'); // Loads
  $this->load->view('welcome_message'); // Will not load the default welcome_message b/c the second param to add_package_path is FALSE

  // Reset things
  $this->load->remove_package_path(APPPATH.'my_app');

  // Again without the second parameter:
  $this->load->add_package_path(APPPATH.'my_app');
  $this->load->view('my_app_index'); // Loads
  $this->load->view('welcome_message'); // Loads

***************
類參考
***************

.. php:class:: CI_Loader

  .. php:method:: library($library[, $params = NULL[, $object_name = NULL]])

    :param  mixed $library: Library name as a string or an array with multiple libraries
    :param  array $params: Optional array of parameters to pass to the loaded library's constructor
    :param  string  $object_name: Optional object name to assign the library to
    :returns: CI_Loader instance (method chaining)
    :rtype: CI_Loader

    該成員函數用於載入核心類。

    .. note:: 我們有時候說 "類" ，有時候說 "庫" ，這兩個詞不做區分。

    例如，如果您想使用 CodeIgniter 發送郵件，第一步就是在控制器中載入 email 類::

      $this->load->library('email');

    載入完之後，email 類就可以使用 ``$this->email`` 來存取使用了。

    類庫文件可以被儲存到主 libraries 資料夾的子資料夾下面，或者儲存到個人的 *application/libraries*
    資料夾下。要載入子資料夾下的文件，只需將路徑包含進來就可以了，注意這裡說的路徑是指相對於
    libraries 資料夾的路徑。 例如，當您有一個文件儲存在下面這個位置::

      libraries/flavors/Chocolate.php

    您應該使用下面的方式來載入它::

      $this->load->library('flavors/chocolate');

    您可以隨心所欲地將文件儲存到多層的子資料夾下。

    另外，您可以同時載入多個類，只需給 library 成員函數傳入一個包含所有要載入的類名的陣列即可::

      $this->load->library(array('email', 'table'));

    **設定選項**

    第二個參數是可選的，用於選擇性地傳遞設定參數。一般來說，您可以將參數以陣列的形式傳遞過去::

      $config = array(
        'mailtype' => 'html',
        'charset'  => 'utf-8',
        'priority' => '1'
      );

      $this->load->library('email', $config);


    設定參數通常也可以儲存在一個設定文件中，在每個類庫自己的頁面中有詳細的說明，
    所以在使用類庫之前，請認真閱讀說明。

    請注意，當第一個參數使用陣列來同時載入多個類時，每個類將獲得相同的參數資訊。

    **給類庫分配不同的物件名**

    第三個參數也是可選的，如果為空，類庫通常就會被賦值給一個與類庫同名的物件。
    例如，如果類庫名為 Calendar ，它將會被賦值給一個名為 ``$this->calendar`` 的變數。

    如果您希望使用您的自定義名稱，您可以通過第三個參數把它傳遞過去::

      $this->load->library('calendar', NULL, 'my_calendar');

      // Calendar class is now accessed using:
      $this->my_calendar

    請注意，當第一個參數使用陣列來同時載入多個類時，第三個參數將不起作用。

  .. php:method:: driver($library[, $params = NULL[, $object_name]])

    :param  mixed $library: Library name as a string or an array with multiple libraries
    :param  array $params: Optional array of parameters to pass to the loaded library's constructor
    :param  string  $object_name: Optional object name to assign the library to
    :returns: CI_Loader instance (method chaining)
    :rtype: CI_Loader

    該成員函數用於載入驅動器類，和 ``library()`` 成員函數非常相似。

    例如，如果您想在 CodeIgniter 中使用會話，第一步就是在控制器中載入 session 驅動器::

      $this->load->driver('session');

    載入完之後，session 驅動器就可以使用 ``$this->session`` 來存取使用了。

    驅動器文件可以被儲存到主 libraries 資料夾的子資料夾下面，或者儲存到個人的 *application/libraries*
    資料夾下。子資料夾的名稱必須和驅動器父類的名稱一致，您可以閱讀 :doc:`驅動器 <../general/drivers>`
    瞭解詳細資訊。

    另外，您可以同時載入多個驅動器，只需給 driver 成員函數傳入一個包含所有要載入的驅動器名的陣列即可::
    ::

      $this->load->driver(array('session', 'cache'));

    **設定選項**

    第二個參數是可選的，用於選擇性地傳遞設定參數。一般來說，您可以將參數以陣列的形式傳遞過去::

      $config = array(
        'sess_driver' => 'cookie',
        'sess_encrypt_cookie'  => true,
        'encryption_key' => 'mysecretkey'
      );

      $this->load->driver('session', $config);

    設定參數通常也可以儲存在一個設定文件中，在每個類庫自己的頁面中有詳細的說明，
    所以在使用類庫之前，請認真閱讀說明。

    **給類庫分配不同的物件名**

    第三個參數也是可選的，如果為空，驅動器通常就會被賦值給一個與它同名的物件。
    例如，如果驅動器名為 Session ，它將會被賦值給一個名為 ``$this->session`` 的變數。

    如果您希望使用您的自定義名稱，您可以通過第三個參數把它傳遞過去::

      $this->load->driver('session', '', 'my_session');

      // Session class is now accessed using:
      $this->my_session

  .. php:method:: view($view[, $vars = array()[, return = FALSE]])

    :param  string  $view: View name
    :param  array $vars: An associative array of variables
    :param  bool  $return: Whether to return the loaded view
    :returns: View content string if $return is set to TRUE, otherwise CI_Loader instance (method chaining)
    :rtype: mixed

    該成員函數用於載入您的檢視文件。如果您尚未閱讀本手冊的 :doc:`檢視 <../general/views>`
    章節的話，建議您先去閱讀那裡的內容，會有更詳細的函數使用說明。

    第一個參數是必須的，指定您要載入的檢視文件的名稱。

    .. note:: 無需加上 .php 擴展名，除非您使用了其他的擴展名。

    第二個參數是**可選的**，允許您傳入一個陣列或物件參數，傳入的參數將使用 PHP 的
    `extract() <http://php.net/extract>`_  函數進行提取，提取出來的變數可以在檢視中使用。
    再說一遍，請閱讀 :doc:`檢視 <../general/views>` 章節瞭解該功能的更多用法。

    第三個參數是**可選的**，用於改變成員函數的行為，將資料以字元串的形式傳回，
    而不是發送給瀏覽器。當您希望對資料進行一些特殊處理時，這個參數就非常有用。
    如果您將這個參數設定為 TRUE，成員函數就會傳回資料。這個參數的預設值是 FALSE，
    也就是資料將會被發送給瀏覽器。如果您希望資料被傳回，記得要將它賦值給一個變數::

      $string = $this->load->view('myfile', '', TRUE);

  .. php:method:: vars($vars[, $val = ''])

    :param  mixed $vars: An array of variables or a single variable name
    :param  mixed $val: Optional variable value
    :returns: CI_Loader instance (method chaining)
    :rtype: CI_Loader

    這個成員函數以一個關聯陣列作為輸入參數,將這個陣列用 PHP 的 `extract()
    <http://php.net/extract>`_ 函數轉化成與之對應的變數。這個成員函數的結果與上面的
    ``$this->load->view()`` 成員函數使用第二個參數的結果一樣。
    假如您想在控制器的構造函數中定義一些全區變數，並希望這些變數在控制器的
    每一個成員函數載入的檢視文件中都可用，這種情況下您可能想唯一使用這個函數。
    您可以多次呼叫該成員函數，資料將被快取，並被合併為一個陣列，以便轉換成變數。

  .. php:method:: get_var($key)

    :param  string  $key: Variable name key
    :returns: Value if key is found, NULL if not
    :rtype: mixed

    該成員函數檢查關聯陣列中的變數對您的檢視是否可用。當一個變數在一個類
    或者控制器的另一個成員函數裡被以這樣的方式定義時：``$this->load->vars()``，
    會做這樣的檢查。

  .. php:method:: get_vars()

    :returns: An array of all assigned view variables
    :rtype: array

    該成員函數傳回所有對檢視可用的變數。

  .. php:method:: clear_vars()

    :returns: CI_Loader instance (method chaining)
    :rtype: CI_Loader

    清除快取的檢視變數。

  .. php:method:: model($model[, $name = ''[, $db_conn = FALSE]])

    :param  mixed $model: Model name or an array containing multiple models
    :param  string  $name: Optional object name to assign the model to
    :param  string  $db_conn: Optional database configuration group to load
    :returns: CI_Loader instance (method chaining)
    :rtype: CI_Loader

    ::

      $this->load->model('model_name');


    如果您的模型位於子資料夾下，載入時將路徑包含進來即可。例如，
    如果您有一個模型位於 *application/models/blog/Queries.php* ，
    您可以使用下面的成員函數來載入::

      $this->load->model('blog/queries');

    如果您希望將您的模型賦值給一個不同的變數，您可以在第二個參數中指定::

      $this->load->model('model_name', 'fubar');
      $this->fubar->method();

  .. php:method:: database([$params = ''[, $return = FALSE[, $query_builder = NULL]]])

    :param  mixed $params: Database group name or configuration options
    :param  bool  $return: Whether to return the loaded database object
    :param  bool  $query_builder: Whether to load the Query Builder
    :returns: Loaded CI_DB instance or FALSE on failure if $return is set to TRUE, otherwise CI_Loader instance (method chaining)
    :rtype: mixed

    該成員函數用於載入資料庫類，有兩個可選的參數。
    更多資訊，請閱讀 :doc:`資料庫 <../database/index>` 。

  .. php:method:: dbforge([$db = NULL[, $return = FALSE]])

    :param  object  $db: Database object
    :param  bool  $return: Whether to return the Database Forge instance
    :returns: Loaded CI_DB_forge instance if $return is set to TRUE, otherwise CI_Loader instance (method chaining)
    :rtype: mixed

    載入 :doc:`資料庫工廠類 <../database/forge>` ，更多資訊，請參考該頁面。

  .. php:method:: dbutil([$db = NULL[, $return = FALSE]])

    :param  object  $db: Database object
    :param  bool  $return: Whether to return the Database Utilities instance
    :returns: Loaded CI_DB_utility instance if $return is set to TRUE, otherwise CI_Loader instance (method chaining)
    :rtype: mixed

    載入 :doc:`資料庫工具類 <../database/utilities>` ，更多資訊，請參考該頁面。

  .. php:method:: helper($helpers)

    :param  mixed $helpers: Helper name as a string or an array containing multiple helpers
    :returns: CI_Loader instance (method chaining)
    :rtype: CI_Loader

    該成員函數用於載入輔助函數文件，其中 file_name 為載入的文件名，不帶 _helper.php 後綴。

  .. php:method:: file($path[, $return = FALSE])

    :param  string  $path: File path
    :param  bool  $return: Whether to return the loaded file
    :returns: File contents if $return is set to TRUE, otherwise CI_Loader instance (method chaining)
    :rtype: mixed

    這是一個通用的文件載入成員函數，在第一個參數中給出文件所在的路徑和文件名，
    將會打開並讀取對應的文件。預設情況下，資料會被發送給瀏覽器，
    就如同檢視文件一樣，但如果您將第二個參數設定為 TRUE ，
    那麼資料就會以字元串的形式被傳回，而不是發送給瀏覽器。

  .. php:method:: language($files[, $lang = ''])

    :param  mixed $files: Language file name or an array of multiple language files
    :param  string  $lang: Language name
    :returns: CI_Loader instance (method chaining)
    :rtype: CI_Loader

    該成員函數是 :doc:`語言載入成員函數 <language>` ``$this->lang->load()`` 的一個別名。

  .. php:method:: config($file[, $use_sections = FALSE[, $fail_gracefully = FALSE]])

    :param  string  $file: Configuration file name
    :param  bool  $use_sections: Whether configuration values should be loaded into their own section
    :param  bool  $fail_gracefully: Whether to just return FALSE in case of failure
    :returns: TRUE on success, FALSE on failure
    :rtype: bool

    該成員函數是 :doc:`設定文件載入成員函數 <config>` ``$this->config->load()`` 的一個別名。

  .. php:method:: is_loaded($class)

    :param  string  $class: Class name
    :returns: Singleton property name if found, FALSE if not
    :rtype: mixed

    用於檢查某個類是否已經被載入。

    .. note:: 這裡的類指的是類庫和驅動器。

    如果類已經被載入，成員函數傳回它在 CodeIgniter 超級物件中被賦值的變數的名稱，
    如果沒有載入，傳回 FALSE::

      $this->load->library('form_validation');
      $this->load->is_loaded('Form_validation');  // returns 'form_validation'

      $this->load->is_loaded('Nonexistent_library');  // returns FALSE

    .. important:: 如果您有類的多個執行緒（被賦值給多個不同的屬性），那麼將傳回第一個的名稱。

    ::

      $this->load->library('form_validation', $config, 'fv');
      $this->load->library('form_validation');

      $this->load->is_loaded('Form_validation');  // returns 'fv'

  .. php:method:: add_package_path($path[, $view_cascade = TRUE])

    :param  string  $path: Path to add
    :param  bool  $view_cascade: Whether to use cascading views
    :returns: CI_Loader instance (method chaining)
    :rtype: CI_Loader

    加入一個包路徑，用於告訴載入器類使用給定的路徑來載入後續請求的資源。
    例如，"Foo Bar" 應用程式包裡有一個名為 Foo_bar.php 的類，在控制器中，
    我們可以按照如下的成員函數呼叫::

      $this->load->add_package_path(APPPATH.'third_party/foo_bar/')
        ->library('foo_bar');

  .. php:method:: remove_package_path([$path = ''])

    :param  string  $path: Path to remove
    :returns: CI_Loader instance (method chaining)
    :rtype: CI_Loader

    當您的控制器完成從應用程式包中讀取資源，如果您還需要讀取其他的應用程式包的資源，
    您會希望刪除目前使用的包路徑來讓載入器不再使用這個文件夾中的資源。
    要刪除最後一次使用的包路徑，您可以直接不帶參數的呼叫該成員函數。

    或者您也可以刪除一個特定的包路徑，指定與之前使用 ``add_package_path()`` 成員函數時
    所載入的包相同的路徑::

      $this->load->remove_package_path(APPPATH.'third_party/foo_bar/');

  .. php:method:: get_package_paths([$include_base = TRUE])

    :param  bool  $include_base: Whether to include BASEPATH
    :returns: An array of package paths
    :rtype: array

    傳回目前所有可用的包路徑。
