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
    <xsl:variable name="hub2htm-default" 
      select="transform(map{
                          'stylesheet-location': $xslt-uri,
                          'source-node': $with-namespace,
                          'initial-mode': QName('', 'hub2htm-default')
                       })"/>
    <xsl:sequence select="$hub2htm-default?output"/>
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