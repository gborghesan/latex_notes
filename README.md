# Latex tips and tricks

## In-line enumeration
To save space, it is usegful to make a enumered list in the form of _i)_ , _ii)_, etc.
for doing so, I define the following environment:
```
% packages for inline lists
\usepackage{paralist}
\newenvironment{inparlist}{\begin{inparaenum}[\itshape i)]}{\end{inparaenum}}
```
The usage is the same of _itemize_ environment.

## inclusion of figures
I use mainly to types of figures

- svg files made in inkscape
- eps files made in matlab

for both, I use psfrag commands to have all the text in figure uniform.
psfrag is a comman that allows to substitute a string in a eps figure with another one. THe main advantage is the it is possible to control the type of charater and size will not scale by scaling the figure. in addittion math formulas can be inserted in the figure.
See [psfrag documentation](https://ctan.org/pkg/psfrag?lang=en) for more info.
### preamble
in the preable, I add the following:

```latex
%\newcommand{\REFRESHFIGURES}{} % uncomment this to regenerate the figures
\ifdefined\REFRESHFIGURES
\usepackage{auto-pst-pdf}%this one is for eps 
\newcommand{\executeiffilenewer}[3]{%
 \ifnum\pdfstrcmp{\pdffilemoddate{#1}}%
 {\pdffilemoddate{#2}}>0%
 {\immediate\write18{#3}}\fi%
}

\newcommand{\includesvg}[1]{%
 \executeiffilenewer{images/#1.svg}{images/#1.pdf}%
 {inkscape -z -D --file=images/#1.svg %
 --export-area-page %
 --export-pdf=images/#1.pdf --export-latex}%
 \input{images/#1.pdf_tex}%
}
\else
\usepackage[off]{auto-pst-pdf}

\newcommand{\includesvg}[1]{%
 \input{images/#1.pdf_tex}%
 } 
\fi
```
The figure are generated only if the  `\REFRESHFIGURES` is defined.
The eps files must be in _images_ sub-deirectory
This code is largely taken from [here](http://tug.ctan.org/info/svg-inkscape/InkscapePDFLaTeX.pdf)
also check there how to make the svgs.
**important**

- Tested in ubuntu
- pdflatex is used for compiling
- pdf latex needs to call inkscape so
  - inkscape must be istalled
  - pdflatex must be called with the *-shell-escape* flag, e.g.:
```bash
pdflatex -shell-escape main.tex
```
### adding an svg figure
in the text, to add a figure, the following code can be use
```latex
\begin{figure}\centering
  	\def\svgwidth{\columnwidth}
  	\includesvg{figure_file}
\caption{\label{fig:figure1} A nice caption.}
\end{figure}
```
additionals psfrag commands can be used, before the `includesvg` command.
### adding an eps figure
this i do mainly for matlab-generated graphs, but can be useful also for schemes generated with [Dia](https://sourceforge.net/projects/dia-installer/)

Following examples insert two subfigures (and needs also `\usepackage{subfig}` in the preamble)
```latex
\begin{figure}
\centering
\include{macro_psfrag}
\subfloat[caption of subfig 1 \label{fig:fig1_subfig1}]{
  \psfragfig[width=0.3892\columnwidth]{filename_subfig1}
}
\hfill
\subfloat[caption of subfig 2 \label{fig:fig1_subfig2}]{
   \psfragfig[width= 0.56 \columnwidth]{filename_subfig2}
}
\caption{Main caption of the figure \label{fig:main_figure}}
\end{figure}
```
The command `\psfragfig` is part of the pstool package. it automatically generates a pdf files that contains all the images, with the text already inthere. is quite handy also for figure reuse.
