# Vim Auto Complete Popup

Plugin for automatically prompting completion popup menu.

## Introduction

This plugin is a fork of Takeshi Nishida's AutoComplPop. The plugin enables
VIM to automatically prompt popup menu for completion when inserting
characters in the text. It supports prompting completion for keywords and
omni-completion for various programming languages, as well as spelling
completion for text files.

### Supported programming languages

* HTML, XHTML, XML
* CSS
* JavaScript, Coffee, LiveScript
* PHP
* Perl
* Python
* Ruby
* VimScript
* SAS

### Spelling completion for:
* Markdown

## Changes

* Add default behaviors for JavaScript, Coffee, LiveScript, PHP, VimScript
  and SAS.
* Add spelling completion for Markdown, as well as plain text files.
* Add a new option `acp_set_completeopt_noselect` to control whether to
  select the first item in the popup menu.
* Fix various bugs in the original plugin.
* Revert the reliability to L9 library.

## License

This plugin is released under the MIT license:

Copyright 2006-2009 Takeshi NISHIDA, 2016-2017 Zhenhuan Hu

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
