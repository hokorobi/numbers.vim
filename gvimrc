" Basic interface elements
set guioptions-=T

" Font
if has("gui_macvim")
  set guifont=Source\ Code\ Pro:h14
elseif has("gui_win32")
  if version > 704
    set guifont=Source_Code_Pro:h10:cANSI,Consolas:h11:cANSI
    set renderoptions=type:directx,level:0.75,gamma:1.25,contrast:0.25,geom:1,renmode:5,taamode:1
  else
    set guifont=Consolas:h11:cANSI
  endif
  set linespace=3
endif

" Menus
if has("gui_macvim")
  an 10.326 File.-KSEP1-                                    <Nop>
  an 10.327 File.Reopen\ Using\ Encoding.Unicode\ (UTF-8)   :conf e ++enc=utf-8<CR>
elseif has("gui_win32")
  an 10.331 File.-KSEP1-                                    <Nop>
  an 10.332 File.Reopen\ Using\ Encoding.Unicode\ (UTF-8)   :conf e ++enc=utf-8<CR>
endif
an File.Reopen\ Using\ Encoding.Unicode\ (UTF-16)           :conf e ++enc=utf-16<CR>
an File.Reopen\ Using\ Encoding.-KSEP1-                     <Nop>
an File.Reopen\ Using\ Encoding.Chinese\ (GB18030)          :conf e ++enc=gb18030<CR>
an File.Reopen\ Using\ Encoding.Chinese\ (GBK)              :conf e ++enc=gbk<CR>
an File.Reopen\ Using\ Encoding.Chinese\ (Big-5)            :conf e ++enc=big5<CR>
an File.Reopen\ Using\ Encoding.Japanese\ (Shift-JIS)       :conf e ++enc=sjis<CR>
an File.Reopen\ Using\ Encoding.Japanese\ (ISO-2022-JP)     :conf e ++enc=iso-2022-jp<CR>
an File.Reopen\ Using\ Encoding.Japanese\ (EUC-JP)          :conf e ++enc=euc-jp<CR>
an File.Reopen\ Using\ Encoding.Western\ (Latin-1)          :conf e ++enc=latin1<CR>

an 20.421 Edit.-KSEP1-                                      <Nop>
inoreme <silent> 20.422 Edit.Insert.File\ Path\.\.\.        <C-r>= browse(0, "Insert File Path", $HOME, "")<CR>
inoreme <silent> Edit.Insert.Folder\ Path\.\.\.             <C-r>= browsedir("Insert Folder Path", $HOME)<CR>
inoreme <silent> Edit.Insert.Folder\ Listing\.\.\.          <C-r>= globpath(browsedir("Insert Folder Listing", $HOME), '*')<CR>
an Edit.Insert.-KSEP1-                                      <Nop>
inoreme <silent> Edit.Insert.Time\ Stamp                    <C-r>= strftime('%c')<CR>
inoreme <silent> Edit.Insert.Today                          <C-r>= strftime('%b %d, %Y')<CR>
vnoreme <silent> 20.423 Edit.Convert.Make\ Uppercase        U<CR>
vnoreme <silent> Edit.Convert.Make\ Lowercase               u<CR>
vnoreme <silent> Edit.Convert.Toggle\ Case                  ~<CR>
an Edit.Convert.-KSEP1-                                     <Nop>
vnoreme <silent> Edit.Convert.Shift\ Selection\ to\ Left    <<CR>
vnoreme <silent> Edit.Convert.Shift\ Selection\ to\ Right   ><CR>
an Edit.Convert.-KSEP2-                                     <Nop>
vnoreme <silent> Edit.Convert.Split\ Line                   :call keny#SplitLineNicely()<CR>
vnoreme <silent> Edit.Convert.Join\ Lines                   J<CR>
an Edit.Convert.-KSEP3-                                     <Nop>
an <silent> Edit.Convert.Convert\ Encoding\ to\ UTF-8       :setlocal fenc=utf-8<CR>
an <silent> Edit.Convert.Convert\ Encoding\ to\ UTF-16      :setlocal fenc=utf-16<CR>
