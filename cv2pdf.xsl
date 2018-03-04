<?xml version='1.0' encoding='ISO-8859-1'?>

<!-- =============================================================== -->
<!--                                                                 -->
<!-- This stylesheet renders CVs to XSL Formatting Objects           -->
<!-- (with RenderX extensions for PDF bookmarks and meta info)       -->
<!--                                                                 -->
<!--     Author: Nikolai Grigoriev                                   -->
<!--                                                                 -->
<!--    (c) XSL.ru, 2002                                             -->
<!--                                                                 -->
<!-- =============================================================== -->


<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                xmlns:rx="http://www.renderx.com/XSL/Extensions">

<xsl:output method="xml"
            version="1.0"
            indent="no"
            encoding="ISO-8859-1"/>

<!-- =============================================================== -->
<!-- Parameters and attribute sets                                   -->
<!-- =============================================================== -->

<xsl:param name="title-color">#002080</xsl:param>
<xsl:param name="href-color">#0040C0</xsl:param>

<xsl:attribute-set name="title-attrs">
  <xsl:attribute name="color"><xsl:value-of select="$title-color"/></xsl:attribute>
  <xsl:attribute name="font-weight">bold</xsl:attribute>
  <xsl:attribute name="keep-together.within-column">always</xsl:attribute>
  <xsl:attribute name="keep-with-next.within-column">always</xsl:attribute>
  <xsl:attribute name="text-align">start</xsl:attribute>
  <xsl:attribute name="space-after.optimum">6pt</xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="href-attrs">
  <xsl:attribute name="color"><xsl:value-of select="$href-color"/></xsl:attribute>
  <xsl:attribute name="text-decoration">underline</xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="contact-item">
  <xsl:attribute name="font-style">italic</xsl:attribute>
</xsl:attribute-set>

<!-- *************************************************************** -->
<!-- Top-level template: document layout for a book                  -->
<!-- *************************************************************** -->

<xsl:template match="resume">

  <fo:root hyphenation-push-character-count="3"
           hyphenation-remain-character-count="3">

    <xsl:variable name="persname">
      <xsl:apply-templates select="person" mode="name-only"/>
    </xsl:variable>

    <rx:meta-info>
      <rx:meta-field name="title" value="Curriculum Vitae of {$persname}"/>
      <rx:meta-field name="author" value="{$persname}"/>
      <rx:meta-field name="keywords" value="{@keywords}"/>
    </rx:meta-info>

    <fo:layout-master-set>
      <fo:simple-page-master master-name="first-page">
        <fo:region-body  margin="1.5in 0.6in 0.9in 1in"
                         padding="6pt 0pt"
                         border-bottom="thin solid silver"/>
        <fo:region-after extent="0.9in"
                         padding="6pt 0.6in 0pt 1in"/>
      </fo:simple-page-master>

      <fo:simple-page-master master-name="regular-page">
        <fo:region-body  margin="0.9in 0.6in 0.9in 1in"
                         padding="6pt 0pt"
                         border-top="thin solid silver"
                         border-bottom="thin solid silver"/>
        <fo:region-before extent="0.9in"
                         padding="0pt 0.6in 6pt 1in"
                         display-align="after"/>
        <fo:region-after extent="0.9in"
                         padding="6pt 0.6in 0pt 1in"/>
      </fo:simple-page-master>

      <!-- Sequences -->
      <fo:page-sequence-master master-name="body">
        <fo:single-page-master-reference master-reference="first-page"/>
        <fo:repeatable-page-master-reference master-reference="regular-page"/>
      </fo:page-sequence-master>
    </fo:layout-master-set>

    <xsl:call-template name="outline"/>   <!-- bookmarks -->

    <fo:page-sequence master-reference="body">

      <fo:static-content flow-name="xsl-region-before">
        <fo:block text-align-last="justify" font="bold 9pt Helvetica">
          <xsl:value-of select="$persname"/>
          <fo:leader/>
          <xsl:text>Page </xsl:text>
          <fo:page-number/>
        </fo:block>
      </fo:static-content>

      <fo:static-content flow-name="xsl-region-after">
        <fo:block font="bold 9pt Helvetica">
          <fo:basic-link external-destination="url('http://www.xsl.ru')" color="{$href-color}">XSL.ru</fo:basic-link>
        </fo:block>
      </fo:static-content>

      <fo:flow flow-name="xsl-region-body"
               font="11pt/1.3 Times"
               text-align="justify">

        <xsl:apply-templates select="person"/>
        <xsl:apply-templates select="objective"/>
        <xsl:apply-templates select="skills"/>
        <xsl:apply-templates select="employments"/>
        <xsl:apply-templates select="education"/>
        <xsl:apply-templates select="projects"/>
        <xsl:apply-templates select="publications"/>
        <xsl:apply-templates select="miscellanea"/>
      </fo:flow>
    </fo:page-sequence>
  </fo:root>

</xsl:template>

<!-- *************************************************************** -->
<!-- Personal info                                                   -->
<!-- *************************************************************** -->

<xsl:template match="person" mode="name-only">
  <xsl:value-of select="firstname"/>
  <xsl:text> </xsl:text>
  <xsl:value-of select="lastname"/>
</xsl:template>

<xsl:template match="person">
  <fo:block font-size="24pt" text-decoration="underline"
            xsl:use-attribute-sets="title-attrs"
            space-after="24pt"><xsl:apply-templates select="." mode="name-only"/></fo:block>
  <xsl:apply-templates select="contactinfo"/>
</xsl:template>

<!-- *************************************************************** -->
<!-- Sections                                                        -->
<!-- *************************************************************** -->

<!-- These elements form a section -->

<xsl:template match="contactinfo |
                     objective |
                     skills |
                     projects |
                     employments |
                     education |
                     miscellanea">
  <fo:block font-size="15pt" space-before="18pt" id="{generate-id()}" xsl:use-attribute-sets="title-attrs">
    <xsl:apply-templates select="." mode="title-mode"/>
  </fo:block>
  <fo:block margin-left="0.5in"><xsl:apply-templates select="." mode="content-mode"/></fo:block>
</xsl:template>

<xsl:template match="contactinfo" mode="title-mode">Contact info</xsl:template>
<xsl:template match="objective" mode="title-mode">Objective</xsl:template>
<xsl:template match="skills" mode="title-mode">Skills</xsl:template>
<xsl:template match="projects" mode="title-mode">Projects</xsl:template>
<xsl:template match="employments" mode="title-mode">Employments</xsl:template>
<xsl:template match="education" mode="title-mode">Education</xsl:template>
<xsl:template match="miscellanea" mode="title-mode">Miscellanea</xsl:template>

<xsl:template match="*" mode="content-mode">
  <xsl:apply-templates/>
</xsl:template>


<!-- Contact info -->

<xsl:template match="contactinfo" mode="content-mode">
  <fo:table border-spacing="6pt">
    <fo:table-column column-width="20%"/>
    <fo:table-body>
      <xsl:apply-templates select="email"/>
      <xsl:apply-templates select="address"/>
      <xsl:apply-templates select="phone"/>
      <xsl:apply-templates select="www"/>
    </fo:table-body>
  </fo:table>
</xsl:template>

<xsl:template match="contactinfo/email">
  <fo:table-row>
    <fo:table-cell text-align="end">
       <fo:block xsl:use-attribute-sets="contact-item">E-mail:</fo:block>
    </fo:table-cell>
    <fo:table-cell>
      <fo:block><fo:basic-link color="{$href-color}" external-destination="url('mailto:{.}')"><xsl:apply-templates/></fo:basic-link></fo:block>
    </fo:table-cell>
  </fo:table-row>
</xsl:template>

<xsl:template match="contactinfo/address">
  <fo:table-row>
    <fo:table-cell text-align="end">
       <fo:block xsl:use-attribute-sets="contact-item">Address:</fo:block>
    </fo:table-cell>
    <fo:table-cell>
      <fo:block>
        <xsl:apply-templates select="street"/>
        <xsl:text>, </xsl:text>
        <xsl:apply-templates select="zip"/>
        <xsl:text> </xsl:text>
        <xsl:apply-templates select="city"/>
        <xsl:text>, </xsl:text>
        <xsl:apply-templates select="country"/>
      </fo:block>
    </fo:table-cell>
  </fo:table-row>
</xsl:template>

<xsl:template match="contactinfo/phone">
  <fo:table-row>
    <fo:table-cell text-align="end">
      <fo:block xsl:use-attribute-sets="contact-item">
        <xsl:if test="not(preceding-sibling::phone)">
          <xsl:choose>
            <xsl:when test="following-sibling::phone"><xsl:text>Phones:</xsl:text></xsl:when>
            <xsl:otherwise><xsl:text>Phone:</xsl:text></xsl:otherwise>
          </xsl:choose>
        </xsl:if>
      </fo:block>
    </fo:table-cell>
    <fo:table-cell>
      <fo:block>
        <xsl:apply-templates/>
        <xsl:if test="@mode">
          <xsl:text> (</xsl:text>
          <xsl:value-of select="@mode"/>
          <xsl:text>)</xsl:text>
        </xsl:if>
      </fo:block>
    </fo:table-cell>
  </fo:table-row>
</xsl:template>

<xsl:template match="contactinfo/www">
  <fo:table-row>
    <fo:table-cell text-align="end">
      <fo:block xsl:use-attribute-sets="contact-item">Home page:</fo:block>
    </fo:table-cell>
    <fo:table-cell>
      <fo:block>
        <fo:basic-link xsl:use-attribute-sets="href-attrs" external-destination="url('{.}')"><xsl:apply-templates/></fo:basic-link>
      </fo:block>
    </fo:table-cell>
  </fo:table-row>
</xsl:template>

<!-- Projects -->

<xsl:template match="project">
  <fo:block space-before="12pt"
            space-after="6pt"
            text-align-last="justify"
            keep-together.within-column="always"
            keep-with-next.within-column="always"
            font-weight="bold">
    <xsl:apply-templates select="subject" mode="show"/>
    <fo:leader/>
    <xsl:value-of select="@since"/>
    <xsl:text> &#x2013; </xsl:text>
    <xsl:value-of select="@till"/>
  </fo:block>
  <fo:block margin-left="0.5in" space-after="12pt"><xsl:apply-templates/></fo:block>
</xsl:template>

<xsl:template match="project/subject[@url]" mode="show" priority="2">
  <fo:basic-link xsl:use-attribute-sets="href-attrs" external-destination="url('{@url}')"><xsl:apply-templates/></fo:basic-link>
</xsl:template>

<xsl:template match="project/subject" mode="show">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="project/subject"/>

<!-- Employments -->

<xsl:template match="employment | consulting">
  <fo:block space-before="12pt"
            space-after="6pt"
            keep-together.within-column="always"
            keep-with-next.within-column="always"
            font-weight="bold">
    <xsl:value-of select="@since"/>
    <xsl:text> &#x2013; </xsl:text>
    <xsl:value-of select="@till"/>
  </fo:block>
  <fo:block margin-left="0.5in" space-after="12pt">
    <fo:block space-after="6pt">
      <xsl:apply-templates select="company"/>
      <xsl:text> &#x2013; </xsl:text>
      <xsl:apply-templates select="position"/>
      <xsl:if test="self::consulting">
        <xsl:text> (consultant)</xsl:text>
      </xsl:if>
      <xsl:text>.</xsl:text>
    </fo:block>
    <xsl:apply-templates select="responsibility"/>
    <xsl:apply-templates select="experience"/>
  </fo:block>
</xsl:template>

<xsl:template match="company[@url]" priority="2">
  <fo:basic-link xsl:use-attribute-sets="href-attrs" external-destination="url('{@url}')" font-weight="bold"><xsl:apply-templates/></fo:basic-link>
</xsl:template>

<xsl:template match="company">
  <fo:inline font-weight="bold"><xsl:apply-templates/></fo:inline>
</xsl:template>

<xsl:template match="responsibility">
  <fo:block space-after="6pt">
    <fo:inline font-style="italic">Responsibility</fo:inline>: <xsl:apply-templates/>
  </fo:block>
</xsl:template>

<xsl:template match="experience">
  <fo:block space-after="6pt"><xsl:apply-templates/></fo:block>
</xsl:template>

<!-- Education -->

<xsl:template match="diploma">
  <fo:block font-size="110%"
            space-before="12pt"
            space-after="6pt"
            text-align-last="justify"
            keep-together.within-column="always"
            keep-with-next.within-column="always"
            font-weight="bold">
    <xsl:apply-templates select="school"/>
    <fo:leader/>
    <xsl:value-of select="@since"/>
    <xsl:text> &#x2013; </xsl:text>
    <xsl:value-of select="@till"/>
  </fo:block>
  <fo:block margin-left="0.5in" space-after="12pt">
    <xsl:apply-templates select="degree"/>
  </fo:block>
</xsl:template>

<xsl:template match="degree">
  <fo:block><xsl:apply-templates/></fo:block>
</xsl:template>


<!-- *************************************************************** -->
<!-- Standard elements                                               -->
<!-- *************************************************************** -->

<!-- Paragraph -->

<xsl:template match="para">
  <fo:block space-after.optimum="6pt"
            hyphenate="true">
    <xsl:apply-templates/>
  </fo:block>
</xsl:template>

<!-- Emphasis -->

<xsl:template match="emphasis">
  <fo:inline>
    <xsl:if test="contains(@role, 'italic') or not (@role)">
      <xsl:attribute name="font-style">italic</xsl:attribute>
    </xsl:if>
    <xsl:if test="contains(@role, 'bold')">
      <xsl:attribute name="font-weight">bold</xsl:attribute>
    </xsl:if>
    <xsl:if test="contains(@role, 'underline')">
      <xsl:attribute name="text-decoration">underline</xsl:attribute>
    </xsl:if>
    <xsl:if test="contains(@role, 'frame')">
      <xsl:attribute name="border">0.5pt solid gray</xsl:attribute>
      <xsl:attribute name="padding">0pt 1pt</xsl:attribute>
    </xsl:if>
    <xsl:if test="contains(@role, 'background')">
      <xsl:attribute name="background-color">silver</xsl:attribute>
      <xsl:attribute name="padding">0pt 1pt</xsl:attribute>
    </xsl:if>
    <xsl:text/><xsl:apply-templates/><xsl:text/>
  </fo:inline>
</xsl:template>

<!-- Hyperlinks -->

<xsl:template match="ulink">
  <fo:basic-link xsl:use-attribute-sets="href-attrs"
      external-destination="url('{@url}')"><xsl:apply-templates/></fo:basic-link>
</xsl:template>

<!-- =============================================================== -->
<!-- Lists: ordered and unordered                                    -->
<!-- =============================================================== -->

<!-- Common list-block template: generic. All subtle processing      -->
<!-- is done in item templates.                                      -->

<xsl:template match="itemizedlist|orderedlist">
  <xsl:variable name="list-type"
                select="name()"/>
  <xsl:variable name="list-level"
                select="count(ancestor-or-self::*[name()=$list-type])"/>

  <fo:list-block provisional-label-separation="3pt"
                 provisional-distance-between-starts="18pt"
                 space-before.optimum="6pt"
                 space-after.optimum="6pt">
    <xsl:apply-templates>
      <xsl:with-param name="list-level" select="$list-level"/>
    </xsl:apply-templates>
  </fo:list-block>
</xsl:template>


<!-- =============================================================== -->
<!-- Item for an unordered list                                      -->

<xsl:template match="itemizedlist/listitem">
  <xsl:param name="list-level"/>

  <fo:list-item>
    <fo:list-item-label end-indent="label-end()">
      <fo:block text-align="start">
        <xsl:choose>
          <xsl:when test="($list-level mod 2) = 1">
            <xsl:text>&#x2022;</xsl:text>  <!-- disk bullet -->
          </xsl:when>

          <xsl:otherwise>
            <xsl:text>-</xsl:text> <!-- hyphen bullet -->
          </xsl:otherwise>

        </xsl:choose>
      </fo:block>
    </fo:list-item-label>

    <fo:list-item-body start-indent="body-start()">
      <fo:block><xsl:apply-templates/></fo:block>
    </fo:list-item-body>
  </fo:list-item>
</xsl:template>


<!-- =============================================================== -->
<!-- Ordered list item                                               -->

<xsl:template match="orderedlist/listitem">
  <xsl:param name="list-level"/>

  <fo:list-item>
    <fo:list-item-label end-indent="label-end()">
      <fo:block text-align="start">
        <xsl:choose>
          <xsl:when test="($list-level mod 2) = 1"> <!-- arabic -->
            <xsl:number format="1."/>
          </xsl:when>

          <xsl:otherwise>  <!-- alphabetic -->
            <xsl:number format="a."/>
          </xsl:otherwise>

        </xsl:choose>
      </fo:block>
    </fo:list-item-label>

    <fo:list-item-body start-indent="body-start()">
      <fo:block><xsl:apply-templates/></fo:block>
    </fo:list-item-body>
  </fo:list-item>

</xsl:template>


<!-- =============================================================== -->
<!-- Definition list                                                 -->
<!-- =============================================================== -->

<xsl:template match="variablelist">
  <fo:block space-before.optimum="6pt"
            space-after.optimum="6pt">
    <xsl:apply-templates/>
  </fo:block>
</xsl:template>

<xsl:template match="varlistentry">
  <fo:block space-before.optimum="6pt"
            keep-together.within-column="always"
            keep-with-next.within-column="always"
            font-weight="bold"
            line-height="1.1">
    <xsl:for-each select="term">
      <fo:block><xsl:apply-templates/></fo:block>
    </xsl:for-each>
  </fo:block>

  <xsl:apply-templates select="listitem"/>
</xsl:template>

<xsl:template match="varlistentry/listitem">
  <fo:block space-before.optimum="3pt"
            start-indent="0.5in">
    <xsl:apply-templates/>
  </fo:block>
</xsl:template>


<!-- *************************************************************** -->
<!-- PDF Bookmarks                                                   -->
<!-- *************************************************************** -->

<xsl:template name="outline">
  <rx:outline>
    <xsl:apply-templates select="person/contactinfo" mode="bookmark-mode"/>
    <xsl:apply-templates select="objective" mode="bookmark-mode"/>
    <xsl:apply-templates select="skills" mode="bookmark-mode"/>
    <xsl:apply-templates select="projects" mode="bookmark-mode"/>
    <xsl:apply-templates select="employments" mode="bookmark-mode"/>
    <xsl:apply-templates select="education" mode="bookmark-mode"/>
    <xsl:apply-templates select="miscellanea" mode="bookmark-mode"/>
  </rx:outline>
</xsl:template>

<xsl:template match="*" mode="bookmark-mode">
  <rx:bookmark internal-destination="{generate-id()}">
    <rx:bookmark-label><xsl:apply-templates select="." mode="title-mode"/></rx:bookmark-label>
  </rx:bookmark>
</xsl:template>

</xsl:stylesheet>
