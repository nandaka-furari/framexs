<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet type="application/xml" href="framexs.xsl"?>
<!--
XSLTで実現するフレームワーク framexs
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:svg="http://www.w3.org/2000/svg" xmlns:framexs="urn:framexs" version="1.0">
	<xsl:output encoding="UTF-8" media-type="image" method="xml"/>

	<!-- skeleton_locが指定されればXHTMLテンプレート処理を行う -->
	<xsl:param name="skeleton_loc" select="/processing-instruction('framexs.skeleton')"/>
	<xsl:param name="properties_loc" select="/processing-instruction('framexs.properties')"/>
	
	<xsl:variable name="framexs.addpath" select="concat($skeleton_loc, '/../')"></xsl:variable>
	<xsl:variable name="root" select="/"/>
	<xsl:variable name="content" select="$root"/>
	<xsl:variable name="fmxns" select="'urn:framexs'"/>
	<xsl:variable name="empty" select="''"/>
	<xsl:variable name="version" select="'0.1'"/>
	
	<xsl:template match="/">
		<xsl:message>framexs <xsl:value-of select="$version"/></xsl:message>
		<xsl:variable name="svgns" select="'http://www.w3.org/2000/svg'"/>
		<!-- 基本的な処理分けを行う。XHTMLか一般XMLか -->
		<xsl:choose>                                      
			<xsl:when test="$skeleton_loc and namespace-uri(*[1]) = $svgns">
				<xsl:message>exec content</xsl:message>
				<xsl:variable name="properties" select="document($properties_loc)"/>
				<xsl:choose>
					<xsl:when test="$properties">
						<xsl:apply-templates select="document($skeleton_loc)/*">
							<xsl:with-param name="properties" select="document($properties_loc)"></xsl:with-param>
						</xsl:apply-templates>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="document($skeleton_loc)/*"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="namespace-uri(*[1]) = $svgns">
				<xsl:call-template name="print_svg">
					<xsl:with-param name="message" select="'skeleton_locを指定してください。'"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="print_svg">
					<xsl:with-param name="message" select="concat('コンテントはSVG名前空間(',$svgns,')を指定してください')"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="print_svg">
		<xsl:param name="message" select="'test'"/>
		<svg:svg>
			
		</svg:svg>
	</xsl:template>

	<!-- contentの処理 -->
	<xsl:template match="svg:*" mode="content">
		<xsl:element name="{name()}" namespace="http://www.w3.org/2000/svg">
			<xsl:apply-templates mode="content" select="@*"/>
			<xsl:apply-templates mode="content" select="node()"/>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="@* | node()" mode="content">
		<xsl:copy>
			<xsl:apply-templates select="@*" mode="content"/>
			<xsl:apply-templates mode="content"/>
		</xsl:copy>
	</xsl:template>
	<!-- その他の名前空間の処理 SVGなど -->
	<xsl:template match="*">
		<xsl:copy-of select="."/>
	</xsl:template>
    <!-- framexs属性系-->
	<xsl:template match="svg:*" mode="search-id">
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
				<xsl:apply-templates select="svg:*" mode="search-id">
					<xsl:with-param name="id" select="$id"/>
					<xsl:with-param name="self" select="$self"/>
				</xsl:apply-templates>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="svg:*[@framexs:id]">
		<xsl:message>svg:*[@framexs:id]</xsl:message>
		<xsl:apply-templates mode="search-id" select="$content/svg:svg">
			<xsl:with-param name="id" select="@framexs:id"/>
			<xsl:with-param name="self" select="@framexs:self"/>
		</xsl:apply-templates>
	</xsl:template>
	<xsl:template match="framexs:id">
		<xsl:apply-templates mode="search-id" select="$content/svg:svg">
			<xsl:with-param name="id" select="@target"/>
			<xsl:with-param name="self" select="@self"/>
		</xsl:apply-templates>
	</xsl:template>
	<xsl:template match="svg:*[@framexs:id-d]">
		<xsl:message>id-d</xsl:message>
		<xsl:apply-templates mode="search-id" select="$content/svg:svg">
			<xsl:with-param name="id" select="@framexs:id-d"/>
			<xsl:with-param name="self" select="false()"/>
		</xsl:apply-templates>
	</xsl:template>
	<xsl:template match="svg:*[@framexs:id-sd]">
		<xsl:apply-templates mode="search-id" select="$content/svg:svg">
			<xsl:with-param name="id" select="@framexs:id-sd"/>
			<xsl:with-param name="self" select="true()"/>
		</xsl:apply-templates>
	</xsl:template>
	
	<xsl:template match="svg:*[@framexs:fetch]">
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
	<xsl:template match="svg:*[@framexs:fetch-sd]">
		<xsl:variable name="name" select="@framexs:fetch-sd"/>
		<xsl:for-each select="$content/processing-instruction('framexs.fetch')">
			<xsl:if test="$name = substring-before(.,' ')">
				<xsl:apply-templates mode="content" select="document(substring-after(.,' '), $content)/*"/>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>
	<xsl:template match="svg:*[@framexs:fetch-d]">
		<xsl:variable name="name" select="@framexs:fetch-d"/>
		<xsl:for-each select="$content/processing-instruction('framexs.fetch')">
			<xsl:if test="$name = substring-before(.,' ')">
				<xsl:apply-templates mode="content" select="document(substring-after(.,' '), $content)/*[1]/*"/>
			</xsl:if>
		</xsl:for-each>
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
	<xsl:template match="framexs:property">
	
	</xsl:template>

	<xsl:template match="svg:*" mode="id-exists">
		<xsl:param name="id"/>
		<xsl:choose>
			<xsl:when test="@id = $id"><xsl:value-of select="true()"/></xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="svg:*" mode="id-exists">
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
	<xsl:template match="svg:*" mode="position-id">
		<xsl:param name="id"/>
		<xsl:param name="position"/>
		<xsl:choose>
			<xsl:when test="@id = $id">
				<xsl:for-each select="svg:*">
					<xsl:if test="position() = $position">
						<xsl:value-of select="text()"/>
					</xsl:if>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="svg:*" mode="position-id">
					<xsl:with-param name="id" select="$id"/>
					<xsl:with-param name="position" select="$position"/>
				</xsl:apply-templates>            
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="framexs:value[@id and @position]">
		<xsl:apply-templates select="$content/svg:svg/svg:*" mode="position-id">
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
	<xsl:template match="svg:*" mode="for-id">
		<xsl:param name="id"/>
		<xsl:choose>
			<xsl:when test="@id = $id">
				<xsl:for-each select="svg:*/svg:*">
					<xsl:apply-templates mode="for-in">
						<xsl:with-param name="value" select="text()"></xsl:with-param>
					</xsl:apply-templates>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="svg:*" mode="for-id">
					<xsl:with-param name="id" select="$id"/>
				</xsl:apply-templates>            
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="framexs:for[@id]">
		<xsl:param name="content" select="$content"/>
		<xsl:apply-templates mode="search-id" select="$content/svg:svg/svg:*">
			<xsl:with-param name="id" select="@id"/>
		</xsl:apply-templates>
	</xsl:template>
	<xsl:template match="framexs:*"></xsl:template>
	

	<!-- 何も出力しない -->
	<xsl:template match="svg:*[@framexs:print='no']"/>
	
	<xsl:template match="svg:*">
		<xsl:element name="{name()}" namespace="http://www.w3.org/2000/svg">
			<xsl:call-template name="replacepath">
				<xsl:with-param name="current" select="."/>
			</xsl:call-template>
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>
	<xsl:template match="svg:svg">
		<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
			<xsl:call-template name="replacepath">
				<xsl:with-param name="current" select="."/>
			</xsl:call-template>
			<xsl:apply-templates/>
		</svg>
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
							<xsl:value-of select="$framexs.addpath"/>
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