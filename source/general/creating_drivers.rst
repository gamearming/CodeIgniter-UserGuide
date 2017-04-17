################
建立驅動器
################

驅動器資料夾及文件結構
===================================

下面是驅動器資料夾和文件結構佈局的簡單範例:

-  /application/libraries/Driver_name

   -  Driver_name.php
   -  drivers

      -  Driver_name_subclass_1.php
      -  Driver_name_subclass_2.php
      -  Driver_name_subclass_3.php

.. note:: 為了在大小寫敏感的檔案系統下保證相容性，Driver_name 資料夾必須以 
	``ucfirst()`` 函數傳回的結果格式進行命名。

.. note:: 由於驅動器的架構是子驅動器並不繼承主驅動器，因此在子驅動器裡
	無法存取主驅動器中的屬性或成員函數。

譯者補充
-------------------------------------------------

鑒於這篇文件並沒有詳細介紹什麼是驅動器（driver），驅動器的用途，以及如何
建立驅動器，下面列出一些外部資源供參考：

 - `Usage of drivers in CodeIgniter <http://sysmagazine.com/posts/132494/>`_
 - `Guide to CodeIgniter Drivers <http://tominator.comper.sk/2011/01/guide-to-codeigniter-drivers/>`_
 - `Codeigniter Drivers Tutorial <http://www.kevinphillips.co.nz/news/codeigniter-drivers-tutorial/>`_