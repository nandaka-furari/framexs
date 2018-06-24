<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet type="application/xml" href="framexs.xsl"?>
<!--
XSLTで実現するフレームワーク framexs
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xh="http://www.w3.org/1999/xhtml" xmlns:framexs="urn:framexs" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:skos="http://www.w3.org/2004/02/skos/core#" version="1.0">
	
	<!-- skos plugin -->
	<xsl:key name="abbr-key" match="rdf:RDF/skos:Concept" use="skos:altLabel"/>
	<xsl:template match="xh:abbr">
		<xsl:choose>
			<xsl:when test="xh:abbr">
				<!-- title要素がある場合はそのまま出力 -->
				<xsl:copy>
					<xsl:apply-templates select="node()|@*"/>
				</xsl:copy>
			</xsl:when>
			<xsl:otherwise>
				<!-- 用語集から略語の正式名を取得して出力 -->
				<xsl:apply-templates select="document(document($skeleton_loc)/processing-instruction('framexs.plugin.skos'))/rdf:RDF/skos:Concept[skos:altLabel = current()]">
					<xsl:with-param name="abbr" select="self::node()"/>
				</xsl:apply-templates>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="rdf:RDF/skos:Concept">
		<xsl:param name="abbr"/>
		<xsl:element name="abbr">
			<xsl:attribute name="title"><xsl:value-of select="key('abbr-key', $abbr)/skos:prefLabel"/></xsl:attribute>
			<xsl:value-of select="key('abbr-key', $abbr)/skos:altLabel"/>
		</xsl:element>
	</xsl:template>

	<!--  -->
	<xsl:template match="xh:*" mode="content">
		<xsl:choose>
			<xsl:when test="boolean(document($skeleton_loc)/processing-instruction('framexs.plugin.skos')) and name() = 'abbr'">
				<xsl:apply-templates select="."/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:element name="{name()}">
					<xsl:apply-templates mode="content" select="@*"/>
					<xsl:apply-templates mode="content" select="node()"/>
				</xsl:element>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>