all: CV.pdf

%.pdf: %.md
	pandoc -o $@ $<
