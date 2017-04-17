################
遷移類
################

遷移是一種非常方便的途徑來組織和管理您的資料庫變更，當您編寫了一小段 SQL
對資料庫做了修改之後，您就需要告訴其他的開發者他們也需要執行這段 SQL ，
而且當您將應用程式部署到生產環境時，您還需要記得對資料庫已經做了哪些修改，
需要執行哪些 SQL 。

在 CodeIgniter 中，**migration** 表記錄了目前已經執行了哪些遷移，所以
您需要做的就是，修改您的應用程式文件然後呼叫 ``$this->migration->current()``
成員函數遷移到目前版本，目前版本可以在 **application/config/migration.php**
文件中進行設定。

.. contents::
  :local:

.. raw:: html

  <div class="custom-index container"></div>

********************
遷移文件命令規則
********************

每個遷移都是依據文件名中的數字順序向前或向後執行，有兩種不同的數字格式：

* **序列格式：** 每個遷移文件以數字序列格式遞增命名，從 **001** 開始，每個數字都需要占三位，
  序列之間不能有間隙。（這是 CodeIgniter 3.0 版本之前的命令方式）
* **時間戳格式：** 每個遷移文件以建立時間的時間戳來命名，格式為：**YYYYMMDDHHIISS** （例如：
  **20121031100537**），這種方式可以避免在團隊環境下以序列命名可能造成的衝突，而且也是
  CodeIgniter 3.0 之後版本中推薦的命名方式。

可以在 *application/config/migration.php* 文件中的 ``$config['migration_type']`` 參數設定命名規則。

無論您選擇了哪種規則，將這個數字格式作為遷移文件的前綴，並在後面加入一個下劃線，
再加上一個描述性的名字。如下所示：

* 001_add_blog.php (sequential numbering)
* 20121031100537_add_blog.php (timestamp numbering)

******************
建立一次遷移
******************

這裡是一個新部落格站點的第一次遷移的範例，所有的遷移文件位於 **application/migrations/** 資料夾，
並命名為這種格式：*20121031100537_add_blog.php* 。
::

	<?php

	defined('BASEPATH') OR exit('No direct script access allowed');

	class Migration_Add_blog extends CI_Migration {

		public function up()
		{
			$this->dbforge->add_field(array(
				'blog_id' => array(
					'type' => 'INT',
					'constraint' => 5,
					'unsigned' => TRUE,
					'auto_increment' => TRUE
				),
				'blog_title' => array(
					'type' => 'VARCHAR',
					'constraint' => '100',
				),
				'blog_description' => array(
					'type' => 'TEXT',
					'null' => TRUE,
				),
			));
			$this->dbforge->add_key('blog_id', TRUE);
			$this->dbforge->create_table('blog');
		}

		public function down()
		{
			$this->dbforge->drop_table('blog');
		}
	}

然後在 **application/config/migration.php** 文件中設定：``$config['migration_version'] = 20121031100537;``

*************
使用範例
*************

在這個範例中，我們在 **application/controllers/Migrate.php** 文件中加入如下的程式碼來更新資料庫::

	<?php
	
	class Migrate extends CI_Controller
	{

		public function index()
		{
			$this->load->library('migration');

			if ($this->migration->current() === FALSE)
			{
				show_error($this->migration->error_string());
			}
		}

	}

*********************
遷移參數
*********************

下表為所有可用的遷移參數。

========================== ====================== ========================== =============================================
參數                         預設值                可選項                    描述
========================== ====================== ========================== =============================================
**migration_enabled**      FALSE                  TRUE / FALSE               啟用或停用遷移
**migration_path**         APPPATH.'migrations/'  None                       遷移資料夾所在位置
**migration_version**      0                      None                       目前資料庫所使用版本
**migration_table**        migrations             None                       用於儲存目前版本的資料庫表名
**migration_auto_latest**  FALSE                  TRUE / FALSE               啟用或停用自動遷移
**migration_type**         'timestamp'            'timestamp' / 'sequential' 遷移文件的命名規則
========================== ====================== ========================== =============================================

***************
類參考
***************

.. php:class:: CI_Migration

	.. php:method:: current()

		:returns:	TRUE if no migrations are found, current version string on success, FALSE on failure
		:rtype:	mixed

		遷移至目前版本。（目前版本通過 *application/config/migration.php* 文件的 ``$config['migration_version']`` 參數設定）

	.. php:method:: error_string()

		:returns:	Error messages
		:rtype:	string

		傳回遷移過程中發生的錯誤資訊。

	.. php:method:: find_migrations()

		:returns:	An array of migration files
		:rtype:	array

		傳回 **migration_path** 資料夾下的所有遷移文件的陣列。

	.. php:method:: latest()

		:returns:	Current version string on success, FALSE on failure
		:rtype:	mixed

		這個成員函數和 ``current()`` 類似，但是它並不是遷移到 ``$config['migration_version']`` 參數所對應的版本，而是遷移到遷移文件中的最新版本。

	.. php:method:: version($target_version)

		:param	mixed	$target_version: Migration version to process
		:returns:	TRUE if no migrations are found, current version string on success, FALSE on failure
		:rtype:	mixed

		遷移到特定版本（回退或升級都可以），這個成員函數和 ``current()`` 類似，但是忽略 ``$config['migration_version']`` 參數，而是遷移到用戶指定版本。
		::

			$this->migration->version(5);
