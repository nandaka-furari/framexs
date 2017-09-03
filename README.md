XHTMLフレームワーク：framexs
---
## 初めに

framexsは主にブラウザーからウェブサイトにアクセスして(X)HTMLを読む場合を想定し、XHTMLのコンテンツとテンプレートから柔軟に効率的にHTMLを作りそれを読ませる目的のフレームワークです。XSL(XSLT 1.0)で書かれていてXSLTプロセッサーに処理を行わせます。一般的なXMLをHTMLに変換する機能もあります。
最低限の仕様の解説と原理はframexsそのものに書かれています。

http://www.bbwtest.info/~nandaka_furari/framexs/framexs.xml
http://www.bbwtest.info/~nandaka_furari/framexs/index.xhtml

### こんにちわ世界！
XHTMLについて実際のコード見ていきます。まずはコンテンツデータを見てみましょう。

```xml:content.xhtml
<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet type="application/xml" href="../../framexs.xml"?>
<?framexs.skelton template.xhtml?>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>世界よこんにちは</title>
</head>
<body>
<main>
<h1>あいさつ</h1>
<p>ハローワールド！</p>
</main>
</body>
</html>
```

次にテンプレートを見ていきます。

```xml:template.xhtml
<?xml version="1.0" encoding="UTF-8"?>
<html xmlns="http://www.w3.org/1999/xhtml" xmlns:framexs="urn:framexs">
<head>
<title> - テンプレートタイトル</title>
</head>
<body>
<article><p framexs:element-d="main">コンテンツのmain部分を読み込み置き換える</p></article>
</body>
</html>
```

そして変換結果はおおよそ次のようになります。処理系によって若干違う可能性があり正確にこうならないかもしれません。jEditでは空行や空白などが生成されましたがここでは見やすさのためにそれを削除しています。

```xml:result
<!DOCTYPE html SYSTEM "about:legacy-compat">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>コンテンツタイトル - テンプレートタイトル</title>
</head>
<body>
<article>
<h1>あいさつ</h1>
<p>ハローワールド！</p>
</article>
</body>
</html>
```

テンプレートとコンテンツが合成されたHTMLになります。
title要素のテキストも合成されており、コンテンツのtitle要素のテキストにテンプレートのtitle要素のテキストを加えたものになっています。合成するテキストの順番は固定です。

この処理方法はMVCパターンといえると思います。モデルはコンテンツでビューはテンプレート、コントローラーはframexsとコンテンツのframexsコマンドに相当します。XSLは重要な役目を負っていますがただ単に利用するだけならXSLコードは一切書く必要はありません。framexsにおいてXSLを書く役割りを持つのは私だけだからです（今のところは、ですが。XSLを書くのに協力してくれる方がいれば大歓迎します）。

## 原理と応用

framexsはXSLなのでXSLT処理を行わせるタイミングや方法としては

* ケース1 クライアントのアクセスごとにクライアント側のブラウザでXSLTを行わせ、同時に結果HTMLを処理させる。
* ケース2 クライアントのアクセスごとにサーバー側でXSLT処理を行い、クライアントに対して結果HTMLをサーバーが出力する。
* ケース3 Static Site Generatorとしてコンテンツに対して任意のプログラムにXSLTを行わせ結果HTMLを作っておき、クライアントからのアクセスではそれらのファイルを直接出力する。

などがあります。今回はケース1のみの解説ですが、他のケースで活用することは可能なはずです。
