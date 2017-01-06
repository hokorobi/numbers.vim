" Vim completion script
" Language:     SAS
" Maintainer:   Zhenhuan Hu <wildkeny@gmail.com>
" License:      Same as Vim
" Last Change:  2017-01-06

" Procedures in Base SAS and SAS/STAT
let s:sas_proc_names = ["aceclus", "adaptivereg", "anova", "append", "authlib", "bchoice", "boxplot", "calendar", "calis", "cancorr", "candisc", "catalog", "catmod", "causaltrt", "cdisc", "chart", "cimport", "cluster", "compare", "contents", "convert", "copy", "corr", "corresp", "cport", "datasets", "datekeys", "dbcstab", "delete", "discrim", "display", "distance", "document", "ds2", "explode", "export", "factor", "fastclus", "fcmp", "fedsql", "fmm", "fontreg", "format", "forms", "freq", "fslist", "gam", "gampl", "gee", "genmod", "glimmix", "glm", "glmmod", "glmpower", "glmselect", "groovy", "hadoop", "hdmd", "hpcandisc", "hpfmm", "hpgenselect", "hplmixed", "hplogistic", "hpmixed", "hpnlmod", "hppls", "hpprincomp", "hpquantselect", "hpreg", "hpsplit", "http", "iclifetest", "icphreg", "import", "inbreed", "infomaps", "irt", "items", "javainfo", "json", "kde", "krige2d", "lattice", "lifereg", "lifetest", "localedata", "loess", "logistic", "lua", "mcmc", "mds", "means", "metadata", "metalib", "metaoperate", "mi", "mianalyze", "migrate", "mixed", "modeclus", "multtest", "nested", "nlin", "nlmixed", "npar1way", "odslist", "odstable", "odstext", "options", "optload", "optsave", "orthoreg", "pds", "pdscopy", "phreg", "plan", "plm", "plot", "pls", "pmenu", "power", "presenv", "princomp", "prinqual", "print", "printto", "probit", "proto", "prtdef", "prtexp", "psmatch", "pwencode", "qdevice", "quantlife", "quantreg", "quantselect", "rank", "reg", "registry", "release", "report", "robustreg", "rsreg", "scaproc", "score", "seqdesign", "seqtest", "sgdesign", "sgpanel", "sgplot", "sgrender", "sgscatter", "sim2d", "simnormal", "soap", "sort", "source", "spp", "sql", "sqoop", "standard", "stdize", "stdrate", "stepdisc", "stream", "summary", "surveyfreq", "surveyimpute", "surveylogistic", "surveymeans", "surveyphreg", "surveyreg", "surveyselect", "tabulate", "tapecopy", "tapelabel", "template", "timeplot", "tpspline", "transpose", "transreg", "trantab", "tree", "ttest", "univariate", "varclus", "varcomp", "variogram", "xsl"]

" Simple word completion for SAS procedures
function! sascomplete#Complete(findstart, base)
  if a:findstart
    let current_text = strpart(getline('.'), 0, col('.') - 1)
    if matchstrpos(current_text, '\<proc \k*$')[1] >= 0
      return matchstrpos(current_text, '\k*$')[1]
    else
      return -3
    endif
  else
    return { 'words': filter(copy(s:sas_proc_names), 'v:val =~# "\\V\\^' . a:base . '"') }
  endif
endfunction
