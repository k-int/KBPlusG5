<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:java="http://xml.apache.org/xalan/java"
                exclude-result-prefixes="java">
   <xsl:output method="text" encoding="utf-8"/>
   <xsl:strip-space elements="*" />
   <xsl:template match="/">
    <xsl:call-template name="kbartii_header" />
    <xsl:apply-templates select="//TitleListEntry" />
   </xsl:template>
   <xsl:template match="TitleListEntry">
      <!-- publication_title -->
      <xsl:call-template name="tsventry">
        <xsl:with-param name="txt" select="./Title" />
      </xsl:call-template>
      <!-- print_identifier -->
      <xsl:choose>
        <xsl:when test="./TitleIDs/ID[@namespace='ISSN' or @namespace='issn']">
          <xsl:call-template name="tsventry">
            <xsl:with-param name="txt" select="./TitleIDs/ID[@namespace='ISSN' or @namespace='issn'][1]" />
          </xsl:call-template>
        </xsl:when>
        <xsl:when test="./TitleIDs/ID[@namespace='ISBN' or @namespace='isbn']">
          <xsl:call-template name="tsventry">
            <xsl:with-param name="txt" select="./TitleIDs/ID[@namespace='ISBN' or @namespace='isbn'][1]" />
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>""&#x9;</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
      <!-- online_identifier -->
      <xsl:choose>
        <xsl:when test="./TitleIDs/ID[@namespace='eISSN' or @namespace='eissn']">
          <xsl:call-template name="tsventry">
            <xsl:with-param name="txt" select="./TitleIDs/ID[@namespace='eISSN' or @namespace='eissn'][1]" />
          </xsl:call-template>
        </xsl:when>
        <xsl:when test="./TitleIDs/ID[@namespace='eISBN' or @namespace='eisbn']">
          <xsl:call-template name="tsventry">
            <xsl:with-param name="txt" select="./TitleIDs/ID[@namespace='eISBN' or @namespace='eisbn'][1]" />
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>""&#x9;</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
      <!-- date_first_issue_online -->
      <xsl:call-template name="tsventry">
        <xsl:with-param name="txt" select="./CoverageStatement/StartDate" />
      </xsl:call-template>
      <!-- num_first_vol_online -->
      <xsl:call-template name="tsventry">
        <xsl:with-param name="txt" select="./CoverageStatement/StartVolume" />
      </xsl:call-template>
      <!-- num_first_issue_online -->
      <xsl:call-template name="tsventry">
        <xsl:with-param name="txt" select="./CoverageStatement/StartIssue" />
      </xsl:call-template>
      <!-- date_last_issue_online -->
      <xsl:call-template name="tsventry">
        <xsl:with-param name="txt" select="./CoverageStatement/EndDate" />
      </xsl:call-template>
      <!-- num_last_vol_online -->
      <xsl:call-template name="tsventry">
        <xsl:with-param name="txt" select="./CoverageStatement/EndVolume" />
      </xsl:call-template>
      <!-- num_last_issue_online -->
      <xsl:call-template name="tsventry">
        <xsl:with-param name="txt" select="./CoverageStatement/EndIssue" />
      </xsl:call-template>
      <!-- title_url -->
      <xsl:call-template name="tsventry">
        <xsl:with-param name="txt" select="./CoverageStatement/HostPlatformURL" />
      </xsl:call-template>
      <!-- first_author -->
      <xsl:call-template name="tsventry">
      </xsl:call-template>      
      <!-- title_id -->
      <xsl:call-template name="tsventry">
        <xsl:with-param name="txt" select="./titleId" />
      </xsl:call-template>
      <!-- embargo_info -->
      <xsl:call-template name="tsventry">
        <xsl:with-param name="txt" select="./CoverageStatement/Embargo" />
      </xsl:call-template>
      <!-- coverage_depth -->
      <xsl:call-template name="tsventry">
        <xsl:with-param name="txt" select="./CoverageStatement/Coverage" />
      </xsl:call-template>
      <!-- notes -->
      <xsl:call-template name="tsventry">
        <xsl:with-param name="txt" select="./CoverageStatement/CoverageNote" />
      </xsl:call-template>
      <!-- publisher_name -->
      <xsl:call-template name="tsventry"></xsl:call-template>
      <!-- publication_type -->
      <xsl:call-template name="tsventry">
        <xsl:with-param name="txt" select="./publicationType" />
      </xsl:call-template>
      <!-- date_monograph_published_print -->
      <xsl:call-template name="tsventry">
        <xsl:with-param name="txt" select="./dateMonographPublishedPrint" />
      </xsl:call-template>
      <!-- date_monograph_published_online -->
      <xsl:call-template name="tsventry">
        <xsl:with-param name="txt" select="./dateMonographPublishedOnline" />
      </xsl:call-template>
      <!-- monograph_volume -->
      <xsl:call-template name="tsventry">
        <xsl:with-param name="txt" select="./monographVolume" />
      </xsl:call-template>
      <!-- monograph_edition -->
      <xsl:call-template name="tsventry">
        <xsl:with-param name="txt" select="./monographEdition" />
      </xsl:call-template>
      <!-- first_editor -->
      <xsl:call-template name="tsventry">
        <xsl:with-param name="txt" select="./firstEditor" />
      </xsl:call-template>
      <!-- parent_publication_title_id -->
      <xsl:call-template name="tsventry">
        <xsl:with-param name="txt" select="./parentPublicationTitleId" />
      </xsl:call-template>
      <!-- preceding_publication_title_id -->
      <xsl:call-template name="tsventry">
        <xsl:with-param name="txt" select="./precedingPublicationTitleId" />
      </xsl:call-template>
      <!-- access_type -->
      <xsl:choose>
        <xsl:when test="./CoverageStatement/Payment='OA'">
          <xsl:call-template name="tsventry">
            <xsl:with-param name="txt" select="'F'" />
          </xsl:call-template>
        </xsl:when>
        <xsl:when test="./CoverageStatement/Payment='Paid'">
          <xsl:call-template name="tsventry">
            <xsl:with-param name="txt" select="'P'" />
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="tsventry">
            <xsl:with-param name="txt" select="''" />
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
      <!-- DOIs -->
      <xsl:variable name="DOIs">
        <xsl:for-each select="./TitleIDs/ID[@namespace='DOI' or @namespace='doi']">
          <xsl:call-template name="plainentry">
            <xsl:with-param name="txt" select="text()" />
          </xsl:call-template>
          <xsl:if test="not(position()=last())">
            <xsl:text>,</xsl:text>
          </xsl:if>
        </xsl:for-each>
      </xsl:variable>
      <xsl:call-template name="tsventry">
        <xsl:with-param name="txt" select="$DOIs" />
      </xsl:call-template>
      <!-- all issns -->
      <xsl:variable name="ISSNs">
        <xsl:for-each select="./TitleIDs/ID[@namespace='ISSN' or @namespace='issn']">
          <xsl:call-template name="plainentry">
            <xsl:with-param name="txt" select="text()" />
          </xsl:call-template>
          <xsl:if test="not(position()=last())">
            <xsl:text>,</xsl:text>
          </xsl:if>
        </xsl:for-each>
      </xsl:variable>
      <xsl:call-template name="tsventry">
        <xsl:with-param name="txt" select="$ISSNs" />
      </xsl:call-template>
      <!-- all eissns -->
      <xsl:variable name="eISSNs">
        <xsl:for-each select="./TitleIDs/ID[@namespace='eISSN' or @namespace='eissn']">
          <xsl:call-template name="plainentry">
            <xsl:with-param name="txt" select="text()" />
          </xsl:call-template>
          <xsl:if test="not(position()=last())">
            <xsl:text>,</xsl:text>
          </xsl:if>
        </xsl:for-each>
      </xsl:variable>
      <xsl:call-template name="tsventry">
        <xsl:with-param name="txt" select="$eISSNs" />
      </xsl:call-template>
      <!-- all isbns -->
      <xsl:variable name="ISBNs">
        <xsl:for-each select="./TitleIDs/ID[@namespace='ISBN' or @namespace='isbn']">
          <xsl:call-template name="plainentry">
            <xsl:with-param name="txt" select="text()" />
          </xsl:call-template>
          <xsl:if test="not(position()=last())">
            <xsl:text>,</xsl:text>
          </xsl:if>
        </xsl:for-each>
      </xsl:variable>
      <xsl:call-template name="tsventry">
        <xsl:with-param name="txt" select="$ISBNs" />
      </xsl:call-template>
      <!-- all eisbns -->
      <xsl:variable name="eISBNs">
        <xsl:for-each select="./TitleIDs/ID[@namespace='eISBN' or @namespace='eisbn']">
          <xsl:call-template name="plainentry">
            <xsl:with-param name="txt" select="text()" />
          </xsl:call-template>
          <xsl:if test="not(position()=last())">
            <xsl:text>,</xsl:text>
          </xsl:if>
        </xsl:for-each>
      </xsl:variable>
      <xsl:call-template name="tsventry">
        <xsl:with-param name="txt" select="$eISBNs" />
      </xsl:call-template>
      <!-- access_start_date -->
      <xsl:call-template name="tsventry">
        <xsl:with-param name="txt">
          <xsl:if test="./CoverageStatement/AccessFrom != ''">
            <xsl:call-template name="formats_date_yyyy-MM-dd">
              <xsl:with-param name="date" select="./CoverageStatement/AccessFrom" />
            </xsl:call-template>
          </xsl:if>
        </xsl:with-param>
      </xsl:call-template>
      <!-- access_end_date -->
      <xsl:call-template name="tsventry">
        <xsl:with-param name="txt">
          <xsl:if test="./CoverageStatement/AccessTo != ''">
            <xsl:call-template name="formats_date_yyyy-MM-dd">
              <xsl:with-param name="date" select="./CoverageStatement/AccessTo" />
            </xsl:call-template>
          </xsl:if>
        </xsl:with-param>
      </xsl:call-template>
      <!-- access_status (Current/Expected) -->
      <xsl:call-template name="tsventry">
        <xsl:with-param name="txt" select="./CoverageStatement/AccessStatus" />
      </xsl:call-template>

      <xsl:text>&#xA;</xsl:text>
   </xsl:template>

  <xsl:template name="tsventry"><xsl:param name="txt"/><xsl:text>"</xsl:text><xsl:value-of select="java:replaceAll(java:java.lang.String.new(normalize-space($txt)),'&#34;','&#34;&#34;')"/><xsl:text>"</xsl:text><xsl:text>&#x9;</xsl:text></xsl:template>
  <xsl:template name="plainentry"><xsl:param name="txt"/><xsl:value-of select="$txt"/></xsl:template>

  <xsl:template name="kbartii_header"><xsl:text>publication_title&#x9;print_identifier&#x9;online_identifier&#x9;date_first_issue_online&#x9;num_first_vol_online&#x9;num_first_issue_online&#x9;date_last_issue_online&#x9;num_last_vol_online&#x9;num_last_issue_online&#x9;title_url&#x9;first_author&#x9;title_id&#x9;embargo_info&#x9;coverage_depth&#x9;notes&#x9;publisher_name&#x9;publication_type&#x9;date_monograph_published_print&#x9;date_monograph_published_online&#x9;monograph_volume&#x9;monograph_edition&#x9;first_editor&#x9;parent_publication_title_id&#x9;preceding_publication_title_id&#x9;access_type&#x9;DOI&#x9;ISSNs&#x9;eISSNs&#x9;ISBNs&#x9;eISBNs&#x9;access_start_date&#x9;access_end_date&#x9;access_status&#x9;&#xA;</xsl:text></xsl:template>

  <xsl:template name="formats_date_yyyy-MM-dd"><xsl:param name="date"/><xsl:value-of select="concat(substring($date,1,4),'-',substring($date,6,2),'-',substring($date,9,2))"/></xsl:template>

</xsl:stylesheet>
