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

 <!-- Getting the Enumeration-->
  <xsl:template name="enumeration">
      <xsl:param name="id" /> 
      TypeId <xsl:value-of select="$id"/>
      <xsl:for-each select="//GCC_XML/Enumeration"> <!--//GCC_XML/Enumeration the search xpath pattern-->
             <xsl:choose>
                   <xsl:when test="($id = @id)">
                       $typeName <xsl:value-of select="@id"/>
                   </xsl:when>
            </xsl:choose>
      </xsl:for-each>
  </xsl:template>

 <!-- Getting the CvQualifiedType-->
  <xsl:template name="cvQualifiedType">
      <xsl:param name="id" /> 
      TypeId <xsl:value-of select="$id"/>
      <xsl:for-each select="//GCC_XML/CvQualifiedType"> <!--//GCC_XML/CvQualifiedType  the search xpath pattern-->
             <xsl:choose>
                   <xsl:when test="($id = @id)">
                       $typeName <xsl:value-of select="@id"/>
                   </xsl:when>
            </xsl:choose>
      </xsl:for-each>
  </xsl:template>


 <!-- Getting the PointerType-->
  <xsl:template name="pointerType">
      <xsl:param name="id" /> 
      TypeId <xsl:value-of select="$id"/>
      <xsl:for-each select="//GCC_XML/PointerType"> <!--//GCC_XML/PointerType  the search xpath pattern-->
             <xsl:choose>
                   <xsl:when test="($id = @id)">
                       $typeName <xsl:value-of select="@id"/>
                   </xsl:when>
            </xsl:choose>
      </xsl:for-each>
  </xsl:template>

 <!-- Getting the Fundamental Type -->
  <xsl:template name="fundamentalType">
      <xsl:param name="id" /> 
      TypeId <xsl:value-of select="$id"/>
      <xsl:for-each select="//GCC_XML/FundamentalType"> <!--//GCC_XML/FundamentalType  the search xpath pattern-->
             <xsl:choose>
                   <xsl:when test="($id = @id)">
                       $typeName <xsl:value-of select="@id"/>
                   </xsl:when>
            </xsl:choose>
      </xsl:for-each>
  </xsl:template>
  
 <!-- Getting the Getting the type-->  
  <xsl:template name="type" >
     <xsl:param name="id" />
     TypeId <xsl:value-of select="$id"/>
     <xsl:variable name="fundamentalType" select="'FundamentalType'" />
     <xsl:call-template name="fundamentalType">
           <xsl:with-param name="id"><xsl:value-of select="$id" /></xsl:with-param>
           <xsl:with-param name="typeName"><xsl:value-of select="$fundamentalType" /></xsl:with-param>
     </xsl:call-template>
  </xsl:template>  
  
  <!-- Getting the Getting the return of the function-->  
  <xsl:template name="return" >
     <xsl:for-each select="GCC_XML/Method">
       Returns <xsl:value-of select="@returns"/>
     </xsl:for-each>
  </xsl:template>  

  <!-- Getting the Getting the method-->  
  <xsl:template name="method" >
     <xsl:param name="id" /> 
     <xsl:for-each select="//GCC_XML/Method">
        <xsl:choose>
             <xsl:when test="($id = @id)"> 
                 Method Function <xsl:value-of select="@name"/>
                 <xsl:for-each select="Argument">
                     Argument <xsl:value-of select="@type"/>
                     <xsl:call-template name="type">
                         <xsl:with-param name="id"><xsl:value-of select="@type" /></xsl:with-param>
                     </xsl:call-template>
                 </xsl:for-each>
             </xsl:when>
        </xsl:choose>
     </xsl:for-each>
  </xsl:template>

  <!-- Getting the Getting the member aka functions of the class-->  
  <xsl:template name="members" >
     <xsl:call-template name="method-list">
         <xsl:with-param name="list"><xsl:value-of select="GCC_XML/Class/@members" /></xsl:with-param>
     </xsl:call-template>   
  </xsl:template>

 <!-- Getting the member aka functions of the class-->  
  <xsl:template name="class_members" >
     <xsl:param name="members" />
     <xsl:call-template name="method-list">
         <xsl:with-param name="list"><xsl:value-of select="$members" /></xsl:with-param>
     </xsl:call-template>
  </xsl:template>

  <!-- Getting the class details-->  
  <xsl:template name="class" >
     <xsl:for-each select="GCC_XML/Class">
       Class <xsl:value-of select="@name"/>
       <xsl:call-template name="class_members">
           <xsl:with-param name="members"><xsl:value-of select="@members" /></xsl:with-param>
       </xsl:call-template>
     </xsl:for-each>
  </xsl:template>  
  
  <!-- Starting point of the parsing the xml like main-->  
  <xsl:template match="/">
     #include "connection.h"
     
     <xsl:call-template name="class" />
   
  </xsl:template>
</xsl:stylesheet>
