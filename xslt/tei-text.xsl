<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.1"
                xmlns:t="http://www.tei-c.org/ns/1.0"
                exclude-result-prefixes="t"
                xpath-default-namespace="http://www.tei-c.org/ns/1.0">

  <xsl:output method="html"/>

  <!-- ignore non-<text> elements -->
  <xsl:template match="/t:TEI/t:teiHeader"/>
  <xsl:template match="/t:TEI/t:facsimile"/>

  <!-- <text> wrapper -->
  <xsl:template match="/t:TEI/t:text">
    <div class="tei-text">
      <xsl:apply-templates/>
    </div>
  </xsl:template>

  <!-- TEI text elements -->
  <xsl:template match="/t:TEI/t:text//t:*">
    <span class="tei-{local-name(.)}">
      <xsl:call-template name="set-data-attributes"/>
      <xsl:apply-templates/>
    </span>
  </xsl:template>

  <!-- data attributes -->
  <xsl:template name="set-data-attributes">
    <xsl:for-each select="@*">
      <xsl:call-template name="data-attribute">
        <xsl:with-param name="name" select="name(current())"/>
        <xsl:with-param name="value" select="current()"/>
      </xsl:call-template>
    </xsl:for-each>
  </xsl:template>

  <!-- pb/@facs -->
  <xsl:template match="t:pb" priority="10">
    <span class="tei-{local-name(.)}">
      <xsl:call-template name="set-data-attributes"/>
      <xsl:attribute name="data-n">
        <xsl:value-of select="count(preceding::t:pb) + 1"/>
      </xsl:attribute>
      <xsl:variable name="id">
        <xsl:value-of select="substring-after(@facs, '#')"/>
      </xsl:variable>
      <xsl:if test="/t:TEI/t:facsimile/t:graphic[@xml:id=$id]">
        <xsl:attribute name="data-facsimile">
          <xsl:value-of select="/t:TEI/t:facsimile/@xml:base"/>
          <xsl:value-of select="/t:TEI/t:facsimile/t:graphic[@xml:id=$id]/@url"/>
        </xsl:attribute>
      </xsl:if>
    </span>
  </xsl:template>

  <xsl:template name="data-attribute">
    <xsl:param name="name"/>
    <xsl:param name="value"/>
    <xsl:attribute name="data-{translate($name, ':', '-')}">
      <xsl:value-of select="$value"/>
    </xsl:attribute>
  </xsl:template>

  <!--
    Line breaks: <lb/>

    @break="no"  → hyphenation across lines
    @break="yes" → separate words across lines
  -->
  <xsl:template match="t:lb[@break='no']" priority="100">
    <span class="tei-supplied">-</span>
    <span class="tei-lb">
      <xsl:call-template name="set-data-attributes"/>
      <xsl:apply-templates/>
    </span>
  </xsl:template>

</xsl:stylesheet>
