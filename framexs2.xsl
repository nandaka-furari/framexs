<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet type="application/xml" href="framexs2.xml"?>
<?framexs?>
<?framexs.def.js framexs.js?>
<!--
XSLTで実現するフレームワーク framexs
-->
<xsl:stylesheet
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns="http://www.w3.org/1999/xhtml"
	xmlns:xh="http://www.w3.org/1999/xhtml"
	xmlns:xh2="http://www.w3.org/2002/06/xhtml2/"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:framexs="urn:framexs2"
	version="2.0">
	<xsl:output encoding="UTF-8" media-type="text/html" method="html" doctype-system="about:legacy-compat" exclude-result-prefixes="xh xh2"/>
	<xsl:param name="framexs" select="boolean(/processing-instruction('framexs'))"/>


	<!-- skelton_locが指定されればXHTMLテンプレート処理を行う -->
	<xsl:param name="skelton_loc" select="/processing-instruction('framexs.skelton')"/>
	<xsl:param name="framexs.base" select="/processing-instruction('framexs.base')"/>
	<xsl:param name="framexs.addpath" select="/processing-instruction('framexs.addpath')"/>

	<!-- デフォルトか一般XML -->
	<xsl:param name="framexs.tab" select="/processing-instruction('framexs.def.tab')"/>
	<xsl:param name="saxonce_loc" select="/processing-instruction('framexs.def.saxonce')"/>
	<xsl:param name="css_loc" select="/processing-instruction('framexs.def.css')"/>
	<xsl:param name="js_loc" select="/processing-instruction('framexs.def.js')"/>
	<xsl:param name="framexsjs_loc" select="/processing-instruction('framexs.def.framexsjs')"/>




	<xsl:variable name="root" select="/"/>
	<xsl:variable name="rootns" select="namespace-uri(*[1])"/>
	<xsl:variable name="xhns" select="'http://www.w3.org/1999/xhtml'"/>
	<xsl:variable name="fmxns" select="'urn:framexs'"/>
	<xsl:variable name="xh2ns" select="'http://www.w3.org/2002/06/xhtml2/'"/>
	<xsl:variable name="addedpath" select="resolve-uri($framexs.addpath,document-uri(/))"/>
	<xsl:variable name="version" select="'2.0.0.alpha-SNAPSHOT'"/>
	
	<!-- テンプレート兼解説書 このXSLに関する説明 -->
	<xsl:variable name="desc">
		<h2>framexsフレームワーク <xsl:value-of select="$version"/></h2>
		<p>framexsはXSLTプロセッサに処理を行わせる記述のXSLファイルです。どのXMLでもHTML5に変換する機能がありますが、特にXHTMLのコンテンツとテンプレートによって、効率的に柔軟にHTML5に変換する目的で書かれたフレームワークです。</p>
		<section>
			<h2>framexsの原理</h2>
			<p>処理対象のソースとなるXMLのこのファイルをスタイルシートとして読み込ませ、さらにスタイルシートパラメータの指定かXMLのプロローグ部においてframexs特有の記述を追加することによってさまざまな処理を行わせます。<br/>
			framexsはXHTMLのテンプレートとコンテンツを使うモードと一般的なXMLを処理するモードの2つのモードがあります。
			</p>
			<p>ブラウザで使う場合はXMLのプロローグ部でxml-stylesheet処理命令によって指定してください。<br/>
			xml-stylesheet処理命令に関しては詳しくXMLやはXSLTやUserAgentの仕様を確認してください。<br/>
			今このファイルをブラウザで観ているならば処理形態はXMLモードで処理しています。このファイルをXSLにしてこのファイル自身をソースXMLとしてXSLT処理を行わせてHTML5を出力しています。</p>
			<h4>XHTMLモード</h4>
			<p>名前空間が<xsl:value-of select="$xhns"/>のXHTMLでframexs.skeltonコマンドがある場合です。テンプレートとコンテンツは名前空間が<xsl:value-of select="$xhns"/>のXHTMLを使います。テンプレートにはframexsの名前空間<xsl:value-of select="$fmxns"/>も必要です。<br/>
			framexs.skeltonが#のときはデフォルトのテンプレート的な内部での処理を行います。</p>
			<h4>XMLモード</h4>
			<p>名前空間がXHTMLのものではないか、あるいは、XHTMLであってもframexs.skeltonコマンドが無ければ一般的なXMLを処理する動作を行います。</p>
		</section>
		<section>
			<h4>framexsコマンド</h4>
			<p>XMLのプロローグ部において処理命令のうち名前の先頭にframexsが付くものをframexsコマンドと呼ぶものとします。</p>
			<p>先頭にframexs.defがあるものはframexs.skeltonが#の時にあるいは一般的なXMLの時に有効です。</p>
			<table summary="1行目はコマンド名。2行目は解説。コンテンツで使う。">
				<caption>framexsコマンド一覧</caption>
				<tr><td>framexs.skelton</td><td>テンプレートのパスを指定します。"#"にすると内蔵の処理機構を適用します。</td></tr>
				<tr><td>framexs.base</td><td>テンプレートにbase要素がある場合、この値で上書きします。</td></tr>
				<tr><td>framexs.addpath</td><td>テンプレートのframexs:addpathがある要素のhref、src、data属性の先頭にこの値を付け足します。</td></tr>
				<tr id="command_fetch"><td>framexs.fetch</td><td>XMLを指定します。名前と呼び出したいXMLのパスを空白で区切ります。framexs:copyで呼び出します。</td></tr>
				<tr><td>framexs.id</td><td>指定したXHTMLの中のその名前の値を持つid属性を持つ要素を指定します。名前と呼び出したいXHTMLのパスを空白で区切ります。<a href="template_attr_id-d">framexs:id-d属性</a>か<a href="template_attr_id-sd">framexs:id-sd属性</a>で呼び出します。</td></tr>
				<tr><td>framexs.element</td><td>指定したXHTMLのbody要素の子の中のその名前の要素を指定します。名前と呼び出したいXHTMLのパスを空白で区切ります。<a href="template_attr_element">framexs:element属性</a>で呼び出します。</td></tr>
				<tr><td>framexs.def.tab</td><td>タブ表示をします。</td></tr>
				<tr><td>framexs.def.js</td><td>指定したJavaScriptを読み込みます。</td></tr>
				<tr><td>framexs.def.framexsjs</td><td>指定したJavaScriptをframexsアプリのJSにします。</td></tr>
				<tr><td>framexs.def.saxonce</td><td>framexsアプリで使うSaxonCEを呼び出すパスを指定します。</td></tr>
			</table>
			<h4>framexs属性</h4>
			<p>テンプレートではframexsの名前空間(<xsl:value-of select="$fmxns"/>)を持つ属性によってさまざまな機能が使えます。</p>
			<table summary="">
				<caption>テンプレートで使うframexs属性</caption>
				<tr id="template_attr_id-d"><td>id-d</td><td>コンテンツXHTMLかまたはframexs.idで定義したXHTMLファイルの中でidかxml:idの値と一致する要素の子孫をコピーします。</td></tr>
				<tr id="template_attr_id-sd"><td>id-sd</td><td>コンテンツXHTMLかまたはframexs.idで定義したXHTMLファイルの中でidかxml:idの値と一致する要素とその子孫をコピーします。</td></tr>
				<tr id="template_attr_elelment-d"><td>elment-d</td><td>コンテンツXHTMLかまたはframexs.elementで定義したXHTMLファイルの中でidが値と一致する要素の子孫をコピーします。</td></tr>
				<tr id="template_attr_elelment-sd"><td>elment-sd</td><td>コンテンツXHTMLかまたはframexs.elementで定義したXHTMLファイルの中でidが値と一致する要素とその子孫をコピーします。</td></tr>
				<tr><td>fetch-d</td><td>framexs.fetchで指定したXMLのルートの子孫ノードをコピーします。</td></tr>
				<tr><td>fetch-sd</td><td>framexs.fetchで指定したXMLをコピーします。</td></tr>
				<tr><td>title</td><td>title要素のテキストに置き換えます。</td></tr>
				<tr><td>meta-name</td><td>コンテンツのmeta要素の中でnameが一致する要素のcontent属性値に置き換えます。</td></tr>
				<tr><td>meta-property</td><td>コンテンツのmeta要素の中でpropertyが一致するcontent属性値に置き換えます。</td></tr>
				<tr><td>addpath</td><td>src、href、data属性にコンテンツのframexs.addpathで指定された値を先頭に加えます</td></tr>
				<tr><td>print</td><td>noを指定するとその要素を含めて結果に出力しません。</td></tr>
				<tr><td>load</td><td>meta要素のみで使えます。読み込む要素名を指定するとコンテンツのhead直下の要素を指定します。script、style、linkが指定可能です。</td></tr>
			</table>
		</section>
	</xsl:variable>

	<xsl:template match="/">
		<xsl:message>test<xsl:value-of select="name($xml-content/xh2:html)"/></xsl:message>
		<xsl:choose>
			<!-- テンプレート付きXHTML2またはXHTML -->
			<xsl:when test="$skelton_loc != '' and namespace-uri(*[1]) = $xh2ns">
				<xsl:message>
					<xsl:value-of select="'test'"/>
				</xsl:message>
				<xsl:choose>
					<xsl:when test="$skelton_loc = '#'">
						<xsl:message>xh2_content</xsl:message>
						<xsl:apply-templates select="$default-template"></xsl:apply-templates>
					</xsl:when>
					<xsl:otherwise>
						<xsl:message>content</xsl:message>
						<xsl:apply-templates select="document($skelton_loc)/xh2:html" mode="default">
							<xsl:with-param name="content" select="$root/xh2:html"/>
						</xsl:apply-templates>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="$skelton_loc = '#' and string(namespace-uri(*[1])) = $xh2ns">
				<xsl:apply-templates select="$default-template" mode="default">
					<xsl:with-param name="content" select="$root/xh2:html"/>
				</xsl:apply-templates>
			</xsl:when>
			<!--  -->
			<xsl:otherwise>
				<xsl:apply-templates select="$default-template" mode="default">
					<xsl:with-param name="content" select="$xml-content/xh2:html"/>
				</xsl:apply-templates>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="*" mode="default">
		<xsl:param name="content"/>
		<xsl:choose>
			<xsl:when test="boolean(@framexs:*)">
				<xsl:message>framexs:<xsl:value-of select="name()"/></xsl:message>
				<xsl:apply-templates select="." mode="framexs">
					<xsl:with-param name="content" select="$content"/>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="." mode="transform">
					<xsl:with-param name="content" select="$content"/>
				</xsl:apply-templates>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- XHTML2.0 -->
	<xsl:template match="xh2:title">
		<xsl:param name="content"/>
		<title><xsl:value-of select="$content/xh2:head/xh2:title"/><xsl:value-of select="text()"/></title>
	</xsl:template>
	
	<xsl:template match="xh2:h" mode="transform">
		<xsl:param name="content"/>
		<xsl:element name="{framexs:heading(number(@importance))}">
			<xsl:apply-templates>
				<xsl:with-param name="content" select="$content"/>
			</xsl:apply-templates>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="xh2:*[@href or @hreflang or @rel or @target]" mode="href">
		<a>
		</a>
	</xsl:template>
	
	<xsl:template name="trans">
		<xsl:param name="elename"/>
		<xsl:param name="name"/>
		<xsl:variable name="elem" select="."/>
		<xsl:element name="{$elename}">
			<xsl:attribute name="class"><xsl:value-of select="$name"/></xsl:attribute>
			<xsl:if test=".[@class] and $name != ''">
				<xsl:attribute name="class">
						<xsl:value-of select="concat(concat($name,' '),@class)"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:if test="@href or @hreflang or @target or @rel"></xsl:if>
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="xh2:frame" mode="transform">
		<xsl:param name="content"/>
		<xsl:variable name="name" select="'frame'"/>
		<div>
			<xsl:attribute name="class"><xsl:value-of select="$name"/></xsl:attribute>
			<xsl:for-each select="@*">
				<xsl:copy/>
				<xsl:if test="name() = 'class'">
					<xsl:attribute name="class">
						
					</xsl:attribute>
				</xsl:if>
			</xsl:for-each>
			<xsl:apply-templates mode="default">
				<xsl:with-param name="content" select="$content"/>
			</xsl:apply-templates>
		</div>
	</xsl:template>
	
	<xsl:template match="xh2:p">
		<xsl:variable name="name" select="'paragraph'"/>
		<div>
			<xsl:attribute name="class"><xsl:value-of select="$name"/></xsl:attribute>
			<xsl:apply-templates/>
		</div>
	</xsl:template>

	<xsl:template match="xh2:l">
		<xsl:variable name="name" select="'line'"/>
		<p>
			<xsl:attribute name="class"><xsl:value-of select="$name"/></xsl:attribute>
			<xsl:for-each select="@*">
				<xsl:choose>
					<xsl:when test="name() = 'class'">
						<xsl:attribute name="class">
							<xsl:value-of select="concat(concat($name,' '),@class)"/>
						</xsl:attribute>
					</xsl:when>
				</xsl:choose>
				<xsl:copy/>
				<xsl:if test="name() = 'href'">
					<a>
						<xsl:attribute name="href"><xsl:value-of select="resolve-uri(@href,$addedpath)"/></xsl:attribute>
						<xsl:apply-templates/>
					</a>
				</xsl:if>
			</xsl:for-each>
			<xsl:apply-templates/>
		</p>
	</xsl:template>
	
	<xsl:template match="xh2:link">
		<a>
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates/>
		</a>
	</xsl:template>
	
	<xsl:template match="xh2:di" mode="transform">
		<xsl:apply-templates/>
	</xsl:template>
	
	<xsl:template match="xh2:*" mode="transform">
		<xsl:param name="content"/>
		<xsl:message><xsl:value-of select="name()"/></xsl:message>
		<xsl:element name="{name()}" namespace="http://www.w3.org/1999/xhtml">
			<xsl:for-each select="@*">
				<xsl:copy/>
			</xsl:for-each>
			<xsl:apply-templates mode="default">
				<xsl:with-param name="content" select="$content"/>
			</xsl:apply-templates>
		</xsl:element>
	</xsl:template>
		
	<xsl:template match="xh2:source" mode="transform">
		<xsl:choose>
			<xsl:when test="@type = 'text/javascript' or @type = 'application/jsavascript' or @type = 'application/ecmascript'">
				<xsl:element name="script" namespace="http://www.w3.org/1999/xhtml">
					<xsl:for-each select="@*">
						<xsl:choose>
							<xsl:when test="name()='uri'">
								<xsl:attribute name="src"><xsl:value-of select="."/></xsl:attribute>
							</xsl:when>
							<xsl:otherwise>
								<xsl:copy/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:for-each>
					<xsl:apply-templates mode="default"/>
			</xsl:element>
			</xsl:when>
			<xsl:when test="@type = 'text/css'">
				<link/>
				<xsl:element name="link" namespace="http://www.w3.org/1999/xhtml">
					<xsl:attribute name="rel">stylesheet</xsl:attribute>
					<xsl:for-each select="@*">
						<xsl:choose>
							<xsl:when test="name()='uri'">
								<xsl:attribute name="href"><xsl:value-of select="."/></xsl:attribute>
							</xsl:when>
							<xsl:otherwise>
								<xsl:copy/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:for-each>
				</xsl:element>
			</xsl:when>
		</xsl:choose>
	</xsl:template>	
	<xsl:template name="href">
		<xsl:element name="{name()}" namespace="http://www.w3.org/1999/xhtml">
			<xsl:for-each select="@*">
				<xsl:if test="name() != 'href'">
					<xsl:copy/>
				</xsl:if>
			</xsl:for-each>
			<a href="{@href}">
				<xsl:apply-templates></xsl:apply-templates>
			</a>
		</xsl:element>
	</xsl:template>

	<!--xhtml2 -->

	<xsl:template match="*" mode="content">
		<xsl:element name="{name()}">
			<xsl:apply-templates mode="content" select="@*"></xsl:apply-templates>
			<xsl:apply-templates mode="content" select="node()"></xsl:apply-templates>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="@* | node()" mode="content">
		<xsl:copy>
			<xsl:apply-templates select="@*" mode="content"/>
			<xsl:apply-templates mode="content"/>
		</xsl:copy>
	</xsl:template>	
	
	<!-- framexs:idを処理 -->
	<xsl:template match="*" mode="search-id">
		<xsl:param name="targetid"/>
		<xsl:param name="self" select="false()"/>
		<xsl:choose>
			<xsl:when test="@id = $targetid or @xml:id = $targetid">
				<xsl:choose>    
					<xsl:when test="$self">
						<xsl:apply-templates mode="content" select="."/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates mode="content" select="node()"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="*" mode="search-id">
					<xsl:with-param name="targetid" select="$targetid"/>
					<xsl:with-param name="self" select="$self"/>
				</xsl:apply-templates>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="attr_id">
		<xsl:param name="content"/>
		<xsl:param name="id"/>
		<xsl:param name="range"/>
		<xsl:apply-templates mode="search-id" select="$content/*">
			<xsl:with-param name="targetid" select="$id"/>
			<xsl:with-param name="self" select="$range = 'sd'"/>
		</xsl:apply-templates>
		<xsl:for-each select="$root/processing-instruction('framexs.id')">
			<xsl:variable name="name" select="substring-before(.,' ')"/>
			<xsl:if test="$id = $name">
				<xsl:apply-templates mode="search-id" select="document(substring-after(.,' '),$root)/*">
					<xsl:with-param name="targetid" select="$id"/>
					<xsl:with-param name="self" select="$range = 'sd'"/>
				</xsl:apply-templates>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>
	<xsl:template match="*[@framexs:id-d]" mode="framexs">
		<xsl:param name="content"/>
		<xsl:call-template name="attr_id">
			<xsl:with-param name="content" select="$content"/>
			<xsl:with-param name="id" select="@framexs:id-d"/>
			<xsl:with-param name="range" select="'d'"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="*[@framexs:id-sd]" mode="framexs">
		<xsl:param name="content"/>
		<xsl:call-template name="attr_id">
			<xsl:with-param name="content" select="$content"/>
			<xsl:with-param name="id" select="@framexs:id-sd"/>
			<xsl:with-param name="range" select="'sd'"/>
		</xsl:call-template>
	</xsl:template>
	
    <xsl:template name="element">
    	<xsl:param name="content"/>
    	<xsl:param name="self" select="false()"/>
    	<xsl:param name="element"/>
    	<xsl:for-each select="framexs:getbody($content)">
			<xsl:if test="name() = $element">
				<xsl:choose>
					<xsl:when test="$self">
						<xsl:apply-templates mode="content" select="."/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates mode="content" select="node()"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:if>
		</xsl:for-each>
		<xsl:for-each select="$root/processing-instruction('framexs.element')">
			<xsl:variable name="name" select="substring-before(., ' ')"/>
			<xsl:if test="$element = $name">
				<xsl:for-each select="framexs:getbody(document(substring-after(.,' '),$root))">
					<xsl:if test="name() = $element">
						<xsl:choose>
							<xsl:when test="$self">
								<xsl:apply-templates mode="content" select="."/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:apply-templates mode="content" select="node()"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</xsl:for-each>
			</xsl:if>
		</xsl:for-each>
    </xsl:template>
    <xsl:template match="*[@framexs:element-sd]" mode="framexs">
    	<xsl:param name="content"/>
		<xsl:call-template name="element">
			<xsl:with-param name="content" select="$content"/>
			<xsl:with-param name="element" select="@framexs:element-sd"/>
			<xsl:with-param name="self" select="true()"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="*[@framexs:element-d]" mode="framexs">
		<xsl:param name="content"/>
		<xsl:message>test<xsl:value-of select="$content"/></xsl:message>
		<xsl:call-template name="element">
			<xsl:with-param name="content" select="$content"/>
			<xsl:with-param name="element" select="@framexs:element-d"/>
			<xsl:with-param name="self" select="false()"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="xh:*[@framexs:fetch-sd]" mode="framexs">
		<xsl:variable name="name" select="@framexs:fetch-sd"/>
		<xsl:for-each select="$root/processing-instruction('framexs.fetch')">
			<xsl:if test="$name = substring-before(.,' ')">
				<xsl:apply-templates mode="content" select="document(substring-after(.,' '), $root)/*"/>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>
	<xsl:template match="xh:*[@framexs:fetch-d]" mode="framexs">
		<xsl:variable name="name" select="@framexs:fetch-d"/>
		<xsl:for-each select="$root/processing-instruction('framexs.fetch')">
			<xsl:if test="$name = substring-before(.,' ')">
				<xsl:apply-templates mode="content" select="document(substring-after(.,' '), $root)/*"/>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>
	
	<xsl:template match="xh:*">
		<xsl:element name="{name()}">
			<xsl:for-each select="@*">
				<xsl:choose>
					<xsl:when test="name() = 'src' or name() = 'href' or name() = 'data'">
						<xsl:attribute name="{name()}"><xsl:value-of select="resolve-uri(.,$addedpath)"/><xsl:value-of select="."/></xsl:attribute>
					</xsl:when>
					<xsl:otherwise>
						<xsl:if test="string(namespace-uri()) != 'urn:framexs'">
							<xsl:copy-of select="."/>
						</xsl:if>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>

	<xsl:template match="*" mode="xmltohtml">
		<div class="element {name()}">
			<p>
				<span class="elemicon fa fa-folder-o"></span>
				<span class="elemname">
					<xsl:value-of select="name()"/>
				</span>
				<xsl:for-each select="@*">
					<span class="attricon fa fa-cogs"></span>
					<span class="attr">
						<span class="name">
							<xsl:value-of select="name()"/>
						</span>
						<xsl:text>=</xsl:text>
						<span class="value">
							<xsl:value-of select="."/>
						</span>
					</span>
					<xsl:text>&#160;</xsl:text>
				</xsl:for-each>
			</p>
			<xsl:apply-templates mode="xmltohtml"/>
		</div>
	</xsl:template>
	
	<xsl:template match="id('profile')">
		<xsl:apply-templates></xsl:apply-templates>
	</xsl:template>

	
	<xsl:template match="*">
		<xsl:copy-of select="."/>
	</xsl:template>
	
	<!-- command -->
	<xsl:template match="*[@framexs:print='no']"><!--何も出力しない--></xsl:template>    
	<xsl:template match="*[@framexs:pull]">
		<xsl:variable name="pull" select="@framexs:pull"/>
		<xsl:apply-templates mode="search-id" select="$content/xh:*">
			<xsl:with-param name="targetid" select="$pull"/>
		</xsl:apply-templates>
		<xsl:for-each select="$content/processing-instruction('framexs.pull')">
			<xsl:variable name="name" select="substring-before(.,' ')"/>
			<xsl:if test="$pull = $name">
				<xsl:apply-templates mode="search-id" select="document(substring-after(.,' '),$root)/xh:*">
					<xsl:with-param name="targetid" select="$pull"/>
				</xsl:apply-templates>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>

	<xsl:template match="*[framexs:if]">
		
	</xsl:template>
	<xsl:template match="*[framexs:for]">
	</xsl:template>
	<xsl:template match="xh:*" mode="search-id">
		<xsl:param name="targetid"/>
		<xsl:choose>
			<xsl:when test="@id = $targetid">
				<xsl:copy-of select="node()"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="xh:*" mode="search-id">
					<xsl:with-param name="targetid" select="$targetid"/>
				</xsl:apply-templates>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:variable name="xml-content">
		<html xmlns="http://www.w3.org/2002/06/xhtml2/">
			<head>
				<title>デフォルト</title>
			</head>
			<body>
				<main>test</main>
			</body>
		</html>
	</xsl:variable>
	<xsl:variable name="default-template">
		<html xmlns="http://www.w3.org/2002/06/xhtml2/" xmlns:v-on="urn:v-on">
			<head>
				<title> - デフォルトテンプレート</title>
				<source type="text/javascript" uri="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.1.0/jquery.js"></source>
				<source type="text/javascript" uri="https://cdnjs.cloudflare.com/ajax/libs/vue/2.0.1/vue.js"></source>
				<source type="text/css" uri="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css"></source>
				<source type="text/javascript" uri="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></source>
				<source type="text/javascript" uri="https://cdnjs.cloudflare.com/ajax/libs/URI.js/1.18.4/URI.js"></source>
				<source type="text/css" uri="https://cdnjs.cloudflare.com/ajax/libs/qunit/2.0.1/qunit.css"></source>
				<source type="text/javascript" uri="https://cdnjs.cloudflare.com/ajax/libs/qunit/2.0.1/qunit.js"></source>
				<source type="" uri="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.css"></source>
				<source type="" uri="https://cdnjs.cloudflare.com/ajax/libs/d3/4.2.6/d3.min.js"></source>
				<source type="" uri="https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.6.1/MathJax.js"></source>
				<sourcecode type="text/css">
				#framexs-name {color: gray; text-shadow: 1px 1px blue;font-family: 'ヒラギノ角ゴ Pro W3'; transition: all 300ms 0s ease}
#framexs-name:hover {color: black;box-shadow: 3px 3px gray;text-shadow: 3px 3px 1px 1px azure;transition: all 600ms 0s ease}
#logo {vertical-align: top}
#framexs-name .first-letter {display:inline-block}
main p {box-shadow:1px 1px 1px 1px silver;margin: .5em;padding:.5em}
section {}
header {border-bottom:double 5px silver;margin: 10px}
footer {border-top:double 5px silver;margin: 10px; padding: 10px 0}
footer .col {border-style: solid; border-color: aqua; border-width: 1px 0 0 1px; box-shadow: 1px 1px aquq; display: table-cell}
.elemicon {margin-right: .5em}
.elemname {}
.element {border: solid 1px gray;}
.element .element:hover, article .element:hover {box-shadow: 3px 3px gray}
.element .element,article .element  {border-style: solid; border-color: blue; border-width: 1px 0 0 1px; margin: 10px 0 10px 10px; padding:10px}
.attricon {margin-right: .5em; margin-left:1em}
.attr .name {color: #E8351E}
.attr .value {color: #1E6BE6}
.panel-heading {margin:0}
#qunit-panel {width:800px;float:right; display:none}
.wide {width: 200%}
td,th {border: solid 1px gray;}
				</sourcecode>
			</head>
			<body>
				<header id="header-panel" class="row">
					<div class="col-md-4">
						<h id="framexs-name">
							frame<span class="first-letter">x</span>s
						</h>
					</div>
					<div class="col-md-8">
						<p framexs:title=""></p>
					</div>
				</header>
				<frame class="row" id="wrapper">
					<main class="col-md-8" id="main-panel">
						<div framexs:element-d="main"></div>
					</main>
					<aside class="col-md-4" id="controll-panel">
						<p>傍コンテンツ</p>
						<div id="framexs-panel">
							<dl>
								<di>
									<dt>version</dt>
									<dd>{{version}}</dd>
								</di>
								
								<dt>saxonce</dt>
								<dd>{{saxonce_loaded}}</dd>
								<dt>
									<label>source</label>
								</dt>
								<dd>
									<p>
										<input v-model="sourceLocation" placeholder="edit me"/>
									</p>
									<p>
										<button id="framexs-for:basedoc" class="btn btn-default" v-on:click="load">load</button>
									</p>
								</dd>
							</dl>
							<datalist id="xslt">
								<option value="http://www.bbwtest.info/files/xml/xslt/v2/xhtml2-to.xslt"></option>
							</datalist>
							
							<p>
								<button id="qunit-toggle" class="btn btn-default" onclick="qunit_toggle(this);">qunit</button>
							</p>
						</div>
						
						<div id="qunit-panel">
							<div id="qunit"></div>
							<div id="qunit-fixture"></div>
						</div>
						<h3>個別テンプレ</h3>
						<framexs:element name="aside"/>
						
						<p>
							<object data="http://www.bbwtest.info/~nandaka_furari/files/html/framexs-analytics.html" type="text/html" width="160" height="90"></object>
						</p>
					</aside>
				</frame>
				<footer id="footer-panel" class="row">
					<div class="col-md-4">
						<address class="panel panel-default">
							<p class="panel-heading">ナンダカフラリ</p>
							<ul class="panel-body list-group">
								<li class="list-group-item" href="https://twitter.com/nandaka_furari">twitter</li>
								<li class="list-group-item" href="https://github.com/nandaka-furari"></li>
								<li class="list-group-item" href="http://www.bbwtest.info/~nandaka_furari/">website</li>
							</ul>
						</address>
					</div>
					<div class="col-md-4">
						<div class="panel panel-default">
							<p class="panel-heading">XSLT</p>
							<ul class="panel-body list-group">
								<li class="list-group-item" href="https://www.w3.org/TR/xslt">XSL Transformations (XSLT) Version 1.0</li>
								<li class="list-group-item" href="https://www.w3.org/TR/xslt20/">XSL Transformations (XSLT) Version 2.0</li>
								<li class="list-group-item" href="https://www.w3.org/TR/xslt-30/">XSL Transformations (XSLT) Version 3.0</li>
							</ul>
						</div>
					</div>
				</footer>
			</body>
		</html>
	</xsl:variable>
	<xsl:function name="framexs:getbody" as="item()*">
		<xsl:param name="node" as="item()*"/>
		<xsl:message>getbody<xsl:value-of select="name($node)"/></xsl:message>
		<xsl:choose>
			<xsl:when test="string(namespace-uri($node)) = $xhns">
				<xsl:sequence select="$node/xh:body/xh:*"/>
			</xsl:when>
			<xsl:when test="string(namespace-uri($node)) = $xh2ns">
				<xsl:sequence select="$node/xh2:body/xh2:*"/>
			</xsl:when>
		</xsl:choose>
	</xsl:function>
	<xsl:function name="framexs:heading" as="xs:string">
		<xsl:param name="importance" as="xs:double"/>
		<xsl:choose>
			<xsl:when test="$importance >= 6">
				<xsl:text>h1</xsl:text>
			</xsl:when>
			<xsl:when test="$importance = 5">
				<xsl:text>h2</xsl:text>
			</xsl:when>
			<xsl:when test="$importance = 4">
				<xsl:text>3</xsl:text>
			</xsl:when>
			<xsl:when test="$importance = 3">
				<xsl:text>h4</xsl:text>
			</xsl:when>
			<xsl:when test="$importance = 2">
				<xsl:text>h5</xsl:text>
			</xsl:when>
			<xsl:when test="$importance = 1">
				<xsl:text>h6</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>h2</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:function>
</xsl:stylesheet>