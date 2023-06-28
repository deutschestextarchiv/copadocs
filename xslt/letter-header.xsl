<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.1"
                xmlns:t="http://www.tei-c.org/ns/1.0"
                exclude-result-prefixes="t"
                xpath-default-namespace="http://www.tei-c.org/ns/1.0">

  <xsl:output method="html"/>

  <xsl:template match="t:teiHeader">
    <div class="tei-header">
      <!--<h1>
        <xsl:value-of select="normalize-space(/t:TEI/t:teiHeader/t:profileDesc/t:creation/t:persName[@type='sender'])"/>
        <xsl:text>, </xsl:text>
        <xsl:value-of select="normalize-space(/t:TEI/t:teiHeader/t:profileDesc/t:creation/t:date[@type='sent'])"/>
      </h1>-->
      
      <div>
        <button class="btn btn-light" type="button" data-bs-toggle="collapse" data-bs-target="#collapse-meta" aria-expanded="false" aria-controls="collapse-meta">Metadaten</button>
        <a class="btn btn-light ms-3" href="{$base}data/{$dirname}/{$filename}.xml" target="_blank">TEI-XML</a>
        <button class="btn btn-light ms-3" type="button" data-bs-toggle="collapse" data-bs-target="#collapse-bibl" aria-expanded="true" aria-controls="collapse-bibl">Zitationshinweis</button>
      </div>

      <div id="collapse-group">
        <div class="collapse pt-3" id="collapse-meta" data-bs-parent="#collapse-group">
          <h2>Metadaten zu diesem Dokument</h2>
          <xsl:apply-templates select="/t:TEI/@xml:id"/>
          <xsl:apply-templates select="/t:TEI/t:teiHeader/t:profileDesc/t:creation"/>
          <xsl:apply-templates select="/t:TEI/t:teiHeader/t:profileDesc/t:particDesc"/>
          <xsl:apply-templates select="/t:TEI/t:teiHeader/t:profileDesc/t:textDesc"/>
          <xsl:apply-templates select="/t:TEI/t:teiHeader/t:fileDesc/t:titleStmt/t:editor"/>
          <xsl:apply-templates select="/t:TEI/t:teiHeader/t:fileDesc/t:publicationStmt/t:availability/t:licence"/>
          <xsl:apply-templates select="/t:TEI/t:teiHeader/t:fileDesc/t:sourceDesc/t:msDesc/t:msIdentifier"/>
          <xsl:apply-templates select="/t:TEI/t:teiHeader/t:profileDesc/t:handNotes"/>
        </div>

        <div class="collapse pt-3" id="collapse-bibl" data-bs-parent="#collapse-group">
          <h2>Zitationshinweis</h2>
          <blockquote>
            <cite>
              Schiegg, Markus (Hg.): CoPaDocs – Korpus historischer Patiententexte.
              &lt;https://www.deutschestextarchiv.de/copadocs/&gt;.
              Quelle aus:
              <xsl:call-template name="archive-name">
                <xsl:with-param name="code" select="substring-before($dirname,'_')"/>
              </xsl:call-template>
              <xsl:text>, Patientenakte </xsl:text>
              <xsl:value-of select="/t:TEI/t:teiHeader/t:fileDesc/t:sourceDesc/t:msDesc/t:msIdentifier/t:idno"/>
              <xsl:text>, </xsl:text>
              <xsl:value-of select="normalize-space(/t:TEI/t:teiHeader/t:profileDesc/t:particDesc/t:person/t:persName)"/>
              <xsl:text>, Text von </xsl:text>
              <xsl:value-of select="normalize-space(/t:TEI/t:teiHeader/t:profileDesc/t:creation/t:persName[@type='sender'])"/>
              <xsl:text>, </xsl:text>
              <xsl:value-of select="normalize-space(/t:TEI/t:teiHeader/t:profileDesc/t:creation/t:date[@type='sent'])"/>
              <xsl:text>.</xsl:text>
            </cite>
          </blockquote>
        </div>
      </div>
    </div>
  </xsl:template>

  <xsl:template match="/t:TEI/@xml:id">
    <h3>ID dieses Dokuments</h3>
    <p>
      <code><xsl:value-of select="."/></code>
    </p>
  </xsl:template>

  <xsl:template match="t:fileDesc/t:titleStmt/t:editor">
    <h3>Bearbeiter des digitalen Dokuments (Transkription, Korrekturlesung)</h3>
    <ul>
      <xsl:for-each select="t:name">
        <li><xsl:apply-templates select="current()"/></li>
      </xsl:for-each>
    </ul>
  </xsl:template>


  <xsl:template match="t:profileDesc/t:creation">
    <h3>Informationen zum Text <!--(Schreiber und ggf. Empfänger)--></h3>
    <table class="table table-sm">
      <thead>
        <tr>
          <th></th>
          <th>Name</th>
          <th>Ort</th>
          <th>Datum</th>
        </tr>
      </thead>
      <tbody>
        <tr>
          <th>von</th>
          <td><xsl:apply-templates select="t:persName[@type='sender']"/></td>
          <td><xsl:apply-templates select="t:settlement[@type='sent']"/></td>
          <td><xsl:apply-templates select="t:date[@type='sent']"/></td>
        </tr>
        <tr>
          <th>an</th>
          <td><xsl:apply-templates select="t:persName[@type='addressee']"/></td>
          <td><xsl:value-of select="t:settlement[@type='received']"/></td>
          <td><xsl:value-of select="t:date[@type='received']"/></td>
        </tr>
      </tbody>
    </table>
  </xsl:template>

  <xsl:template match="t:profileDesc/t:particDesc">
    <div>
      <h3>Informationen zum Patienten</h3>
      <div class="ms-3">
        <!-- TODO: more than 1 person? -->
        <xsl:for-each select="t:person">
          <xsl:apply-templates select="current()"/>
        </xsl:for-each>
      </div>
    </div>
  </xsl:template>

  <xsl:template match="t:profileDesc/t:particDesc/t:person">
    <table class="table table-sm">
      <tr>
        <th>ID</th>
        <td><code><xsl:value-of select="@xml:id"/></code></td>
      </tr>
      <tr>
        <th>Name</th>
        <td><xsl:apply-templates select="t:persName"/></td>
      </tr>
      <tr>
        <th>Geschlecht</th>
        <td><xsl:value-of select="@sex"/></td>
      </tr>
      <tr>
        <th>geboren</th>
        <td><xsl:value-of select="t:birth/@when"/></td>
      </tr>
      <tr>
        <th>gestorben</th>
        <td>
          <xsl:choose>
            <xsl:when test="t:death[@cert='unknown']">
              <i>unbekannt</i>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="t:death/@when"/>
            </xsl:otherwise>
          </xsl:choose>
        </td>
      </tr>
      <tr>
        <th>Tätigkeit(en)</th>
        <td>
          <xsl:for-each select="t:occupation">
            <xsl:apply-templates select="current()"/>
            <xsl:if test="position()!=last()"><xsl:text>, </xsl:text></xsl:if>
          </xsl:for-each>
        </td>
      </tr>
      <tr>
        <th>Ort(e)</th>
        <td>
          <xsl:for-each select="t:residence">
            <xsl:apply-templates select="current()"/>
            <xsl:if test="position()!=last()"><xsl:text>, </xsl:text></xsl:if>
          </xsl:for-each>
        </td>
      </tr>
      <tr>
        <th>Religion</th>
        <td>
          <xsl:for-each select="t:faith">
            <xsl:apply-templates select="current()"/>
            <xsl:if test="position()!=last()"><xsl:text>, </xsl:text></xsl:if>
          </xsl:for-each>
        </td>
      </tr>
      <tr>
        <th>Weitere Informationen</th>
        <td>
          <ul>
            <xsl:for-each select="t:state/t:p">
              <li><xsl:apply-templates select="current()"/></li>
            </xsl:for-each>
          </ul>
        </td>
      </tr>
      <tr>
        <th>Diagnose</th>
        <td>
          <xsl:for-each select="t:trait">
            <xsl:apply-templates select="current()"/>
            <xsl:if test="position()!=last()"><xsl:text>, </xsl:text></xsl:if>
          </xsl:for-each>
        </td>
      </tr>
    </table>
  </xsl:template>

  <xsl:template match="t:handNotes">
    <h3>Informationen zur Schrift</h3>
    <table class="table table-sm">
      <thead>
        <tr>
          <th>Schreiber</th>
          <th>Medium</th>
          <th>Umfang</th>
        </tr>
      </thead>
      <tbody>
        <xsl:for-each select="t:handNote">
          <tr>
            <td><xsl:value-of select="@scribe"/></td>
            <td><xsl:value-of select="@medium"/></td>
            <td><xsl:value-of select="@scope"/></td>
          </tr>
        </xsl:for-each>
      </tbody>
    </table>
  </xsl:template>

  <xsl:template match="t:textDesc">
    <!--<h3>Informationen zum Text</h3>-->
    <table class="table table-sm">
      <!--
        always empty(?):
          + channel
          + constitution
          + derivation
          + factuality
          + interaction
          + preparedness

      -->
      <tr>
        <th>Domain</th>
        <td><xsl:apply-templates select="t:domain"/></td>
      </tr>
      <tr>
        <th>Regest</th>
        <td><xsl:apply-templates select="t:purpose"/></td>
      </tr>
    </table>
  </xsl:template>
  
  <xsl:template match="t:fileDesc/t:publicationStmt/t:availability/t:licence">
    <h3>Nutzungsbedingungen</h3>
    <p><a href="{@target}"><xsl:apply-templates/></a></p>
  </xsl:template>

  <xsl:template match="t:fileDesc/t:sourceDesc/t:msDesc/t:msIdentifier">
    <h3>Nachweis Originaldokument</h3>
    <table class="table table-sm">
      <tr>
        <th>Einrichtung</th>
        <td><xsl:apply-templates select="t:repository"/></td>
      </tr>
      <tr>
        <th>Sammlung</th>
        <td><xsl:apply-templates select="t:collection"/></td>
      </tr>
      <tr>
        <th>Nr.</th>
        <td><xsl:apply-templates select="t:idno"/></td>
      </tr>
    </table>
  </xsl:template>

  <xsl:template match="t:surname[string-length(.)=0]">
    [Nachname]
  </xsl:template>
</xsl:stylesheet>
