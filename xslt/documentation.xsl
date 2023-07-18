<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.1">
  <xsl:import href="wrapper.xsl"/>

  <xsl:variable name="force-exclude-all-namespaces" select="true()"/>
  <xsl:param name="page">0</xsl:param>

  <xsl:output method="html"/>

  <xsl:template match="/section[1]">
    <xsl:call-template name="doctype"/>
    <html lang="de">
      <head>
        <xsl:call-template name="html-header">
          <xsl:with-param name="title" select="h1[1]"/>
        </xsl:call-template>
      </head>
      <body class="d-flex flex-column vh-100">
        <header>
          <xsl:call-template name="site-header"/>
        </header>
        <main class="flex-shrink-0">
          <div>
            <xsl:choose>
              <xsl:when test="$page='list.html' or $page='patientenakten.html'">
                <xsl:attribute name="class">
                  <xsl:text>container-fluid mt-3 mb-5</xsl:text>
                </xsl:attribute>
              </xsl:when>
              <xsl:otherwise>
                <xsl:attribute name="class">
                  <xsl:text>container mt-3 mb-5</xsl:text>
                </xsl:attribute>
              </xsl:otherwise>
            </xsl:choose>
            <div class="row">
              <xsl:choose>
                <xsl:when test="$page='geobrowser.html' or $page='index.html' or $page='list.html' or $page='patientenakten.html'">
                  <div class="col-lg-12 col-md-12 tei mx-auto">
                    <xsl:copy-of select="."/>
                  </div>
                </xsl:when>
                <xsl:otherwise>
                  <div class="col-lg-8 col-md-12 tei mx-auto">
                    <xsl:copy-of select="."/>
                  </div>
                </xsl:otherwise>
              </xsl:choose>
            </div>
          </div>
        </main>

        <xsl:call-template name="site-footer"/>
        <xsl:call-template name="html-footer"/>
      </body>
    </html>
  </xsl:template>

</xsl:stylesheet>
