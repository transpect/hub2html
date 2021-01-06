<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema" 
  xmlns:saxon="http://saxon.sf.net/"
  xmlns:html="http://www.w3.org/1999/xhtml"
  xmlns:epub="http://www.idpf.org/2007/ops"
  xmlns:css="http://www.w3.org/1996/css" 
  xmlns:xlink="http://www.w3.org/1999/xlink" 
  xmlns:dbk="http://docbook.org/ns/docbook"
  xmlns:hub2htm="http://transpect.io/hub2htm" 
  xmlns:tr="http://transpect.io" 
  xmlns:mml="http://www.w3.org/1998/Math/MathML"
  xmlns:svg="http://www.w3.org/2000/svg"
  xmlns="http://www.w3.org/1999/xhtml">
  
  <!-- Alternative XSLT-only orchestration for hub2html -->
  
  <xsl:param name="xslt-uri" as="xs:string" select="'http://transpect.io/hub2html/xsl/hub2html.xsl'"/>
  <xsl:param name="debug" select="'no'"/>
  <xsl:param name="debug-dir-uri" select="'debug'"/>
  
  <xsl:template match="/">
    <xsl:variable name="with-namespace" as="document-node(element(*))">
      <xsl:choose>
        <xsl:when test="namespace-uri(/*) = ''">
          <xsl:document>
            <xsl:apply-templates mode="add-dbk-namespace"/>
          </xsl:document>
        </xsl:when>
        <xsl:otherwise>
          <xsl:sequence select="."/>
        </xsl:otherwise>
      </xsl:choose>  
    </xsl:variable>
    <xsl:if test="$debug = 'yes'">
      <xsl:result-document href="{concat($debug-dir-uri,'/0_dbk-with-namespace.xml')}">
        <xsl:sequence select="$with-namespace"/>
      </xsl:result-document>
    </xsl:if>
    <xsl:variable name="hub2htm:default" 
      select="transform(map{
                          'stylesheet-location': $xslt-uri,
                          'source-node': $with-namespace,
                          'initial-mode': QName('', 'hub2htm-default')
                       })"/>
    <xsl:if test="$debug = 'yes'">
      <xsl:result-document href="{concat($debug-dir-uri,'/hub2htm_default.xml')}">
        <xsl:sequence select="$hub2htm:default?output"/>
      </xsl:result-document>
    </xsl:if>
    
    <xsl:variable name="hub2htm:css" 
      select="transform(map{
      'stylesheet-location': $xslt-uri,
      'source-node': $hub2htm:default?output,
      'initial-mode': QName('http://transpect.io/hub2htm', 'css')
      })"/>
    <xsl:if test="$debug = 'yes'">
      <xsl:result-document href="{concat($debug-dir-uri,'/hub2htm_css.xml')}">
        <xsl:sequence select="$hub2htm:css?output"/>
      </xsl:result-document>
    </xsl:if>
    
    <xsl:variable name="hub2htm:lists" 
      select="transform(map{
      'stylesheet-location': $xslt-uri,
      'source-node': $hub2htm:css?output,
      'initial-mode': QName('', 'hub2htm-lists')
      })"/>
    <xsl:if test="$debug = 'yes'">
      <xsl:result-document href="{concat($debug-dir-uri,'/hub2htm_lists.xml')}">
        <xsl:sequence select="$hub2htm:lists?output"/>
      </xsl:result-document>
    </xsl:if>
    
    <xsl:variable name="hub2htm:cals2html" 
      select="transform(map{
      'stylesheet-location': $xslt-uri,
      'source-node': $hub2htm:lists?output,
      'initial-mode': QName('', 'hub2htm-cals2html')
      })"/>
    <xsl:if test="$debug = 'yes'">
      <xsl:result-document href="{concat($debug-dir-uri,'/hub2htm_cals2html.xml')}">
        <xsl:sequence select="$hub2htm:cals2html?output"/>
      </xsl:result-document>
    </xsl:if>
    
    <xsl:variable name="hub2htm:references" 
      select="transform(map{
      'stylesheet-location': $xslt-uri,
      'source-node': $hub2htm:cals2html?output,
      'initial-mode': QName('', 'hub2htm-references')
      })"/>
    <xsl:if test="$debug = 'yes'">
      <xsl:result-document href="{concat($debug-dir-uri,'/hub2htm_references.xml')}">
        <xsl:sequence select="$hub2htm:references?output"/>
      </xsl:result-document>
    </xsl:if>
    
    <xsl:variable name="hub2htm:remove-ns" 
      select="transform(map{
      'stylesheet-location': $xslt-uri,
      'source-node': $hub2htm:references?output,
      'initial-mode': QName('', 'hub2htm-remove-ns')
      })"/>
    <xsl:if test="$debug = 'yes'">
      <xsl:result-document href="{concat($debug-dir-uri,'/hub2htm_remove-ns.xml')}">
        <xsl:sequence select="$hub2htm:remove-ns?output"/>
      </xsl:result-document>
    </xsl:if>
  </xsl:template>

  <xsl:template match="*" mode="add-dbk-namespace">
    <xsl:element name="{name()}" xmlns="http://docbook.org/ns/docbook">
      <xsl:apply-templates select="@* | node()" mode="#current"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="@* | text() | comment() | processing-instruction()" mode="add-dbk-namespace">
    <xsl:copy/>
  </xsl:template>
  
</xsl:stylesheet>