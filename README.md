numbers.vim
===========

This is a fork of the numbers.vim plugin originally developed by Mahdi Yusuf.
The majority of the plugin codes have been rewritten, including bug fixes and
an alternative approach to determine whether a number column is needed.
Manual toggle commands have been removed from the original plugin.

This plugin alternates between relative numbering (`relativenumber`) and
absolute numbering (`number`) for the active window depending on the current
mode. Relative numbering is used in `Normal` mode while absolute numbering is
used in `Insert` mode. In a GUI, it also functions based on whether or not the
app has focus.

Requirements
------------

  - Vim 8.0+

Usage
-----

Once installed, no action is *required* at the user's end.
