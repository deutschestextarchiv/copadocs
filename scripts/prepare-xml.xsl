<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:t="http://www.tei-c.org/ns/1.0"
  exclude-result-prefixes="t"
  xpath-default-namespace="http://www.tei-c.org/ns/1.0"
>

  <xsl:output method="xml" version="1.0" indent="no" encoding="UTF-8"/>

  <!-- <lb break="no"/>: concat word parts -->
  <xsl:template match="t:lb[@break='no']"/>

  <!-- <seg>: only its content -->
  <xsl:template match="t:seg">
    <xsl:copy-of select="node()"/>
  </xsl:template>

  <!-- <w>: one word -->
  <xsl:template match="t:w">
    <xsl:value-of select="translate( translate( translate(.,' ',''),'&#xd;','' ),'&#xa;','' )"/>
  </xsl:template>

  <!-- inject first facsimile image -->
  <xsl:template match="t:teiHeader">
    <xsl:copy>
      <xsl:apply-templates select="*|@*|text()|processing-instruction()|comment()"/>
      <firstImage xmlns="http://www.tei-c.org/ns/1.0">
        <xsl:value-of select="//t:facsimile[1]/@xml:base"/>
        <xsl:value-of select="//t:facsimile[1]/t:graphic/@url"/>
      </firstImage>
    </xsl:copy>
  </xsl:template>

  <!-- default: copy -->
  <xsl:template match="*|@*|text()|processing-instruction()|comment()" priority="-1">
    <xsl:copy>
      <xsl:apply-templates select="*|@*|text()|processing-instruction()|comment()"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
