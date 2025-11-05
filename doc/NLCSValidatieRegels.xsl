<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:ns="NLCSValidatieRegelsNameSpace">
	<xsl:output method="html" doctype-system="about:legacy-compat" encoding="UTF-8" indent="yes" />

	<xsl:variable name="lowercase" select="'abcdefghijklmnopqrstuvwxyz'"/>
	<xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>
	<xsl:template name="human-string">
		<!--
			Convert a string to a 'human-string'
		 -->
		<xsl:param name="a-string"/>
		<xsl:value-of select="concat(translate(substring(local-name(),1,1), $lowercase, $uppercase),
  						      		 substring(local-name(), 2),
          							 substring(' ', 1 div not(position()=last())))"/>
	</xsl:template>

	<xsl:template name="convert-newlines">
		<xsl:param name="text"/>
	  	<!-- If there's a newline, split and process recursively -->
		<xsl:choose>
			<xsl:when test="contains($text, '&#10;')">
			<!-- Output text before newline -->
			<xsl:value-of select="substring-before($text, '&#10;')"/>
		    <br/>
		    <!-- Recurse on the remaining text -->
		    <xsl:call-template name="convert-newlines">
		      <xsl:with-param name="text" select="substring-after($text, '&#10;')"/>
		    </xsl:call-template>
		    </xsl:when>
			<xsl:otherwise>
		     	<!-- No more newlines, output remaining text -->
				<xsl:value-of select="$text"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="tablefy">
		<!--
			Converts an XML-node to an HTML table structure
		 -->
		<xsl:param name="node"/>
		<xsl:param name="prefix"/>
		<xsl:param name="id"/>
		<xsl:param name="title"/>

		<xsl:if test="$title">
			<b>
				<xsl:attribute name="id">
        			<xsl:value-of select="$id"/>
      			</xsl:attribute>
				<xsl:value-of select="$title"/>
			</b>
			<br/><br/>
		</xsl:if>

		<xsl:if test="count($node) = 0">
			<xsl:call-template name="convert-newlines">
	    		<xsl:with-param name="text" select="concat($prefix, text())"/>
			</xsl:call-template>
		</xsl:if>

		<xsl:if test="count($node) = 1">
			<xsl:for-each select="$node">
				<xsl:call-template name="tablefy">
					<xsl:with-param name="node" select="*"/>
					<xsl:with-param name="prefix" select="concat($prefix, local-name($node), ': ')"/>
					<xsl:with-param name="id" select="''"/>
					<xsl:with-param name="title" select="''"/>
    			</xsl:call-template>
    		</xsl:for-each>
		</xsl:if>

		<xsl:if test="count($node) > 1">
			<table class="validatieDocumentatieTable">

				<xsl:for-each select="$node">
					<tr class="validatieDocumentatieRow">
						<td class="validatieDocumentatieCell">
							<b>
								<xsl:call-template name="human-string">
	    							<xsl:with-param name="a-string" select="local-name()"/>
								</xsl:call-template>
							</b>
						</td>
						<td class="validatieDocumentatieCell">
							<xsl:call-template name="tablefy">
								<xsl:with-param name="node" select="*"/>
								<xsl:with-param name="prefix" select="''"/>
								<xsl:with-param name="id" select="''"/>
								<xsl:with-param name="title" select="''"/>
				    		</xsl:call-template>
				    	</td>
					</tr>
				</xsl:for-each>

			</table>
			<br/>
		</xsl:if>
	</xsl:template>

	<xsl:template match="/">
		<!--
			The actual body of the documentation
		-->
		<html>
			<head>
				<title>NLCS++ Inhoudelijke Validaties - Documentatie</title>
				<link rel="stylesheet" href="NLCSValidatieRegels.css" />
			</head>
			<body>
				<h1>NLCS++ Inhoudelijke validaties - Documentatie</h1>

				<h2>Index</h2>

				<h3>Validatie regels</h3>

				<xsl:for-each select="/ns:NLCSValidatieregels/ns:validatieRegels/ns:validatieRegel">
					<xsl:variable name="nummer" select="@nummer"/>
					<xsl:variable name="naam" select="@naam"/>
					<li>
						<a>
							<xsl:attribute name="href">
			        			<xsl:value-of select="concat('#', $nummer)"/>
			      			</xsl:attribute>
							<xsl:value-of select="$nummer"/> - <xsl:value-of select="$naam"/>
						</a>
					</li>
				</xsl:for-each>

				<h3>Scopes</h3>
				<xsl:for-each select="/ns:NLCSValidatieregels/ns:scopes/ns:scope">
					<xsl:variable name="naam" select="@naam"/>
					<li>
						<a>
							<xsl:attribute name="href">
			        			<xsl:value-of select="concat('#', $naam)"/>
			      			</xsl:attribute>
							<xsl:value-of select="$naam"/>
						</a>
					</li>
				</xsl:for-each>

				<h2>Documentatie</h2>

				<h3>Validatie regels</h3>

					<xsl:for-each select="/ns:NLCSValidatieregels/ns:validatieRegels/ns:validatieRegel">
						<xsl:variable name="nummer" select="@nummer"/>
						<xsl:variable name="naam" select="@naam"/>
						<xsl:call-template name="tablefy">
							<xsl:with-param name="node" select="*"/>
							<xsl:with-param name="prefix" select="''"/>
							<xsl:with-param name="id" select="$nummer"/>
							<xsl:with-param name="title" select="concat($nummer, ' - ', $naam)"/>
      					</xsl:call-template>

					</xsl:for-each>

				<h3>Scopes</h3>

					<xsl:for-each select="/ns:NLCSValidatieregels/ns:scopes/ns:scope">
						<xsl:variable name="naam" select="@naam"/>
						<xsl:call-template name="tablefy">
							<xsl:with-param name="node" select="*"/>
							<xsl:with-param name="prefix" select="''"/>
							<xsl:with-param name="id" select="$naam"/>
							<xsl:with-param name="title" select="$naam"/>
	     				</xsl:call-template>
					</xsl:for-each>
			</body>
		</html>
	</xsl:template>
</xsl:stylesheet>
