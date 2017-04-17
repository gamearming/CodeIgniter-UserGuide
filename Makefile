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

# LaTeX ����ƪ� http://linux-wiki.cn/wiki/zh-tw/LaTeX����ƪ��]�ϥ�XeTeX�^
# fclist
help:
	@echo "�Шϥ� \`make <target>' where <target> is one of"
	@echo "  html       �sĶ�Ҧ��� .rst �ɮר� .html �ɮ�"
	@echo "  dirhtml    �sĶ��Ƨ����� index.html" 
	@echo "  singlehtml �sĶ�j���� HTML �ɮ�"
	@echo "  pickle     �sĶ�� pickle �ɮ�"
	@echo "  json       �sĶ�� JSON �ɮ�"
	@echo "  htmlhelp   �sĶ�� HTML �����M��"
	@echo "  qthelp     �sĶ�� qthelp �M��"
	@echo "  devhelp    �sĶ�� Devhelp �M��"
	@echo "  epub       make an epub"
	@echo "  latex      to make LaTeX files, you can set PAPER=a4 or PAPER=letter"
	@echo "  latexpdf   �s�@ LaTeX �ɮסA�óq�L pdflatex �B�楦��"
	@echo "  text       �sĶ����r�ɮ�"
	@echo "  man        �sĶ����U����"
	@echo "  changes    ��Ҧ��w �ק�/�s�W/�L�ɪ��M�׶i�淧�z"
	@echo "  linkcheck  �ˬd�Ҧ��~���s���������"
	@echo "  doctest    to run all doctests embedded in the documentation (if enabled)"

clean:
	-rm -rf $(BUILDDIR)/*

html:
	$(SPHINXBUILD) -b html $(ALLSPHINXOPTS) $(BUILDDIR)/html
	@echo off
	@echo "�ظm�����CHTML �����s��b $(BUILDDIR)/html ��Ƨ��C"

dirhtml:
	$(SPHINXBUILD) -b dirhtml $(ALLSPHINXOPTS) $(BUILDDIR)/dirhtml
	@echo off
	@echo "�ظm�����CHTML �����s��b $(BUILDDIR)/dirhtml ��Ƨ��C"

singlehtml:
	$(SPHINXBUILD) -b singlehtml $(ALLSPHINXOPTS) $(BUILDDIR)/singlehtml
	@echo off
	@echo "�ظm�����CHTML �����s��b $(BUILDDIR)/singlehtml ��Ƨ��C"

pickle:
	$(SPHINXBUILD) -b pickle $(ALLSPHINXOPTS) $(BUILDDIR)/pickle
	@echo off
	@echo "�ظm����; �{�b�i�H�s�� pickle �ɮסC"

json:
	$(SPHINXBUILD) -b json $(ALLSPHINXOPTS) $(BUILDDIR)/json
	@echo off
	@echo "�ظm����; �{�b�i�H�s�� JSON �ɮסC"

htmlhelp:
	$(SPHINXBUILD) -b htmlhelp $(ALLSPHINXOPTS) $(BUILDDIR)/htmlhelp
	@echo off
	@echo "�ظm����; now you can run HTML Help Workshop with the" \
	      ".hhp project file in $(BUILDDIR)/htmlhelp."

qthelp:
	$(SPHINXBUILD) -b qthelp $(ALLSPHINXOPTS) $(BUILDDIR)/qthelp
	@echo off
	@echo "�ظm����; now you can run "qcollectiongenerator" with the" \
	      ".qhcp project file in $(BUILDDIR)/qthelp, like this:"
	@echo "# qcollectiongenerator $(BUILDDIR)/qthelp/CodeIgniter.qhcp"
	@echo "To view the help file:"
	@echo "# assistant -collectionFile $(BUILDDIR)/qthelp/CodeIgniter.qhc"

devhelp:
	$(SPHINXBUILD) -b devhelp $(ALLSPHINXOPTS) $(BUILDDIR)/devhelp
	@echo off
	@echo "�ظm�����C"
	@echo "To view the help file:"
	@echo "# mkdir -p $$HOME/.local/share/devhelp/CodeIgniter"
	@echo "# ln -s $(BUILDDIR)/devhelp $$HOME/.local/share/devhelp/CodeIgniter"
	@echo "# devhelp"

epub:
	$(SPHINXBUILD) -b epub $(ALLSPHINXOPTS) $(BUILDDIR)/epub
	@echo off
	@echo "�ظm�����C The epub file is in $(BUILDDIR)/epub."

latex:
	$(SPHINXBUILD) -b latex $(ALLSPHINXOPTS) $(BUILDDIR)/latex
	@echo off
	@echo "�ظm����; the LaTeX files are in $(BUILDDIR)/latex."
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
	@echo "�ظm�����C The text files are in $(BUILDDIR)/text."

man:
	$(SPHINXBUILD) -b man $(ALLSPHINXOPTS) $(BUILDDIR)/man
	@echo off
	@echo "�ظm�����C The manual pages are in $(BUILDDIR)/man."

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
