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
\usepackage{auto-pst-pdf} %this one is for eps 
\newcommand{\executeiffilenewer}[3]{
 \ifnum\pdfstrcmp{\pdffilemoddate{#1}}
 {\pdffilemoddate{#2}}>0
 {\immediate\write18{#3}}\fi
}

\newcommand{\includesvg}[1]{
 \executeiffilenewer{images/#1.svg}{images/#1.pdf}
 {inkscape -z -D --file=images/#1.svg 
 --export-area-page 
 --export-pdf=images/#1.pdf --export-latex}
 \input{images/#1.pdf_tex}
}
\else
\usepackage[off]{auto-pst-pdf}

\newcommand{\includesvg}[1]{
 \input{images/#1.pdf_tex}
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
The command `\psfragfig` is part of the pstool package. it automatically generates a pdf files that contains all the images, with the text already in there. is quite handy also for figure reuse.

## Reference
Instead of putting the type of reference before the `\ref` command, e.g. `Fig.~\ref{fig:myfig}`, I use the package _cleverref_ . This package gives the command `\cref{}`, that automatically recognises the type of reference adding the type. in case the reference need to have the first letter capitalised, the command `\Cref` is also available.
If the default behaviuor is not of (e.g. you what _Fig. 1_ in place of _Figure 1_ in the text)it is possible to define the behaviuor.
```latex
\crefformat{equation}{(#2#1#3)}
\crefformat{section}{Sec.~#2#1#3}
\crefformat{figure}{Fig.~#2#1#3}
\crefformat{paragraph}{par.~#2#1#3}
\crefformat{lstlisting}{Listing~#2#1#3}
\crefmultiformat{lstlisting}{Listings~#2#1#3}%
{ and~#2#1#3}{, #2#1#3}{ and~#2#1#3} 
```
the last line specify what to do two or more listings (will be on that in a moment) are present.
look at the [package documentation](http://tug.ctan.org/tex-archive/macros/latex/contrib/cleveref/cleveref.pdf), sincethe package has many more options.

## Source code.
To snippets of code in latex, I use the package _listings_
it has already some syntax higlight done for some languages.if you need to define your language (syntax higlighting) and the way it is presented (listing style), this is possible in the preable:
```latex
\usepackage{listings}
\usepackage{textcomp}
\definecolor{dkgreen}{rgb}{0,0.6,0}
\definecolor{gray}{rgb}{0.5,0.5,0.5}
\definecolor{mauve}{rgb}{0.58,0,0.82}
\lstdefinelanguage{lua}
  {morekeywords={and,break,do,else,elseif,end,false,for,function,if,in,local,
     nil,not,or,repeat,return,then,true,until,while},
     sensitive=true,
   morecomment=[l]{--},
   morecomment=[s]{--[[}{]]--},
   morestring=[b]",
   morestring=[d]'
  }
\lstdefinestyle{luastyle}
{
    numbers=left,
    stepnumber=5,    
    firstnumber=1,
    numberfirstline=true,
    numbersep=2pt, % how far the line-numbers are from the code 
    numberstyle=\tiny\color{gray}, % the style that is used for the line-numbers
    xleftmargin=5pt,%framexleftmargin=5mm,
    language=lua,
    inputencoding=utf8x,
    backgroundcolor=\color[rgb]{0.95,0.95,0.95},
    tabsize=2,
    rulecolor=,
        basicstyle=\footnotesize \ttfamily,
        upquote=true,
        aboveskip={1.0\baselineskip},
        columns=fixed,
        showstringspaces=false,
        extendedchars=true,
        breaklines=true,
        prebreak = \raisebox{0ex}[0ex][0ex]{\ensuremath{\hookleftarrow}},
        showtabs=false,
        showspaces=false,
        showstringspaces=false,
        identifierstyle=\ttfamily,
        commentstyle=\color[rgb]{0.133,0.545,0.133},
        stringstyle=\color[rgb]{0.627,0.126,0.941},
}  
```
then to add a snippet from a file:
```
\lstinputlisting[style=luastyle,float,caption={caption of the listing},label=listing: point]{file.lua}
```
The package has many possible options,to be checked in the [documentation](https://ctan.org/pkg/listings?lang=en).

## Gantt charts
Practically the only way i found to make these kind of charts, is tu use the _pgfgantt_ package.
An example is the following:
```
\documentclass{article}
\usepackage{pgfgantt}

\usepackage[a4paper,vmargin={1mm,1mm},hmargin={5mm,5mm}]{geometry}


%optional, to change the fonts, font files must be in the same directory
%\usepackage{fontspec}
% \setmainfont[BoldFont={CALIBRIB.TTF}, ItalicFont={CALIBRII.TTF},BoldItalicFont={CALIBRIZ.TTF}]{Calibri.ttf} 
 

% deliverable
 \newcommand{\del}[5]{
 \ganttmilestone{ \scriptsize {\begin{tabular}[r]{@{}r@{}}#2\\[-2pt]#3\end{tabular}\,}\large{#1}}{#5}
 \ganttmilestone[inline,
 milestone inline label node/.style={left=1mm}]{ \tiny{\textbf{#4}}}{#5}
 }
  \newcommand{\delsec}[2]{\ganttmilestone[inline,
 milestone inline label node/.style={left=1mm}]{ \tiny{\textbf{#1}}}{#2}}
 
  \newcommand{\milestone}[4]{\ganttmilestone[milestone/.style={fill=orange, draw=black, rounded corners=2pt}]{ \scriptsize {\begin{tabular}[r]{@{}r@{}}#2\\[-2pt]#3\end{tabular}}\, \large{#1}}{#4}}
  
 %\newcommand{\task}[5]{\ganttbar{\large {#1} \scriptsize {\shortstack[l]{#2\\#3}}}{#4}{#5}}
\newcommand{\task}[5]{\ganttbar[bar/.append style={fill=red!50,rounded corners=3pt}]{\scriptsize {\begin{tabular}[r]{@{}r@{}}#2\\[-2pt]#3\end{tabular}}
 \,\large {#1}}{#4}{#5} }
 
\newcommand{\WP}[5]{\ganttgroup{ \scriptsize {\begin{tabular}[r]{@{}r@{}}#2\\[-2pt]#3\end{tabular}}
 \,\large {#1}}{#4}{#5}}
\begin{document}
\pagestyle{empty}
%[vgrid, hgrid, bar label font=\Large,bar label text={--#1$\rightarrow$}]{
\begin{ganttchart}
[
bar /.append style={fill=red!50},
bar label anchor/.append style={align=left, text width=16em}, 
group label anchor/.append style={align=left, text width=16em}, 
milestone label anchor/.append style={align=left, text width=16em}, 
y unit chart=0.5cm, x unit=0.25cm,vgrid={*2{white},*1{black, dashed}},
group /.append style={draw=black, fill=green!50}
]{1}{48}



 \newcommand{\del}[5]{
 \ganttmilestone{ \scriptsize {\begin{tabular}[r]{@{}r@{}}#2\\[-2pt]#3\end{tabular}\,}\large{#1}}{#5}
 \ganttmilestone[inline,
 milestone inline label node/.style={left=1mm}]{ \tiny{\textbf{#4}}}{#5}
 }
  \newcommand{\delsec}[2]{\ganttmilestone[inline,
 milestone inline label node/.style={left=1mm}]{ \tiny{\textbf{#1}}}{#2}}
 
  \newcommand{\milestone}[4]{\ganttmilestone[milestone/.style={fill=orange, draw=black, rounded corners=2pt}]{ \scriptsize {\begin{tabular}[r]{@{}r@{}}#2\\[-2pt]#3\end{tabular}}\, \large{#1}}{#4}}
  
 %\newcommand{\task}[5]{\ganttbar{\large {#1} \scriptsize {\shortstack[l]{#2\\#3}}}{#4}{#5}}
\newcommand{\task}[5]{\ganttbar[bar/.append style={fill=red!50,rounded corners=3pt}]{\scriptsize {\begin{tabular}[r]{@{}r@{}}#2\\[-2pt]#3\end{tabular}}
 \,\large {#1}}{#4}{#5} }
 
\newcommand{\WP}[5]{\ganttgroup{ \scriptsize {\begin{tabular}[r]{@{}r@{}}#2\\[-2pt]#3\end{tabular}}
 \,\large {#1}}{#4}{#5}}
\begin{document}
\pagestyle{empty}
%[vgrid, hgrid, bar label font=\Large,bar label text={--#1$\rightarrow$}]{
\begin{ganttchart}
[
bar /.append style={fill=red!50},
bar label anchor/.append style={align=left, text width=16em}, 
group label anchor/.append style={align=left, text width=16em}, 
milestone label anchor/.append style={align=left, text width=16em}, 
y unit chart=0.5cm, x unit=0.25cm,vgrid={*2{white},*1{black, dashed}},
group /.append style={draw=black, fill=green!50}
]{1}{48}
\gantttitle{Year 1}{12} \gantttitle{Year 2}{12} \gantttitle{Year 3}{12} \gantttitle{Year 4}{12} \\
%\gantttitlelist{1,...,12}{1} \gantttitlelist{1,...,12}{1} \gantttitlelist{1,...,12}{1} \\
\WP{WP 1}{My}
		 {work package}{1}{48} \\
\task{T1.1}{my first}{task}{1}{4} \\
\del{D1.1}{my first}{deliverable}{KUL}{3}\\		
%%%%%%%%%%%
\WP{WP 2}{My second}
		 {work package}{1}{48} \\
\task{T2.1}{another task}
		   {in Wp 2}{1}{24} \\
%%%%%%%%%%%
\ganttbar[]{Milestones}{1}{48}\\
\milestone{M1.1}{First }{  Milestone  }{3}\\

\end{ganttchart}
\end{document}
```

