============
usercomplete
============

What's this
-----------
mikutterにユーザー名補完機能をつけます．

How to
------
::

 $ git clone https://github.com/osak/usercomplete.git ~/.mikutter/plugin/

もしくはみっくストアで．
userutilに依存しているので，一緒に https://github.com/osak/userutil も導入してください．

導入すると，postboxロールに「ユーザー名補完(次)」「ユーザー名補完(前)」というコマンドが追加されます．
これをTabとかShift+Tabとかに割り当てておくと，IDの入力中にショートカットキーを押した時にユーザー名が補完されます．
複数の候補があるときは，カーソル位置をそのままで繰り返し押すと1つずつ変わります．

例::

 @br<Tab>
   ↓
 @brsywe

License
-------
MIT License とします．

Copyright (c) 2013 Koga Osamu(osa_k)

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
