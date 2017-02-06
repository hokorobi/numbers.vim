numbers.vim
===========

numbers.vim is a plugin for intelligently toggling line numbers.

This plugin alternates between relative numbering (`relativenumber`) and
absolute numbering (`number`) for the active window depending on the mode you
are in. In a GUI, it also functions based on whether or not the app has focus.

Requirements
------------

  - Vim 7.4+

Numbers Don't Belong
--------------------

If you see numbers where they don't belong like in the help menus or other vim
plugins, be sure to add your plugins to the exclusion list in your vimrc like
so:

    let g:windows_excluded = ['tagbar', 'gundo', 'minibufexpl', 'nerdtree']

The plugin by default contains the following:

    let g:windows_excluded = ['unite', 'tagbar', 'startify',
        \ 'gundo', 'vimshell', 'w3m']

So be sure to include the superset in your vimrc or gvimrc

Usage
-----

Once installed, no action is *required* on your part.
