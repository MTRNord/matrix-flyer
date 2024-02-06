# lists of all output files that can be made
ALL_PDF = $(patsubst %.tex,%.pdf,$(wildcard *.tex))


# makes everything that can be made
# default is pdf
all : $(ALL_PDF)

pdf : $(ALL_PDF)

%.pdf: build/index/% %.tex
	latexmk -xelatex -shell-escape $*.tex > build/index/$*/flyer_make.log || (less +G build/index/$*/flyer_make.log && exit 1)
# compile using XeLaTex
# redirects the shell output of latexmk to tmp
# if latexmk were to fail, show the tail of said output for debugging purposes
	mv `ls $*.* | grep -v '\.tex\|\.pdf\|\.dvi\|\.ps'` build/index/$*

build :
	mkdir -p build

build/index :
	mkdir -p build/index

build/index/%: build build/index
	mkdir -p build/index/$*

clean:
	rm -rf build/index
	latexmk -c

clean_% :
	latexmk -c $*.tex
	rm -rf build/index/$*
	-rm -df build/index
	-rm -df build

.PHONY: all clean pdf