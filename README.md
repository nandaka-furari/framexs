framexsフレームワーク 1.2.0
---
## 初めに

framexsは主にブラウザーからウェブサイトにアクセスして(X)HTMLを読む場合を想定し、XHTMLのコンテンツとテンプレートから柔軟に効率的にHTMLを作りそれを読ませる目的のフレームワークです。XSL(XSLT 1.0)で書かれていてXSLTプロセッサーに処理を行わせます。一般的なXMLをHTMLに変換する機能もあります。
最低限の仕様の解説と原理はframexsそのものに書かれています。

https://nandaka-furari.github.io/framexs/framexs.xml
https://nandaka-furari.github.io/framexs/index.xhtml


## XHTMLモード
名前空間がhttp://www.w3.org/1999/xhtmlのXHTMLでframexs.skeltonコマンドがある場合です。テンプレートとコンテンツは名前空間がhttp://www.w3.org/1999/xhtmlのXHTMLを使います。テンプレートにはframexsの名前空間urn:framexsも必要です。
framexs.skeltonが#のときはデフォルトのテンプレート的な内部での処理を行います。

## framexsコマンド
XMLのプロローグ部において処理命令のうち名前の先頭にframexsが付くものをframexsコマンドと呼ぶものとします。

先頭にframexs.defがあるものはframexs.skeltonが#の時にあるいは一般的なXMLの時に有効です。

## framexsコマンド一覧

|名前|解説|
|---------------|---|
|framexs.skelton|テンプレートのパスを指定します。"#"にすると内蔵の処理機構を適用します。|
|framexs.base   |テンプレートにbase要素がある場合、この値で上書きします。               |
|framexs.addpath|テンプレートのframexs:addpathがある要素のhref、src、data属性の先頭にこの値を付け足します。|
|framexs.fetch  |XMLを指定します。名前と呼び出したいXMLのパスを空白で区切ります。framexs:copyで呼び出します。|
|framexs.id     |指定したXHTMLの中のその名前の値を持つid属性を持つ要素を指定します。名前と呼び出したいXHTMLのパスを空白で区切ります。framexs:id-d属性かframexs:id-sd属性で呼び出します。|
|framexs.element|指定したXHTMLのbody要素の子の中のその名前の要素を指定します。名前と呼び出したいXHTMLのパスを空白で区切ります。framexs:element属性で呼び出します。|
|framexs.def.tab|タブ表示をします。|
|framexs.def.js |指定したJavaScriptを読み込みます。|

framexs属性
テンプレートではframexsの名前空間(urn:framexs)を持つ属性によってさまざまな機能が使えます。

## テンプレートで使うframexs属性

|名前|解説|
|-------------|---|
|id-d         |コンテンツXHTMLかまたはframexs.idで定義したXHTMLファイルの中でidが値と一致する要素の子孫をコピーします。|
|id-sd        |コンテンツXHTMLかまたはframexs.idで定義したXHTMLファイルの中でidが値と一致する要素とその子孫をコピーします。|
|element-d    |コンテンツXHTMLかまたはframexs.elementで定義したXHTMLファイルの中でidが値と一致する要素の子孫をコピーします。|
|element-sd   |コンテンツXHTMLかまたはframexs.elementで定義したXHTMLファイルの中でidが値と一致する要素とその子孫をコピーします。|
|fetch-d      |framexs.fetchで指定したXMLのルートの子孫ノードをコピーします。|
|fetch-sd     |framexs.fetchで指定したXMLをコピーします。|
|title        |title要素のテキストに置き換えます。|
|fix          |meta要素のみで使えます。contentをそのまま出力し合成しません。|
|meta-name    |コンテンツのmeta要素の中でnameが一致する要素のcontent属性値に置き換えます。|
|meta-property|コンテンツのmeta要素の中でpropertyが一致するcontent属性値に置き換えます。|
|addpath      |src、href、data属性にコンテンツのframexs.addpathで指定された値を先頭に加えます|
|print        |noを指定するとその要素を含めて結果に出力しません。|
|load         |meta要素のみで使えます。読み込む要素名を指定するとコンテンツのhead直下の要素を指定します。script、style、linkが指定可能です。|
