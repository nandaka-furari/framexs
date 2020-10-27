XSLTフレームワーク framexs
---
## 初めに
<a href=""></a>
framexsは主にブラウザーからウェブサイトにアクセスして(X)HTMLを読む場合を想定し、XHTMLのコンテンツとスケルトンから柔軟に効率的にHTMLを作りそれを読ませる目的のフレームワークです。XSL(XSLT 1.0)で書かれていてXSLTプロセッサーに処理を行わせます。
## ドキュメント
このコードの使い方
## 用語
* スケルトン：共通して使われるテンプレートのようなXHTML。
* コンテンツ：単純な中身だけのXHTML。framexsコマンドを書く。
* framexsコマンド：framexsへの指示
## XHTMLモード
名前空間が`http://www.w3.org/1999/xhtml`のXHTMLでframexs.skeletonコマンドがある場合です。  
スケルトンとコンテンツは名前空間が`http://www.w3.org/1999/xhtml`のXHTMLを使います。  
スケルトンにはframexsの名前空間urn:framexsも必要です。

## framexsコマンド
XMLのプロローグ部において処理命令のうち名前の先頭にframexsが付くものをframexsコマンドと呼ぶものとします。

|名前           |解説|
|---------------|---|
|framexs.skeleton  |スケルトンのパスを指定します。|
|framexs.fetch     |XMLを指定します。名前と呼び出したいXMLのパスを空白で区切ります。framexs:fetch-d属性かframexs:fetch-sd属性で呼び出します。|

## スケルトンで使うframexs
スケルトンではframexsの名前空間(urn:framexs)を持つ要素と属性によってさまざまな機能が使えます。

## framexs要素
|名前         |解説|
|-------------|---|
|title        |コンテンツのtitle要素のテキストに置き換えます。|
|script       |コンテンツのhead要素下にあるscript要素をすべて呼び出します|
|style        |コンテンツのhead要素下にあるscript要素をすべて呼び出します|
|link         |コンテンツのhead要素下にあるscript要素をすべて呼び出します|
## framexs属性
|名前         |解説|                   
|-------------|---|
|id-d         |コンテンツXHTMLの中でidが値と一致する要素の子孫に置き換えます。|
|id-sd        |コンテンツXHTMLの中でidが値と一致する要素に置き換えます。|
|fetch-d      |framexs.fetchで指定したXMLのルートの子孫に置き換えます。|
|fetch-sd     |framexs.fetchで指定したXMLに置き換えます。|
|title        |コンテンツのtitle要素のテキストに置き換えます。|
|fix          |meta要素のみで使えます。contentをそのまま出力し合成しません。|
|meta-name    |コンテンツのmeta要素の中でnameが一致する要素のcontent属性値に置き換えます。|
|meta-property|コンテンツのmeta要素の中でpropertyが一致するcontent属性値に置き換えます。|
|print        |noを指定するとその要素を含めて結果に出力しません。|
