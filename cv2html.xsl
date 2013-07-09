<?xml version='1.0' encoding='ISO-8859-1'?>

<!-- =============================================================== -->
<!--                                                                 -->
<!-- This stylesheet renders CVs to HTML.                            -->
<!--                                                                 -->
<!--     Author: Nikolai Grigoriev                                   -->
<!--                                                                 -->
<!--    (c) XSL.ru, 2002                                             -->
<!--                                                                 -->
<!-- =============================================================== -->

<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="html"
            version="1.0"
            indent="no"
            encoding="ISO-8859-1"/>

<!-- =============================================================== -->
<!-- Parameters and attribute sets                                   -->
<!-- =============================================================== -->

<xsl:param name="href-color">#0040C0</xsl:param>
<xsl:param name="title-color">#002080</xsl:param>

<!-- *************************************************************** -->
<!-- Top-level template: page layout                                 -->
<!-- *************************************************************** -->

<xsl:template match="resume">
  <html>
    <head>
      <title><xsl:apply-templates select="person" mode="name-only"/></title>
      <style type="text/css">
	    body { font: 11pt serif; line-height: 1.44 }
        a { color: <xsl:value-of select="$href-color"/>; }
        p { text-align: justify;
            margin-top: 6pt; margin-bottom: 6pt; margin-right: 6pt; }
        li {text-align: justify;
            margin-top: 3pt; margin-bottom: 3pt; margin-right: 6pt; }
        h1 {font-family: "sans serif"; text-align: left;
            color: <xsl:value-of select="$title-color"/>;
            margin-right: 6pt; }
        h2 {font-family: "sans serif"; text-align: left;
            color: <xsl:value-of select="$title-color"/>;
            margin-right: 6pt; }
        h3 {font-family: "sans serif"; text-align: left;
            color: <xsl:value-of select="$title-color"/>;
            margin-right: 6pt; }
      </style>
    </head>
    <body bgcolor="white" marginwidth="6" marginheight="6" leftmargin="6" topmargin="6">

      <xsl:apply-templates select="person"/>
      <xsl:apply-templates select="objective"/>
      <xsl:apply-templates select="interests"/>
      <xsl:apply-templates select="skills"/>
      <xsl:apply-templates select="education"/>
      <xsl:apply-templates select="employments"/>
      <xsl:apply-templates select="publications"/>
      <xsl:apply-templates select="projects"/>
      <xsl:apply-templates select="miscellanea"/>

      <hr/>
      <p style="font-size: smaller">
        <xsl:text>&#169; </xsl:text>
        <xsl:apply-templates select="person" mode="name-only"/>
<!--        <xsl:text>, </xsl:text>
		<a href="http://davidashen.net/">http://davidashen.net/</a> -->
      </p>
    </body>
  </html>
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
  <h1><xsl:apply-templates select="." mode="name-only"/></h1>
  <hr/>
  <xsl:apply-templates select="contactinfo"/>
</xsl:template>

<!-- *************************************************************** -->
<!-- Sections                                                        -->
<!-- *************************************************************** -->

<!-- These elements form a section -->

<xsl:template match="contactinfo |
                     objective |
                     skills |
                     interests |
                     projects |
		     publications |
                     employments |
                     education |
                     miscellanea">
  <h2><xsl:apply-templates select="." mode="title-mode"/></h2>
  <div style="margin-left: 36"><xsl:apply-templates select="." mode="content-mode"/></div>
</xsl:template>

<xsl:template match="contactinfo" mode="title-mode">Contact info</xsl:template>
<xsl:template match="objective" mode="title-mode">Objective</xsl:template>
<xsl:template match="skills" mode="title-mode">Skills</xsl:template>
<xsl:template match="interests" mode="title-mode">Research Interests</xsl:template>
<xsl:template match="publications" mode="title-mode">Publications and Patents</xsl:template>
<xsl:template match="projects" mode="title-mode">Representative Projects</xsl:template>
<xsl:template match="employments" mode="title-mode">Employment</xsl:template>
<xsl:template match="education" mode="title-mode">Education</xsl:template>
<xsl:template match="miscellanea" mode="title-mode">Miscellanea</xsl:template>

<xsl:template match="*" mode="content-mode">
  <xsl:apply-templates/>
</xsl:template>


<!-- Contact info -->

<xsl:template match="contactinfo" mode="content-mode">
  <table border="0" cellspacing="6" cellpadding="0">
    <xsl:apply-templates select="email"/>
    <xsl:apply-templates select="address"/>
    <xsl:apply-templates select="phone"/>
    <xsl:apply-templates select="www"/>
  </table>
</xsl:template>


<xsl:template match="contactinfo/email">
  <tr>
    <td align="right"><span class="contact-item">E-mail:</span></td>
    <td><a href="mailto:{.}"><xsl:apply-templates/></a></td>
  </tr>
</xsl:template>

<xsl:template match="contactinfo/address">
  <tr>
    <td align="right"><span class="contact-item">Address:</span></td>
    <td>
      <xsl:apply-templates select="street"/>
      <xsl:text>, </xsl:text>
      <xsl:apply-templates select="zip"/>
      <xsl:text> </xsl:text>
      <xsl:apply-templates select="city"/>
      <xsl:text>, </xsl:text>
      <xsl:apply-templates select="country"/>
    </td>
  </tr>
</xsl:template>

<xsl:template match="contactinfo/phone">
  <tr>
    <td align="right">
      <xsl:if test="not(preceding-sibling::phone)">
        <span class="contact-item">
          <xsl:choose>
            <xsl:when test="following-sibling::phone"><xsl:text>Phones:</xsl:text></xsl:when>
            <xsl:otherwise><xsl:text>Phone:</xsl:text></xsl:otherwise>
          </xsl:choose>
        </span>
      </xsl:if>
    </td>
    <td>
      <xsl:apply-templates/>
      <xsl:if test="@mode">
        <xsl:text> (</xsl:text>
        <xsl:value-of select="@mode"/>
        <xsl:text>)</xsl:text>
      </xsl:if>
    </td>
  </tr>
</xsl:template>

<xsl:template match="contactinfo/www">
  <tr>
    <td align="right"><span class="contact-item">Home page:</span></td>
    <td><a href="{.}"><xsl:apply-templates/></a></td>
  </tr>
</xsl:template>

<!-- Publications -->

<xsl:template match="publications" mode="content-mode">
  <ol><xsl:apply-templates/></ol>
</xsl:template>

<xsl:template match="journalpubs">
  <li style="list-style-type:none"><h3>Journals</h3>
   	<ol><xsl:apply-templates/></ol>
  </li>
</xsl:template>

<xsl:template match="conferencepubs">
  <li style="list-style-type:none"><h3>Conferences</h3>
   	<ol><xsl:apply-templates/></ol>
  </li>
</xsl:template>

<xsl:template match="workshoppubs">
  <li style="list-style-type:none"><h3>Worskhops</h3>
   	<ol><xsl:apply-templates/></ol>
  </li>
</xsl:template>

<xsl:template match="patentpubs">
  <li style="list-style-type:none"><h3>Patents</h3>
   	<ol><xsl:apply-templates/></ol>
  </li>
</xsl:template>

<xsl:template match="publication">
  <li><xsl:apply-templates/></li>
</xsl:template>

<!-- Projects -->

<xsl:template match="projects" mode="content-mode">
  <dl><xsl:apply-templates/></dl>
</xsl:template>

<xsl:template match="project">
  <dt><b><xsl:apply-templates select="subject" mode="show"/></b></dt>
  <dt>
    <xsl:value-of select="@since"/>
    <xsl:text> &#x2013; </xsl:text>
    <xsl:value-of select="@till"/>
  </dt>
  <dd><xsl:apply-templates/><br/></dd>
</xsl:template>

<xsl:template match="project/subject[@url]" mode="show" priority="2">
  <a href="{@url}"><xsl:apply-templates/></a>
</xsl:template>

<xsl:template match="project/subject" mode="show">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="project/subject"/>

<!-- Employments -->

<xsl:template match="employments" mode="content-mode">
  <dl><xsl:apply-templates/></dl>
</xsl:template>

<xsl:template match="employment | consulting">
  <dt>
    <b>
      <xsl:value-of select="@since"/>
      <xsl:text> &#x2013; </xsl:text>
      <xsl:value-of select="@till"/>
    </b>
  </dt>
  <dd>
    <p>
      <b><xsl:apply-templates select="company"/></b>
      <xsl:text> &#x2013; </xsl:text>
      <xsl:apply-templates select="position"/>
      <xsl:if test="self::consulting">
        <xsl:text> (consultant)</xsl:text>
      </xsl:if>
      <xsl:text>.</xsl:text>
    </p>
    <xsl:apply-templates select="responsibility"/>
    <xsl:apply-templates select="experience"/>
  </dd>
</xsl:template>

<xsl:template match="company[@url]" priority="2">
  <a href="{@url}"><xsl:apply-templates/></a>
</xsl:template>

<xsl:template match="company">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="responsibility">
  <p>
    <i>Responsibility</i>: <xsl:apply-templates/>
  </p>
</xsl:template>

<xsl:template match="experience">
  <p><xsl:apply-templates/></p>
</xsl:template>


<!-- Education -->

<xsl:template match="education" mode="content-mode">
  <dl><xsl:apply-templates/></dl>
</xsl:template>

<xsl:template match="diploma">
  <dt>
    <b>
      <xsl:apply-templates select="school"/>
      <xsl:text> (</xsl:text>
      <xsl:value-of select="@since"/>
      <xsl:text> &#x2013; </xsl:text>
      <xsl:value-of select="@till"/>
      <xsl:text>)</xsl:text>
    </b>
  </dt>
  <dd>
    <xsl:apply-templates select="degree"/>
    <xsl:apply-templates select="award"/>
  </dd>
</xsl:template>

<xsl:template match="degree">
  <p><xsl:apply-templates/></p>
</xsl:template>


<xsl:template match="award">
  <p><b><xsl:value-of select="@when"/></b> - <xsl:apply-templates/></p>
</xsl:template>

<!-- *************************************************************** -->
<!-- Standard elements                                               -->
<!-- *************************************************************** -->

<!-- Paragraph -->

<xsl:template match="para">
  <p><xsl:apply-templates/></p>
</xsl:template>

<!-- Emphasis -->

<xsl:template match="emphasis[not(@role)]">
  <i><xsl:apply-templates/></i>
</xsl:template>

<xsl:template match="emphasis[@role]">
  <xsl:variable name="italics-applied">
    <xsl:choose>
      <xsl:when test="contains(@role, 'italic')"><i><xsl:apply-templates/></i></xsl:when>
      <xsl:otherwise><xsl:apply-templates/></xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="bold-applied">
    <xsl:choose>
      <xsl:when test="contains(@role, 'bold')"><b><xsl:copy-of select="$italics-applied"/></b></xsl:when>
      <xsl:otherwise><xsl:copy-of select="$italics-applied"/></xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="contains(@role, 'underline')"><b><xsl:copy-of select="$bold-applied"/></b></xsl:when>
    <xsl:otherwise><xsl:copy-of select="$bold-applied"/></xsl:otherwise>
  </xsl:choose>

</xsl:template>


<!-- Hyperlinks -->

<xsl:template match="ulink">
  <a href="{@url}"><xsl:apply-templates/></a>
</xsl:template>

<!-- =============================================================== -->
<!-- Lists: ordered and unordered                                    -->
<!-- =============================================================== -->

<xsl:template match="itemizedlist">
  <ul><xsl:apply-templates/></ul>
</xsl:template>

<xsl:template match="orderedlist">
  <ol><xsl:apply-templates/></ol>
</xsl:template>

<xsl:template match="itemizedlist/listitem | orderedlist/listitem">
  <li><xsl:apply-templates/></li>
</xsl:template>

<xsl:template match="variablelist">
  <dl><xsl:apply-templates/></dl>
</xsl:template>

<xsl:template match="varlistentry">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="varlistentry/term">
  <dt><xsl:apply-templates/></dt>
</xsl:template>

<xsl:template match="varlistentry/listitem">
  <dd><xsl:apply-templates/></dd>
</xsl:template>

</xsl:stylesheet>

