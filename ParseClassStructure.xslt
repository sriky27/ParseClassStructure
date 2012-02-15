<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:template name="method-list">
    <xsl:param name="list" /> 
    <xsl:variable name="newlist" select="concat(normalize-space($list), ' ')" /> 
    <xsl:variable name="first" select="substring-before($newlist, ' ')" /> 
    <xsl:variable name="remaining" select="substring-after($newlist, ' ')" /> 
    Method <xsl:value-of select="$first" /> 
    <xsl:call-template name="method" >
         <xsl:with-param name="id" select="$first" /> 
    </xsl:call-template>
    <xsl:if test="$remaining">
        <xsl:call-template name="method-list">
                <xsl:with-param name="list" select="$remaining" /> 
        </xsl:call-template>
    </xsl:if>
</xsl:template>

  <xsl:template name="globalEnumeration" >
     <xsl:param name="id" /> 
     <xsl:for-each select="GCC_XML/Enumeration">
       Enumeration <xsl:value-of select="@name"/>
     </xsl:for-each>  
  </xsl:template>  

  <xsl:template name="pointerType">
     <xsl:param name="id" /> 
     <xsl:for-each select="GCC_XML/PointerType">
       PointerType id = <xsl:value-of select="@id"/> type = <xsl:value-of select="@type"/>
     </xsl:for-each>
  </xsl:template>
  
  <xsl:template name="fundamentalType">
      <xsl:param name="id" /> 
      <xsl:for-each select="GCC_XML/FundamentalType">
         FundamentalType <xsl:value-of select="@id"/>
       </xsl:for-each>
  </xsl:template>
  
  <xsl:template name="type" >
     <xsl:value-of select="//GCC_XML"/>
  </xsl:template>  
  
  <xsl:template name="argument" >
       <xsl:param name="name" /> 
       <xsl:for-each select="GCC_XML/Argument">
         Argument <xsl:value-of select="@type"/>
     
       </xsl:for-each>
  </xsl:template>

  <xsl:template name="method" >
     <xsl:param name="id" /> 
     <xsl:for-each select="//GCC_XML/Method">
        <xsl:choose>
             <xsl:when test="($id = @id)"> 
               Method Function <xsl:value-of select="@name"/>
             </xsl:when>
        </xsl:choose>
     </xsl:for-each>
  </xsl:template>

  <xsl:template name="members" >
     <xsl:call-template name="method-list">
         <xsl:with-param name="list"><xsl:value-of select="GCC_XML/Class/@members" /></xsl:with-param>
     </xsl:call-template>   
  </xsl:template>

  <xsl:template name="class_members" >
     <xsl:param name="members" />
     <xsl:call-template name="method-list">
         <xsl:with-param name="list"><xsl:value-of select="$members" /></xsl:with-param>
     </xsl:call-template>
  </xsl:template>

  <xsl:template name="return" >
     <xsl:for-each select="GCC_XML/Method">
       Returns <xsl:value-of select="@returns"/>
     </xsl:for-each>
  </xsl:template>  

  <xsl:template name="class" >
     <xsl:for-each select="GCC_XML/Class">
       Class <xsl:value-of select="@name"/>
       <xsl:call-template name="class_members">
           <xsl:with-param name="members"><xsl:value-of select="@members" /></xsl:with-param>
       </xsl:call-template>
     </xsl:for-each>
  </xsl:template>  
  
  <xsl:template match="/">
     #include "connection.h"
     
     <xsl:call-template name="class" />
   
  </xsl:template>
</xsl:stylesheet>
