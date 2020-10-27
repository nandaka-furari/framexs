<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet type="application/xml" href="framexs.xsl"?>
<!--
XSLTで実現するフレームワーク framexs
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xh="http://www.w3.org/1999/xhtml" xmlns:framexs="urn:framexs" version="1.0">

	<xsl:template match="xh:*" mode="search-id">
		<xsl:param name="id"/>
		<xsl:param name="self" select="false()"/>
		<xsl:choose>
			<xsl:when test="@id = $id">
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
					<xsl:with-param name="id" select="$id"/>
					<xsl:with-param name="self" select="$self"/>
				</xsl:apply-templates>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="xh:*[@framexs:id]">
		<xsl:message>xh:*[@framexs:id]</xsl:message>
		<xsl:apply-templates mode="search-id" select="$content/xh:html">
			<xsl:with-param name="id" select="@framexs:id"/>
			<xsl:with-param name="self" select="@framexs:self"/>
		</xsl:apply-templates>
	</xsl:template>
	<xsl:template match="xh:*[@framexs:id-d]">
		<xsl:message>id-d</xsl:message>
		<xsl:apply-templates mode="search-id" select="$content/xh:html">
			<xsl:with-param name="id" select="@framexs:id-d"/>
			<xsl:with-param name="self" select="false()"/>
		</xsl:apply-templates>
	</xsl:template>
	<xsl:template match="xh:*[@framexs:id-sd]">
		<xsl:apply-templates mode="search-id" select="$content/xh:html">
			<xsl:with-param name="id" select="@framexs:id-sd"/>
			<xsl:with-param name="self" select="true()"/>
		</xsl:apply-templates>
	</xsl:template>
	
	<xsl:template match="xh:*[@framexs:fetch]">
		<xsl:variable name="name" select="@framexs:fetch"/>
		<xsl:for-each select="$content/processing-instruction('framexs.fetch')">
			<xsl:if test="$name = substring-before(.,' ')">
				<xsl:choose>
					<xsl:when test="@framexs:self">
						<xsl:apply-templates mode="content" select="document(substring-after(.,' '), $content)/*"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates mode="content" select="document(substring-after(.,' '), $content)/*[1]/*"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:if>
		</xsl:for-each>
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

	<xsl:template match="framexs:element[@name]">
		<xsl:variable name="name" select="@name"></xsl:variable>
		<xsl:element name="{$name}">
			<xsl:for-each select="framexs:attribute">
				<xsl:attribute name="{name()}">
					<xsl:call-template name="concat"></xsl:call-template>
				</xsl:attribute>
			</xsl:for-each>
			<xsl:if test="framexs:attribute-set">
				<xsl:for-each select="@*">
					<xsl:attribute name="{name()}"></xsl:attribute>
				</xsl:for-each>
			</xsl:if>
		</xsl:element>
	</xsl:template>
	
	<!--framexs要素-->
	<xsl:template match="framexs:fetch[@src]">
		<xsl:variable name="name" select="@src"/>
		<xsl:for-each select="$content/processing-instruction('framexs.fetch')">
			<xsl:if test="$name = substring-before(.,' ')">
				<xsl:choose>
					<xsl:when test="@framexs:self">
						<xsl:apply-templates mode="content" select="document(substring-after(.,' '), $content)/*"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates mode="content" select="document(substring-after(.,' '), $content)/*[1]/*"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>
	<xsl:template match="xh:*" mode="id-exists">
		<xsl:param name="id"/>
		<xsl:choose>
			<xsl:when test="@id = $id"><xsl:value-of select="true()"/></xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="xh:*" mode="id-exists">
					<xsl:with-param name="id" select="$id"/>
				</xsl:apply-templates>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="is-exists">
		<xsl:param name="id"></xsl:param>
		<xsl:apply-templates select="$content" mode="id-exists">
			<xsl:with-param name="id" select="$id" />
		</xsl:apply-templates>
	</xsl:template>
	<xsl:template match="framexs:if[@id]">
		<xsl:variable name="id" select="@id"></xsl:variable>
		<xsl:variable name="exists">
			<xsl:call-template name="is-exists">
				<xsl:with-param name="id" select="$id"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:if test="$exists = 'true'">
			<xsl:apply-templates/>
		</xsl:if>
	</xsl:template>
	<xsl:template match="xh:*" mode="position-id">
		<xsl:param name="id"/>
		<xsl:param name="position"/>
		<xsl:choose>
			<xsl:when test="@id = $id">
				<xsl:for-each select="xh:*">
					<xsl:if test="position() = $position">
						<xsl:value-of select="text()"/>
					</xsl:if>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="xh:*" mode="position-id">
					<xsl:with-param name="id" select="$id"/>
					<xsl:with-param name="position" select="$position"/>
				</xsl:apply-templates>            
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="framexs:value[@id and @position]">
		<xsl:apply-templates select="$content/xh:html/xh:body/xh:*" mode="position-id">
			<xsl:with-param name="id" select="@id"/>
			<xsl:with-param name="position" select="@position"/>
		</xsl:apply-templates>
	</xsl:template>
	<!-- for loop -->
	<xsl:template match="*" mode="for-in">
		<xsl:param name="value"/>
		<xsl:choose>
			<xsl:when test="local-name() = 'framexs:value' and namespace-uri() = $fmxns">
				<xsl:value-of select="value"/>
			</xsl:when>
			<xsl:otherwise>
				
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="xh:*" mode="for-id">
		<xsl:param name="id"/>
		<xsl:choose>
			<xsl:when test="@id = $id">
				<xsl:for-each select="xh:*/xh:*">
					<xsl:apply-templates mode="for-in">
						<xsl:with-param name="value" select="text()"></xsl:with-param>
					</xsl:apply-templates>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="xh:*" mode="for-id">
					<xsl:with-param name="id" select="$id"/>
				</xsl:apply-templates>            
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="framexs:for[@id]">
		<xsl:param name="content" select="$content"/>
		<xsl:apply-templates mode="search-id" select="$content/xh:html/xh:body/xh:*">
			<xsl:with-param name="id" select="@id"/>
		</xsl:apply-templates>
	</xsl:template>
	<xsl:template match="framexs:*"></xsl:template>

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