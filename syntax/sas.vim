" Vim syntax file
" Language:     SAS
" Maintainer:   Zhen-Huan Hu <wildkeny@gmail.com>
" Version:      2.1.1
" Last Change:  Feb 09, 2017
"
" 2017 Feb 9
"
" Add syntax folding marks
"
" 2016 Oct 10
"
" Add highlighting for functions
"
" 2016 Sep 14
"
" Change the implementation of syntaxing
" macro function names so that macro parameters same
" as SAS keywords won't be highlighted
" (Thank Joug Raw for the suggestion)
" Add section highlighting:
" - Use /** and **/ to define a section
" - It functions the same as a comment but
"   with different highlighting
"
" 2016 Jun 14
"
" Major changes so upgrade version number to 2.0
" Overhaul the entire script (again). Improvements include:
" - Higher precision
" - Faster synchronization
" - Separate color for control statements
" - Hightlight macro variables in double quoted strings
" - Update all syntaxes based on SAS 9.4
" - Add complete SAS/GRAPH and SAS/STAT procedure syntaxes
" - Add Proc TEMPLATE and GTL syntaxes
" - Add complete DS2 syntaxes
" - Add basic IML syntaxes
" - Many other improvements and bug fixes
" Drop support for earlier versions of VIM
"
" 2012 Feb 27 
"
" Rewrite the entire matching algorithm 
" Add keywords in Base SAS 9.3 and SAS/Stat
" Fix issues in highlighting procedure names and internal variables
" Add highlighting for hash and hiter objects
"
" 2011 Apr 1
"
" Simplify matching algorithm
" Fix mis-matching of some keywords and function names
" Fix an issue caused by multiple comments written at the same line
" Add highlighting for new statements and functions in SAS 9.1/9.2
" Add highlighting for user defined macro functions
" Add highlighting for format tags
"
" 2008 Jul 18 by Paulo Tanimoto <ptanimoto@gmail.com>
"
" Fix comments with asterisks taking multiple lines
" Fix highlighting of macro keywords
" Add words to cases that do not fit anywhere
"
" 2003 Jun 2 by Bob Heckel
"
" Add highlighting for additional keywords and such
" Attempt to match SAS default syntax colors
" Change syncing so it does not lose colors on large blocks
"
" 2001 Sep 26 by James Kidd
"
" Add keywords for use in SAS SQL procedure
" Add highlighting for SAS base procedures
" Add logic to distinqush between versions for SAS macro variable highlighting
" - For SAS 5: Clear all syntax items
" - For SAS 6: Quit when a syntax file was already loaded

if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

let s:cpo_save = &cpo
set cpo&vim

syn case ignore

" Keywords
syn keyword sasOperator and eq ge gt in le lt ne not of or
syn keyword sasReserved _all_ _automatic_ _char_ _character_ _data_ _infile_ _last_ _n_ _name_ _null_ _num_ _numeric_ _temporary_ _user_ _webout_

" Numbers
syn match sasNumber "\v<\-=%(\d+\.=\d*|\.\d+)%(e\-=\d+)=>" display

" Strings
syn region sasString start=+'+ end=+'+ contains=@Spell
syn region sasString start=+"+ end=+"+ contains=sasMacroVariable,@Spell

" Format tag
syn match sasFormatTag "\v<\$=[a-z_]\w*\.\d*%([^a-z_]|$)@=" display contained

" Comments
syn region sasComment start="/\*" end="\*/"
syn region sasComment start="\v%(^|;)@1<=\s*\%=\*" end="\v;@="
syn region sasSectLbl matchgroup=sasSectLblEnds start="/\*\*\s*" end="\s*\*\*/" concealends

" Functions
syn region sasFunction matchgroup=sasFuncName start="\v<%(call\s+)=\w+\ze\(" end="\v\ze\)" contains=@sasBasicSyntax
syn region sasMacroFunc matchgroup=sasMacroFuncName start="\v\%\w+\ze\(" end="\v\ze\)" contains=@sasBasicSyntax

" Macros
syn match sasMacroVariable "\v\&+\w+%(\.\w+)=" display
syn match sasMacroReserved "\v\%%(abort|by|copy|display|do|else|end|global|goto|if|include|input|let|list|local|macro|mend|put|return|run|symdel|syscall|sysexec|syslput|sysrput|then|to|until|window|while)>" display

" Syntax cluster for basic SAS syntaxes
syn cluster sasBasicSyntax contains=sasOperator,sasReserved,sasNumber,sasString,sasFormatTag,sasComment,sasFunction,sasMacroReserved,sasMacroFunc,sasMacroVariable,sasSectLbl

" Define statements that can be accessed out of data step or procedure sections
syn match sasGlobalStatement "\v%(^|;)@1<=\s*%(catname|data|dm|endsas|filename|footnote\d*|libname|lock|options|page|proc%( \w+)=|quit|run|run cancel|sasfile|skip|sysecho|title\d*)>" display
syn match sasGlobalStatement "\v%(^|;)@1<=\s*ods%( %(chtml|csvall|docbook|document|escapechar|exclude|graphics|html3|html|htmlcss|imode|listing|markup|output|package|path|pcl|pdf|preferences|phtml|printer|proclabel|proctitle|ps|results|rtf|select|show|tagsets\.%(chtml|core|csv|csvall|csvbyline|default|docbook|excelxp|html4|htmlcss|htmlpanel|imode|msoffice2k|mvshtml|phtml|pyx|rtf|sasreport|wml|wmlolist|xhtml)|trace|usegopt|verify|wml))=>" display

" Data step statements, 9.4
syn keyword sasDataStepControl by continue do else end go goto if leave link otherwise over return select then to until when while contained
syn match sasDataStepStatement "\v%(^|;)@1<=\s*%(abort|array|attrib|by|call|cards|cards4|datalines|datalines4|%(dcl|declare)%( %(hash|hiter|javaobj))=|delete|describe|display|drop|error|execute|file|format|infile|informat|input|keep|label|length|lines|lines4|list|lostcard|merge|modify|output|put|putlog|redirect|remove|rename|replace|retain|set|stop|update|where|window)>" display contained
syn region sasDataStep start="\v%(^|;)@1<=\s*data>" end="\v%(^|;)@1<=%(\s*%(data|endsas|proc|run)>)@=" fold contains=@sasBasicSyntax,sasGlobalStatement,sasDataStepControl,sasDataStepStatement

" Procedures, base SAS, 9.4
syn match sasProcStatement "\v%(^|;)@1<=\s*%(abort|age|append|array|attrib|audit|block|break|by|calid|cdfplot|change|checkbox|class|classlev|column|compute|contents|copy|create|datarow|dbencoding|define|delete|deletefunc|deletesubr|delimiter|device|dialog|dur|endcomp|exact|exchange|exclude|explore|fin|fmtlib|fontfile|fontpath|format|formats|freq|function|getnames|guessingrows|hbar|hdfs|histogram|holidur|holifin|holistart|holivar|id|idlabel|informat|inset|invalue|item|key|keylabel|keyword|label|line|link|listfunc|listsubr|mapmiss|mapreduce|mean|menu|messages|meta|modify|opentype|outargs|outdur|outfin|output|outstart|pageby|partial|picture|pie|pig|plot|ppplot|printer|probplot|profile|prompter|qqplot|radiobox|ranks|rbreak|rbutton|rebuild|record|remove|rename|repair|report|roptions|save|select|selection|separator|source|star|start|statistics|struct|submenu|subroutine|sum|sumby|table|tables|test|text|trantab|truetype|type1|types|value|var|vbar|ways|weight|where|with|write)>" display contained
" ODS graphics procedures, 9.4
syn match sasProcStatement "\v%(^|;)@1<=\s*%(band|bubble|colaxis|compare|density|dot|dynamic|ellipse|hbar|hbarparm|hbox|highlow|histogram|hline|inset|keylegend|lineparm|loess|matrix|needle|parent|panelby|pbspline|plot|refline|reg|rowaxis|scatter|series|step|style|vbar|vbarparm|vbox|vector|vline|waterfall|xaxis|x2axis|yaxis|y2axis)>" display contained
" ODS procedures, 9.4
syn match sasProcStatement "\v%(^|;)@1<=\s*%(categoryaxis|chartattrs|copy|delete|dir|doc|doc close|hcolumn|hide|import|keylegend|line|link|list|make|move|note|obanote|obbnote|obfootn|obpage|obstitle|obtempl|obtitle|pie|primaryaxis|rename|replay|scatter|secondaryaxis|setlabel|unhide|vcolumn)>" display contained
" PROC statement
syn region sasProc start="\v%(^|;)@1<=\s*proc" end="\v%(^|;)@1<=%(\s*%(data|endsas|proc|quit|run)>)@=" fold contains=@sasBasicSyntax,sasGlobalStatement,sasProcStatement

" Procedures, SAS/GRAPH, 9.4
syn match sasGraphProcStatement "\v%(^|;)@1<=\s*%(add|area|axis\d{0,2}|bar|block|bubble2|byline|cc|ccopy|cdef|cdelete|chart|cmap|choro|copy|delete|device|dial|donut|exclude|flow|fs|goptions|gout|grid|group|hbar|hbar3d|hbullet|hslider|htrafficlight|id|igout|legend\d{0,2}|list|modify|move|nobyline|note|pattern\d{0,3}|pie|pie3d|plot|plot2|preview|prism|quit|rename|replay|select|scatter|speedometer|star|surface|symbol\d{0,3}|tc|tcopy|tdef|tdelete|template|tile|toggle|treplay|vbar|vbar3d|vtrafficlight|vbullet|vslider)>" display contained
syn region sasGraphProc start="\v%(^|;)@1<=\s*proc\s+%(g3d|g3grid|ganno|gareabar|gbarline|gchart|gcontour|gdevice|geocode|gfont|ginside|gkpi|gmap|goptions|gplot|gproject|gradar|greduce|gremove|greplay|gslide|gtile|mapimport)>" end="\v%(^|;)@1<=%(\s*%(data|endsas|proc|run)>)@=" fold contains=@sasBasicSyntax,sasGlobalStatement,sasGraphProcStatement

" Procedures, SAS/STAT, 14.1
syn match sasAnalyticalProcStatement "\v%(^|;)@1<=\s*%(absorb|add|array|assess|baseline|bayes|beginnodata|bivar|bootstrap|bounds|by|cdfplot|cells|class|cluster|code|compute|condition|contrast|control|coordinates|copy|cosan|cov|covtest|coxreg|der|design|determ|deviance|direct|directions|domain|effect|effectplot|effpart|em|endnodata|equality|estimate|exact|exactoptions|factor|factors|fcs|filter|fitindex|freq|fwdlink|gender|grid|group|grow|hazardratio|height|hyperprior|id|impjoint|inset|insetgroup|invar|invlink|ippplot|lincon|lineqs|lismod|lmtests|location|logistic|loglin|lpredplot|lsmeans|lsmestimate|manova|matings|matrix|mcmc|mean|means|missmodel|mnar|model|modelaverage|modeleffects|monotone|mstruct|mtest|multreg|name|nlincon|nloptions|oddsratio|onecorr|onesamplefreq|onesamplemeans|onewayanova|outfiles|output|paired|pairedfreq|pairedmeans|parameters|parent|parms|partial|partition|path|pathdiagram|pcov|performance|plot|population|poststrata|power|preddist|predict|predpplot|priors|process|probmodel|profile|prune|pvar|ram|random|ratio|reference|refit|refmodel|renameparm|repeated|replicate|repweights|response|restore|restrict|retain|reweight|ridge|rmsstd|roc|roccontrast|rules|samplesize|samplingunit|seed|size|scale|score|selection|show|simtests|simulate|slice|std|stderr|store|strata|structeq|supplementary|table|tables|test|testclass|testfreq|testfunc|testid|time|transform|treatments|trend|twosamplefreq|twosamplemeans|towsamplesurvival|twosamplewilcoxon|uds|units|univar|var|variance|varnames|weight|where|with|zeromodel)>" display contained
syn region sasAnalyticalProc start="\v%(^|;)@1<=\s*proc\s+%(aceclus|adaptivereg|anova|bchoice|boxplot|calis|cancorr|candisc|catmod|cluster|corresp|discrim|distance|factor|fastclus|fmm|freq|gam|gampl|gee|genmod|glimmix|glm|glmmod|glmpower|glmselect|hpcandisc|hpfmm|hpgenselect|hplmixed|hplogistic|hpmixed|hpnlmod|hppls|hpprincomp|hpquantselect|hpreg|hpsplit|iclifetest|icphreg|inbreed|irt|kde|krige2d|lattice|lifereg|lifetest|loess|logistic|mcmc|mds|mi|mianalyze|mixed|modeclus|multtest|nested|nlin|nlmixed|npar1way|orthoreg|phreg|plan|plm|pls|power|princomp|prinqual|probit|quantlife|quantreg|quantselect|reg|robustreg|rsreg|score|seqdesign|seqtest|sim2d|simnormal|spp|stdize|stdrate|stepdisc|surveyfreq|surveyimpute|surveylogistic|surveymeans|surveyphreg|surveyreg|surveyselect|tpspline|transreg|tree|ttest|varclus|varcomp|variogram)>" end="\v%(^|;)@1<=%(\s*(data|endsas|proc|run)>)@=" fold contains=@sasBasicSyntax,sasGlobalStatement,sasAnalyticalProcStatement

" Proc TEMPLATE, 9.4
syn match sasProcTemplateStatement "\v%(^|;)@1<=\s*%(block|break|cellstyle|cellvalue|class|close|column|compute|continue|define( (column|crosstabs|event|footer|header|statgraph|style|table|tagset))=|delete|delstream|do|done|dynamic|edit|else|end|eval|flush|footer|header|import|iterate|link|list|mvar|ndent|next|nmvar|notes|open|path|put|putl|putlog|putstream|putvars|replace|set|source|stop|style|test|text[23]=|translate|trigger|unblock|unset|xdent)>" display contained
syn match sasGTLStatement "\v%(^|;)@1<=\s*%(axislegend|axistable|bandplot|barchart|barchartparm|begingraph|beginpolygon|beginpolyline|bihistogram3dparm|blockplot|boxplot|boxplotparm|bubbleplot|continuouslegend|contourplotparm|dendrogram|discretelegend|drawarrow|drawimage|drawline|drawoval|drawrectangle|drawtext|dropline|ellipse|ellipseparm|endgraph|endinnermargin|endlayout|endpolygon|endpolyline|endsidebar|entry|entryfootnote|entrytitle|fringeplot|heatmap|heatmapparm|highlowplot|histogram|histogramparm|innermargin|layout%( %(datalattice|datapanel|globallegend|gridded|lattice|overlay|overlayequated|overlay3d|region))=|legenditem|legendtextitems|linechart|lineparm|loessplot|mergedlegend|modelband|needleplot|pbsplineplot|polygonplot|referenceline|regressionplot|scatterplot|seriesplot|sidebar|stepplot|surfaceplotparm|symbolchar|symbolimage|textplot|vectorplot|waterfallchart)>" display contained
syn region sasProcTemplate start="\v%(^|;)@1<=\s*proc\s+template>" end="\v%(^|;)@1<=%(\s*%(data|endsas|proc|quit|run)>)@=" fold contains=@sasBasicSyntax,sasGlobalStatement,sasProcTemplateStatement,sasGTLStatement

" Proc SQL, 9.4
syn keyword sasProcSQLClause add as asc between by calculated cascade case check connection constraint cross delete desc distinct drop else end escape except exists foreign from full group having in inner intersect into is join key left libname like modify natural newline notrim null on order outer references restrict right select separated set then to trimmed union unique update user using values when where contained
syn match sasProcSQLStatement "\v%(^|;)@1<=\s*%(alter( table)=|connect|create%( %(index|table|view))=|delete|describe%( %(table|view))=|disconnect|drop%( %(index|table|view))=|execute|insert|reset|select|update|validate)>" display contained
syn region sasProcSQL start="\v%(^|;)@1<=\s*proc\s+sql>" end="\v%(^|;)@1<=%(\s*%(data|endsas|proc|quit|run)>)@=" fold contains=@sasBasicSyntax,sasGlobalStatement,sasProcSQLClause,sasProcSQLStatement

" SAS/DS2, 9.4
syn keyword sasDS2Control by continue data do else end enddata endpackage endthread go goto if leave method otherwise package point return select then thread to until when while contained
syn match sasDS2Statement "\v%(^|;)@1<=\s*%(array|by|%(dcl|declare|drop)%( %(package|thread))=|forward|keep|merge|output|put|rename|retain|set%( from)=|stop|vararray|varlist)>" display contained
syn region sasDS2 start="\v%(^|;)@1<=\s*proc\s+ds2>" end="\v%(^|;)@1<=%(\s*%(data|endsas|proc|quit|run)>)@=" fold contains=@sasBasicSyntax,sasGlobalStatement,sasDS2Control,sasDS2Statement

" SAS/IML, 14.1
syn keyword sasIMLControl by data do else end goto if link return then to until while contained
syn match sasIMLStatement "\v%(^|;)@1<=\s*%(abort|append%( %(var|from))=|call|close|closefile|create|delete|display|file|find|finish|free|index%( none)=|infile|input|list|load|mattrib|pause|print|purge|put|quit|read|remove|replace|reset|resume|remove|run|save|setin|setout|show|sort|start|stop|store|summary|use|window)>" display contained
syn region sasIML start="\v%(^|;)@1<=\s*proc\s+iml>" end="\v%(^|;)@1<=%(\s*%(data|endsas|proc|quit)>)@=" fold contains=@sasBasicSyntax,sasGlobalStatement,sasIMLControl,sasIMLStatement

" Macro definition
syn region sasMacro start="\v\%macro>" end="\v\%mend>" fold contains=@sasBasicSyntax,sasGlobalStatement,sasDataStepControl,sasDataStepStatement,sasDataStep,sasProc,sasGraphProc,sasAnalyticalProc,sasProcTemplate,sasProcSQL,sasDS2,sasIML

" Define default highlighting
hi def link sasComment Comment
hi def link sasSectLbl Title
hi def link sasSectLblEnds Comment
hi def link sasDataStepControl Keyword
hi def link sasProcSQLClause Keyword
hi def link sasODSControl Keyword
hi def link sasDS2Control Keyword
hi def link sasIMLControl Keyword
hi def link sasOperator Operator
hi def link sasNumber Number
hi def link sasString String
hi def link sasFuncName Function
hi def link sasGlobalStatement Statement
hi def link sasDataStepStatement Statement
hi def link sasProcStatement Statement
hi def link sasGraphProcStatement Statement
hi def link sasAnalyticalProcStatement Statement
hi def link sasProcSQLStatement Statement
hi def link sasProcTemplateStatement Statement
hi def link sasGTLStatement Statement
hi def link sasDS2Statement Statement
hi def link sasIMLStatement Statement
hi def link sasMacroReserved Macro
hi def link sasMacroFuncName Define
hi def link sasMacroVariable Define
hi def link sasFormatTag SpecialChar
hi def link sasReserved Special

" Syncronize from beginning to keep large blocks from losing
" syntax coloring while moving through code.
syn sync fromstart

let b:current_syntax = "sas"

let &cpo = s:cpo_save
unlet s:cpo_save
