<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.1"
                xmlns:t="http://www.tei-c.org/ns/1.0"
                exclude-result-prefixes="t"
                xpath-default-namespace="http://www.tei-c.org/ns/1.0">

  <xsl:import href="letter-type.xsl"/>

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

    <!-- id -->
    <xsl:value-of select="/t:TEI/@xml:id"/>
    <xsl:text>&#x9;</xsl:text>

    <!-- patient -->
    <xsl:value-of select="normalize-space(/t:TEI/t:teiHeader/t:profileDesc/t:particDesc/t:person[1]/t:persName)"/>
    <xsl:text>&#x9;</xsl:text>

    <!-- birth date -->
    <xsl:value-of select="normalize-space(/t:TEI/t:teiHeader/t:profileDesc/t:particDesc/t:person[1]/t:birth/@when)"/>
    <xsl:text>&#x9;</xsl:text>

    <!-- entry date -->
    <!--<xsl:value-of select="normalize-space(/t:TEI/t:teiHeader/t:profileDesc/t:particDesc/t:person[1]/t:state/t:p[starts-with(., 'Anstalt: ')]/date/@from)"/>
    <xsl:text>&#x9;</xsl:text>-->

    <xsl:variable name="entry-date">
      <xsl:call-template name="reformat-date">
        <xsl:with-param name="date">
          <xsl:value-of select="normalize-space(
                                  substring-before(
                                    substring-after(
                                      /t:TEI/t:teiHeader/t:profileDesc/t:particDesc/t:person[1]/t:state/t:p[starts-with(., 'Anstalt: ')],
                                      'Anstalt: '
                                    ),
                                    '-'
                                  )
                                )"/>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="$entry-date"/>
    <xsl:text>&#x9;</xsl:text>

    <!-- leave date -->
    <!--<xsl:value-of select="normalize-space(/t:TEI/t:teiHeader/t:profileDesc/t:particDesc/t:person[1]/t:state/t:p[starts-with(., 'Anstalt: ')]/date/@to)"/>
    <xsl:text>&#x9;</xsl:text>-->
    <xsl:call-template name="reformat-date">
      <xsl:with-param name="date">
        <xsl:value-of select="normalize-space(
                                substring-after(
                                  substring-after(
                                    /t:TEI/t:teiHeader/t:profileDesc/t:particDesc/t:person[1]/t:state/t:p[starts-with(., 'Anstalt: ')],
                                    'Anstalt: '
                                  ),
                                  '-'
                                )
                              )"/>
      </xsl:with-param>
      <xsl:with-param name="start" select="$entry-date"/>
    </xsl:call-template>
    <xsl:text>&#x9;</xsl:text>

    <!-- death date -->
    <xsl:choose>
      <xsl:when test="/t:TEI/t:teiHeader/t:profileDesc/t:particDesc/t:person[1]/t:death/@cert='unknown'">
        <xsl:text>-</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="normalize-space(/t:TEI/t:teiHeader/t:profileDesc/t:particDesc/t:person[1]/t:death/@when)"/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text>&#x9;</xsl:text>

    <!-- occupation -->
    <xsl:value-of select="normalize-space(/t:TEI/t:teiHeader/t:profileDesc/t:particDesc/t:person[1]/t:occupation)"/>
    <xsl:text>&#x9;</xsl:text>

    <!-- residence -->
    <xsl:value-of select="normalize-space(/t:TEI/t:teiHeader/t:profileDesc/t:particDesc/t:person[1]/t:residence/text())"/>
    <xsl:text>&#x9;</xsl:text>

    <!-- family status -->
    <xsl:value-of select="normalize-space(
                            substring-after(
                              /t:TEI/t:teiHeader/t:profileDesc/t:particDesc/t:person[1]/t:state/t:p[starts-with(., 'Familienstand: ')],
                              'Familienstand: '
                            )
                          )"/>
    <xsl:text>&#x9;</xsl:text>

    <!-- faith -->
    <xsl:value-of select="normalize-space(/t:TEI/t:teiHeader/t:profileDesc/t:particDesc/t:person[1]/t:faith)"/>
    <xsl:text>&#x9;</xsl:text>

    <!-- text type -->
    <xsl:call-template name="letter-type">
      <xsl:with-param name="filename" select="$filename"/>
    </xsl:call-template>
    <xsl:text>&#x9;</xsl:text>

    <!-- sender -->
    <xsl:choose>
      <xsl:when test="string-length(/t:TEI/t:teiHeader/t:profileDesc/t:creation/t:persName[@type='sender'])">
        <xsl:value-of select="normalize-space(/t:TEI/t:teiHeader/t:profileDesc/t:creation/t:persName[@type='sender'])"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>[no name given]</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text>&#x9;</xsl:text>

    <!-- date sent -->
    <xsl:call-template name="reformat-date">
      <xsl:with-param name="date">
        <xsl:value-of select="normalize-space(/t:TEI/t:teiHeader/t:profileDesc/t:creation/t:date[@type='sent'])"/>
      </xsl:with-param>
    </xsl:call-template>
    <xsl:text>&#x9;</xsl:text>

    <!-- place sent -->
    <xsl:value-of select="normalize-space(/t:TEI/t:teiHeader/t:profileDesc/t:creation/t:settlement[@type='sent'])"/>
    <xsl:text>&#x9;</xsl:text>

    <!-- extent: pages -->
    <xsl:value-of select="count(//t:pb)"/>
    <xsl:text>&#x9;</xsl:text>

    <!-- extent: words
      via https://stackoverflow.com/questions/6188189/count-the-number-of-words-in-a-xml-node-using-xsl#answer-6196072 -->
    <xsl:value-of select="string-length(normalize-space(/t:TEI/t:text))
                          -
                          string-length(translate(normalize-space(/t:TEI/t:text),' ','')) +1"/>

    <xsl:if test="1=0">
      <xsl:text>&#x9;</xsl:text>
      <!-- addressee -->
      <xsl:choose>
        <xsl:when test="string-length(/t:TEI/t:teiHeader/t:profileDesc/t:creation/t:persName[@type='addressee'])">
          <xsl:value-of select="normalize-space(/t:TEI/t:teiHeader/t:profileDesc/t:creation/t:persName[@type='addressee'])"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>[no name given]</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:text>&#x9;</xsl:text>

      <!-- date received -->
      <xsl:value-of select="normalize-space(/t:TEI/t:teiHeader/t:profileDesc/t:creation/t:date[@type='received'])"/>
      <xsl:text>&#x9;</xsl:text>

      <!-- letter types -->
      <xsl:value-of select="normalize-space(
                              substring-after(
                                /t:TEI/t:teiHeader/t:profileDesc/t:particDesc/t:person[1]/t:state/t:p[starts-with(., 'Brieftypen: ')],
                                'Brieftypen: '
                              )
                            )"/>
      <xsl:text>&#x9;</xsl:text>
    </xsl:if>

    <!-- line break -->
    <xsl:text>&#x0a;</xsl:text>
  </xsl:template>

  <!--
    reformates a from various formats into YYYY(-MM-DD) form
  -->
  <xsl:template name="reformat-date">
    <xsl:param name="date"/>
    <xsl:param name="start"/>
    <xsl:choose>
      <!-- empty date -->
      <xsl:when test="string-length($date)=0"/>
      <!-- YY -->
      <xsl:when test="string-length($date)=2">
        <xsl:value-of select="substring($start, 1, 2)"/>
        <xsl:value-of select="$date"/>
      </xsl:when>
      <!-- YYYY -->
      <xsl:when test="string-length($date)=4">
        <xsl:value-of select="$date"/>
      </xsl:when>
      <!-- YYYY-MM -->
      <xsl:when test="string-length($date)=7 and substring($date,3,1)='.'">
        <xsl:value-of select="substring-after($date, '.')"/>
        <xsl:text>-</xsl:text>
        <xsl:value-of select="substring-before($date, '.')"/>
      </xsl:when>
      <!-- DD.MM.YYYY -->
      <xsl:when test="string-length($date)=10 and substring($date,3,1)='.'">
        <xsl:value-of select="substring-after(
                                substring-after($date,'.'),
                                '.'
                              )"/>
        <xsl:text>-</xsl:text>
        <xsl:value-of select="substring-before(
                                substring-after($date,'.'),
                                '.'
                              )"/>
        <xsl:text>-</xsl:text>
        <xsl:value-of select="substring-before($date,'.')"/>
      </xsl:when>
      <!-- D.M.YYYY -->
      <xsl:when test="string-length($date)=8 and substring($date,2,1)='.' and substring($date,4,1)='.'">
        <xsl:value-of select="substring-after(
                                substring-after($date,'.'),
                                '.'
                              )"/>
        <xsl:text>-0</xsl:text>
        <xsl:value-of select="substring-before(
                                substring-after($date,'.'),
                                '.'
                              )"/>
        <xsl:text>-0</xsl:text>
        <xsl:value-of select="substring-before($date,'.')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$date"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
