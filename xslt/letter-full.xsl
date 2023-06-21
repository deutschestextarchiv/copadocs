<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.1"
                xmlns:t="http://www.tei-c.org/ns/1.0"
                exclude-result-prefixes="t"
                xpath-default-namespace="http://www.tei-c.org/ns/1.0">

  <xsl:import href="wrapper.xsl"/>
  <xsl:import href="tei-text.xsl"/>
  <xsl:import href="letter-header.xsl"/>

  <xsl:variable name="force-exclude-all-namespaces" select="true()"/>
  <xsl:variable name="volume-id" select="/t:TEI/t:teiHeader/t:fileDesc/t:sourceDesc/t:biblFull/t:seriesStmt/t:title[@type='main']/@xml:id"/>
  <xsl:variable name="barcode" select="substring-before(/t:TEI/t:text[1]//t:pb[1]/@facs, '/')"/>

  <xsl:output method="html" media-type="text/html"/>

  <xsl:template match="/">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="/t:TEI">
    <xsl:call-template name="doctype"/>
    <html lang="de">
      <head>
        <xsl:call-template name="html-header">
          <xsl:with-param name="title" select="/t:TEI/t:teiHeader/t:fileDesc/t:titleStmt/t:title[@type='main'][1]"/>
        </xsl:call-template>
      </head>
      <body class="d-flex flex-column vh-100">
        <header>
          <xsl:call-template name="site-header"/>
          <div class="container">
            <div class="row">
              <div class="col-lg-8 col-md-8 mt-2 mx-auto bg-white">
                <nav aria-label="breadcrumb">
                  <ol class="breadcrumb mb-0">
                    <li class="breadcrumb-item"><a href="{$base}">Start</a></li>
                    <li class="breadcrumb-item">
                      <a href="../volumes/{$volume-id}.html">
                        <xsl:text>Band </xsl:text>
                        <xsl:value-of select="/t:TEI/t:teiHeader/t:fileDesc/t:sourceDesc/t:biblFull/t:seriesStmt/t:biblScope[@unit='volume']"/>
                        <xsl:text>, </xsl:text>
                        <xsl:value-of select="/t:TEI/t:teiHeader/t:fileDesc/t:sourceDesc/t:biblFull/t:seriesStmt/t:biblScope[@unit='issue']"/>
                      </a>
                    </li>
                    <li class="breadcrumb-item active" aria-current="page">
                      Artikel
                      <xsl:value-of select="/t:TEI/t:text[1]//t:titlePart[@type='number'][1]"/>
                    </li>
                  </ol>
                </nav>
              </div>
            </div>
          </div>
        </header>
        <main class="flex-shrink-0">
          <div class="container mt-3 mb-5">
            <div class="row">
              <div class="col-lg-2"></div>
              <div class="col-lg-7 col-md-8 tei mx-auto">
                <xsl:apply-templates/>
              </div>
              <div class="col-lg-3 bg-light">
              </div>
            </div>
          </div>
        </main>

        <xsl:call-template name="site-footer"/>
        <xsl:call-template name="html-footer"/>
      </body>
    </html>
  </xsl:template>

</xsl:stylesheet>
