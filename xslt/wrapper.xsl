<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.1"
                xmlns:t="http://www.tei-c.org/ns/1.0"
                exclude-result-prefixes="t"
                xpath-default-namespace="http://www.tei-c.org/ns/1.0">

  <xsl:output method="html"/>

  <xsl:param name="base" select="'http://localhost/copadocs/'"/>

  <!-- <!DOCTYPE html> declaration -->
  <xsl:template name="doctype">
    <xsl:text disable-output-escaping='yes'>&lt;!DOCTYPE html&gt;
</xsl:text>
  </xsl:template>

  <!-- /html/head content -->
  <xsl:template name="html-header">
    <xsl:param name="title"/>

    <meta name="viewport" content="width=device-width, initial-scale=1"/>
    <title><xsl:value-of select="$title"/> – CoPaDocs</title>

    <link href="{$base}assets/bootstrap/bootstrap.min.css" rel="stylesheet"/>

    <link href="{$base}assets/css/styles.css" rel="stylesheet"/>
  </xsl:template>

  <!-- navigation links -->
  <xsl:template name="set-class-active">
    <xsl:param name="value"/>
    <xsl:param name="link"/>
    <xsl:attribute name="class">
      <xsl:value-of select="$value"/>
      <xsl:if test="$page = $link">
        <xsl:text> active</xsl:text>
      </xsl:if>
    </xsl:attribute>
  </xsl:template>

  <!-- /html/body/header content -->
  <xsl:template name="site-header">
    <nav class="navbar navbar-expand-lg bg-light">
      <div class="container-fluid">
        <a class="navbar-brand" href="{$base}index.html">
          <img src="https://www.deutschestextarchiv.de/static/images/dta.svg" height="50" title="Logo Deutsches Textarchiv"/>
        </a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
          <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarSupportedContent">
          <ul class="navbar-nav me-auto mb-2 mb-lg-0">
            <li class="nav-item">
              <a aria-current="page" href="{$base}index.html">
                <xsl:call-template name="set-class-active">
                  <xsl:with-param name="value" select="'nav-link'"/>
                  <xsl:with-param name="link" select="'index.html'"/>
                </xsl:call-template>
                Start
              </a>
            </li>
            <li class="nav-item">
              <a aria-current="page" href="{$base}geobrowser.html">
                <xsl:call-template name="set-class-active">
                  <xsl:with-param name="value" select="'nav-link disabled'"/>
                  <xsl:with-param name="link" select="'geobrowser.html'"/>
                </xsl:call-template>
                Geobrowser
              </a>
            </li>
            <li class="nav-item">
              <a class="nav-link" href="{$base}list.html">
                <xsl:call-template name="set-class-active">
                  <xsl:with-param name="value" select="'nav-link disabled'"/>
                  <xsl:with-param name="link" select="'list.html'"/>
                </xsl:call-template>
                Übersicht Briefe
              </a>
            </li>
            <li class="nav-item dropdown">
              <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                Dokumentation
              </a>
              <ul class="dropdown-menu">
                <li>
                  <a href="{$base}quellen.html">
                    <xsl:call-template name="set-class-active">
                      <xsl:with-param name="value" select="'dropdown-item'"/>
                      <xsl:with-param name="link" select="'quellen.html'"/>
                    </xsl:call-template>
                    Infos zu den Quellen
                  </a>
                </li>
                <li>
                  <a href="{$base}technik.html">
                    <xsl:call-template name="set-class-active">
                      <xsl:with-param name="value" select="'dropdown-item disabled'"/>
                      <xsl:with-param name="link" select="'technik.html'"/>
                    </xsl:call-template>
                    Technik, Tools, Nachnutzbarkeit
                  </a>
                </li>
                <li>
                  <a href="{$base}forschungsprojekt.html">
                    <xsl:call-template name="set-class-active">
                      <xsl:with-param name="value" select="'dropdown-item'"/>
                      <xsl:with-param name="link" select="'forschungsprojekt.html'"/>
                    </xsl:call-template>
                    Infos zum Forschungsprojekt
                  </a>
                </li>
                <li>
                  <a href="{$base}korpus.html">
                    <xsl:call-template name="set-class-active">
                      <xsl:with-param name="value" select="'dropdown-item'"/>
                      <xsl:with-param name="link" select="'korpus.html'"/>
                    </xsl:call-template>
                    Infos zum Korpus
                  </a>
                </li>
                <li>
                  <a href="{$base}publikationen.html">
                    <xsl:call-template name="set-class-active">
                      <xsl:with-param name="value" select="'dropdown-item'"/>
                      <xsl:with-param name="link" select="'publikationen.html'"/>
                    </xsl:call-template>
                    Publikationen
                  </a>
                </li>
              </ul>
            </li>
          </ul>
          <form class="d-flex mb-1" role="search">
            <input class="form-control me-2" type="search" placeholder="Suche" aria-label="Search" disabled="disabled"/>
            <button class="btn btn-outline-success" type="submit" disabled="disabled">Suche</button>
          </form>
        </div>
      </div>
    </nav>
  </xsl:template>

  <xsl:template name="site-footer">
    <footer class="footer mt-auto py-3 bg-light">
      <div class="container">
        <p class="text-center">
          <a href="{$base}kontakt.html">Kontakt</a>
          |
          <a href="{$base}datenschutz.html">Datenschutz</a>
          |
          <a href="{$base}impressum.html">Impressum</a>
        </p>
        <p class="text-muted text-center">
          [Logos der beteiligten Institutionen, dazu BBAW und Text+]
        </p>
      </div>
    </footer>
  </xsl:template>

  <xsl:template name="html-footer">
    <script src="{$base}assets/bootstrap/popper.min.js"></script>
    <script src="{$base}assets/bootstrap/bootstrap.min.js"></script>
    <script src="{$base}assets/js/jquery-3.6.1.min.js"></script>
    <script src="{$base}assets/js/holder.min.js"></script>
    <script src="{$base}assets/js/scripts.js"></script>
  </xsl:template>

</xsl:stylesheet>
