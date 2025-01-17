<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.1"
                xmlns:t="http://www.tei-c.org/ns/1.0"
                exclude-result-prefixes="t"
                xpath-default-namespace="http://www.tei-c.org/ns/1.0">

  <xsl:output method="html"/>

  <xsl:param name="base" select="'http://localhost/copadocs/'"/>
  <xsl:param name="img-base" select="'https://kaskade.dwds.de/~wiegand/copadocs/'"/>
  <xsl:param name="page"/>

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
    <link href="{$base}assets/datatables/datatables.min.css" rel="stylesheet"/>
    <link href="{$base}assets/fancybox/fancybox.css" rel="stylesheet"/>

    <link href="{$base}assets/css/site.css" rel="stylesheet"/>
    <link href="{$base}assets/css/tei.css" rel="stylesheet"/>

    <script>
      base    = '<xsl:value-of select="$base"/>'
      imgBase = '<xsl:value-of select="$img-base"/>'
    </script>
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
                  <xsl:with-param name="value" select="'nav-link'"/>
                  <xsl:with-param name="link" select="'geobrowser.html'"/>
                </xsl:call-template>
                Geobrowser
              </a>
            </li>
            <li class="nav-item">
              <a class="nav-link" href="{$base}list.html">
                <xsl:call-template name="set-class-active">
                  <xsl:with-param name="value" select="'nav-link'"/>
                  <xsl:with-param name="link" select="'list.html'"/>
                </xsl:call-template>
                Korpus
              </a>
            </li>
            <li class="nav-item">
              <a aria-current="page" href="{$base}patientenakten.html">
                <xsl:call-template name="set-class-active">
                  <xsl:with-param name="value" select="'nav-link'"/>
                  <xsl:with-param name="link" select="'patientenakten.html'"/>
                </xsl:call-template>
                Patientenakten
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
                  <a href="{$base}technik.html" class="disabled">
                    <xsl:call-template name="set-class-active">
                      <xsl:with-param name="value" select="'dropdown-item'"/>
                      <xsl:with-param name="link" select="'technik.html'"/>
                    </xsl:call-template>
                    Technik, Tools, Nachnutzbarkeit
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
          <form class="d-flex mb-1 me-5" role="search" action="{$base}suche.html">
            <input class="form-control me-2" name="q" id="q-wrapper" type="search" placeholder="Suche" aria-label="Search"/>
            <button class="btn btn-outline-success" type="submit">Suche</button>
          </form>
        </div>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
          <span class="navbar-toggler-icon"></span>
        </button>
        <a class="navbar-brand" href="https://www.dwds.de/d/korpora/copadocs" target="_blank">
          <img src="{$base}assets/logos/dwds.svg" height="50" title="Digitales Wörterbuch der deutschen Sprache" alt="Logo DWDS" data-bs-toggle="tooltip" data-bs-placement="right"/>
        </a>
      </div>
    </nav>
  </xsl:template>

  <xsl:template name="site-footer">
    <footer class="footer mt-auto mt-5 py-3 bg-white">
      <div class="container-fluid">
        <p class="text-center">
          <a href="{$base}datenschutz.html">Datenschutz</a>
          |
          <a href="{$base}impressum.html">Impressum</a>
        </p>
        <div class="row">
          <div class="col-12">
            <div class="footer-box">
              <div class="footer-col">
                <a href="https://www.humboldt-foundation.de/" target="_blank"><img src="{$base}assets/logos/avh-stiftung.jpg" title="Alexander von Humboldt-Stiftung" alt="Logo Alexander von Humboldt-Stiftung" data-bs-toggle="tooltip"/></a>
              </div>
              <div class="footer-col">
                <a href="https://www.elitenetzwerk.bayern.de/" target="_blank"><img src="{$base}assets/logos/elitenetzwerk-bayern.jpg" title="Elitenetzwerk Bayern" alt="Logo Elitenetzwerk Bayern" data-bs-toggle="tooltip"/></a>
              </div>
              <div class="footer-col">
                <a href="https://www.fau.de/" target="_blank"><img src="{$base}assets/logos/fau.jpg" title="Friedrich-Alexander-Universität Erlangen-Nürnberg" alt="Logo Friedrich-Alexander-Universität Erlangen-Nürnberg" data-bs-toggle="tooltip"/></a>
              </div>
              <div class="footer-col">
                <a href="https://hison.org/" target="_blank"><img src="{$base}assets/logos/hison.jpg" title="Historical Sociolinguistics Network" alt="Logo Historical Sociolinguistics Network" data-bs-toggle="tooltip"/></a>
              </div>
              <div class="footer-col">
                <a href="https://www.bbaw.de/" target="_blank"><img src="{$base}assets/logos/bbaw.png" title="Berlin-Brandenburgische Akademie der Wissenschaften" alt="Logo Berlin-Brandenburgische Akademie der Wissenschaften" data-bs-toggle="tooltip"/></a>
              </div>
              <div class="footer-col">
                <a href="https://www.text-plus.org/" target="_blank"><img src="{$base}assets/logos/text-plus-logo.svg" style="height:70px" title="NFDI-Konsortium Text+" alt="Logo NFDI-Konsortium Text+" data-bs-toggle="tooltip"/></a>
              </div>
              <div class="footer-col">
                <a href="https://creativecommons.org/licenses/by-sa/4.0/deed.de" target="_blank"><img src="{$base}assets/logos/cc-by-sa.svg" style="height:70px" title="CC BY-SA 4.0" alt="Logo CC BY-SA 4.0" data-bs-toggle="tooltip"/></a>
              </div>
            </div>
          </div>
        </div>
      </div>
    </footer>
  </xsl:template>

  <xsl:template name="html-footer">
    <script src="{$base}assets/bootstrap/popper.min.js"></script>
    <script src="{$base}assets/bootstrap/bootstrap.min.js"></script>
    <script src="{$base}assets/js/jquery-3.6.1.min.js"></script>
    <script src="{$base}assets/js/holder.min.js"></script>
    <script src="{$base}assets/js/scripts.js"></script>
    <script src="{$base}assets/datatables/datatables.min.js"></script>
    <script src="{$base}assets/datatables/natural.js"></script>
    <script src="{$base}assets/fancybox/fancybox.umd.js"></script>

    <!-- Matomo -->
    <script>
      var _paq = window._paq = window._paq || [];
      _paq.push(['trackPageView']);
      _paq.push(['enableLinkTracking']);
      (function() {
        var u="https://stats.dwds.de/";
        _paq.push(['setTrackerUrl', u+'matomo.php']);
        _paq.push(['setSiteId', '5']);
        _paq.push(['enableLinkTracking']);
        _paq.push(['trackPageView']);
        _paq.push(['trackVisibleContentImpressions']);
        var d=document, g=d.createElement('script'), s=d.getElementsByTagName('script')[0];
        g.async=true; g.src=u+'matomo.js'; s.parentNode.insertBefore(g,s);
      })();
    </script>
    <noscript><p><img src="https://stats.dwds.de/matomo.php?idsite=5&amp;rec=1" style="border:0"/></p></noscript>
    <!-- End Matomo Code -->
  </xsl:template>

</xsl:stylesheet>
