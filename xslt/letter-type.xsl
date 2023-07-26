<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.1">

<xsl:template name="letter-type">
  <xsl:param name="filename"/>
  <xsl:choose>
    <xsl:when test="contains($filename, '_pp_') or contains($filename, '_pp-')">
      <xsl:text>pp</xsl:text>
    </xsl:when>
    <xsl:when test="contains($filename, '_po_') or contains($filename, '_po-')">
      <xsl:text>po</xsl:text>
    </xsl:when>
    <xsl:when test="contains($filename, '_ap_') or contains($filename, '_ap-')">
      <xsl:text>ap</xsl:text>
    </xsl:when>
    <xsl:when test="contains($filename, '_ao_') or contains($filename, '_ao-')">
      <xsl:text>ao</xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:text>so</xsl:text>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="letter-subtype">
  <xsl:param name="filename"/>
  <xsl:choose>
    <xsl:when test="contains($filename, '_pp-')">
      <xsl:value-of select="substring-before( substring-after($filename, '_pp-'), '_' )"/>
    </xsl:when>
    <xsl:when test="contains($filename, '_po-')">
      <xsl:value-of select="substring-before( substring-after($filename, '_po-'), '_' )"/>
    </xsl:when>
    <xsl:when test="contains($filename, '_ap-')">
      <xsl:value-of select="substring-before( substring-after($filename, '_ap-'), '_' )"/>
    </xsl:when>
    <xsl:when test="contains($filename, '_ao-')">
      <xsl:value-of select="substring-before( substring-after($filename, '_ao-'), '_' )"/>
    </xsl:when>
    <xsl:when test="contains($filename, '_so-')">
      <xsl:value-of select="substring-before( substring-after($filename, '_so-'), '_' )"/>
    </xsl:when>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>
