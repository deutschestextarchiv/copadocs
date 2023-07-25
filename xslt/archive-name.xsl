<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.1">

<xsl:template name="archive-name">
  <xsl:param name="code"/>
  <xsl:choose>
    <xsl:when test="$code='dor'">
      <xsl:text>LWL-Archivamt für Westfalen, Münster (Best. 653: Dortmund-Aplerbeck)</xsl:text>
    </xsl:when>
    <xsl:when test="$code='gut'">
      <xsl:text>LWL-Archivamt für Westfalen, Münster (Best. 661: Gütersloh)</xsl:text>
    </xsl:when>
    <xsl:when test="$code='ham'">
      <xsl:text>Staatsarchiv Hamburg, Bestand Staatskrankenanstalt Langenhorn (352-8/7, Abl. 1995/2)</xsl:text>
    </xsl:when>
    <xsl:when test="$code='kfb'">
      <xsl:text>Archiv des Bezirkskrankenhauses Kaufbeuren</xsl:text>
    </xsl:when>
    <xsl:when test="$code='len'">
      <xsl:text>LWL-Archivamt für Westfalen, Münster (Best. 662: Lengerich-Bethesda)</xsl:text>
    </xsl:when>
    <xsl:when test="$code='lip'">
      <xsl:text>LWL-Archivamt für Westfalen, Münster (Best. 656: Lippstadt)</xsl:text>
    </xsl:when>
    <xsl:when test="$code='mrs'">
      <xsl:text>LWL-Archivamt für Westfalen, Münster (Best. 657: Marsberg)</xsl:text>
    </xsl:when>
    <xsl:when test="$code='mun'">
      <xsl:text>LWL-Archivamt für Westfalen, Münster (Best. 658: Münster)</xsl:text>
    </xsl:when>
    <xsl:when test="$code='war'">
      <xsl:text>LWL-Archivamt für Westfalen, Münster (Best. 660: Warstein)</xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$code"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>
