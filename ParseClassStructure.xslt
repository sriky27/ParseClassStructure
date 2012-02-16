<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:template name="method-list">
    <xsl:param name="className" />
    <xsl:param name="list" /> 
    <xsl:variable name="newlist" select="concat(normalize-space($list), ' ')" /> 
    <xsl:variable name="first" select="substring-before($newlist, ' ')" /> 
    <xsl:variable name="remaining" select="substring-after($newlist, ' ')" /> 
    <xsl:call-template name="method" >
         <xsl:with-param name="className" select="$className" /> 
         <xsl:with-param name="id" select="$first" /> 
    </xsl:call-template>
    <xsl:if test="$remaining">
        <xsl:call-template name="method-list">
                <xsl:with-param name="className" select="$className" /> 
                <xsl:with-param name="list" select="$remaining" /> 
        </xsl:call-template>
    </xsl:if>
</xsl:template>

 <!-- Getting the Enumeration-->
  <xsl:template name="isEnumerationType">
      <xsl:param name="id" /> 
      <xsl:variable name="Valid">
          <xsl:for-each select="//GCC_XML/Enumeration"> <!--//GCC_XML/Enumeration the search xpath pattern-->
             <xsl:choose>
                   <xsl:when test="($id = @id)">
                       <!--Enumeration <xsl:value-of select="@name"/> id : <xsl:value-of select="@id"/>-->
                       insertIntoEnumerationTable(&quot;<xsl:value-of select="@name"/>&quot;);
                   </xsl:when>
            </xsl:choose>
          </xsl:for-each>
      </xsl:variable>
      <xsl:value-of select="$Valid"/>
  </xsl:template>

 <!-- Getting the CvQualifiedType-->
  <xsl:template name="isCvQualifiedType">
      <xsl:param name="id" /> 
      <xsl:variable name="Valid">
          <xsl:for-each select="//GCC_XML/CvQualifiedType"> <!--//GCC_XML/CvQualifiedType  the search xpath pattern-->
             <xsl:choose>
                   <xsl:when test="($id = @id)">
                       <!-- &quotCvQualified Type <xsl:value-of select="@type"/>  id : <xsl:value-of select="@id"/ >&quot-->
                       insertIntoCvQualifiedTable(&quot;<xsl:value-of select="@type"/>&quot;);
                       <xsl:call-template name="type">
                         <xsl:with-param name="id"><xsl:value-of select="@type" /></xsl:with-param>
                       </xsl:call-template>
                   </xsl:when>
            </xsl:choose>
          </xsl:for-each>
      </xsl:variable>
      <xsl:value-of select="$Valid"/>
  </xsl:template>


 <!-- Getting the PointerType-->
  <xsl:template name="isPointerType">
      <xsl:param name="id" /> 
      <xsl:variable name="Valid">
         <xsl:for-each select="//GCC_XML/PointerType"> <!--//GCC_XML/PointerType  the search xpath pattern-->
             <xsl:choose>
                   <xsl:when test="($id = @id)">
                       <!--PointerType <xsl:value-of select="@type"/> id : <xsl:value-of select="@id"/>-->
                       insertIntoPointerTable(&quot;<xsl:value-of select="@type"/>&quot;);
                      <xsl:call-template name="type">
                         <xsl:with-param name="id"><xsl:value-of select="@type" /></xsl:with-param>
                      </xsl:call-template>
                   </xsl:when>
            </xsl:choose>
         </xsl:for-each>
      </xsl:variable>
      <xsl:value-of select="$Valid"/>
  </xsl:template>

 <!-- Getting the Fundamental Type -->
  <xsl:template name="isFundamentalType">
      <xsl:param name="id" /> 
      <xsl:variable name="Valid">
         <xsl:for-each select="//GCC_XML/FundamentalType"> <!--//GCC_XML/FundamentalType  the search xpath pattern-->
             <xsl:choose>
                   <xsl:when test="($id = @id)">
                       <!--Fundamental name <xsl:value-of select="@name"/> id : <xsl:value-of select="@id"/>-->
                       insertIntoFundamentalTable(&quot;<xsl:value-of select="@name"/>&quot;);
                   </xsl:when>
            </xsl:choose>
         </xsl:for-each>
      </xsl:variable>
      <xsl:value-of select="$Valid"/>
  </xsl:template>
  
 <!-- Getting the Getting the type-->  
  <xsl:template name="type" >
     <xsl:param name="id" />
     <xsl:variable name="isFundamental">
        <xsl:call-template name="isFundamentalType">
           <xsl:with-param name="id"><xsl:value-of select="$id" /></xsl:with-param>
        </xsl:call-template>
     </xsl:variable>
     <xsl:variable name="isPointer">
        <xsl:call-template name="isPointerType">
           <xsl:with-param name="id"><xsl:value-of select="$id" /></xsl:with-param>
        </xsl:call-template>
     </xsl:variable>
     <xsl:variable name="isCvQualified">
        <xsl:call-template name="isCvQualifiedType">
           <xsl:with-param name="id"><xsl:value-of select="$id" /></xsl:with-param>
        </xsl:call-template>
     </xsl:variable>
     <xsl:variable name="isEnumeration">
        <xsl:call-template name="isEnumerationType">
           <xsl:with-param name="id"><xsl:value-of select="$id" /></xsl:with-param>
        </xsl:call-template>
     </xsl:variable>
     <xsl:value-of select="$isFundamental" />
     <xsl:value-of select="$isPointer" />
     <xsl:value-of select="$isCvQualified" />
     <xsl:value-of select="$isEnumeration" />
  </xsl:template>  
  
  <!-- Getting the Getting the return of the function-->  
  <xsl:template name="return" >
     <xsl:param name="id" /> 
       Returns <xsl:value-of select="@returns"/>
  </xsl:template>

  <!-- Getting the Getting the method details like argument, return types, access specifier-->  
  <xsl:template name="method" >
     <xsl:param name="className" />
     <xsl:param name="id" /> 
     <xsl:for-each select="//GCC_XML/Method">
        <xsl:choose>
             <xsl:when test="($id = @id)"> 
                 <!-- Method Function: <xsl:value-of select="@name"/> -->
                 <!-- Access Specifier: <xsl:value-of select="@access"/>-->
                 insertIntoFunctionTable(&quot;<xsl:value-of select="$className" />&quot;, &quot;<xsl:value-of select="@name" />&quot;);
                 <xsl:for-each select="Argument">
                     <!--  Argument <xsl:value-of select="@type"/> -->
                     <xsl:call-template name="type">
                         <xsl:with-param name="id"><xsl:value-of select="@type" /></xsl:with-param>
                     </xsl:call-template>
                 </xsl:for-each>
                 <!-- Returns: -->
                 <xsl:call-template name="type">
                         <xsl:with-param name="id"><xsl:value-of select="@returns" /></xsl:with-param>
                     </xsl:call-template>
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
     <xsl:param name="className" />
     <xsl:param name="members" />
     <!-- className : <xsl:value-of select="$className" /> -->
     <xsl:call-template name="method-list">
         <xsl:with-param name="className"><xsl:value-of select="$className" /></xsl:with-param>
         <xsl:with-param name="list"><xsl:value-of select="$members" /></xsl:with-param>
     </xsl:call-template>
  </xsl:template>

  <!-- Getting the class details-->  
  <xsl:template name="class" >
     <xsl:for-each select="GCC_XML/Class">
       <!-- Class <xsl:value-of select="@name"/> -->
       insertIntoClassTable(&quot;<xsl:value-of select="@name"/>&quot;);
       <xsl:call-template name="class_members">
           <xsl:with-param name="className"><xsl:value-of select="@name" /></xsl:with-param>
           <xsl:with-param name="members"><xsl:value-of select="@members" /></xsl:with-param>
       </xsl:call-template>
     </xsl:for-each>
  </xsl:template>  
  
  <!-- Starting point of the parsing the xml like main-->  
  <xsl:template match="/">
     #include "connection.h"
     #include "QDebug"
     
     void init()
     {
          createConnection();
          <xsl:call-template name="class" />
     }
     
     
   
  </xsl:template>
</xsl:stylesheet>
