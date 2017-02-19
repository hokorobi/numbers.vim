# TagList

A source code browser plugin for Vim based on tags.

## Introduction

This plugin is a fork of Yegappan Lakshmanan's TagList plugin. The plugin
provides an overview of the structure of the programming language files and
enables you to efficiently browse through source code files for various
programming languages.

For more information about using this plugin, after installing the taglist
plugin, use the `:help taglist` command.

## Installation

1. Unpackage the plugin to the `$HOME/.vim` or the `$HOME/vimfiles` directory.
2. Change to the `$HOME/.vim/doc` or `$HOME/vimfiles/doc` directory, start Vim
   and run the `:helptags .` command to process the help file.
3. The binary file of Exuberant Ctags is always included for Windows. For other
   systems, if Exuberant Ctags is not present in your `PATH`, set the
   `tlist_ctags_cmd` variable with the location of Exuberant Ctags in the
   `.vimrc` file.
4. If you are running a terminal/console version of Vim and the terminal does
   not support changing the window width then set the `tlist_inc_win_width`
   variable to 0 in the `.vimrc` file.
5. Restart Vim.
6. You can now use `<C-j>` or the `:TlistToggle` command to open/close the
   taglist window. You can use the `:help taglist` command to get more
   information about using the taglist plugin.

## Supported file types

All file types supported by Exuberant Ctags.

* Please see [HERE](http://ctags.sourceforge.net/languages.html).

Additional supported languages:

* Markdown
* R
* SAS

## Changes

* Package the latest version of Exuberant Ctags with the plugin (Windows only).
* Read user language configurations from the `$HOME/vimfiles/tools` directory.
* Show tag information when moving the cursor in the taglist window.
* Add the default key mapping of `<C-j>` to toggle the taglist window.
* Add `Toggle Tag List` command to the main menu.

## License

Copyright (C) 2002-2013 Yegappan Lakshmanan, 2017 Zhenhuan Hu

Permission is hereby granted to use and distribute this code, with or without
modifications, provided that this copyright notice is copied with it. Like
anything else that is free, this plugin is provided *as is* and comes with no
warranty of any kind, either expressed or implied. In no event will the
copyright holder be liable for any damages resulting from the use of this
software.
