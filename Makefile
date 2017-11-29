# $Id: Makefile,v 1.3 2006/06/10 15:00:34 dvd Exp $

#XSLT=java com.icl.saxon.StyleSheet
XSLT=saxon-xslt
#HTML2PDF=pandoc
HTML2PDF=prince
SED=sed
.SUFFIXES: .xml .html .pdf .txt

.xml.html:
	${XSLT} $< cv2html.xsl > $@  || ( rm $@; exit 1 )

.html.pdf:
	${HTML2PDF} -o $@ $<

.html.txt:
	lynx -list_inline -dump $< \
	| ${SED} -e '/^References$$/,$$d' \
	     -e '/^ *__* *$$/d' \
	     -e 's/\[[0-9][0-9]*\]//g' \
	     > $@

all: dvd_CV.html dvd_CV.txt dvd_CV.pdf dvd_CV_ac.html dvd_CV_ac.txt dvd_CV_ac.pdf

clean:
	rm *.html *.txt *.pdf
