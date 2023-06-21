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

  <xsl:template name="data-attribute">
    <xsl:param name="name"/>
    <xsl:param name="value"/>
    <xsl:attribute name="data-{translate($name, ':', '-')}">
      <xsl:value-of select="$value"/>
    </xsl:attribute>
  </xsl:template>

</xsl:stylesheet>
