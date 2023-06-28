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

  <!--
    Text nodes.
    Thanks to https://stackoverflow.com/users/423105/larsh
  -->
  <xsl:template match="text()[
          (preceding::node()[
              self::text()[normalize-space() != ''] or
              self::t:lb])
                  [last()]
          [self::t:lb[@break='no']]
          ]">
    <!-- Trim whitespace on the left. Thanks to Alejandro,
      http://stackoverflow.com/a/3997107/423105 -->
    <xsl:variable name="firstNonSpace" select="substring(normalize-space(), 1, 1)"/>
    <xsl:value-of select="concat($firstNonSpace, substring-after(., $firstNonSpace))"/>
  </xsl:template>

  <!--
    Match if the next node (not necessarily sibling) that is either
    a non-empty-space-text node or an <lb> is an <lb break='no'> or
    <lb/> without @break.
  -->
  <xsl:template match="text()[
            following::node()[
              self::text()[normalize-space() != ''] or self::t:lb
            ][1]
            [self::t:lb[@break='no']]
            and name(following-sibling::t:*[2])!='pb'
          ]" priority="100">

    <xsl:variable name="normalized" select="normalize-space()"/>
    <xsl:if test="$normalized != ''">
      <xsl:variable name="lastNonSpace" select="substring($normalized, string-length($normalized))"/>
      <xsl:variable name="trimmedSuffix">
        <xsl:call-template name="substring-after-last">
          <xsl:with-param name="string" select="."/>
          <xsl:with-param name="delimiter" select="$lastNonSpace"/>
        </xsl:call-template>
        </xsl:variable>
        <xsl:choose>
          <xsl:when test="substring(normalize-space(.), string-length(normalize-space(.)), 1) = '-'">
            <xsl:value-of select="substring(., 1, string-length(.) - string-length($trimmedSuffix) - 1)"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="substring(., 1, string-length(.) - string-length($trimmedSuffix))"/>
          </xsl:otherwise>
        </xsl:choose>
    </xsl:if>
    <!-- otherwise output nothing. -->
  </xsl:template>

  <!--
    Thanks to Jeni Tennison:
    http://www.stylusstudio.com/xsllist/200111/post00460.html
  -->
  <xsl:template name="substring-after-last">
    <xsl:param name="string" />
    <xsl:param name="delimiter" />
    <xsl:choose>
      <xsl:when test="contains($string, $delimiter)">
        <xsl:call-template name="substring-after-last">
          <xsl:with-param name="string" select="substring-after($string, $delimiter)" />
          <xsl:with-param name="delimiter" select="$delimiter" />
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise><xsl:value-of select="$string" /></xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>
