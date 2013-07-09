# $Id: Makefile,v 1.3 2006/06/10 15:00:34 dvd Exp $

#XSLT=java com.icl.saxon.StyleSheet
XSLT=saxon-xslt
.SUFFIXES: .xml .html .pdf .txt

.xml.html:
	${XSLT} $< cv2html.xsl > $@  || ( rm $@; exit 1 )

.html.txt:
	lynx -dump $< \
	| sed -e '/^References$$/,$$d' \
	     -e '/^ *__* *$$/d' \
	     -e 's/\[[0-9][0-9]*\]//g' \
	     > $@

all: dvd_CV_ac.html dvd_CV_ac.txt dvd_CV_ind.html dvd_CV_ind.txt

clean:
	rm *.html *.txt
