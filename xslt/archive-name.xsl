<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.1">

<xsl:template name="archive-name">
  <xsl:param name="code"/>
  <xsl:choose>
    <xsl:when test="$code='kfb'">
      <xsl:text>Archiv des Bezirkskrankenhauses Kaufbeuren</xsl:text>
    </xsl:when>
    <xsl:when test="$code='war' or $code='mun' or $code='len'">
      <xsl:text>LWL-Archivamt für Westfalen, Münster (Best. 656)</xsl:text>
    </xsl:when>
    <xsl:when test="$code='ham'">
      <xsl:text>Staatsarchiv Hamburg, Bestand Staatskrankenanstalt Langenhorn (352-8/7, Abl. 1995/2)</xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$code"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>
