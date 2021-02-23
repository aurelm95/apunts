#!/bin/bash
filename = main

all:
	make pdf
	make read

pdf:
	pdflatex -src -interaction=nonstopmode -halt-on-error -shell-escape ${filename}.tex

draft:
	pdflatex -src -interaction=nonstopmode -halt-on-error -draftmode ${filename}.tex

myrefOff:
	pdflatex -src -interaction=nonstopmode -halt-on-error -draftmode "\newcommand{\myref}[1]{\ref{#1}}\input{${filename}.tex}"

myrefFix:
	make clean
	make myrefOff
	make pdf

index:
	makeindex -q -s end-matter/indexstyle.ist ${filename}.idx

glossary:
	makeindex -q -s end-matter/glossarystyle.gst -o ${filename}.gls ${filename}.glo

bibliography:
	biber ${filename}

main:
	make myrefOff
	make bibliography
	make draft
	make glossary
	make index
	make pdf
	make pdf

pdfPortada:
	( cd front-matter/portada/ && pdflatex -synctex=1 -interaction=nonstopmode portada.tex )

portada:
	make pdfPortada
	make pdfPortada

clean:
	find ./ -name "${filename}.*" -not -name "${filename}.tex" -exec rm {} \;

cleanportada:
	find ./front-matter/portada/ -name "portada.*" -not -name "portada.tex" -exec rm {} \;

cleanFull:
	make clean
	make cleanportada

read:
# 	zathura main.pdf
#	okular main.pdf

full:
	make cleanportada
	make portada
	make clean
	make main
# 	make read
