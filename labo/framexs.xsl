<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet type="application/xml" href="framexs.xsl"?>
<!--
XSLTで実現するフレームワーク framexs
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xh="http://www.w3.org/1999/xhtml" xmlns:framexs="urn:framexs" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:skos="http://www.w3.org/2004/02/skos/core#" version="1.0">
	<xsl:output encoding="UTF-8" media-type="text/html" method="html" doctype-system="about:legacy-compat"/>

	<!-- skeleton_locが指定されればXHTMLテンプレート処理を行う -->
	<xsl:param name="skeleton_loc" select="/processing-instruction('framexs.skeleton')"/>
	<xsl:param name="framexs.base" select="/processing-instruction('framexs.base')"/>
	<xsl:param name="framexs.addpath" select="/processing-instruction('framexs.addpath')"/>
	
	<xsl:variable name="root" select="/"/>
	<xsl:variable name="content" select="$root"/>
	<xsl:variable name="xhns" select="'http://www.w3.org/1999/xhtml'"/>
	<xsl:variable name="fmxns" select="'urn:framexs'"/>
	<xsl:variable name="empty" select="''"/>
	<xsl:variable name="version" select="'1.3.3'"/>
	<xsl:include href="plugin.xsl"/>
	<xsl:template match="/">
		<xsl:message>framexs <xsl:value-of select="$version"/>
		</xsl:message>
		<!-- 基本的な処理分けを行う。XHTMLか一般XMLか -->
		<xsl:choose>
			<xsl:when test="$skeleton_loc and namespace-uri(*[1]) = $xhns">
				<xsl:message>content</xsl:message>
				<xsl:apply-templates select="document($skeleton_loc)/*"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:message>一般XML</xsl:message>
				<html>
					<head>
						<title>エラー</title>
					</head>
					<body>
						<p>framexsバージョン:<xsl:value-of select="$version"/>
						</p>
						<p>テンプレートは名前空間(<xsl:value-of select="$xhns"/>)を持ったXHTMLを指定してください</p>
					</body>
				</html>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--  -->
	<xsl:template match="@* | node()" mode="content">
		<xsl:copy>
			<xsl:apply-templates select="@*" mode="content"/>
			<xsl:apply-templates mode="content"/>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="xh:*" mode="search-id">
		<xsl:param name="targetid"/>
		<xsl:param name="self" select="false()"/>
		<xsl:choose>
			<xsl:when test="@id = $targetid">
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
				<xsl:apply-templates select="xh:*" mode="search-id">
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
		<xsl:apply-templates mode="search-id" select="$content/xh:html">
			<xsl:with-param name="targetid" select="$id"/>
			<xsl:with-param name="self" select="$range = 'sd'"/>
		</xsl:apply-templates>
		<xsl:for-each select="$content/processing-instruction('framexs.id')">
			<xsl:variable name="name" select="substring-before(.,' ')"/>
			<xsl:if test="$id = $name">
				<xsl:apply-templates mode="search-id" select="document(substring-after(.,' '),$content)/xh:*">
					<xsl:with-param name="targetid" select="$id"/>
					<xsl:with-param name="self" select="$range = 'sd'"/>
				</xsl:apply-templates>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>
	<xsl:template match="xh:*[@framexs:id-d]">
		<xsl:param name="content" select="$content"/>
		<xsl:message>id-d</xsl:message>
		<xsl:call-template name="attr_id">
			<xsl:with-param name="content" select="$content"/>
			<xsl:with-param name="id" select="@framexs:id-d"/>
			<xsl:with-param name="range" select="'d'"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="xh:*[@framexs:id-sd]">
		<xsl:param name="content" select="$content"/>
		<xsl:call-template name="attr_id">
			<xsl:with-param name="content" select="$content"/>
			<xsl:with-param name="id" select="@framexs:id-sd"/>
			<xsl:with-param name="range" select="'sd'"/>
		</xsl:call-template>
	</xsl:template>
	
	<xsl:template match="xh:*[@framexs:ifexist]">
		<xsl:variable name="ifexist" select="@framexs:ifexist"/>
		<xsl:apply-templates></xsl:apply-templates>
	</xsl:template>
    
	<!-- framexs:element-dまたはframexs:element-sdを処理するxsl:templateから呼び出される -->
	<xsl:template name="element">
		<xsl:param name="self" select="false()"/>
		<xsl:param name="element"/>
		<xsl:for-each select="$content/xh:html/xh:body/xh:*">
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
		<xsl:for-each select="$content/processing-instruction('framexs.element')">
			<xsl:variable name="name" select="substring-before(., ' ')"/>
			<xsl:if test="$element = $name">
				<xsl:for-each select="document(substring-after(.,' '),$content)/xh:html/xh:body/xh:*">
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
	
	<xsl:template match="xh:*[@framexs:element-sd]">
		<xsl:call-template name="element">
			<xsl:with-param name="element" select="@framexs:element-sd"/>
			<xsl:with-param name="self" select="true()"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="xh:*[@framexs:element-d]">
		<xsl:call-template name="element">
			<xsl:with-param name="element" select="@framexs:element-d"/>
			<xsl:with-param name="self" select="false()"/>
		</xsl:call-template>
	</xsl:template>
	
	<xsl:template match="xh:*[@framexs:fetch-sd]">
		<xsl:variable name="name" select="@framexs:fetch-sd"/>
		<xsl:for-each select="$content/processing-instruction('framexs.fetch')">
			<xsl:if test="$name = substring-before(.,' ')">
				<xsl:apply-templates mode="content" select="document(substring-after(.,' '), $content)/*"/>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>
	<xsl:template match="xh:*[@framexs:fetch-d]">
		<xsl:variable name="name" select="@framexs:fetch-d"/>
		<xsl:for-each select="$content/processing-instruction('framexs.fetch')">
			<xsl:if test="$name = substring-before(.,' ')">
				<xsl:apply-templates mode="content" select="document(substring-after(.,' '), $content)/*[1]/*"/>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>
	<xsl:template match="xh:*[@framexs:copy]">
		<xsl:variable name="name" select="@framexs:copy"/>
		<xsl:for-each select="$content/processing-instruction('framexs.copy')">
			<xsl:if test="$name = substring-before(.,' ')">
				<xsl:apply-templates mode="content" select="document(substring-after(.,' '), $content)/*"/>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>
	
	<!--  -->
	
	<xsl:template match="id('profile')">
		<xsl:apply-templates></xsl:apply-templates>
	</xsl:template>
	
	<xsl:template match="*">
		<xsl:copy-of select="."/>
	</xsl:template>
	
	<xsl:template match="xh:*[@framexs:title]">
		<xsl:value-of select="$content/xh:html/xh:head/xh:title"/>
	</xsl:template>
	
	<xsl:template match="xh:*[@framexs:meta-name]">
		<xsl:variable name="name" select="@framexs:meta-name"/>
		<xsl:for-each select="$content/xh:html/xh:head/xh:meta">
			<xsl:if test="@name = $name">
				<xsl:value-of select="@content"/>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>
	
	<xsl:template match="xh:*[@framexs:meta-property]">
		<xsl:variable name="property" select="@framexs:meta-property"/>
		<xsl:for-each select="$content/xh:html/xh:head/xh:meta">
			<xsl:if test="@property = $property">
				<xsl:value-of select="@content"/>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>	
	
	<!-- コンテンツにframexs.baseがあるならbaseのhrefを上書きする -->
	<xsl:template match="xh:base[@framexs:base='on']">
		<xsl:element name="base">
			<xsl:for-each select="@*">
				<xsl:copy-of select="."/>
				<xsl:if test="name() = 'href' and $framexs.base">
					<xsl:attribute name="href">
						<xsl:value-of select="$framexs.base"/>
					</xsl:attribute>
				</xsl:if>
			</xsl:for-each>
		</xsl:element>
	</xsl:template>
	<!-- 何も出力しない -->
	<xsl:template match="xh:*[@framexs:print='no']"/>
	<xsl:template match="xh:*[@framexs:noprint]"/>
	
	<xsl:template match="xh:title">
		<xsl:element name="title">
			<xsl:value-of select="concat($content/xh:html/xh:head/xh:title/text(),.)"/>
		</xsl:element>
	</xsl:template>
	
	<!-- meta要素は特別な扱いをする -->
	<xsl:template name="metatemplate">
		<xsl:param name="target"/>
		<xsl:param name="base"/>
		<xsl:element name="meta">
			<xsl:for-each select="@*">
				<xsl:choose>
					<xsl:when test="name() = 'content'">
						<xsl:attribute name="{name()}">
							<xsl:value-of select="$target/@content"/>
							<xsl:value-of select="$base/@content"/>
						</xsl:attribute>
					</xsl:when>
					<xsl:otherwise>
						<xsl:attribute name="{name()}">
							<xsl:value-of select="."/>
						</xsl:attribute>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="xh:meta[@framexs:fix]">
		<xsl:element name="{name()}">
			<xsl:for-each select="@*[not(namespace-uri(.) = $fmxns)]">
				<xsl:attribute name="{name()}">
					<xsl:value-of select="."/>
				</xsl:attribute>
			</xsl:for-each>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="xh:meta[@name and not(@framexs:fix)]">
		<xsl:variable name="template" select="."></xsl:variable>
		<xsl:for-each select="$content/xh:html/xh:head/xh:meta[@name]">
			<xsl:variable name="target" select="."></xsl:variable>
			<xsl:if test="$template/@name=$target/@name">
				<xsl:call-template name="metatemplate">
					<xsl:with-param name="base" select="$template"/>
					<xsl:with-param name="target" select="$target"/>
				</xsl:call-template>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>
	
	<xsl:template match="xh:meta[@property and not(@framexs:fix)]">
		<xsl:variable name="base" select="."></xsl:variable>
		<xsl:for-each select="$content/xh:html/xh:head/xh:meta[@property]">
			<xsl:variable name="target" select="."></xsl:variable>
			<xsl:if test="$base/@property=$target/@property">
				<xsl:call-template name="metatemplate">
					<xsl:with-param name="base" select="$base"/>
					<xsl:with-param name="target" select="$target"/>
				</xsl:call-template>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>
	
	<xsl:template match="xh:*[@framexs:load]">
		<xsl:for-each select="$content/xh:html/xh:head/xh:*">
			<xsl:if test="name() = @framexs:load">
				<xsl:copy-of select="."/>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>
	
	<xsl:template name="addpath">
		<xsl:param name="attr"></xsl:param>
		<xsl:param name="addpath"></xsl:param>
	</xsl:template>
	
	<xsl:template match="xh:*">
		<!-- addpathがonならパスの処理を行う -->
		<xsl:variable name="addpath" select="@framexs:addpath"></xsl:variable>
		<xsl:element name="{name()}">
			<xsl:for-each select="@*">
				<xsl:choose>
					<xsl:when test="name() = 'src' or name() = 'href' or name() = 'data'">
						<xsl:choose>
							<xsl:when test="$addpath = 'on'">
								<xsl:attribute name="{name()}">
									<xsl:value-of select="$framexs.addpath"/>
									<xsl:value-of select="."/>
								</xsl:attribute>
							</xsl:when>
							<xsl:when test="$addpath">
								<xsl:attribute name="{name()}">
									<xsl:value-of select="$framexs.addpath"/>
									<xsl:value-of select="."/>
								</xsl:attribute>
							</xsl:when>
							<xsl:otherwise>
								<xsl:attribute name="{name()}">
									<xsl:value-of select="."/>
								</xsl:attribute>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise>
						<xsl:if test="namespace-uri() != 'urn:framexs'">
							<xsl:copy-of select="."/>
						</xsl:if>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>

</xsl:stylesheet>