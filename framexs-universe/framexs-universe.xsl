<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet type="application/xml" href="framexs.xsl"?>
<!--
XSLTで実現するフレームワーク framexs
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xh="http://www.w3.org/1999/xhtml" xmlns:framexs="urn:framexs" version="1.0">
	<xsl:output encoding="UTF-8" media-type="text/html" method="html" doctype-system="about:legacy-compat"/>

	<!-- skeleton_locが指定されればXHTMLテンプレート処理を行う -->
	<xsl:param name="skeleton_loc" select="/processing-instruction('framexs.skeleton')"/>
	<xsl:param name="properties_loc" select="/processing-instruction('framexs.properties')"/>
	
	<xsl:variable name="root" select="/"></xsl:variable>
	<xsl:variable name="content" select="/*[1]"></xsl:variable>
	<xsl:variable name="xhns" select="'http://www.w3.org/1999/xhtml'"/>
	<xsl:variable name="fmxns" select="'urn:framexs'"/>
	<xsl:variable name="empty" select="''"/>
	<xsl:variable name="version" select="'0.1.1'"/>
	
	<xsl:template match="/">
		<xsl:choose>
			<xsl:when test="$skeleton_loc">
				<xsl:variable name="skeleton" select="document($skeleton_loc)"></xsl:variable>
				<xsl:variable name="target_namespace" select="$skeleton/processing-instruction('target')"></xsl:variable>
				<xsl:apply-templates select="$skeleton/*[1]">
					<xsl:with-param name="content_current" select="/*[1]"></xsl:with-param>
				</xsl:apply-templates>                                       
			</xsl:when>
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="xh:*">
		<xsl:param name="content_current"/>
		<xsl:element name="{local-name()}">
			<xsl:for-each select="@*">
				<xsl:copy/>
			</xsl:for-each>
			<xsl:apply-templates>
				<xsl:with-param name="content_current" select="$content_current"></xsl:with-param>
			</xsl:apply-templates>
		</xsl:element>
	</xsl:template>

	<xsl:template match="framexs:root">
		<xsl:apply-templates>
			<xsl:with-param name="content_current" select="$content"></xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>
	
	<xsl:template match="framexs:for-element[@name]">
		<xsl:param name="content_current"></xsl:param>
		<xsl:variable name="name" select="@name"></xsl:variable>
		<xsl:variable name="skeleton_current" select="."></xsl:variable>
		<xsl:for-each select="$content_current/*[local-name() = $name]">
			<xsl:apply-templates select="$skeleton_current/node()">
				<xsl:with-param name="content_current" select="."></xsl:with-param>
			</xsl:apply-templates>
		</xsl:for-each>
	</xsl:template>
	<xsl:template match="framexs:for-all-element">
		<xsl:param name="content_current"></xsl:param>
		<xsl:variable name="name" select="@name"></xsl:variable>
		<xsl:variable name="skeleton_current" select="."></xsl:variable>
		<xsl:for-each select="$content_current/*">
			<xsl:apply-templates select="$skeleton_current/node()">
				<xsl:with-param name="content_current" select="."></xsl:with-param>
			</xsl:apply-templates>
		</xsl:for-each>
	</xsl:template>
	<xsl:template match="framexs:for-id">    
		<xsl:variable name="id" select="@id"></xsl:variable>
	</xsl:template>
	<xsl:template match="framexs:element"></xsl:template>
	<xsl:template match="framexs:text">
		<xsl:param name="content_current"></xsl:param>
		<xsl:value-of select="$content_current/text()"></xsl:value-of>
	</xsl:template>
	<xsl:template match="framexs:value[@name]">
		<xsl:param name="content_current"/>
		<xsl:variable name="name" select="@name"></xsl:variable>
		<xsl:value-of select="$content_current/@*[name() = $name]"></xsl:value-of>
	</xsl:template>
	<xsl:template match="framexs:name">
		<xsl:value-of select="local-name()"></xsl:value-of>
	</xsl:template>
	<xsl:template match="framexs:*">
		test
	</xsl:template>
	<xsl:template match="framexs:title">
		<xsl:value-of select="$root/processing-instruction('framexs.title')"/>
	</xsl:template>
	<xsl:template match="framexs:namespace">
		<xsl:value-of select="namespace-uri($content)"></xsl:value-of>
	</xsl:template>
	<xsl:template match="framexs:apply[@src]">
		<xsl:apply-templates select="document(@src)/*[1]/*">
			<xsl:with-param name="content_current" select="$content"></xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>
	<!-- パスの解決アルゴリズム -->
	<xsl:template name="replacepath">
		<xsl:param name="current"/>
		<xsl:for-each select="$current/@*">
			<xsl:choose>
				<xsl:when test="name() = 'src' or name() = 'href' or name() = 'data'">
					<xsl:variable name="absolute">
						<xsl:call-template name="is-absolute">
							<xsl:with-param name="uri" select="."></xsl:with-param>
						</xsl:call-template>
					</xsl:variable>
					<xsl:attribute name="{name()}">
						<xsl:if test="not($absolute = 'true') and not(starts-with(., '#'))">
							<xsl:value-of select="'../'"/>
						</xsl:if>
						<xsl:value-of select="."/>
					</xsl:attribute>
				</xsl:when>
				<xsl:otherwise>
					<xsl:if test="namespace-uri() != 'urn:framexs'">
						<xsl:copy-of select="."/>
					</xsl:if>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
	</xsl:template>
	<!--文字列を受け取ってそれが絶対URIかを判定する-->	
	<xsl:template name="is-absolute">
		<xsl:param name="uri" />

		<xsl:variable name="uri-has-scheme">
			<xsl:call-template name="is-valid-scheme">
				<xsl:with-param name="scheme" select="substring-before($uri, ':')" />
			</xsl:call-template>
		</xsl:variable>

		<xsl:value-of select="starts-with($uri, '/') or ($uri-has-scheme = 'true')" />
	</xsl:template>

	<xsl:template name="is-valid-scheme">
		<xsl:param name="scheme" />

		<xsl:variable name="alpha">
			<xsl:text>ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:text>
			<xsl:text>abcdefghijklmnopqrstuvwxyz</xsl:text>
		</xsl:variable>
		<xsl:variable name="following-chars">
			<xsl:value-of select="$alpha" />
			<xsl:text>0123456789</xsl:text>
			<xsl:text>+-.</xsl:text>
		</xsl:variable>

		<xsl:value-of
			select="
				$scheme
				and not(translate(substring($scheme, 1, 1), $alpha, ''))
				and not(translate(substring($scheme, 2), $following-chars, ''))"
		 />
	</xsl:template>
</xsl:stylesheet>