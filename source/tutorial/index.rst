################
教學簡介 - 內容提要
################

這篇教學主要是介紹 CodeIgniter 框架以及 MVC 架構的基本理論，
它將由淺入深的告訴您如何建置一個基本的 CodeIgniter 程式。

本篇教學裡將以一個 **簡單的新聞系統** 開始帶領您進入 CodeIgniter 框架。
首先從讀取靜態頁面開始，緊接從資料庫讀取新聞內容並將其資料顯示出來，最後再
透過表單方式新增新聞內容。


以下是會使用到的知識：

-  模型檢視控制器的基礎知識 (Model-View-Controller)
-  路由基礎知識 (Routing)
-  表單驗證
-  資料庫的基本操作，使用查詢產生器 (Query Builder)

整篇教學分為多個章節，每個章節都會涉及到 CodeIgniter 框架的部份功能。

相關章節詳列如下：

-  教學簡介： 簡單介紹教學內容要點。 (本頁內容)
-  :doc:`靜態頁面 <static_pages>`： 此節主要介紹``控制器``、``檢視``、``路由``的基礎知識。(Controllers,Views,Routing)
-  :doc:`新聞模組 <news_section>`： 此節開始介紹``模型``的相關知識，並且執行簡單的資料庫操作。(Models)
-  :doc:`新增新聞內容 <create_news_items>`： 此節開始使用更進階的資料庫操作及表單驗證。
-  :doc:`結論 <conclusion>`： 總結整個教學，並指引出未來學習方向及其它資源連結。   

開始探索 CodeIgniter 框架強大的功能吧。

.. toctree::
	:glob:
	:hidden:
	:titlesonly:
	
	static_pages
	news_section
	create_news_items
	conclusion