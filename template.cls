%% ============================================================================
%% template.cls -- Preliminary Design Report Class (LuaLaTeX, Hebrew / English)
%% Seminar 5523001, OrbiTech.  Structure of the skeleton is unchanged; this
%% version only improves the DESIGN CODE (v4.0, 2026-11-26):
%%   * cover: logos on one baseline-free row, equal height, never clipped,
%%     file search order, no square-bracket placeholders, copyright in English
%%   * BiDi helpers: \req \hyp \risk \idlist \pctto \xtimes ... (one LTR unit)
%%   * TOC / LOF / LOT set compactly (TOC on one page, lists flow together)
%%   * \Needspace before every heading, float parameters tuned: no orphan
%%     headings and no (almost) empty pages
%%   * breakable tables (pclongtable), automatic figure fitting (\pcAutoFit)
%%   * Pugh / risk / Gantt / figure helpers moved here from main.tex
%% Engine       : LuaLaTeX      Bibliography : biblatex + Biber (IEEE)
%% Class options: final (default) | draft  (draft shows guide boxes)
%% ============================================================================
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{template}[2026/11/26 v4.0 OrbiTech Preliminary Design Report Class]

%% ----------------------------------------------------------------------------
%% 1. Engine check, options, base class
%% ----------------------------------------------------------------------------
\RequirePackage{iftex}
\RequireLuaTeX
\RequirePackage{etoolbox}

\newif\ifpcdraft   \pcdraftfalse
\newif\ifpcFigPNG  \pcFigPNGfalse       % \pcFigPNGtrue: figures/<name>.png replaces the TikZ drawing
\DeclareOption{draft}{\pcdrafttrue}
\DeclareOption{final}{\pcdraftfalse}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{report}}
\ExecuteOptions{final}
\ProcessOptions\relax
\LoadClass[12pt,a4paper,oneside]{report}

%% ----------------------------------------------------------------------------
%% 2. Geometry, fonts, languages
%% ----------------------------------------------------------------------------
\RequirePackage[a4paper,top=2.6cm,bottom=2.4cm,left=2.5cm,right=2.5cm,headheight=15pt]{geometry}
\RequirePackage{fontspec}

%%LANG-BEGIN
\RequirePackage{polyglossia}
\setmainlanguage[numerals=arabic]{hebrew}
\setotherlanguage{english}
%%LANG-END

\defaultfontfeatures{Ligatures=TeX}

% first font found wins (course book: David CLM + Times New Roman)
\makeatletter
\newcommand{\pc@try}[1]{\ifdefempty{\pc@picked}{\IfFontExistsTF{#1}{\gdef\pc@picked{#1}}{}}{}}
\newcommand{\pc@pick}[2]{\gdef\pc@picked{}\forcsvlist{\pc@try}{#2}\let#1\pc@picked}
\newcommand{\pc@fontcmd}[3]{\edef\pc@tmpcmd{\unexpanded{#1#2}{#3}}\pc@tmpcmd}
\newcommand{\pcPickFont}{\pc@pick}
\newcommand{\pcFontCmd}{\pc@fontcmd}
\makeatother

\pcPickFont\pcLatinSerif{Times New Roman, Liberation Serif, TeX Gyre Termes, FreeSerif, Latin Modern Roman}
\pcPickFont\pcHebrewSerif{David CLM, David, Times New Roman, Liberation Serif, FreeSerif, DejaVu Serif}
\pcPickFont\pcLatinSans{Arial, Liberation Sans, TeX Gyre Heros, FreeSans, DejaVu Sans}
\pcPickFont\pcHebrewSans{Arial, Liberation Sans, FreeSans, DejaVu Sans}
\pcPickFont\pcMono{Courier New, Liberation Mono, TeX Gyre Cursor, FreeMono, DejaVu Sans Mono}

\pcFontCmd{\setmainfont}{}{\pcLatinSerif}
\pcFontCmd{\setsansfont}{}{\pcLatinSans}
\pcFontCmd{\setmonofont}{}{\pcMono}
\pcFontCmd{\newfontfamily\hebrewfont}{[Script=Hebrew]}{\pcHebrewSerif}
\pcFontCmd{\newfontfamily\hebrewfontsf}{[Script=Hebrew]}{\pcHebrewSans}
\pcFontCmd{\newfontfamily\hebrewfonttt}{[Script=Hebrew]}{\pcMono}

%% ----------------------------------------------------------------------------
%% 3. Colours (same meaning = same colour in text, tables and diagrams)
%% ----------------------------------------------------------------------------
\RequirePackage[table]{xcolor}
\definecolor{pcDark}{HTML}{0B2545}
\definecolor{pcPrimary}{HTML}{1F5FA8}
\definecolor{pcWarn}{HTML}{E8A33D}
\definecolor{pcGood}{HTML}{1B998B}
\definecolor{pcBad}{HTML}{C0392B}
\definecolor{pcGrey}{HTML}{6B7280}
\definecolor{pcZebra}{HTML}{EEF3F9}
\definecolor{pcPH}{HTML}{2B6CB0}
\colorlet{pcAccent}{pcPrimary}
\colorlet{pcTeal}{pcGood}
\colorlet{pcGold}{pcWarn}
\colorlet{pcRed}{pcBad}
\colorlet{pcLightBg}{pcZebra}

%% ----------------------------------------------------------------------------
%% 4. General packages
%% ----------------------------------------------------------------------------
\RequirePackage{graphicx}
\RequirePackage{float}
\RequirePackage{booktabs}
\RequirePackage{array}
\RequirePackage{longtable}
\RequirePackage{enumitem}
\RequirePackage{amsmath,amssymb}
\RequirePackage{caption}
\RequirePackage{placeins}
\RequirePackage{needspace}
\RequirePackage{fancyhdr}
\RequirePackage{titlesec}
\RequirePackage{tikz}
\usetikzlibrary{arrows.meta,positioning,shapes.geometric,calc,fit,backgrounds}
\RequirePackage{pgfplots}
\usepgfplotslibrary{polar}
\pgfplotsset{compat=1.17}
\RequirePackage[skins,breakable]{tcolorbox}

%%BIB-BEGIN
\RequirePackage[backend=biber,style=ieee,sorting=none,giveninits=true]{biblatex}
\IfFileExists{references.bib}{\addbibresource{references.bib}}{}
% numeric citation labels [1] stay ONE LTR unit inside Hebrew text
\renewrobustcmd*{\mkbibbrackets}[1]{\textenglish{\bibopenbracket#1\bibclosebracket}}
% bibliography heading: Hebrew chapter-style title, entries stay LTR
\defbibheading{pcbib}[מקורות]{%
  \begin{hebrew}\chapter*{#1}\addcontentsline{toc}{chapter}{#1}\BudgetBegin{bib}{4}\end{hebrew}}
%%BIB-END

%% ----------------------------------------------------------------------------
%% 5. Direction helpers (BiDi): one LTR unit per Latin / numeric item
%%    Rule: nothing Latin or numeric is ever typed bare inside Hebrew text.
%% ----------------------------------------------------------------------------
\DeclareRobustCommand{\latin}[1]{\textenglish{#1}}
\newcommand{\en}[1]{\latin{#1}}
\newcommand{\num}[1]{\latin{#1}}                       % 1.0   0.85   1,500
\newcommand{\pct}[1]{\latin{#1\%}}                     % 85%
\newcommand{\rng}[2]{\latin{#1--#2}}                   % 10--20  (range)
\newcommand{\pctrng}[2]{\latin{#1\%--#2\%}}            % 10%--20%
\newcommand{\pctto}[2]{\latin{#1\%\,$\rightarrow$\,#2\%}}   % 60% -> 90%  (one unit)
\newcommand{\numto}[2]{\latin{#1\,$\rightarrow$\,#2}}       % 14 -> 4
\newcommand{\ver}[1]{\latin{#1}}                       % v2.1
\newcommand{\money}[2]{\latin{#1\,#2}}                 % \money{\$}{1,500}
\newcommand{\numlist}[1]{\latin{#1}}                   % a list of numbers as ONE unit
\newcommand{\idlist}[1]{\latin{#1}}                    % REQ-01, REQ-05, H2, R03 as ONE unit
\newcommand{\req}[1]{\latin{REQ-#1}}                   % \req{07}
\newcommand{\hyp}[1]{\latin{H#1}}                      % \hyp{2}
\newcommand{\risk}[1]{\latin{R#1}}                     % \risk{03}
\newcommand{\xtimes}[2]{\latin{#1\,$\times$\,#2}}      % 5 x 5  (never reversed)
\newcommand{\gesym}[1]{\latin{$\ge$\,#1}}                % >= 50\%  as ONE unit
\newcommand{\lesym}[1]{\latin{$\le$\,#1}}                % <= 4
\newcommand{\hemath}[1]{\text{\texthebrew{#1}}}        % Hebrew inside a formula
\newcommand{\hmath}[1]{\ensuremath{\text{\texthebrew{#1}}}}
\newcommand{\tn}[1]{\texthebrew{#1}}                   % Hebrew text inside a TikZ node
\newcommand{\mth}[1]{\latin{\ensuremath{#1}}}                    % inline formula = one LTR unit
\newcommand{\threeD}{\mbox{תלת-ממד}}                        % one unbreakable word
\newcommand{\threeDadj}{\mbox{תלת-ממדי}}
\newcommand{\twoD}{\mbox{דו-ממד}}

\makeatletter
\AtBeginDocument{% hyperref is loaded at the end of the class: define the PDF-string mapping at \begin{document}
  \pdfstringdefDisableCommands{%
    \let\latin\@firstofone \let\textenglish\@firstofone \let\texthebrew\@firstofone
    \let\mbox\@firstofone \def\threeD{תלת-ממד}\def\threeDadj{תלת-ממדי}\def\twoD{דו-ממד}%
    \def\req#1{REQ-#1}\def\hyp#1{H#1}\def\risk#1{R#1}}}
\makeatother

% composite numbers are LTR units everywhere (TOC, captions, cross-refs)
\renewcommand{\thesection}{\latin{\arabic{chapter}.\arabic{section}}}
\renewcommand{\thesubsection}{\latin{\arabic{chapter}.\arabic{section}.\arabic{subsection}}}
\renewcommand{\thefigure}{\latin{\arabic{chapter}.\arabic{figure}}}
\renewcommand{\thetable}{\latin{\arabic{chapter}.\arabic{table}}}
\renewcommand{\theequation}{\latin{\arabic{chapter}.\arabic{equation}}}

%% ----------------------------------------------------------------------------
%% 6. Placeholders, draft guides, source lines
%% ----------------------------------------------------------------------------
\newcommand{\ph}[1]{\textcolor{pcPH}{[#1]}}
\newcommand{\phen}[1]{\textcolor{pcPH}{\latin{[#1]}}}
\newcommand{\tbv}[1]{\textcolor{pcBad}{[לאימות: #1]}}
\newcommand{\illus}{\textcolor{pcBad}{(להמחשה בלבד --- יש להחליף בנתונים אמיתיים)}}
\newcommand{\figsrc}[1]{\par\vspace{2pt}{\footnotesize\textcolor{pcGrey}{מקור: #1}}\par}

\newsavebox{\pcVoidBox}
\makeatletter
\newenvironment{pcguide}[1][הנחיה]{%
  \ifpcdraft
    \begin{english}\tcolorbox[colback=pcWarn!10,colframe=pcWarn,boxrule=0.6pt,arc=2pt,
      left=6pt,right=6pt,top=3pt,bottom=3pt,fonttitle=\bfseries\small,
      title={\texthebrew{#1}},before skip=6pt,after skip=8pt]\begin{hebrew}\small
  \else
    \setbox\pcVoidBox\vbox\bgroup
  \fi}%
 {\ifpcdraft
    \end{hebrew}\endtcolorbox\end{english}
  \else
    \egroup
  \fi}
\makeatother

\newenvironment{pcbox}[2][pcPrimary]{%
  \begin{english}\tcolorbox[colback=#1!6,colframe=#1,boxrule=0.8pt,arc=2pt,
    left=8pt,right=8pt,top=5pt,bottom=5pt,fonttitle=\bfseries,
    title={\texthebrew{#2}},before skip=8pt,after skip=10pt]\begin{hebrew}}%
 {\end{hebrew}\endtcolorbox\end{english}}

%% ----------------------------------------------------------------------------
%% 7. Page budget (planned vs actual pages per chapter), reported in the log
%% ----------------------------------------------------------------------------
\makeatletter
\newcommand{\pcStart}[2]{\csgdef{pcStartPage@#1}{#2}}
\newcommand{\pcEnd}[2]{\csgdef{pcEndPage@#1}{#2}}
\newcommand{\BudgetBegin}[2]{\csgdef{pcPlan@#1}{#2}%
  \immediate\write\@auxout{\string\pcStart{#1}{\the\value{page}}}}
\newcommand{\BudgetEnd}[1]{\clearpage
  \immediate\write\@auxout{\string\pcEnd{#1}{\the\numexpr\value{page}-1\relax}}}
\newcommand{\pcPagesNum}[1]{%
  \ifcsname pcEndPage@#1\endcsname\ifcsname pcStartPage@#1\endcsname
    \number\numexpr\csname pcEndPage@#1\endcsname-\csname pcStartPage@#1\endcsname+1\relax
  \else 0\fi\else 0\fi}
\newcommand{\pcBudgetNote}[2]{%
  \ifpcdraft
    {\par\nobreak\vspace{-8pt}\noindent{\footnotesize\color{pcGrey}%
      תקציב עמודים: \latin{#2} \quad בפועל (קומפילציה קודמת): \latin{\pcPagesNum{#1}}}\par\vspace{4pt}}%
  \fi}
\newcommand{\pcBudgetCheck}[1]{%
  \ifcsname pcPlan@#1\endcsname\ifcsname pcEndPage@#1\endcsname\ifcsname pcStartPage@#1\endcsname
    \ifnum\numexpr\csname pcEndPage@#1\endcsname-\csname pcStartPage@#1\endcsname+1\relax
          >\csname pcPlan@#1\endcsname\relax
      \PackageWarningNoLine{pcreport}{Chapter `#1' exceeds its page budget of \csname pcPlan@#1\endcsname}%
    \fi
  \fi\fi\fi}
\AtEndDocument{\forcsvlist{\pcBudgetCheck}{intro,problem,solution,lit,market,alt,plan,risk,summary,bib}}
\makeatother

\newcommand{\pcChapter}[3]{\chapter{#3}\label{ch:#1}\BudgetBegin{#1}{#2}\pcBudgetNote{#1}{#2}}
\newcommand{\pcChapterEnd}[1]{\BudgetEnd{#1}}
\newcommand{\pcFrontChapter}[1]{\chapter*{#1}\addcontentsline{toc}{chapter}{#1}\markboth{#1}{#1}}
\newcommand{\pcFrontChapterNT}[1]{\chapter*{#1}\markboth{#1}{#1}}   % no TOC entry

%% ----------------------------------------------------------------------------
%% 8. Layout: spacing, headings, headers/footers, captions, lists, floats
%% ----------------------------------------------------------------------------
\linespread{1.12}
\setlength{\parindent}{0pt}
\setlength{\parskip}{5pt plus 1pt minus 1pt}
\setcounter{tocdepth}{2}
\setcounter{secnumdepth}{3}
\renewcommand{\arraystretch}{1.2}
\emergencystretch=2em
\raggedbottom

\titleformat{\chapter}[display]
  {\normalfont\bfseries\color{pcDark}}
  {\Large\color{pcPrimary}\chaptertitlename\ \thechapter}
  {6pt}
  {\Huge}
  [\vspace{2pt}{\color{pcPrimary}\titlerule[1.2pt]}]
\titlespacing*{\chapter}{0pt}{-16pt}{14pt}
\titleformat{\section}{\normalfont\Large\bfseries\color{pcPrimary}}{\thesection}{0.7em}{}
\titleformat{\subsection}{\normalfont\large\bfseries\color{pcDark}}{\thesubsection}{0.7em}{}
\titleformat{\subsubsection}{\normalfont\normalsize\bfseries\color{pcDark}}{}{0pt}{}
\titlespacing*{\section}{0pt}{12pt plus 2pt}{5pt}
\titlespacing*{\subsection}{0pt}{9pt plus 2pt}{4pt}
\titlespacing*{\subsubsection}{0pt}{7pt plus 2pt}{3pt}

% no orphan headings: every heading needs room for 5 lines below it
\newcommand{\pcNeed}[1]{\Needspace{#1\baselineskip}}
\AtBeginDocument{%
  \pretocmd{\section}{\Needspace{5\baselineskip}}{}{\PackageWarning{template}{Needspace hook for \string\section failed}}%
  \pretocmd{\subsection}{\Needspace{5\baselineskip}}{}{\PackageWarning{template}{Needspace hook for \string\subsection failed}}}

\pagestyle{fancy}
\fancyhf{}
\renewcommand{\chaptermark}[1]{\markboth{#1}{}}
\fancyhead[R]{\small\texthebrew{\leftmark}}
\fancyhead[L]{\small\texthebrew{\ProjectShortTitle}}
\fancyfoot[C]{\small\thepage}
\renewcommand{\headrulewidth}{0.4pt}
\fancypagestyle{plain}{\fancyhf{}\fancyfoot[C]{\small\thepage}\renewcommand{\headrulewidth}{0pt}}

\captionsetup{font=small,labelfont=bf,labelsep=colon,justification=centering,
  singlelinecheck=true,skip=5pt}
\captionsetup[table]{skip=4pt,belowskip=2pt}
\setlist{itemsep=2pt,topsep=3pt,parsep=2pt}
\setlist[enumerate,1]{label=\latin{\arabic*.},leftmargin=*}
\setlist[itemize,1]{leftmargin=*}

% floats: fewer float-only pages and fewer half-empty pages
\renewcommand{\topfraction}{0.92}
\renewcommand{\bottomfraction}{0.88}
\renewcommand{\textfraction}{0.08}
\renewcommand{\floatpagefraction}{0.80}
% float pages: stack floats from the top instead of centring them in a sea of white space
\makeatletter\setlength{\@fptop}{0pt}\setlength{\@fpsep}{10pt plus 1fil}\setlength{\@fpbot}{0pt plus 2fil}\makeatother
\setcounter{topnumber}{3}
\setcounter{bottomnumber}{2}
\setcounter{totalnumber}{5}
\setlength{\textfloatsep}{10pt plus 2pt minus 4pt}
\setlength{\floatsep}{8pt plus 2pt minus 2pt}
\setlength{\intextsep}{8pt plus 2pt minus 2pt}

%% ----------------------------------------------------------------------------
%% 9. Figures: TikZ / pgfplots always in an LTR environment, never wider
%%    than 12.4 cm (automatic shrinking with \pcAutoFit)
%% ----------------------------------------------------------------------------
\newlength{\pcFigW}
\setlength{\pcFigW}{0.8\textwidth}
\ifdim\pcFigW>12.4cm\setlength{\pcFigW}{12.4cm}\fi
\newlength{\pcMaxW}
\setlength{\pcMaxW}{\textwidth}
\ifdim\pcMaxW>12.4cm\setlength{\pcMaxW}{12.4cm}\fi
\newsavebox{\pcFitBox}
% \pcAutoFit{<picture>}: natural size when narrower than \pcMaxW, otherwise scaled down (text too)
\newcommand{\pcAutoFit}[1]{%
  \begin{english}\centering
  \sbox{\pcFitBox}{#1}%
  \ifdim\wd\pcFitBox>\pcMaxW
    \resizebox{\pcMaxW}{!}{\usebox{\pcFitBox}}%
  \else
    \usebox{\pcFitBox}%
  \fi\par
  \end{english}}
\newcommand{\pcFig}[2]{%
  \ifpcFigPNG\IfFileExists{figures/#1.png}%
    {\includegraphics[width=\pcFigW]{figures/#1.png}\par}%
    {#2}\else #2\fi}
\tikzset{pcfit/.style={scale=#1,every node/.append style={transform shape}}}

\newcommand{\InsertEnglishFigure}[4][12.4cm]{%
  \begin{figure}[!htbp]\centering
  \begin{english}\includegraphics[width=#1,keepaspectratio]{#2}\end{english}
  \caption{#3}\label{#4}
  \end{figure}}

\newenvironment{pctikz}[1][]{\begin{english}\centering\tikzpicture[#1]}{\endtikzpicture\end{english}}

\tikzset{
  pcnode/.style={draw=pcPrimary,rounded corners=2pt,fill=pcPrimary!8,align=center,
    font=\small\sffamily,inner sep=4pt,minimum height=8mm,text width=2.7cm},
  pcnodeD/.style={pcnode,fill=pcDark,draw=pcDark,text=white},
  pcleaf/.style={pcnode,text width=3.3cm,fill=white},
  pcflow/.style={-{Stealth[length=2.6mm]},thick,draw=pcGrey},
  pcentity/.style={draw=pcDark,thick,fill=pcZebra,align=center,font=\small\sffamily,
    minimum height=9mm,text width=2.4cm,inner sep=3pt},
  pcproc/.style={circle,draw=pcPrimary,thick,fill=pcPrimary!10,align=center,
    font=\footnotesize\sffamily,minimum size=2.1cm,inner sep=1pt,text width=1.8cm},
  pcstore/.style={draw=none,fill=pcZebra,align=center,font=\small\sffamily,
    minimum height=9mm,text width=2.5cm,
    path picture={\draw[pcDark,thick] (path picture bounding box.north west) -- (path picture bounding box.north east);
                  \draw[pcDark,thick] (path picture bounding box.south west) -- (path picture bounding box.south east);}},
  ganttnorm/.style={fill=pcPrimary},
  ganttcrit/.style={fill=pcBad},
}

%% ----------------------------------------------------------------------------
%% 10. Tables written in reading order (first column = RIGHT-hand column)
%%     \begin{pctable}{H{0.3},c,H{0.5}} \pchead{a & b & c} \pcrow{..&..&..} ...
%%     \begin{pclongtable}{...} \pcheadL{...} ...   (breaks over pages)
%% ----------------------------------------------------------------------------
\newcolumntype{H}[1]{>{\raggedleft\arraybackslash}p{\dimexpr#1\linewidth-2\tabcolsep\relax}}
\newcolumntype{C}[1]{>{\centering\arraybackslash}p{\dimexpr#1\linewidth-2\tabcolsep\relax}}

\makeatletter
\def\pc@empty{}
\newcommand{\pc@addcol}[1]{\xdef\pc@spec{#1\pc@spec}}
\newcommand{\pc@mkspec}[1]{\gdef\pc@spec{}\forcsvlist{\pc@addcol}{#1}}
\newcommand{\pc@cell}[1]{\texthebrew{#1}}
\newcommand{\pc@hcell}[1]{\textcolor{white}{\texthebrew{\bfseries #1}}}
\def\pc@emit#1{\gdef\pc@result{#1\\}}
\def\pc@rev#1#2#3&#4\pc@stop{%
  \def\pc@rest{#4}%
  \ifx\pc@rest\pc@empty
    \def\pc@next{\pc@emit{#1{#3}#2}}%
  \else
    \def\pc@next{\pc@rev#1{&#1{#3}#2}#4\pc@stop}%
  \fi
  \pc@next}
% splitting runs inside a group so that '&' is not taken as a cell separator
\newcommand{\pcrow}[1]{{\pc@rev\pc@cell{}#1&\pc@stop}\pc@result}
\newcommand{\pchead}[1]{\rowcolor{pcPrimary}{\pc@rev\pc@hcell{}#1&\pc@stop}\pc@result}
\newcommand{\pcheadL}[1]{\pchead{#1}\endhead}
\newcommand{\pcTabFont}{\small}
% \pcCompactTables: inside a float, switches the following pctable/pclongtable to \footnotesize (group-local)
\newcommand{\pcCompactTables}{\renewcommand{\pcTabFont}{\footnotesize}}
\newenvironment{pctable}[1]{%
  \pc@mkspec{#1}%
  \begin{english}\pcTabFont\setlength{\tabcolsep}{4pt}\rowcolors{2}{pcZebra}{white}%
  \edef\pc@tmp{\noexpand\begin{tabular}{\pc@spec}}\pc@tmp\toprule}%
 {\bottomrule\end{tabular}\end{english}}
\newenvironment{pclongtable}[1]{%
  \pc@mkspec{#1}%
  \begin{english}\pcTabFont\setlength{\tabcolsep}{4pt}\rowcolors{2}{pcZebra}{white}%
  \edef\pc@tmp{\noexpand\begin{longtable}{\pc@spec}}\pc@tmp\toprule}%
 {\bottomrule\end{longtable}\end{english}}
\makeatother

% markers inside tables: text glyphs (robust in LR columns), Harvey ball as a small picture
\newcommand{\pcdot}{\textcolor{pcPrimary}{\textenglish{\textbullet}}}
\newcommand{\harvey}[1]{\tikz[baseline=-0.6ex]{\draw[pcDark,thick](0,0)circle(0.16cm);%
  \ifnum#1>0 \fill[pcDark](0,0)--(0.16cm,0)arc(0:{90*#1}:0.16cm)--cycle;\fi}}

%% ----------------------------------------------------------------------------
%% 11. Pugh matrix automation (absolute 1--5 scores; weights must sum to 1)
%% ----------------------------------------------------------------------------
\newcommand{\pughReset}{\gdef\pughSumW{0}\gdef\pughSA{0}\gdef\pughSB{0}\gdef\pughSC{0}\gdef\pughSeries{}}
\newcommand{\pughRowAbs}[5]{% criterion, w, rA, rB, rC
  \pgfmathparse{\pughSumW+#2}\xdef\pughSumW{\pgfmathresult}%
  \pgfmathparse{#2*#3}\xdef\pughWA{\pgfmathresult}%
  \pgfmathparse{#2*#4}\xdef\pughWB{\pgfmathresult}%
  \pgfmathparse{#2*#5}\xdef\pughWC{\pgfmathresult}%
  \pgfmathparse{\pughSA+\pughWA}\xdef\pughSA{\pgfmathresult}%
  \pgfmathparse{\pughSB+\pughWB}\xdef\pughSB{\pgfmathresult}%
  \pgfmathparse{\pughSC+\pughWC}\xdef\pughSC{\pgfmathresult}%
  \xappto\pughSeries{\noexpand\addplot coordinates {(A,\pughWA) (B,\pughWB) (C,\pughWC)};%
    \noexpand\addlegendentry{\noexpand\tn{\unexpanded{#1}}}}%
  \pcrow{#1 & \num{#2} & \num{#3} & \num{#4} & \num{#5}}}
% variant: every cell shows "engineering value -> score" (values are Latin / numeric only)
\newcommand{\pughRowEv}[8]{% criterion, w, rA, eA, rB, eB, rC, eC
  \pgfmathparse{\pughSumW+#2}\xdef\pughSumW{\pgfmathresult}%
  \pgfmathparse{#2*#3}\xdef\pughWA{\pgfmathresult}%
  \pgfmathparse{#2*#5}\xdef\pughWB{\pgfmathresult}%
  \pgfmathparse{#2*#7}\xdef\pughWC{\pgfmathresult}%
  \pgfmathparse{\pughSA+\pughWA}\xdef\pughSA{\pgfmathresult}%
  \pgfmathparse{\pughSB+\pughWB}\xdef\pughSB{\pgfmathresult}%
  \pgfmathparse{\pughSC+\pughWC}\xdef\pughSC{\pgfmathresult}%
  \xappto\pughSeries{\noexpand\addplot coordinates {(A,\pughWA) (B,\pughWB) (C,\pughWC)};%
    \noexpand\addlegendentry{\noexpand\tn{\unexpanded{#1}}}}%
  \pcrow{#1 & \num{#2} & \latin{#4\,$\rightarrow$\,\textbf{#3}} & \latin{#6\,$\rightarrow$\,\textbf{#5}} & \latin{#8\,$\rightarrow$\,\textbf{#7}}}}
\newcommand{\pughTotalsAbs}{%
  \midrule
  \pcrow{\textbf{ציון משוקלל $S_j=\sum_i w_i r_{ij}$} & \num{\pgfmathprintnumber[fixed,precision=2]{\pughSumW}} &
    \textbf{\num{\pgfmathprintnumber[fixed,precision=2,fixed zerofill]{\pughSA}}} &
    \textbf{\num{\pgfmathprintnumber[fixed,precision=2,fixed zerofill]{\pughSB}}} &
    \textbf{\num{\pgfmathprintnumber[fixed,precision=2,fixed zerofill]{\pughSC}}}}}
\newcommand{\pughCheck}{%
  \pgfmathparse{abs(\pughSumW-1)>0.001?1:0}%
  \ifnum\pgfmathresult>0 \PackageWarning{pcreport}{Pugh weights sum to \pughSumW, not 1}\fi}

%% ----------------------------------------------------------------------------
%% 12. Risk register and 5x5 matrix (R = P x I, critical if R >= 12)
%% ----------------------------------------------------------------------------
\gdef\pcRiskDots{}
\newcommand{\riskrow}[4]{% id, description, P, I
  \xdef\pcR{\number\numexpr#3*#4\relax}%
  \ifnum\pcR>11 \xdef\pcRcol{pcBad}\else\ifnum\pcR>4 \xdef\pcRcol{pcWarn}\else\xdef\pcRcol{pcGood}\fi\fi
  \gappto\pcRiskDots{\pcRiskDot{#1}{#3}{#4}}%
  \pcrow{#1 & #2 & \num{#3} & \num{#4} & \textcolor{\pcRcol}{\bfseries\num{\pcR}}}}
% several risks in one cell are stacked (2 per row)
\newcommand{\pcRiskDot}[3]{% id, P, I
  \expandafter\ifx\csname pcCell@#2@#3\endcsname\relax\expandafter\gdef\csname pcCell@#2@#3\endcsname{0}\fi
  \pgfmathtruncatemacro{\pcK}{\csname pcCell@#2@#3\endcsname}%
  \pgfmathsetmacro{\jx}{mod(\pcK,2)*0.46-0.23}%
  \pgfmathsetmacro{\jy}{0.20-floor(\pcK/2)*0.40}%
  \node[rectangle,rounded corners=1.5pt,fill=pcDark,text=white,inner sep=1.1pt,font=\scriptsize\bfseries]
    at ({#3-0.5+\jx},{#2-0.5+\jy}) {#1};%
  \expandafter\xdef\csname pcCell@#2@#3\endcsname{\number\numexpr\pcK+1\relax}}

%% ----------------------------------------------------------------------------
%% 13. Gantt helpers (14 weeks, time runs right-to-left like the course figures)
%%     every task lies on a zero-float FS chain -> red frame
%% ----------------------------------------------------------------------------
\newcommand{\pcGsign}{-1}
\newcommand{\ganttbarS}[6]{% row, first week, last week, colour, owner initial, label
  \filldraw[fill=#4,draw=pcBad,line width=0.7pt,rounded corners=1pt]
    ({\pcGsign*(#2-1)},{-#1+0.34}) rectangle ({\pcGsign*#3},{-#1-0.34});
  \node[white,font=\fontsize{6}{7}\selectfont\bfseries\sffamily] at ({\pcGsign*(#2+#3-1)/2},-#1) {\tn{#5}};
  \node[anchor=west,text width=4.0cm,align=right,font=\fontsize{7}{8}\selectfont\sffamily,inner xsep=1pt]
    at (0.25,-#1) {\tn{#6}};}
\newcommand{\ganttsumS}[4]{% work-package summary bar: row, first, last, label
  \fill[pcDark] ({\pcGsign*(#2-1)},{-#1+0.12}) rectangle ({\pcGsign*#3},{-#1-0.12});
  \fill[pcDark] ({\pcGsign*(#2-1)},{-#1-0.12}) -- ++({\pcGsign*0.25},0) -- ++({-\pcGsign*0.25},-0.22) -- cycle;
  \fill[pcDark] ({\pcGsign*#3},{-#1-0.12}) -- ++({-\pcGsign*0.25},0) -- ++({\pcGsign*0.25},-0.22) -- cycle;
  \node[anchor=west,text width=4.0cm,align=right,font=\fontsize{7}{8}\selectfont\sffamily\bfseries,inner xsep=1pt]
    at (0.25,-#1) {\tn{#4}};}
\newcommand{\ganttbufS}[4]{% schedule buffer: row, first, last, label
  \filldraw[fill=pcWarn!30,draw=pcWarn!80!black,dashed,line width=0.7pt,rounded corners=1pt]
    ({\pcGsign*(#2-1)},{-#1+0.34}) rectangle ({\pcGsign*#3},{-#1-0.34});
  \node[anchor=west,text width=4.0cm,align=right,font=\fontsize{7}{8}\selectfont\sffamily\itshape,inner xsep=1pt]
    at (0.25,-#1) {\tn{#4}};}
\newcommand{\ganttmsS}[3]{% milestone: week, label, row
  \node[diamond,fill=pcWarn,draw=pcDark,inner sep=1.3pt,minimum size=3mm] at ({\pcGsign*(#1-0.5)},-#3) {};
  \node[font=\fontsize{6}{7}\selectfont\bfseries,above=1pt] at ({\pcGsign*(#1-0.5)},-#3+0.15) {#2};}

%% ----------------------------------------------------------------------------
%% 14. Front matter: compact TOC / LOF / LOT, abbreviation list
%% ----------------------------------------------------------------------------
\makeatletter
% compact chapter line in the TOC (default adds 1em + a big penalty block)
\newcommand{\pc@tocchapter}[2]{%
  \ifnum\c@tocdepth>\m@ne
    \addpenalty{-\@highpenalty}\vskip 2pt plus 1pt
    \setlength\@tempdima{1.5em}\begingroup
      \parindent\z@ \rightskip\@pnumwidth \parfillskip-\@pnumwidth \leavevmode\bfseries
      \advance\leftskip\@tempdima \hskip-\leftskip #1\nobreak\hfil
      \nobreak\hb@xt@\@pnumwidth{\hss #2}\par\penalty\@highpenalty
    \endgroup
  \fi}
\newcommand{\pcTOC}{%
  \pcFrontChapterNT{תוכן העניינים}%
  \begingroup\scriptsize\setlength{\baselineskip}{9.6pt}\setlength{\parskip}{0pt}\setcounter{tocdepth}{1}%
    \let\l@chapter\pc@tocchapter
    \renewcommand*\l@section{\@dottedtocline{1}{1.5em}{2.3em}}%
    \setlength{\parskip}{0pt}\@starttoc{toc}%
  \endgroup}
% list of figures + list of tables on the same flow (no forced page between them)
\newcommand{\pcLists}{%
  \pcFrontChapter{\listfigurename}%
  \begingroup\footnotesize\linespread{1.0}\setlength{\parskip}{0pt}\@starttoc{lof}\endgroup
  \vspace{0.8em}\Needspace{8\baselineskip}%
  {\Large\bfseries\color{pcPrimary}\noindent\listtablename\par}%
  \addcontentsline{toc}{chapter}{\listtablename}\markboth{\listtablename}{\listtablename}%
  \vspace{0.3em}%
  \begingroup\footnotesize\linespread{1.0}\setlength{\parskip}{0pt}\@starttoc{lot}\endgroup}
\makeatother

% abbreviation table: strictly alphabetical (digits first, then A--Z); Latin keys only
\newcommand{\pcAbbr}[3]{\pcrow{\latin{#1} & \latin{#2} & #3}}
\newcommand{\pcAbbrTable}[1]{%
  \begingroup\renewcommand{\pcTabFont}{\footnotesize}\renewcommand{\arraystretch}{1.05}%
  \begin{pclongtable}{c,H{0.42},H{0.42}}
    \pcheadL{קיצור & מונח באנגלית & משמעות בעברית}
    #1
  \end{pclongtable}\endgroup}

%% ----------------------------------------------------------------------------
%% 15. Cover page: logos (equal height, never clipped), fields, copyright
%% ----------------------------------------------------------------------------
\newlength{\pcLogoH}\setlength{\pcLogoH}{1.7cm}
\makeatletter
% \pcLogoFile{<comma list of candidate files>}{<max width>}{<label if none found>}
\newcommand{\pcLogoFile}[3]{%
  \gdef\pc@logofound{0}%
  \@for\pc@cand:=#1\do{%
    \ifnum\pc@logofound=0
      \IfFileExists{\pc@cand}{\gdef\pc@logofound{1}\xdef\pc@logopath{\pc@cand}}{}%
    \fi}%
  \ifnum\pc@logofound=1
    \includegraphics[height=\pcLogoH,width=#2,keepaspectratio]{\pc@logopath}%
  \else
    \fbox{\parbox[c][\pcLogoH][c]{#2}{\centering\footnotesize\textcolor{pcPH}{#3}}}%
  \fi}
\makeatother
\newcommand{\pcLogoBox}[3]{\vbox to \pcLogoH{\vfil\hbox{\pcLogoFile{#1}{#2}{#3}}\vfil}}
% one row, left -> right: consulting firm, IAI, Bar-Ilan (RTL page: university on the right)
\newcommand{\pcLogoRow}{%
  \begin{english}\noindent
  \hbox to \textwidth{%
    \pcLogoBox{figures/orbitech_logo.png,figures/orbitech_logo.pdf,logos/orbitech_logo.png,logos/consulting.png,logos/consulting.pdf}{4.8cm}{OrbiTech Consulting}%
    \hfill
    \pcLogoBox{logos/iai.png,logos/iai.pdf}{5.0cm}{IAI}%
    \hfill
    \pcLogoBox{logos/biu.png,logos/biu.pdf}{5.0cm}{Bar-Ilan University}}%
  \end{english}\par}
% frame of the cover page
\newcommand{\pcCoverFrame}{%
  \begin{english}
  \begin{tikzpicture}[remember picture,overlay]
    \draw[line width=2.4pt,pcDark]
      ([shift={(1.0cm,1.0cm)}]current page.south west) rectangle ([shift={(-1.0cm,-1.0cm)}]current page.north east);
    \draw[line width=0.5pt,pcPrimary]
      ([shift={(1.25cm,1.25cm)}]current page.south west) rectangle ([shift={(-1.25cm,-1.25cm)}]current page.north east);
  \end{tikzpicture}
  \end{english}}
% contact line of one student: name, ID, e-mail  (prints only what is filled in)
\newcommand{\pcContact}[3]{%
  \ifdefempty{#2}{\ifdefempty{#3}{}{#1: \latin{#3}\par}}%
    {#1: ת"ז~\latin{#2}\ifdefempty{#3}{}{, \latin{#3}}\par}}
% copyright line: the symbol is set in the English font
%% Solution chapter placement: main.tex calls \pcIfSolution{afterproblem} at the end of ch2 and
%% \pcIfSolution{afteralternatives} at the end of ch6; only the matching call inputs the chapter file.
\newcommand{\pcIfSolution}[1]{\ifdefstring{\SolutionPlacement}{#1}{\input{chapters/ch3-solution}}{}}
\newcommand{\pcCopyright}{\textenglish{\copyright}~\latin{2026} \StudentOne\ ו\StudentTwo, קבוצת \ConsultingFirm. כל הזכויות שמורות.}

%% ----------------------------------------------------------------------------
%% 16. Default project metadata (override in main.tex BEFORE \begin{document})
%% ----------------------------------------------------------------------------
\AtBeginDocument{%
  \providecommand{\SolutionPlacement}{afterproblem}%
  \providecommand{\FrontOrder}{abstractfirst}%
  \providecommand{\FrontNumbering}{roman}%
  \providecommand{\ProjectTitleHe}{כותרת הפרויקט בעברית}%
  \providecommand{\ProjectTitleEn}{\latin{Project title in English}}%
  \providecommand{\ProjectShortTitle}{כותרת קצרה}%
  \providecommand{\StudentOne}{שם סטודנט/ית 1}%
  \providecommand{\StudentTwo}{שם סטודנט/ית 2}%
  \providecommand{\AdvisorName}{ד"ר יורם סגל}%
  \providecommand{\IAIContact}{}%
  \providecommand{\ReportDate}{25-11-2026}%
  \providecommand{\ConsultingFirm}{\latin{OrbiTech}}%
  \providecommand{\ProjectNumber}{\latin{5}}%
  \providecommand{\StudentOneID}{}\providecommand{\StudentOneMail}{}%
  \providecommand{\StudentTwoID}{}\providecommand{\StudentTwoMail}{}%
  \providecommand{\GroupID}{}%
  \providecommand{\GitHubRepo}{}%
  \hypersetup{pdftitle={Preliminary Design Report},pdfauthor={OrbiTech},pdfsubject={Seminar 5523001},pdflang={he-IL}}%
}

%% ----------------------------------------------------------------------------
%% 17. Hyperlinks (loaded last)
%% ----------------------------------------------------------------------------
\RequirePackage[unicode,bookmarksnumbered,bookmarksopen,hidelinks]{hyperref}

\endinput
