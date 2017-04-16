##############
保留名稱
##############

為了便於編程，CodeIgniter 使用了一些函數、成員函數、類 和 變數名來實現。
因此，這些名稱不能被開發者所使用，下面是不能使用的保留名稱清單。

控制器名稱
----------------

因為您的控制器類將繼承主程序控制器，所以您的成員函數命名一定不能和
主程序控制器類中的成員函數名相同，否則您的成員函數將會覆蓋他們。
下面列出了已經保留的名稱，請不要將您的控制器命名為這些：

-  CI_Controller
-  Default
-  index

函數
---------

-  :php:func:`is_php()`
-  :php:func:`is_really_writable()`
-  ``load_class()``
-  ``is_loaded()``
-  ``get_config()``
-  :php:func:`config_item()`
-  :php:func:`show_error()`
-  :php:func:`show_404()`
-  :php:func:`log_message()`
-  :php:func:`set_status_header()`
-  :php:func:`get_mimes()`
-  :php:func:`html_escape()`
-  :php:func:`remove_invisible_characters()`
-  :php:func:`is_https()`
-  :php:func:`function_usable()`
-  :php:func:`get_instance()`
-  ``_error_handler()``
-  ``_exception_handler()``
-  ``_stringify_attributes()``

變數
---------

-  ``$config``
-  ``$db``
-  ``$lang``

常數
---------

-  ENVIRONMENT
-  FCPATH
-  SELF
-  BASEPATH
-  APPPATH
-  VIEWPATH
-  CI_VERSION
-  MB_ENABLED
-  ICONV_ENABLED
-  UTF8_ENABLED
-  FILE_READ_MODE
-  FILE_WRITE_MODE
-  DIR_READ_MODE
-  DIR_WRITE_MODE
-  FOPEN_READ
-  FOPEN_READ_WRITE
-  FOPEN_WRITE_CREATE_DESTRUCTIVE
-  FOPEN_READ_WRITE_CREATE_DESTRUCTIVE
-  FOPEN_WRITE_CREATE
-  FOPEN_READ_WRITE_CREATE
-  FOPEN_WRITE_CREATE_STRICT
-  FOPEN_READ_WRITE_CREATE_STRICT
-  SHOW_DEBUG_BACKTRACE
-  EXIT_SUCCESS
-  EXIT_ERROR
-  EXIT_CONFIG
-  EXIT_UNKNOWN_FILE
-  EXIT_UNKNOWN_CLASS
-  EXIT_UNKNOWN_METHOD
-  EXIT_USER_INPUT
-  EXIT_DATABASE
-  EXIT__AUTO_MIN
-  EXIT__AUTO_MAX