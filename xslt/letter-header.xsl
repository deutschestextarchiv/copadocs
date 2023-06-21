<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.1"
                xmlns:t="http://www.tei-c.org/ns/1.0"
                exclude-result-prefixes="t"
                xpath-default-namespace="http://www.tei-c.org/ns/1.0">

  <xsl:output method="html"/>

  <xsl:template match="t:person">
    <xsl:for-each select="t:persName">
      <xsl:for-each select="t:roleName">
        <xsl:apply-templates select="current()"/>
        <xsl:text> </xsl:text>
      </xsl:for-each>
      <xsl:for-each select="t:forename">
        <xsl:apply-templates select="current()"/>
        <xsl:text> </xsl:text>
      </xsl:for-each>
      <xsl:for-each select="t:surname">
        <xsl:apply-templates select="current()"/>
        <xsl:text> </xsl:text>
      </xsl:for-each>
    </xsl:for-each>
    <xsl:if test="t:note[@type='pnd']">
      <xsl:text> [</xsl:text>
      <xsl:for-each select="t:note[@type='pnd']">
        <a href="https://d-nb.info/gnd/{text()}">GND</a>
        <xsl:if test="position() != last()">
          <xsl:text>, </xsl:text>
        </xsl:if>
      </xsl:for-each>
      <xsl:text>]</xsl:text>
    </xsl:if>
  </xsl:template>

  <xsl:template match="t:teiHeader">
    <div class="tei-header">
      <table>
        <tr>
          <td>Titel:</td>
          <td>
            <!-- TODO -->
          </td>
        </tr>
        <tr>
          <td>Autor:</td>
          <td>
            <!-- TODO -->
          </td>
        </tr>
        <tr>
          <td>Download:</td>
          <td>
            <!-- TODO -->
          </td>
        </tr>
      </table>
    </div>
  </xsl:template>
</xsl:stylesheet>
