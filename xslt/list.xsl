<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.1"
                xmlns:t="http://www.tei-c.org/ns/1.0"
                exclude-result-prefixes="t"
                xpath-default-namespace="http://www.tei-c.org/ns/1.0">

  <xsl:output method="text" indent="no" encoding="utf-8"/>

  <xsl:param name="dirname"/>
  <xsl:param name="filename"/>

  <xsl:template match="/">
    <!-- directory -->
    <xsl:value-of select="$dirname"/>
    <xsl:text>&#x9;</xsl:text>

    <!-- filename -->
    <xsl:value-of select="$filename"/>
    <xsl:text>&#x9;</xsl:text>
    
    <!-- sender -->
    <xsl:choose>
      <xsl:when test="string-length(//t:creation/t:persName[@type='sender'])">
        <xsl:value-of select="normalize-space(//t:creation/t:persName[@type='sender'])"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>[no name given]</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text>&#x9;</xsl:text>
    
    <!-- date sent -->
    <xsl:value-of select="normalize-space(//t:creation/t:date[@type='sent'])"/>
    <xsl:text>&#x9;</xsl:text>
    
    <!-- addressee -->
    <xsl:choose>
      <xsl:when test="string-length(//t:creation/t:persName[@type='addressee'])">
        <xsl:value-of select="normalize-space(//t:creation/t:persName[@type='addressee'])"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>[no name given]</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text>&#x9;</xsl:text>

    <!-- date received -->
    <xsl:value-of select="normalize-space(//t:creation/t:date[@type='received'])"/>
    <xsl:text>&#x9;</xsl:text>
    
    <!-- birth date -->
    <xsl:value-of select="normalize-space(//t:particDesc/t:person[1]/t:birth/@when)"/>
    <xsl:text>&#x9;</xsl:text>

    <!-- death date -->
    <xsl:value-of select="normalize-space(//t:particDesc/t:person[1]/t:death/@when)"/>
    <xsl:text>&#x9;</xsl:text>

    <!-- entry date -->
    <xsl:value-of select="normalize-space(
                            substring-before(
                              substring-after(
                                //t:particDesc/t:person[1]/t:state/t:p[starts-with(., 'Anstalt: ')],
                                'Anstalt: '
                              ),
                              '-'
                            )
                          )"/>
    <xsl:text>&#x9;</xsl:text>

    <!-- leave date -->
    <xsl:value-of select="normalize-space(
                            substring-after(
                              substring-after(
                                //t:particDesc/t:person[1]/t:state/t:p[starts-with(., 'Anstalt: ')],
                                'Anstalt: '
                              ),
                              '-'
                            )
                          )"/>
    <xsl:text>&#x9;</xsl:text>

    <!-- letter types -->
    <xsl:value-of select="normalize-space(
                            substring-after(
                              //t:particDesc/t:person[1]/t:state/t:p[starts-with(., 'Brieftypen: ')],
                              'Brieftypen: '
                            )
                          )"/>
    <xsl:text>&#x9;</xsl:text>

    <!-- occupation -->
    <xsl:value-of select="normalize-space(//t:particDesc/t:person[1]/t:occupation)"/>
    <xsl:text>&#x9;</xsl:text>

    <!-- settlement -->
    <xsl:value-of select="normalize-space(//t:creation/t:settlement[@type='sent'])"/>
    <xsl:text>&#x9;</xsl:text>

    <!-- faith -->
    <xsl:value-of select="normalize-space(//t:particDesc/t:person[1]/t:faith)"/>
    <xsl:text>&#x9;</xsl:text>

    <!-- family status -->
    <xsl:value-of select="normalize-space(
                            substring-after(
                              //t:particDesc/t:person[1]/t:state/t:p[starts-with(., 'Familienstand: ')],
                              'Familienstand: '
                            )
                          )"/>
    <xsl:text>&#x9;</xsl:text>

    <!-- line break -->
    <xsl:text>&#x0a;</xsl:text>
  </xsl:template>

</xsl:stylesheet>
