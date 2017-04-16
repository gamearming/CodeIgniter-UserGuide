########################
圖像處理類
########################

CodeIgniter 的圖像處理類可以使您完成以下的操作：

-  調整圖像大小
-  建立縮略圖
-  圖像裁剪
-  圖像旋轉
-  加入圖像水印

可以很好的支援三個主流的圖像庫：GD/GD2、NetPBM 和 ImageMagick 。

.. note:: 加入水印操作僅僅在使用 GD/GD2 時可用。另外，即使支援其他的圖像處理庫，
	但是為了計算圖像的屬性，GD 仍是必需的。然而在進行圖像處理操作時，
	還是會使用您指定的庫。

.. contents::
  :local:

.. raw:: html

  <div class="custom-index container"></div>

**********************
初始化類
**********************

跟 CodeIgniter 中的其他類一樣，可以在您的控制器中使用 ``$this->load->library()``
成員函數載入圖像處理類::

	$this->load->library('image_lib');

一旦載入，圖像處理類就可以像下面這樣使用::

	$this->image_lib

處理圖像
===================

不管您想進行何種圖像處理操作（調整大小，圖像裁剪，圖像旋轉，加入水印），
通常過程都是一樣的。您會先設定一些您想進行的圖像操作的參數，
然後呼叫四個可用成員函數中的一個。例如，建立一個圖像縮略圖::

	$config['image_library'] = 'gd2';
	$config['source_image']	= '/path/to/image/mypic.jpg';
	$config['create_thumb'] = TRUE;
	$config['maintain_ratio'] = TRUE;
	$config['width']	 = 75;
	$config['height']	= 50;

	$this->load->library('image_lib', $config);

	$this->image_lib->resize();

以上程式碼告訴 image_resize 函數去查找位於 source_image 目錄下的名為 mypic.jpg
的圖片，然後運用 GD2 圖像庫建立一個 75 X 50 像素的縮略圖。 當 maintain_ratio
選項設為 TRUE 時，產生的縮略圖將保持圖像的縱橫比例，同時盡可能的在寬度和
高度上接近所設定的 width 和 height 。
縮略圖將被命名為類似 *mypic_thumb.jpg* 的形式，並儲存在 *source_image* 的同級目錄中。

.. note:: 為了讓圖像類能進行所有操作，包含圖片的文件夾必須開啟可寫權限。

.. note:: 圖像處理的某些操作可能需要大量的伺服器記憶體。如果在處理圖像時，
	您遇到了記憶體不足錯誤，您可能需要限製圖像大小的最大值，
	和/或調整 PHP 的記憶體限制。

處理函數
==================

有五個處理函數可以呼叫：

-  $this->image_lib->resize()
-  $this->image_lib->crop()
-  $this->image_lib->rotate()
-  $this->image_lib->watermark()

當呼叫成功時，這些函數會傳回 TRUE ，否則會傳回 FALSE 。
如果呼叫失敗時，用以下函數可以讀取錯誤資訊::

	echo $this->image_lib->display_errors();

下面是一個好的做法，將函數呼叫放在條件判斷裡，當呼叫失敗時顯示錯誤的資訊::

	if ( ! $this->image_lib->resize())
	{
		echo $this->image_lib->display_errors();
	}

.. note:: 您也可以給錯誤資訊指定 HTML 格式，像下面這樣加入起始和結束標籤::

	$this->image_lib->display_errors('<p>', '</p>');

.. _processing-preferences:

參數
===========

您可以用下面的參數來對圖像處理進行設定，滿足您的要求。

注意，不是所有的參數都可以應用到每一個函數中。例如，x/y 軸參數只能被圖像裁剪使用。
但是，寬度和高度參數對裁剪函數是無效的。下表的 "可用性" 一欄將指明哪些函數可以使用對應的參數。

"可用性" 符號說明：

-  R - 調整圖像大小
-  C - 圖像裁剪
-  X - 圖像旋轉
-  W - 加入圖像水印

======================= ======================= =============================== =========================================================================== =============
參數                      預設值                  選項                            描述                                                                           可用性
======================= ======================= =============================== =========================================================================== =============
**image_library**       GD2                     GD, GD2, ImageMagick, NetPBM    設定要使用的圖像庫                                                             R, C, X, W
**library_path**        None                    None                            設定 ImageMagick 或 NetPBM 庫在伺服器上的路徑。                              R, C, X
                                                                                要使用它們中的其中任何一個，您都需要設定它們的路徑。
**source_image**        None                    None                            設定原始圖像的名稱和路徑。                                                   R, C, S, W
                                                                                路徑只能是相對或絕對的伺服器路徑，不能使用URL 。
**dynamic_output**      FALSE                   TRUE/FALSE (boolean)            決定新產生的圖像是要寫入硬盤還是記憶體中。                                      R, C, X, W
                                                                                注意，如果是產生到記憶體的話，一次只能顯示一副圖像，而且
                                                                                不能調整它在您頁面中的位置，它只是簡單的將圖像資料以及圖像的
                                                                                HTTP 頭發送到瀏覽器。
**file_permissions**    0644                    (integer)                       設定產生圖像文件的權限。                                                      R, C, X, W
                                                                                注意：權限值為八進製表示法。
**quality**             90%                     1 - 100%                        設定圖像的品質。品質越高，圖像文件越大。                                       R, C, X, W
**new_image**           None                    None                            設定目標圖像的名稱和路徑。                                                    R, C, X, W
                                                                                建立圖像副本時使用該參數，路徑只能是相對或絕對的伺服器路徑，
                                                                                不能使用URL 。
**width**               None                    None                            設定您想要的圖像寬度。                                                                 R, C
**height**              None                    None                            設定您想要的圖像高度。                                                                 R, C
**create_thumb**        FALSE                   TRUE/FALSE (boolean)            告訴圖像處理函數產生縮略圖。                                                    R
**thumb_marker**        _thumb                  None                            指定縮略圖後綴，它會被插入到文件擴展名的前面，                                R
                                                                                所以 mypic.jpg 文件會變成 mypic_thumb.jpg
**maintain_ratio**      TRUE                    TRUE/FALSE (boolean)            指定是否在縮放或使用硬值的時候                                                 R, C
                                                                                使圖像保持原始的縱橫比例。
**master_dim**          auto                    auto, width, height             指定一個選項作為縮放和建立縮略圖時的主軸。                                         R
                                                                                例如，您想要將一張圖片縮放到 100×75 像素。
                                                                                如果原來的圖像的大小不能完美的縮放到這個尺寸，
                                                                                那麼由這個參數決定把哪個軸作為硬值。
                                                                                "auto" 依據圖片到底是過高還是過長自動設定軸。
**rotation_angle**      None                    90, 180, 270, vrt, hor          指定圖片旋轉的角度。                                                         X
                                                                                注意，旋轉是逆時針的，如果想向右轉 90 度，
                                                                                就得把這個參數定義為 270 。
**x_axis**              None                    None                            為圖像的裁剪設定 X 軸上的長度。                                                   C
                                                                                例如，設為 30 就是將圖片左邊的 30 像素裁去。
**y_axis**              None                    None                            為圖像的裁剪設定Y軸上的長度。                                                     C
                                                                                例如，設為30就是將圖片頂端的30像素裁去。
======================= ======================= =============================== =========================================================================== =============

在設定文件中設定參數
====================================

如果您不喜歡使用上面的成員函數來設定參數，您可以將參數儲存到設定文件中。您只需簡單的建立一個文件
image_lib.php 並將 $config 陣列放到該文件中，然後儲存文件到 **config/image_lib.php** ，這些參數將會自動被使用。
如果您在設定文件中設定參數，那麼您就不需要使用 ``$this->image_lib->initialize()`` 成員函數了。

******************
加入圖像水印
******************

水印處理功能需要 GD/GD2 庫的支援。

水印的兩種類型
=========================

您可以使用以下兩種圖像水印處理方式：

-  **Text**：水印資訊將以文字方式產生，要麼使用您所指定的 TrueType 字體，
   要麼使用 GD 庫所支援的內部字體。如果您要使用 TrueType 版本，
   那麼您安裝的 GD 庫必須是以支援 TrueType 的形式編譯的（大多數都是，但不是所有）。
-  **Overlay**：水印資訊將以圖像方式產生，新產生的水印圖像
   （通常是透明的 PNG 或者 GIF）將覆蓋在原圖像上。

.. _watermarking:

給圖像加入水印
=====================

類似使用其他類型的圖像處理函數（resizing、cropping 和 rotating），
您也要對水印處理函數進行參數設定來產生您要的結果，範例如下::

	$config['source_image']	= '/path/to/image/mypic.jpg';
	$config['wm_text'] = 'Copyright 2006 - John Doe';
	$config['wm_type'] = 'text';
	$config['wm_font_path'] = './system/fonts/texb.ttf';
	$config['wm_font_size']	= '16';
	$config['wm_font_color'] = 'ffffff';
	$config['wm_vrt_alignment'] = 'bottom';
	$config['wm_hor_alignment'] = 'center';
	$config['wm_padding'] = '20';

	$this->image_lib->initialize($config);

	$this->image_lib->watermark();

上面的範例是使用 16 像素 True Type 字體來產生文字水印 "Copyright 2006 - John Doe" ，
該水印將出現在離圖像底部 20 像素的中下部位置。

.. note:: 當呼叫圖像類處理圖像時，所有的目標圖片必須有 "寫入" 權限， 例如：777

水印處理參數
========================

下表列舉的參數對於兩種水印處理方式（text 或 overlay）都適用。

======================= =================== ======================= ==========================================================================
參數                    預設值               選項                         描述
======================= =================== ======================= ==========================================================================
**wm_type**             text                text, overlay           設定想要使用的水印處理類型。
**source_image**        None                None                    設定原圖像的名稱和路徑，路徑必須是相對或絕對路徑，不能是 URL 。
**dynamic_output**      FALSE               TRUE/FALSE (boolean)    決定新產生的圖像是要寫入硬盤還是記憶體中。
                                                                    注意，如果是產生到記憶體的話，一次只能顯示一副圖像，而且
                                                                    不能調整它在您頁面中的位置，它只是簡單的將圖像資料以及圖像的
                                                                    HTTP 頭發送到瀏覽器。
**quality**             90%                 1 - 100%                設定圖像的品質。品質越高，圖像文件越大。
**wm_padding**          None                A number                內邊距，以像素為單位，是水印與圖片邊緣之間的距離。
**wm_vrt_alignment**    bottom              top, middle, bottom     設定水印圖像的垂直對齊方式。
**wm_hor_alignment**    center              left, center, right     設定水印圖像的水平對齊方式。
**wm_hor_offset**       None                None                    您可以指定一個水平偏移量（以像素為單位），
                                                                    用於設定水印的位置。偏移量通常是向右移動水印，
                                                                    除非您把水平對齊方式設定為 "right" ，那麼您的偏移量將會向左移動水印。
**wm_vrt_offset**       None                None                    您可以指定一個垂直偏移量（以像素為單位），
                                                                    用於設定水印的位置。偏移量通常是向下移動水印，
                                                                    除非您把垂直對齊方式設定為 "bottom"，那麼您的偏移量將會向上移動水印。
======================= =================== ======================= ==========================================================================

Text 參數
----------------

下表列舉的參數只適用於 text 水印處理方式。

======================= =================== =================== ==========================================================================
參數                            預設值       選項                     描述
======================= =================== =================== ==========================================================================
**wm_text**             None                None                您想作為水印顯示的文字。通常是一份版權聲明。
**wm_font_path**        None                None                您想使用的 TTF 字體（TrueType）在伺服器上的路徑。
                                                                如果您沒有使用這個選項，系統將使用原生的GD字體。
**wm_font_size**        16                  None                字體大小。 說明：如果您沒有使用上面的 TTF 字體選項，
                                                                那麼這個數值必須是 1-5 之間的一個數字，如果使用了 TTF ，
                                                                您可以使用任意有效的字體大小。
**wm_font_color**       ffffff              None                字體顏色，以十六進制給出。
                                                                注意，您必須給出完整的 6 位數的十六進制值（如：993300），
                                                                而不能使用 3 位數的簡化值（如：fff）。
**wm_shadow_color**     None                None                陰影的顏色, 以十六進制給出。如果此項為空，將不使用陰影。
                                                                注意，您必須給出完整的 6 位數的十六進制值（如：993300），
                                                                而不能使用 3 位數的簡化值（如：fff）。
**wm_shadow_distance**  3                   None                陰影與文字之間的距離（以像素為單位）。
======================= =================== =================== ==========================================================================

Overlay 參數
-------------------

下表列舉的參數只適用於 overlay 水印處理方式。

======================= =================== =================== ==========================================================================
參數                            預設值       選項                     描述
======================= =================== =================== ==========================================================================
**wm_overlay_path**     None                None                您想要用作水印的圖片在您伺服器上的路徑。
                                                                只在您使用了 overlay 成員函數時需要。
**wm_opacity**          50                  1 - 100             圖像不透明度。您可以指定您的水印圖片的不透明度。
                                                                這將使水印模糊化，從而不會掩蓋住底層原始圖片，通常設定為 50 。
**wm_x_transp**         4                   A number            如果您的水印圖片是一個 PNG 或 GIF 圖片，
                                                                您可以指定一種顏色用來使圖片變得 "透明" 。這項設定
                                                                （以及下面那項）將允許您指定這種顏色。它的原理是，通過指定
                                                                "X" 和 "Y" 坐標值（從左上方開始測量）來確定圖片上對應位置的某個像素，
                                                                這個像素所代表的顏色就是您要設定為透明的顏色。
**wm_y_transp**         4                   A number            與前一個選項一起，允許您指定某個像素的坐標值，
                                                                這個像素所代表的顏色就是您要設定為透明的顏色。
======================= =================== =================== ==========================================================================

***************
類參考
***************

.. php:class:: CI_Image_lib

	.. php:method:: initialize([$props = array()])

		:param	array	$props: Image processing preferences
		:returns:	TRUE on success, FALSE in case of invalid settings
		:rtype:	bool

		初始化圖像處理類。

	.. php:method:: resize()

		:returns:	TRUE on success, FALSE on failure
		:rtype:	bool

		該函數讓您能調整原始圖像的大小，建立一個副本（調整或未調整過的），
		或者建立一個縮略圖。

		建立一個副本和建立一個縮略圖之間沒有實際上的區別，
		除了縮略圖的文件名會有一個自定義的後綴（如：mypic_thumb.jpg）。

		所有列在上面 :ref:`processing-preferences` 表中的參數對這個函數都可用，
		除了這三個： *rotation_angle* 、 *x_axis* 和 *y_axis* 。

		**建立一個縮略圖**

		resize 函數能用來建立縮略圖（並保留原圖），只要您把這個參數設為 TRUE ::

			$config['create_thumb'] = TRUE;

		這一個參數決定是否建立一個縮略圖。

		**建立一個副本**

		resize 函數能建立一個圖像的副本（並保留原圖），
		只要您通過以下參數設定一個新的路徑或者文件名::

			$config['new_image'] = '/path/to/new_image.jpg';

		注意以下規則：

		-  如果只指定新圖像的名字，那麼它會被放在原圖像所在的文件夾下。
		-  如果只指定路徑，新圖像會被放在指定的文件夾下，並且名字和原圖像相同。
		-  如果同時定義了路徑和新圖像的名字，那麼新圖像會以指定的名字放在指定的文件夾下。

		**調整原圖像的大小**

		如果上述兩個參數（create_thumb 和 new_image）均未被指定，
		resize 函數的處理將直接作用於原圖像。

	.. php:method:: crop()

		:returns:	TRUE on success, FALSE on failure
		:rtype:	bool

		crop 函數的用法與 resize 函數十分接近，除了它需要您設定用於裁剪的 X 和 Y 值
		（單位是像素），如下::

			$config['x_axis'] = 100;
			$config['y_axis'] = 40;

		前面那張 :ref:`processing-preferences` 表中所列的所有參數都可以用於這個函數，
		除了這些：*rotation_angle* 、*width* 、*height* 、*create_thumb* 、*new_image* 。

		這是一個如何裁剪一張圖片的範例::

			$config['image_library'] = 'imagemagick';
			$config['library_path'] = '/usr/X11R6/bin/';
			$config['source_image']	= '/path/to/image/mypic.jpg';
			$config['x_axis'] = 100;
			$config['y_axis'] = 60;

			$this->image_lib->initialize($config);

			if ( ! $this->image_lib->crop())
			{
				echo $this->image_lib->display_errors();
			}

		.. note:: 如果沒有一個可視化的界面，是很難裁剪一張圖片的。
			因此，除非您打算製作這麼一個界面，否則這個函數並不是很有用。
			事實上我們在自己開發的 CMS 系統 ExpressionEngine 的相冊模塊中
			加入的一個基於 JavaScript 的用戶界面來選擇裁剪的區域。

	.. php:method:: rotate()

		:returns:	TRUE on success, FALSE on failure
		:rtype:	bool

		rotate 函數需要通過參數設定旋轉的角度::

			$config['rotation_angle'] = '90';

		以下是 5 個可選項：

		#. 90 - 逆時針旋轉90度。
		#. 180 - 逆時針旋轉180度。
		#. 270 - 逆時針旋轉270度。
		#. hor - 水平翻轉。
		#. vrt - 垂直翻轉。

		下面是旋轉圖片的一個範例::

			$config['image_library'] = 'netpbm';
			$config['library_path'] = '/usr/bin/';
			$config['source_image']	= '/path/to/image/mypic.jpg';
			$config['rotation_angle'] = 'hor';

			$this->image_lib->initialize($config);

			if ( ! $this->image_lib->rotate())
			{
				echo $this->image_lib->display_errors();
			}

	.. php:method:: watermark()

		:returns:	TRUE on success, FALSE on failure
		:rtype:	bool

		在圖像上加入一個水印，更多資訊請參考 :ref:`watermarking` 。

	.. php:method:: clear()

		:rtype:	void

		clear 函數重置所有之前用於處理圖片的值。當您用循環來處理一批圖片時，您可能會想使用它。

		::

			$this->image_lib->clear();

	.. php:method:: display_errors([$open = '<p>[, $close = '</p>']])

		:param	string	$open: Error message opening tag
		:param	string	$close: Error message closing tag
		:returns:	Error messages
		:rtype:	string

		傳回所有檢測到的錯誤資訊。
		::

			echo $this->image_lib->display_errors();
