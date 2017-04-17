# Makefile for Sphinx documentation
#

# You can set these variables from the command line.
SPHINXOPTS    =
SPHINXBUILD   = sphinx-build
PAPER         =
BUILDDIR      = build

# Internal variables.
PAPEROPT_a4     = -D latex_paper_size=a4
PAPEROPT_letter = -D latex_paper_size=letter
ALLSPHINXOPTS   = -d $(BUILDDIR)/doctrees $(PAPEROPT_$(PAPER)) $(SPHINXOPTS) source

.PHONY: help clean html dirhtml singlehtml pickle json htmlhelp qthelp devhelp epub latex latexpdf text man changes linkcheck doctest

# LaTeX 中文排版 http://linux-wiki.cn/wiki/zh-tw/LaTeX中文排版（使用XeTeX）
# fclist
help:
	@echo "請使用 \`make <target>' where <target> is one of"
	@echo "  html       編譯所有的 .rst 檔案到 .html 檔案"
	@echo "  dirhtml    編譯資料夾中的 index.html" 
	@echo "  singlehtml 編譯大型的 HTML 檔案"
	@echo "  pickle     編譯成 pickle 檔案"
	@echo "  json       編譯成 JSON 檔案"
	@echo "  htmlhelp   編譯成 HTML 說明專案"
	@echo "  qthelp     編譯成 qthelp 專案"
	@echo "  devhelp    編譯成 Devhelp 專案"
	@echo "  epub       make an epub"
	@echo "  latex      to make LaTeX files, you can set PAPER=a4 or PAPER=letter"
	@echo "  latexpdf   製作 LaTeX 檔案，並通過 pdflatex 運行它們"
	@echo "  text       編譯成文字檔案"
	@echo "  man        編譯成手冊頁面"
	@echo "  changes    對所有已 修改/新增/過時的專案進行概述"
	@echo "  linkcheck  檢查所有外部連結的完整性"
	@echo "  doctest    to run all doctests embedded in the documentation (if enabled)"

clean:
	-rm -rf $(BUILDDIR)/*

html:
	$(SPHINXBUILD) -b html $(ALLSPHINXOPTS) $(BUILDDIR)/html
	@echo off
	@echo "建置完成。HTML 頁面存放在 $(BUILDDIR)/html 資料夾。"

dirhtml:
	$(SPHINXBUILD) -b dirhtml $(ALLSPHINXOPTS) $(BUILDDIR)/dirhtml
	@echo off
	@echo "建置完成。HTML 頁面存放在 $(BUILDDIR)/dirhtml 資料夾。"

singlehtml:
	$(SPHINXBUILD) -b singlehtml $(ALLSPHINXOPTS) $(BUILDDIR)/singlehtml
	@echo off
	@echo "建置完成。HTML 頁面存放在 $(BUILDDIR)/singlehtml 資料夾。"

pickle:
	$(SPHINXBUILD) -b pickle $(ALLSPHINXOPTS) $(BUILDDIR)/pickle
	@echo off
	@echo "建置完成; 現在可以存取 pickle 檔案。"

json:
	$(SPHINXBUILD) -b json $(ALLSPHINXOPTS) $(BUILDDIR)/json
	@echo off
	@echo "建置完成; 現在可以存取 JSON 檔案。"

htmlhelp:
	$(SPHINXBUILD) -b htmlhelp $(ALLSPHINXOPTS) $(BUILDDIR)/htmlhelp
	@echo off
	@echo "建置完成; now you can run HTML Help Workshop with the" \
	      ".hhp project file in $(BUILDDIR)/htmlhelp."

qthelp:
	$(SPHINXBUILD) -b qthelp $(ALLSPHINXOPTS) $(BUILDDIR)/qthelp
	@echo off
	@echo "建置完成; now you can run "qcollectiongenerator" with the" \
	      ".qhcp project file in $(BUILDDIR)/qthelp, like this:"
	@echo "# qcollectiongenerator $(BUILDDIR)/qthelp/CodeIgniter.qhcp"
	@echo "To view the help file:"
	@echo "# assistant -collectionFile $(BUILDDIR)/qthelp/CodeIgniter.qhc"

devhelp:
	$(SPHINXBUILD) -b devhelp $(ALLSPHINXOPTS) $(BUILDDIR)/devhelp
	@echo off
	@echo "建置完成。"
	@echo "To view the help file:"
	@echo "# mkdir -p $$HOME/.local/share/devhelp/CodeIgniter"
	@echo "# ln -s $(BUILDDIR)/devhelp $$HOME/.local/share/devhelp/CodeIgniter"
	@echo "# devhelp"

epub:
	$(SPHINXBUILD) -b epub $(ALLSPHINXOPTS) $(BUILDDIR)/epub
	@echo off
	@echo "建置完成。 The epub file is in $(BUILDDIR)/epub."

latex:
	$(SPHINXBUILD) -b latex $(ALLSPHINXOPTS) $(BUILDDIR)/latex
	@echo off
	@echo "建置完成; the LaTeX files are in $(BUILDDIR)/latex."
	@echo "Run \`make' in that directory to run these through (pdf)latex" \
	      "(use \`make latexpdf' here to do that automatically)."

latexpdf:
	$(SPHINXBUILD) -b latex $(ALLSPHINXOPTS) $(BUILDDIR)/latex
	@echo "Running LaTeX files through xelatex..."
	cd $(BUILDDIR)/latex && xelatex CodeIgniter.tex && xelatex CodeIgniter.tex
	@echo "xelatex finished; the PDF files are in $(BUILDDIR)/latex."

text:
	$(SPHINXBUILD) -b text $(ALLSPHINXOPTS) $(BUILDDIR)/text
	@echo off
	@echo "建置完成。 The text files are in $(BUILDDIR)/text."

man:
	$(SPHINXBUILD) -b man $(ALLSPHINXOPTS) $(BUILDDIR)/man
	@echo off
	@echo "建置完成。 The manual pages are in $(BUILDDIR)/man."

changes:
	$(SPHINXBUILD) -b changes $(ALLSPHINXOPTS) $(BUILDDIR)/changes
	@echo off
	@echo "The overview file is in $(BUILDDIR)/changes."

linkcheck:
	$(SPHINXBUILD) -b linkcheck $(ALLSPHINXOPTS) $(BUILDDIR)/linkcheck
	@echo off
	@echo "Link check complete; look for any errors in the above output " \
	      "or in $(BUILDDIR)/linkcheck/output.txt."

doctest:
	$(SPHINXBUILD) -b doctest $(ALLSPHINXOPTS) $(BUILDDIR)/doctest
	@echo "Testing of doctests in the sources finished, look at the " \
	      "results in $(BUILDDIR)/doctest/output.txt."
