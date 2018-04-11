<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" 
      xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
      xmlns:odm="http://www.cdisc.org/ns/odm/v1.3" 
      xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
      xmlns:def="http://www.cdisc.org/ns/def/v2.0" 
      xmlns:xlink="http://www.w3.org/1999/xlink" 
      xml:lang="en"
      xmlns:fo="http://www.w3.org/1999/XSL/Format"
      exclude-result-prefixes="def xlink odm xsi fo">
   <xsl:output method="xml" indent="yes" encoding="utf-8" version="1.0"/>

   <!--
Comments will be displayed, unless the displayComments parameter has a value of 0.
This parameter can be set in the XSLT processor. 
-->
   <xsl:param name="displayComments"/>


   <!-- ********************************************************************************* -->
   <!-- File:   xml2fo.xsl                                                                -->
   <!-- Description: This stylesheet converts V2.0.0 compliant define.xml to fo format    -->
   <!-- the stylesheet is adapted from define2-0-0.xsl file from CDISC XML V2.0 standard  -->
   <!-- package                                                                           -->
   <!--                                                                                   -->
   <!-- ********************************************************************************* -->
   <xsl:variable name="g_stylesheetVersion" select="'2014-08-08'"/>
   <!-- ********************************************************************************* -->

   <!--
Global Variables
-->
   <!-- XSLT 1.0 does not support the function 'upper-case()'
so we need to use the 'translate() function, which uses the variables $lowercase and $uppercase.
   Remark that this is not a XSLT problem, but a problem that browsers like IE do still not support XSLT 2.0 yet -->
   <xsl:variable name="g_lowercase" select="'abcdefghijklmnopqrstuvwxyz'"/>
   <xsl:variable name="g_uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>

   <xsl:variable name="g_xndMetaDataVersion" select="/odm:ODM/odm:Study[1]/odm:MetaDataVersion[1]"/>
   <xsl:variable name="g_seqItemGroupDefs" select="$g_xndMetaDataVersion/odm:ItemGroupDef"/>
   <xsl:variable name="g_seqItemDefs" select="$g_xndMetaDataVersion/odm:ItemDef"/>
   <xsl:variable name="g_seqCodeLists" select="$g_xndMetaDataVersion/odm:CodeList"/>
   <xsl:variable name="g_seqValueListDefs" select="$g_xndMetaDataVersion/def:ValueListDef"/>
   <xsl:variable name="g_seqMethodDefs" select="$g_xndMetaDataVersion/odm:MethodDef"/>
   <xsl:variable name="g_seqCommentDefs" select="$g_xndMetaDataVersion/def:CommentDef"/>
   <xsl:variable name="g_seqWhereClauseDefs" select="$g_xndMetaDataVersion/def:WhereClauseDef"/>
   <xsl:variable name="g_seqleafs" select="$g_xndMetaDataVersion/def:leaf"/>
   <xsl:variable name="g_StandardName" select="$g_xndMetaDataVersion/@def:StandardName"/>
   <xsl:variable name="g_StandardVersion" select="$g_xndMetaDataVersion/@def:StandardVersion"/>

   <xsl:variable name="REFTYPE_PHYSICALPAGE">PhysicalRef</xsl:variable>
   <xsl:variable name="REFTYPE_NAMEDDESTINATION">NamedDestination</xsl:variable>

   <xsl:variable name="g_nItemGroupDefs" select="count($g_seqItemGroupDefs)"/>
   <xsl:variable name="g_nItemGroupDefsAnalysis" select="count($g_seqItemGroupDefs[@Purpose='Analysis'])"/>
   <xsl:variable name="g_nItemGroupDefsTabulation" select="count($g_seqItemGroupDefs[@Purpose='Tabulation'])"/>
   <xsl:variable name="g_ItemGroupDefPurpose">
      <xsl:choose>
         <xsl:when test="($g_nItemGroupDefsAnalysis = $g_nItemGroupDefs) or ($g_nItemGroupDefsTabulation = $g_nItemGroupDefs)">
            <xsl:choose>
               <xsl:when test="($g_nItemGroupDefsTabulation = $g_nItemGroupDefs)">
                  <xsl:text>Tabulation</xsl:text>
               </xsl:when>
               <xsl:when test="($g_nItemGroupDefsAnalysis = $g_nItemGroupDefs)">
                  <xsl:text>Analysis</xsl:text>
               </xsl:when>
               <xsl:otherwise />
            </xsl:choose>
         </xsl:when>
         <xsl:otherwise>
            <xsl:text></xsl:text>
         </xsl:otherwise>
      </xsl:choose>  
   </xsl:variable>

   <xsl:attribute-set name="headfoot">
      <xsl:attribute name="font-family">Times Roman</xsl:attribute>
      <xsl:attribute name="font-size">10pt</xsl:attribute>	
      <xsl:attribute name="line-height">1em + 6pt</xsl:attribute>		
   </xsl:attribute-set>

   <xsl:attribute-set name="caption">
      <xsl:attribute name="font-family">Times Roman</xsl:attribute>
      <xsl:attribute name="font-size">16pt</xsl:attribute>
      <xsl:attribute name="color">#800000</xsl:attribute>
      <xsl:attribute name="font-weight">bold</xsl:attribute>      
      <xsl:attribute name="line-height">18pt</xsl:attribute>	
      <xsl:attribute name="keep-with-next">always</xsl:attribute>	 
   </xsl:attribute-set>


   <xsl:attribute-set name="wholeTable">

      <xsl:attribute name="table-layout">fixed</xsl:attribute>
      <xsl:attribute name="width">100%</xsl:attribute>
      <!--xsl:attribute name="border-spacing">4px</xsl:attribute-->
      <xsl:attribute name="background-color">#EEEEEE</xsl:attribute>
      <xsl:attribute name="margin-top">5px</xsl:attribute>
      <xsl:attribute name="border-collapse">collapse</xsl:attribute>
      <!--xsl:attribute name="padding">5px</xsl:attribute-->
      <xsl:attribute name="empty-cells">show</xsl:attribute>	
      <xsl:attribute name="font-family">Times Roman</xsl:attribute>
      <xsl:attribute name="font-size">10pt</xsl:attribute>
      <xsl:attribute name="vertical-align">top</xsl:attribute>
   </xsl:attribute-set>

   <xsl:attribute-set name="trh">
      <xsl:attribute name="font-weight">bold</xsl:attribute>
      <xsl:attribute name="text-align">left</xsl:attribute>
      <xsl:attribute name="background-color">#6699CC</xsl:attribute>	
      <xsl:attribute name="color">White</xsl:attribute>
      <xsl:attribute name="font-size">11pt</xsl:attribute>
   </xsl:attribute-set>

   <xsl:attribute-set name="tr">	
      <xsl:attribute name="color">Black</xsl:attribute>
   </xsl:attribute-set>

   <xsl:attribute-set name="tre">	
      <xsl:attribute name="background-color">#6699CC</xsl:attribute>
      <xsl:attribute name="color">Black</xsl:attribute>
   </xsl:attribute-set>

   <xsl:attribute-set name="tcl">
      <xsl:attribute name="border">1px solid #000000</xsl:attribute>
      <xsl:attribute name="padding">3px</xsl:attribute>
      <xsl:attribute name="line-height">120%</xsl:attribute>
      <xsl:attribute name="text-align">left</xsl:attribute>   
   </xsl:attribute-set>

   <xsl:attribute-set name="tcc">
      <xsl:attribute name="border">1px solid #000000</xsl:attribute>
      <xsl:attribute name="padding">3px</xsl:attribute>
      <xsl:attribute name="line-height">120%</xsl:attribute>
      <xsl:attribute name="text-align">center</xsl:attribute>   
   </xsl:attribute-set>

   <xsl:attribute-set name="tcr">
      <xsl:attribute name="border">1px solid #000000</xsl:attribute>
      <xsl:attribute name="padding">3px</xsl:attribute>
      <xsl:attribute name="line-height">120%</xsl:attribute>
      <xsl:attribute name="text-align">right</xsl:attribute>   
   </xsl:attribute-set>



   <!-- Create Bookmarks and initialize page dimensions      -->
   <xsl:template match="/">
      <fo:root xmlns:fo="http://www.w3.org/1999/XSL/Format">
         <fo:layout-master-set>
            <fo:simple-page-master page-height="216mm" page-width="279mm"  margin="10mm 1in 10mm 1in" master-name="PageMaster">
               <fo:region-body margin="20mm 0mm 10mm 0mm"/>
               <fo:region-before extent="2cm"/>
               <fo:region-after extent="1cm"/>
            </fo:simple-page-master>
            <!-- With above options 1in margins left & right the total page width can be 22.8 -->
         </fo:layout-master-set>

         <fo:bookmark-tree >

            <fo:bookmark starting-state="hide" internal-destination="Datasets_table">
               <fo:bookmark-title>        
                  <xsl:text>Study </xsl:text>
                  <xsl:value-of select="/odm:ODM/odm:Study/odm:GlobalVariables/odm:StudyName"/>
               </fo:bookmark-title>

               <!-- **************************************************** -->
               <!-- ************** Datasets **************************** -->
               <!-- **************************************************** -->

               <!-- Following code seems useless, but it ensures the following bookmark title in for destination Datasets_table work correctly-->
               <xsl:for-each select="$g_seqItemGroupDefs">
                        <xsl:choose>
                           <xsl:when test="@SASDatasetName">
                           </xsl:when>
                           <xsl:otherwise>
                           </xsl:otherwise>
                        </xsl:choose>
               </xsl:for-each>                 
               
      
               <fo:bookmark starting-state="hide" internal-destination="Datasets_table">
               <fo:bookmark-title><xsl:value-of select="$g_ItemGroupDefPurpose"/> Datasets</fo:bookmark-title>


                  <xsl:for-each select="$g_seqItemGroupDefs">
                     <fo:bookmark starting-state="hide">               
                        <xsl:attribute name="internal-destination">IG.<xsl:value-of select="@OID"/></xsl:attribute>
                        <fo:bookmark-title>
                           <xsl:choose>
                              <xsl:when test="@SASDatasetName">
                                 <xsl:value-of select="concat(./odm:Description/odm:TranslatedText, ' (', @SASDatasetName, ')')"/>
                              </xsl:when>
                              <xsl:otherwise>
                                 <xsl:value-of select="concat(./odm:Description/odm:TranslatedText, ' (', @Name, ')')"/>
                              </xsl:otherwise>
                           </xsl:choose>
                        </fo:bookmark-title>
                     </fo:bookmark>              
                  </xsl:for-each>
               </fo:bookmark>



               <!-- **************************************************** -->
               <!-- **************** Value Lists *********************** -->
               <!-- **************************************************** -->
               <xsl:if test="$g_seqValueListDefs">

                  <fo:bookmark starting-state="hide" internal-destination="valuemeta">
                     <xsl:choose>
                        <xsl:when test="$g_ItemGroupDefPurpose='Analysis'">
                           <fo:bookmark-title>Parameter Value Level Metadata</fo:bookmark-title>
                        </xsl:when>
                        <xsl:otherwise>
                           <fo:bookmark-title>Value Level Metadata</fo:bookmark-title>
                        </xsl:otherwise>
                     </xsl:choose>
                     <xsl:for-each select="$g_seqValueListDefs">


                        <xsl:variable name="valueListDefOID" select="@OID"/>
                        <xsl:variable name="valueListRef"
                              select="//odm:ItemDef/def:ValueListRef[@ValueListOID=$valueListDefOID]"/>
                        <xsl:variable name="itemDefOID" select="$valueListRef/../@OID"/>
                        <fo:bookmark starting-state="hide">
                           <xsl:attribute name="internal-destination">VL.<xsl:value-of select="@OID"/></xsl:attribute>
                           <fo:bookmark-title>
                              <xsl:choose>
                                 <xsl:when test="//odm:ItemRef[@ItemOID=$itemDefOID]/../@Name">
                                    <xsl:value-of select="//odm:ItemRef[@ItemOID=$itemDefOID]/../@Name"/>
                                 </xsl:when>
                                 <xsl:otherwise>
                                    <xsl:value-of select="//odm:ItemRef[@ItemOID=$itemDefOID]/../@OID"/>
                                 </xsl:otherwise>
                              </xsl:choose>

                              <xsl:text> [</xsl:text>
                              <xsl:value-of select="$valueListRef/../@Name"/>
                              <xsl:text>]</xsl:text>
                           </fo:bookmark-title>
                        </fo:bookmark>
                     </xsl:for-each>
                  </fo:bookmark>
               </xsl:if>

               <xsl:if test="$g_seqCodeLists">
                  <fo:bookmark starting-state="hide" internal-destination="decodelist">
                     <fo:bookmark-title>Controlled Terminology</fo:bookmark-title>

                     <xsl:if test="$g_seqCodeLists[odm:CodeListItem|odm:EnumeratedItem]">
                        <fo:bookmark starting-state="hide" internal-destination="decodelist">
                           <fo:bookmark-title>Controlled Terms</fo:bookmark-title>

                           <xsl:for-each select="$g_seqCodeLists[odm:CodeListItem|odm:EnumeratedItem]">
                              <fo:bookmark starting-state="hide"> 
                                 <xsl:attribute name="internal-destination">CL.<xsl:value-of select="@OID"/></xsl:attribute>
                                 <fo:bookmark-title><xsl:value-of select="@Name"/></fo:bookmark-title>
                              </fo:bookmark>
                           </xsl:for-each>
                        </fo:bookmark>
                     </xsl:if>

                     <xsl:if test="$g_seqCodeLists[odm:ExternalCodeList]">
                        <fo:bookmark starting-state="hide" internal-destination="externaldictionary">
                           <fo:bookmark-title>External Dictionaries</fo:bookmark-title>

                           <xsl:for-each select="$g_seqCodeLists[odm:ExternalCodeList]">
                              <fo:bookmark starting-state="hide"> 
                                 <xsl:attribute name="internal-destination">CL.<xsl:value-of select="@OID"/></xsl:attribute>
                                 <fo:bookmark-title><xsl:value-of select="@Name"/></fo:bookmark-title>
                              </fo:bookmark>
                           </xsl:for-each>
                        </fo:bookmark>
                     </xsl:if>

                  </fo:bookmark>
               </xsl:if>
            </fo:bookmark>
         </fo:bookmark-tree>


         <fo:page-sequence master-reference="PageMaster">
            <fo:static-content flow-name="xsl-region-before">
               <fo:block xsl:use-attribute-sets="headfoot"> 
                  <fo:block text-align-last="justify"> Study <xsl:value-of select="/odm:ODM/odm:Study/odm:GlobalVariables/odm:StudyName"/>: Data Definitions
                     <fo:leader leader-pattern="space" /> Date of document generation: <xsl:value-of select="/odm:ODM/@CreationDateTime"/>
                  </fo:block>
                  <fo:block text-align="end"> Stylesheet version: <xsl:value-of select="$g_stylesheetVersion"/>
                  </fo:block>
               </fo:block>
            </fo:static-content>
            <fo:static-content flow-name="xsl-region-after">
               <fo:block text-align="end" xsl:use-attribute-sets="headfoot">Page <fo:page-number/>
               </fo:block>
            </fo:static-content>
            <fo:flow flow-name="xsl-region-body" >
               <xsl:apply-templates/>
            </fo:flow>
         </fo:page-sequence>
      </fo:root>
   </xsl:template>

   <xsl:template match="/odm:ODM/odm:Study/odm:GlobalVariables"/>

   <xsl:template match="/odm:ODM/odm:Study/odm:MetaDataVersion">


      <fo:block xsl:use-attribute-sets="caption" id="Datasets_table"> <xsl:value-of select="$g_ItemGroupDefPurpose"/> Datasets for Study 
         <xsl:value-of select="/odm:ODM/odm:Study/odm:GlobalVariables/odm:StudyName"/> (<xsl:value-of select="$g_StandardName"/>
         <xsl:text/>
         <xsl:value-of select="$g_StandardVersion"/>)
      </fo:block>
      <fo:table  xsl:use-attribute-sets="wholeTable" >
         <fo:table-column column-width="2.2cm"/>
         <fo:table-column column-width="3.2cm"/>
         <fo:table-column column-width="3.1cm"/>
         <fo:table-column column-width="3cm"/>
         <fo:table-column column-width="1.8cm"/>
         <fo:table-column column-width="2.3cm"/>
         <fo:table-column column-width="2.4cm"/>
         <fo:table-column column-width="4.8cm"/>

         <fo:table-header >
            <fo:table-row xsl:use-attribute-sets="trh">
               <fo:table-cell xsl:use-attribute-sets="tcl">
                  <fo:block>Dataset</fo:block>
               </fo:table-cell>
               <fo:table-cell xsl:use-attribute-sets="tcl">
                  <fo:block>Description</fo:block>
               </fo:table-cell>
               <fo:table-cell xsl:use-attribute-sets="tcl">
                  <fo:block>Class</fo:block>
               </fo:table-cell>
               <fo:table-cell xsl:use-attribute-sets="tcl">
                  <fo:block>Structure</fo:block>
               </fo:table-cell>
               <fo:table-cell xsl:use-attribute-sets="tcl">
                  <fo:block>Purpose</fo:block>
               </fo:table-cell>
               <fo:table-cell xsl:use-attribute-sets="tcl">
                  <fo:block>Keys</fo:block>
               </fo:table-cell>
               <fo:table-cell xsl:use-attribute-sets="tcl">
                  <fo:block>Location</fo:block>
               </fo:table-cell>
               <fo:table-cell xsl:use-attribute-sets="tcl">
                  <fo:block>Documentation</fo:block>
               </fo:table-cell>
            </fo:table-row>
         </fo:table-header>


         <fo:table-body  >
            <xsl:for-each select="$g_seqItemGroupDefs">
               <xsl:call-template name="ItemGroupDefs"/>
            </xsl:for-each>
         </fo:table-body>
      </fo:table>

      <xsl:for-each select="$g_seqItemGroupDefs[@Purpose='Analysis']">
         <xsl:call-template name="ItemRefADaM"/>
      </xsl:for-each>

      <xsl:for-each select="$g_seqItemGroupDefs[@Purpose!='Analysis']">
         <xsl:call-template name="ItemRefSDTM"/>
      </xsl:for-each>      

      <xsl:call-template name="AppendixValueList"/>

      <!-- ***************************************************************** -->
      <!-- Create the Code Lists, Enumerated Items and External Dictionaries -->
      <!-- ***************************************************************** -->
      <xsl:call-template name="AppendixCodeLists"/>
      <xsl:call-template name="AppendixExternalCodeLists"/>

   </xsl:template>

   <!-- Template: ItemGroupDefs                              -->
   <xsl:template name="ItemGroupDefs">
      <xsl:param name="rowNum"/>
      <fo:table-row   xsl:use-attribute-sets="tr" page-break-inside="avoid">
         <xsl:call-template name="rowClass">
            <xsl:with-param name="rowNum" select="position()"/>
         </xsl:call-template>
         <fo:table-cell xsl:use-attribute-sets="tcl">
            <fo:block>
               <xsl:value-of select="@Name"/>
            </fo:block>
         </fo:table-cell>
         <!-- *************************************************************** -->
         <!-- Link each ItemGroup to its corresponding section in the define  -->
         <!-- *************************************************************** -->
         <fo:table-cell  xsl:use-attribute-sets="tcl">
            <fo:block>
               <fo:basic-link color="blue" text-decoration="underline">
                  <xsl:attribute name="internal-destination">IG.<xsl:value-of select="@OID"/>
                  </xsl:attribute>
                  <xsl:value-of select="odm:Description/odm:TranslatedText"/>
               </fo:basic-link>
               <xsl:if test="odm:Alias[@Context='DomainDescription']">
                  <xsl:text> (</xsl:text><xsl:value-of select="odm:Alias/@Name"/><xsl:text>)</xsl:text>
               </xsl:if>
            </fo:block>
         </fo:table-cell>

         <fo:table-cell  xsl:use-attribute-sets="tcl">
            <fo:block>
               <xsl:value-of select="@def:Class"/>
            </fo:block>
         </fo:table-cell>

         <fo:table-cell  xsl:use-attribute-sets="tcl">
            <fo:block>
               <xsl:value-of select="@def:Structure"/>
            </fo:block>
         </fo:table-cell>

         <fo:table-cell  xsl:use-attribute-sets="tcl">
            <fo:block>
               <xsl:value-of select="@Purpose"/>
            </fo:block>
         </fo:table-cell>

         <fo:table-cell  xsl:use-attribute-sets="tcl">
            <fo:block>
               <xsl:call-template name="displayKeys"/>
            </fo:block>
         </fo:table-cell>

         <fo:table-cell  xsl:use-attribute-sets="tcl">
            <fo:block>
               <fo:basic-link color="blue" text-decoration="underline">
                  <xsl:attribute name="external-destination">
                     <xsl:value-of select="def:leaf/@xlink:href"/>
                  </xsl:attribute>
                  <xsl:value-of select="def:leaf/def:title"/>
               </fo:basic-link>      
            </fo:block>
         </fo:table-cell>

         <fo:table-cell  xsl:use-attribute-sets="tcl">
            <fo:block>
               <xsl:if test="@def:CommentOID">
                  <xsl:call-template name="displayItemGroupComment"/>
               </xsl:if>
            </fo:block>
         </fo:table-cell>
      </fo:table-row>
   </xsl:template>

   <!-- Template:    displayKeys                             -->
   <xsl:template name="displayKeys">
      <xsl:variable name="KeySequence" select="odm:ItemRef/@KeySequence"/>
      <xsl:variable name="n_keys" select="count($KeySequence)"/>
      <xsl:for-each select="odm:ItemRef">
         <xsl:sort select="@KeySequence" data-type="number" order="ascending"/>
         <xsl:if test="@KeySequence[ .!='' ]">
            <xsl:variable name="ItemOID" select="@ItemOID"/>
            <xsl:variable name="Name" select="$g_seqItemDefs[@OID=$ItemOID]"/>
            <xsl:value-of select="$Name/@Name"/>
            <xsl:if test="@KeySequence &lt; $n_keys">, </xsl:if>
         </xsl:if>
      </xsl:for-each>
   </xsl:template>

   <!-- Template:    displayItemGroupComment                 -->
   <xsl:template name="displayItemGroupComment">
      <xsl:if test="@def:CommentOID">
         <xsl:variable name="cmntOID" select="@def:CommentOID"/>
         <xsl:variable name="Comment" select="$g_seqCommentDefs[@OID=$cmntOID]"/>
         <xsl:variable name="ItemGroupComment">
            <xsl:value-of select="normalize-space($g_seqCommentDefs[@OID=$cmntOID]/odm:Description/odm:TranslatedText)"/>
         </xsl:variable> 
         <xsl:value-of select="$ItemGroupComment"/>
         <xsl:for-each select="$Comment/def:DocumentRef">
            <xsl:variable name="leafID" select="@leafID"/>
            <xsl:variable name="leaf" select="$g_seqleafs[@ID=$leafID]"/>
            <fo:block>
               <fo:basic-link color="blue" text-decoration="underline">
                  <xsl:attribute name="external-destination">
                     <xsl:value-of select="$leaf/@xlink:href"/>
                  </xsl:attribute>
                  <xsl:value-of select="$leaf/def:title"/>
               </fo:basic-link>
            </fo:block>
         </xsl:for-each>
      </xsl:if>
   </xsl:template>

   <!-- Template: ItemRefADaM                                -->
   <xsl:template name="ItemRefADaM">
      <fo:block break-before="page"/> 
      <fo:block xsl:use-attribute-sets="caption" id="IG.{@OID}">
         <xsl:call-template name="linkXPT"/>
      </fo:block>   


      <fo:table xsl:use-attribute-sets="wholeTable">
         <fo:table-column column-width="2.5cm"/>
         <fo:table-column column-width="3cm"/>
         <fo:table-column column-width="1.8cm"/>
         <fo:table-column column-width="2.5cm"/>
         <fo:table-column column-width="5cm"/>
         <fo:table-column column-width="8cm"/>

         <fo:table-header>
            <fo:table-row xsl:use-attribute-sets="trh" >
               <fo:table-cell xsl:use-attribute-sets="tcl">
                  <fo:block>Variable</fo:block>
               </fo:table-cell >
               <fo:table-cell xsl:use-attribute-sets="tcl">
                  <fo:block>Label</fo:block>
               </fo:table-cell>
               <fo:table-cell xsl:use-attribute-sets="tcc">
                  <fo:block>Type</fo:block>
               </fo:table-cell>
               <fo:table-cell xsl:use-attribute-sets="tcr">
                  <fo:block>Length / Display Format</fo:block>
               </fo:table-cell>
               <fo:table-cell xsl:use-attribute-sets="tcl">
                  <fo:block>Controlled Terms or Format</fo:block>
               </fo:table-cell>
               <fo:table-cell xsl:use-attribute-sets="tcl">
                  <fo:block>Source/Derivation/Comment</fo:block>
               </fo:table-cell>
            </fo:table-row>
         </fo:table-header>
         <fo:table-body>
            <xsl:for-each select="./odm:ItemRef">

               <xsl:sort data-type="number" order="ascending" select="@OrderNumber"/>
               <xsl:variable name="itemRef" select="."/>
               <xsl:variable name="itemDefOid" select="@ItemOID"/>
               <xsl:variable name="itemDef" select="../../odm:ItemDef[@OID=$itemDefOid]"/>

               <fo:table-row  xsl:use-attribute-sets="tr" page-break-inside="avoid">
                  <!--xsl:attribute name="id">
                     <xsl:value-of select="$itemDef/@OID"/>
                  </xsl:attribute-->
                  <xsl:call-template name="rowClass">
                     <xsl:with-param name="rowNum" select="position()"/>
                  </xsl:call-template>                  

                  <fo:table-cell xsl:use-attribute-sets="tcl">
                     <fo:block>
                        <xsl:attribute name="id">
                           <xsl:value-of select="../@OID"/>.<xsl:value-of select="$itemDef/@OID"/>
                        </xsl:attribute>
                        <xsl:choose>
                           <xsl:when test="$itemDef/def:ValueListRef/@ValueListOID!=''">
                              <fo:basic-link color="blue" text-decoration="underline">
                                 <xsl:attribute name="internal-destination">VL.<xsl:value-of select="$itemDef/def:ValueListRef/@ValueListOID"/></xsl:attribute>
                                 <xsl:value-of select="$itemDef/@Name"/> 
                              </fo:basic-link>
                           </xsl:when>
                           <xsl:otherwise>
                              <xsl:value-of select="$itemDef/@Name"/>   
                           </xsl:otherwise>
                        </xsl:choose>                                                   
                     </fo:block>
                  </fo:table-cell>

                  <fo:table-cell xsl:use-attribute-sets="tcl">
                     <fo:block>
                        <xsl:value-of select="$itemDef/odm:Description/odm:TranslatedText"/>
                     </fo:block>
                  </fo:table-cell>              

                  <fo:table-cell xsl:use-attribute-sets="tcc">
                     <fo:block>
                        <xsl:value-of select="$itemDef/@DataType"/>
                     </fo:block>
                  </fo:table-cell>

                  <fo:table-cell xsl:use-attribute-sets="tcr">
                     <fo:block>
                        <xsl:choose>
                           <xsl:when test="$itemDef/@def:DisplayFormat">
                              <xsl:value-of select="$itemDef/@def:DisplayFormat"/>
                           </xsl:when>
                           <xsl:otherwise>
                              <xsl:value-of select="$itemDef/@Length"/>
                           </xsl:otherwise>
                        </xsl:choose>
                     </fo:block>
                  </fo:table-cell>

                  <!-- *************************************************** -->
                  <!-- Hypertext Link to the Decode Appendix               -->
                  <!-- *************************************************** -->
                  <fo:table-cell xsl:use-attribute-sets="tcl">
                     <fo:block>
                        <xsl:call-template name="linkDecodeList">
                           <xsl:with-param name="itemDef" select="$itemDef"/>
                        </xsl:call-template>

                        <xsl:call-template name="displayISO8601">
                           <xsl:with-param name="itemDef" select="$itemDef"/>
                        </xsl:call-template>
                     </fo:block>
                  </fo:table-cell>

                  <!-- *************************************************** -->
                  <!--                 Comments Column                     -->
                  <!-- *************************************************** -->
                  <fo:table-cell xsl:use-attribute-sets="tcl">
                     <fo:block> 

                        <xsl:variable name="Origin" select="$itemDef/def:Origin"/>
                        <xsl:if test="$Origin">
                           <xsl:choose>
                              <xsl:when test="$Origin[@Type='Predecessor']"> Predecessor: <xsl:value-of
                                       select="$itemDef/def:Origin/odm:Description/odm:TranslatedText"/>
                              </xsl:when>
                              <xsl:otherwise>
                                 <xsl:value-of select="$Origin/@Type"/>
                                 <xsl:text>: </xsl:text>
                              </xsl:otherwise>
                           </xsl:choose>
                        </xsl:if>

                        <xsl:variable name="methodOID" select="$itemRef/@MethodOID"/>
                        <xsl:if test="$methodOID">
                           <xsl:call-template name="displayItemDefMethod">
                              <xsl:with-param name="itemRef" select="$itemRef"/>
                           </xsl:call-template>
                        </xsl:if>

                        <xsl:variable name="cmntOID" select="$itemDef/@def:CommentOID"/>
                        <xsl:if test="$cmntOID">
                           <xsl:call-template name="displayItemComment">
                              <xsl:with-param name="itemDef" select="$itemDef"/>
                           </xsl:call-template>
                        </xsl:if>

                     </fo:block>
                  </fo:table-cell>

               </fo:table-row>
            </xsl:for-each>
         </fo:table-body>
      </fo:table>

   </xsl:template>

   <!-- Template: ItemRefSDTM                                -->
   <xsl:template name="ItemRefSDTM">

      <fo:block break-before="page"/> 
      <fo:block xsl:use-attribute-sets="caption" id="IG.{@OID}">
         <xsl:call-template name="linkXPT"/>
      </fo:block>   


      <fo:table xsl:use-attribute-sets="wholeTable">
         <fo:table-column column-width="2.5cm"/>
         <fo:table-column column-width="3cm"/>
         <fo:table-column column-width="1cm"/>
         <fo:table-column column-width="1.8cm"/>
         <fo:table-column column-width="2.5cm"/>
         <fo:table-column column-width="5cm"/>
         <fo:table-column column-width="2cm"/>
         <fo:table-column column-width="5cm"/>

         <fo:table-header>
            <fo:table-row xsl:use-attribute-sets="trh" >
               <fo:table-cell xsl:use-attribute-sets="tcl">
                  <fo:block>Variable</fo:block>
               </fo:table-cell >
               <fo:table-cell xsl:use-attribute-sets="tcl">
                  <fo:block>Label</fo:block>
               </fo:table-cell>
               <fo:table-cell xsl:use-attribute-sets="tcc">
                  <fo:block>Key</fo:block>
               </fo:table-cell>
               <fo:table-cell xsl:use-attribute-sets="tcr">
                  <fo:block>Type</fo:block>
               </fo:table-cell>
               <fo:table-cell xsl:use-attribute-sets="tcr">
                  <fo:block>Length</fo:block>
               </fo:table-cell>
               <fo:table-cell xsl:use-attribute-sets="tcl">
                  <fo:block>Controlled Terms or Format</fo:block>
               </fo:table-cell>
               <fo:table-cell xsl:use-attribute-sets="tcl">
                  <fo:block>Origin</fo:block>
               </fo:table-cell>
               <fo:table-cell xsl:use-attribute-sets="tcl">
                  <fo:block>Derivation/Comment</fo:block>
               </fo:table-cell>
            </fo:table-row>
         </fo:table-header>
         <fo:table-body>

            <!-- Get the individual data points -->
            <xsl:for-each select="./odm:ItemRef">

               <xsl:sort data-type="number" order="ascending" select="@OrderNumber"/>
               <xsl:variable name="itemRef" select="."/>
               <xsl:variable name="itemDefOid" select="@ItemOID"/>
               <xsl:variable name="itemDef" select="../../odm:ItemDef[@OID=$itemDefOid]"/>


               <fo:table-row  xsl:use-attribute-sets="tr" page-break-inside="avoid">
                  <!--xsl:attribute name="id">
               <xsl:value-of select="$itemDef/@OID"/>
            </xsl:attribute-->
                  <xsl:call-template name="rowClass">
                     <xsl:with-param name="rowNum" select="position()"/>
                  </xsl:call-template>                  

                  <fo:table-cell xsl:use-attribute-sets="tcl">     

                     <fo:block>
                        <xsl:attribute name="id">
                           <xsl:value-of select="../@OID"/>.<xsl:value-of select="$itemDef/@OID"/>
                        </xsl:attribute>
                        <xsl:choose>
                           <xsl:when test="$itemDef/def:ValueListRef/@ValueListOID!=''">
                              <fo:basic-link color="blue" text-decoration="underline">
                                 <xsl:attribute name="internal-destination">VL.<xsl:value-of select="$itemDef/def:ValueListRef/@ValueListOID"/></xsl:attribute>
                                 <xsl:value-of select="$itemDef/@Name"/> 
                              </fo:basic-link>
                           </xsl:when>
                           <xsl:otherwise>
                              <xsl:value-of select="$itemDef/@Name"/>   
                           </xsl:otherwise>
                        </xsl:choose>                                                   
                     </fo:block>
                  </fo:table-cell>

                  <fo:table-cell xsl:use-attribute-sets="tcl"><fo:block>
                        <xsl:value-of select="$itemDef/odm:Description/odm:TranslatedText"/>
                     </fo:block></fo:table-cell>

                  <fo:table-cell xsl:use-attribute-sets="tcr"><fo:block>
                        <xsl:value-of select="@KeySequence"/>
                     </fo:block></fo:table-cell>

                  <fo:table-cell xsl:use-attribute-sets="tcc"><fo:block>
                        <xsl:value-of select="$itemDef/@DataType"/>
                     </fo:block></fo:table-cell>

                  <fo:table-cell xsl:use-attribute-sets="tcr"><fo:block>
                        <xsl:value-of select="$itemDef/@Length"/>
                     </fo:block></fo:table-cell>



                  <!-- *************************************************** -->
                  <!-- Hypertext Link to the Decode Appendix               -->
                  <!-- *************************************************** -->
                  <fo:table-cell xsl:use-attribute-sets="tcl"><fo:block>
                        <xsl:call-template name="linkDecodeList">
                           <xsl:with-param name="itemDef" select="$itemDef"/>
                        </xsl:call-template>

                        <xsl:call-template name="displayISO8601">
                           <xsl:with-param name="itemDef" select="$itemDef"/>
                        </xsl:call-template>
                     </fo:block></fo:table-cell>

                  <!-- *************************************************** -->
                  <!-- Origin Column for ItemDefs                          -->
                  <!-- *************************************************** -->
                  <fo:table-cell xsl:use-attribute-sets="tcl"><fo:block>
                        <xsl:call-template name="displayItemDefOrigin">
                           <xsl:with-param name="itemDef" select="$itemDef"/>
                        </xsl:call-template>
                     </fo:block></fo:table-cell>

                  <!-- *************************************************** -->
                  <!-- Hypertext Link to the Derivation                    -->
                  <!-- *************************************************** -->
                  <fo:table-cell xsl:use-attribute-sets="tcl"><fo:block>

                        <xsl:variable name="cmntOID" select="$itemDef/@def:CommentOID"/>
                        <xsl:if test="$cmntOID">
                           <xsl:call-template name="displayItemComment">
                              <xsl:with-param name="itemDef" select="$itemDef"/>
                           </xsl:call-template>
                        </xsl:if>

                        <xsl:variable name="methodOID" select="$itemRef/@MethodOID"/>
                        <xsl:if test="$methodOID">
                           <xsl:call-template name="displayItemDefMethod">
                              <xsl:with-param name="itemRef" select="$itemRef"/>
                           </xsl:call-template>
                        </xsl:if>

                     </fo:block></fo:table-cell>
               </fo:table-row> 
            </xsl:for-each>


            <!-- *************************************************** -->
            <!-- Link to SUPPXX domain                               -->
            <!-- For those domains with Suplemental Qualifiers       -->
            <!-- *************************************************** -->

            <xsl:variable name="datasetName" select="@Name"/>
            <xsl:variable name="suppDatasetName" select="concat('SUPP',$datasetName)"/>
            <xsl:if test="../odm:ItemGroupDef[@Name=$suppDatasetName]">
               <!-- create an extra row to the SUPPXX dataset when there is one -->
               <xsl:variable name="datasetOID" select="../odm:ItemGroupDef[@Name=$suppDatasetName]"/>
               <fo:table-row  xsl:use-attribute-sets="tr" page-break-inside="avoid" keep-with-previous="always">

                  <fo:table-cell xsl:use-attribute-sets="tcl" number-columns-spanned="8"><fo:block>

                        <xsl:text>Related dataset: </xsl:text>
                        <xsl:value-of select="../odm:ItemGroupDef[@Name=$suppDatasetName]/odm:Description/odm:TranslatedText"/> 
                        <xsl:text> (</xsl:text> 
                        <fo:inline>
                           <fo:basic-link color="blue" text-decoration="underline">
                              <xsl:attribute name="internal-destination">IG.<xsl:value-of select="$datasetOID/@OID"/></xsl:attribute>
                              <xsl:value-of select="$suppDatasetName"/>
                           </fo:basic-link>    
                           <xsl:text>)</xsl:text>
                        </fo:inline>
                     </fo:block></fo:table-cell>
               </fo:table-row>
            </xsl:if>

            <!-- *************************************************** -->
            <!-- Link to Parent domain                               -->
            <!-- For those domains that are Suplemental Qualifiers   -->
            <!-- *************************************************** -->
            <!-- REMARK that we are still in the 'ItemRef' template
             but at the 'ItemGroupDef' level -->

            <xsl:if test="starts-with($datasetName, 'SUPP')">
               <!-- create an extra row to the XX dataset when there is one -->
               <xsl:variable name="parentDatasetName" select="substring($datasetName, 5)"/>
               <xsl:if test="../odm:ItemGroupDef[@Name=$parentDatasetName]">
                  <xsl:variable name="datasetOID" select="../odm:ItemGroupDef[@Name=$parentDatasetName]"/>
                  <fo:table-row  xsl:use-attribute-sets="tr" page-break-inside="avoid"  keep-with-previous="always">
                     <fo:table-cell xsl:use-attribute-sets="tcl" number-columns-spanned="8"><fo:block>
                           <xsl:text>Related dataset: </xsl:text>
                           <xsl:value-of select="../odm:ItemGroupDef[@Name=$parentDatasetName]/odm:Description/odm:TranslatedText"/>
                           <xsl:text> (</xsl:text>               
                           <fo:inline >
                              <fo:basic-link color="blue" text-decoration="underline">
                                 <xsl:attribute name="internal-destination">IG.<xsl:value-of select="$datasetOID/@OID"/></xsl:attribute>
                                 <xsl:value-of select="$parentDatasetName"/>
                              </fo:basic-link>    
                              <xsl:text>)</xsl:text>
                           </fo:inline>
                        </fo:block></fo:table-cell>
                  </fo:table-row>
               </xsl:if>
            </xsl:if>

         </fo:table-body>
      </fo:table>


   </xsl:template>

   <!-- Code List Items                                      -->
   <xsl:template name="AppendixCodeLists"> 

      <xsl:if test="$g_seqCodeLists[odm:CodeListItem|odm:EnumeratedItem]">
         <fo:block break-before="page" xsl:use-attribute-sets="caption" id="decodelist">Controlled Terms</fo:block>   
         <xsl:for-each select="$g_seqCodeLists[odm:CodeListItem|odm:EnumeratedItem]">
            <fo:block xsl:use-attribute-sets="caption" space-before="20pt" > 
               <xsl:attribute name="id">CL.<xsl:value-of select="@OID"/></xsl:attribute>
               <xsl:value-of select="@Name"/>
               <xsl:text> [</xsl:text>
               <xsl:value-of select="@OID"/>
               <xsl:if test="./odm:Alias/@Context = 'nci:ExtCodeID'">
                  <fo:inline font-style="italic">, <xsl:value-of select="./odm:Alias/@Name"/></fo:inline>                     

               </xsl:if>
               <xsl:text>]</xsl:text>
            </fo:block>   
            <xsl:choose>
               <xsl:when test="./odm:CodeListItem">
                  <xsl:call-template name="displayCodeListItemsTable"/>
               </xsl:when>
               <xsl:when test="./odm:EnumeratedItem">
                  <xsl:call-template name="displayEnumeratedItemsTable"/>
               </xsl:when>
               <xsl:otherwise />
            </xsl:choose>

         </xsl:for-each>
      </xsl:if>
   </xsl:template>

   <!-- Template:    displayItemDefMethod                    -->
   <xsl:template name="displayItemDefMethod">
      <xsl:param name="itemRef"/>
      <!-- if there is a reference to a ComputationalMethod, add it to the Comments column -->
      <xsl:if test="$itemRef/@MethodOID">
         <xsl:variable name="MethodOID" select="$itemRef/@MethodOID"/>
         <xsl:variable name="Method" select="$g_seqMethodDefs[@OID=$MethodOID]"/>
         <xsl:variable name="MethodComment">
            <xsl:value-of select="normalize-space($Method/odm:Description/odm:TranslatedText)"/>
         </xsl:variable>

         <fo:block>
            <xsl:value-of select="$MethodComment"/>
         </fo:block>
         <xsl:for-each select="$Method/def:DocumentRef">
            <xsl:variable name="leafID" select="$Method/def:DocumentRef/@leafID"/>
            <xsl:variable name="leaf" select="$g_seqleafs[@ID=$leafID]"/>
            <fo:block>
               <xsl:value-of select="$leaf/def:title"/> (<fo:inline>
                  <fo:basic-link color="blue" text-decoration="underline">

                     <xsl:attribute name="external-destination">
                        <xsl:value-of select="$leaf/@xlink:href"/>
                     </xsl:attribute>
                     <xsl:value-of select="$leaf/@xlink:href"/>
                  </fo:basic-link></fo:inline>) </fo:block>
         </xsl:for-each>
      </xsl:if>
   </xsl:template>

   <!-- Template:    displayItemDefComment                   -->
   <xsl:template name="displayItemComment">

      <xsl:param name="itemDef"/>

      <xsl:if test="$itemDef/@def:CommentOID">
         <xsl:variable name="cmntOID" select="$itemDef/@def:CommentOID"/>
         <xsl:variable name="Comment" select="$g_seqCommentDefs[@OID=$cmntOID]"/>
         <xsl:variable name="ItemDefComment">
            <xsl:value-of select="normalize-space($g_seqCommentDefs[@OID=$cmntOID]/odm:Description/odm:TranslatedText)"/>
         </xsl:variable>
         <fo:block>
            <xsl:value-of select="$ItemDefComment"/>
         </fo:block>
         <xsl:for-each select="$Comment/def:DocumentRef">
            <xsl:variable name="leafID" select="@leafID"/>
            <xsl:variable name="leaf" select="$g_seqleafs[@ID=$leafID]"/>
            <fo:block>
               <fo:inline>
                  <fo:basic-link color="blue" text-decoration="underline">    
                     <xsl:attribute name="external-destination">
                        <xsl:value-of select="$leaf/@xlink:href"/>
                     </xsl:attribute>
                     <xsl:value-of select="normalize-space($leaf/def:title)"/>
                  </fo:basic-link>               
               </fo:inline>
            </fo:block>
         </xsl:for-each>
      </xsl:if>
   </xsl:template>

   <!-- Display ISO8601                                      -->
   <xsl:template name="displayISO8601">
      <xsl:param name="itemDef"/>
      <!-- when the datatype is 'date', 'time' or 'datetime'
                   or it is a -DUR (duration) variable, print 'ISO8601' in this column -->
      <xsl:if
            test="$itemDef/@DataType='date' or
         $itemDef/@DataType='time' or
         $itemDef/@DataType='datetime' or
         substring($itemDef/@Name,string-length($itemDef/@Name)-2,string-length($itemDef/@Name)) = 'DUR'">
         <xsl:text>ISO8601</xsl:text>
      </xsl:if>
   </xsl:template>

   <!-- Template: AppendixValueList                          -->
   <xsl:template name="AppendixValueList">

      <xsl:if test="$g_seqValueListDefs">

         <fo:block break-before="page" xsl:use-attribute-sets="caption" id="valuemeta">
            <xsl:choose>
               <xsl:when test="$g_ItemGroupDefPurpose='Analysis'">
                  <xsl:text>Parameter Value Lists</xsl:text>
               </xsl:when>
               <xsl:when test="$g_ItemGroupDefPurpose='Tabulation'">
                  <xsl:text>Value Level Metadata</xsl:text>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:text>Value Lists</xsl:text>
               </xsl:otherwise>
            </xsl:choose>
         </fo:block>   

         <xsl:for-each select="$g_seqValueListDefs">
            <xsl:variable name="valueListDefOID" select="@OID"/>
            <xsl:variable name="valueListRef" select="//odm:ItemDef/def:ValueListRef[@ValueListOID=$valueListDefOID]"/>
            <xsl:variable name="itemDefOID" select="$valueListRef/../@OID"/>

            <fo:block xsl:use-attribute-sets="caption"  space-before="20pt"> 
               <xsl:attribute name="id">VL.<xsl:value-of select="@OID"/>
               </xsl:attribute>
               <xsl:choose>
                  <xsl:when test="$g_ItemGroupDefPurpose='Analysis'"> Parameter Value List - </xsl:when>
                  <xsl:when test="$g_ItemGroupDefPurpose='Tabulation'"> Value Level Metadata - </xsl:when>
                  <xsl:otherwise> Value List - </xsl:otherwise>
               </xsl:choose>

               <xsl:choose>
                  <xsl:when test="//odm:ItemRef[@ItemOID=$itemDefOID]/../@Name">
                     <!-- ValueList attached to an ItemGroup Item -->
                     <xsl:value-of select="//odm:ItemRef[@ItemOID=$itemDefOID]/../@Name"/>
                  </xsl:when>
                  <xsl:otherwise>
                     <!-- ValueList attached to a ValueList Item -->
                     <xsl:value-of select="//odm:ItemRef[@ItemOID=$itemDefOID]/../@OID"/>
                  </xsl:otherwise>
               </xsl:choose>

               <xsl:text> [</xsl:text>
               <xsl:value-of	select="$valueListRef/../@Name"/>
               <xsl:text>]</xsl:text> 
            </fo:block>

            <fo:table xsl:use-attribute-sets="wholeTable">
               <fo:table-column column-width="2.5cm"/>
               <fo:table-column column-width="5cm"/>
               <fo:table-column column-width="1.8cm"/>
               <fo:table-column column-width="2.5cm"/>
               <fo:table-column column-width="3.9cm"/>
               <fo:table-column column-width="2.1cm"/>
               <fo:table-column column-width="5cm"/>


               <fo:table-header >
                  <fo:table-row xsl:use-attribute-sets="trh" >
                     <fo:table-cell xsl:use-attribute-sets="tcl">
                        <fo:block>Variable</fo:block>
                     </fo:table-cell>
                     <fo:table-cell xsl:use-attribute-sets="tcl">
                        <fo:block>Where</fo:block>
                     </fo:table-cell>
                     <fo:table-cell xsl:use-attribute-sets="tcc">
                        <fo:block>Type</fo:block>
                     </fo:table-cell>
                     <fo:table-cell xsl:use-attribute-sets="tcr">
                        <fo:block>Length / Display Format</fo:block>
                     </fo:table-cell>
                     <fo:table-cell xsl:use-attribute-sets="tcl">
                        <fo:block>Controlled Terms or Format</fo:block>
                     </fo:table-cell>
                     <fo:table-cell xsl:use-attribute-sets="tcl">
                        <fo:block>Origin</fo:block>
                     </fo:table-cell>
                     <fo:table-cell xsl:use-attribute-sets="tcl">
                        <fo:block>Derivation/Comment</fo:block>
                     </fo:table-cell>
                  </fo:table-row>
               </fo:table-header>
               <fo:table-body>               

                  <!-- Get the individual data points -->
                  <xsl:for-each select="./odm:ItemRef">
                     <xsl:variable name="ItemRef" select="."/>
                     <xsl:variable name="valueDefOid" select="@ItemOID"/>
                     <xsl:variable name="valueDef" select="../../odm:ItemDef[@OID=$valueDefOid]"/>

                     <xsl:variable name="vlOID" select="../@OID"/>
                     <xsl:variable name="parentDef" select="../../odm:ItemDef/def:ValueListRef[@ValueListOID=$vlOID]"/>
                     <xsl:variable name="parentOID" select="$parentDef/../@OID"/>
                     <xsl:variable name="ParentVName" select="$parentDef/../@Name"/>

                     <xsl:variable name="ValueItemGroupOID"
                           select="$g_seqItemGroupDefs/odm:ItemRef[@ItemOID=$parentOID]/../@OID"/>

                     <xsl:variable name="whereOID" select="./def:WhereClauseRef/@WhereClauseOID"/>
                     <xsl:variable name="whereDef" select="$g_seqWhereClauseDefs[@OID=$whereOID]"/>
                     <xsl:variable name="whereRefItemOID" select="$whereDef/odm:RangeCheck/@def:ItemOID"/>
                     <xsl:variable name="whereRefItem"
                           select="$g_seqItemDefs[@OID=$whereRefItemOID]/@Name"/>
                     <xsl:variable name="whereOP" select="$whereDef/odm:RangeCheck/@Comparator"/>
                     <xsl:variable name="whereVal" select="$whereDef/odm:RangeCheck/odm:CheckValue"/>

                     <fo:table-row xsl:use-attribute-sets="tr" page-break-inside="avoid">
                        <xsl:call-template name="rowClass">
                           <xsl:with-param name="rowNum" select="position()"/>
                        </xsl:call-template>
                        <!-- first column: Source Variable column -->                          
                        <fo:table-cell xsl:use-attribute-sets="tcl">
                           <fo:block>
                              <xsl:value-of select="$ParentVName"/>
                           </fo:block>
                        </fo:table-cell>

                        <!-- second column: 'WhereClause' column -->
                        <fo:table-cell xsl:use-attribute-sets="tcl">
                           <fo:block>
                              <xsl:call-template name="assembleWhereText">
                                 <xsl:with-param name="ValueItemRef" select="$ItemRef"/>
                                 <xsl:with-param name="ItemGroupOID" select="$ValueItemGroupOID"/>
                              </xsl:call-template>

                              <xsl:if test="$ParentVName='QVAL'"> (<xsl:value-of
                                       select="$valueDef/odm:Description/odm:TranslatedText"/>) </xsl:if>										
                           </fo:block>
                        </fo:table-cell>

                        <!-- datatype -->
                        <fo:table-cell xsl:use-attribute-sets="tcc">
                           <fo:block>
                              <xsl:value-of select="$valueDef/@DataType"/>
                           </fo:block>
                        </fo:table-cell>

                        <fo:table-cell xsl:use-attribute-sets="tcr">
                           <fo:block>
                              <xsl:choose>
                                 <xsl:when test="$valueDef/@def:DisplayFormat">
                                    <xsl:value-of select="$valueDef/@def:DisplayFormat"/>
                                 </xsl:when>
                                 <xsl:otherwise>
                                    <xsl:value-of select="$valueDef/@Length"/>
                                 </xsl:otherwise>
                              </xsl:choose>
                           </fo:block>
                        </fo:table-cell>


                        <!-- *************************************************** -->
                        <!-- Hypertext Link to the Decode Appendix               -->
                        <!-- *************************************************** -->

                        <fo:table-cell xsl:use-attribute-sets="tcl">
                           <fo:block>
                              <xsl:call-template name="linkDecodeList">
                                 <xsl:with-param name="itemDef" select="$valueDef"/>
                              </xsl:call-template>

                              <xsl:call-template name="displayISO8601">
                                 <xsl:with-param name="itemDef" select="$valueDef"/>
                              </xsl:call-template>										
                           </fo:block>
                        </fo:table-cell>

                        <!-- *************************************************** -->
                        <!-- Origin Column for ValueDefs                          -->
                        <!-- *************************************************** -->
                        <fo:table-cell xsl:use-attribute-sets="tcl">
                           <fo:block>
                              <xsl:call-template name="displayItemDefOrigin">
                                 <xsl:with-param name="itemDef" select="$valueDef"/>
                              </xsl:call-template>
                           </fo:block>
                        </fo:table-cell>

                        <!-- *************************************************** -->
                        <!-- Computation Methods Column                          -->
                        <!-- *************************************************** -->
                        <fo:table-cell xsl:use-attribute-sets="tcl">
                           <fo:block> 
                              <xsl:variable name="whereclausecmntOID" select="$whereDef/@def:CommentOID"/>
                              <xsl:if test="$whereclausecmntOID">
                                 <xsl:call-template name="displayItemComment">
                                    <xsl:with-param name="itemDef" select="$whereDef"/>
                                 </xsl:call-template>
                              </xsl:if>

                              <xsl:variable name="cmntOID" select="$valueDef/@def:CommentOID"/>
                              <xsl:if test="$cmntOID">
                                 <xsl:call-template name="displayItemComment">
                                    <xsl:with-param name="itemDef" select="$valueDef"/>
                                 </xsl:call-template>
                              </xsl:if>

                              <xsl:variable name="methodOID" select="$ItemRef/@MethodOID"/>
                              <xsl:if test="$methodOID">
                                 <xsl:call-template name="displayItemDefMethod">
                                    <xsl:with-param name="itemRef" select="$ItemRef"/>
                                 </xsl:call-template>
                              </xsl:if>
                           </fo:block>
                        </fo:table-cell>
                     </fo:table-row>
                     <!-- end of loop over all def:ValueListDef elements -->

                     <!-- ***************************************************  -->
                     <!-- Link back to the dataset from QNAM                   -->
                     <!-- For those domains with Suplemental Qualifiers        -->
                     <!-- ***************************************************  -->

                  </xsl:for-each>
                  <!-- end of loop over all ValueListDefs -->
               </fo:table-body>
            </fo:table>    
         </xsl:for-each>
      </xsl:if>
   </xsl:template>

   <!-- Template:    assembleWhereText                       -->
   <xsl:template name="assembleWhereText">
      <xsl:param name="ValueItemRef"/>
      <xsl:param name="ItemGroupOID"/>

      <xsl:variable name="ValueRef" select="$ValueItemRef"/>
      <xsl:variable name="LastWhereRef" select="$ValueRef/def:WhereClauseRef[last()]"/>
      <xsl:for-each select="$ValueRef/def:WhereClauseRef">
         <xsl:variable name="thisWhereRef" select="."/>
         <xsl:variable name="whereOID" select="./@WhereClauseOID"/>
         <xsl:variable name="whereDef" select="$g_seqWhereClauseDefs[@OID=$whereOID]"/>
         <xsl:variable name="LastRangeCheck" select="$whereDef/odm:RangeCheck[last()]"/>

         <xsl:for-each select="$whereDef/odm:RangeCheck">
            <xsl:variable name="thisRangeCheck" select="."/>
            <xsl:variable name="whereRefItemOID" select="./@def:ItemOID"/>
            <xsl:variable name="whereRefItemName" select="$g_seqItemDefs[@OID=$whereRefItemOID]/@Name"/>
            <xsl:variable name="whereOP" select="./@Comparator"/>
            <xsl:variable name="whereRefItemCodeListOID" select="$g_seqItemDefs[@OID=$whereRefItemOID]/odm:CodeListRef/@CodeListOID"/>
            <xsl:variable name="whereRefItemCodeList" select="$g_seqCodeLists[@OID=$whereRefItemCodeListOID]"/>

            <xsl:variable name="linkItemGroupItem">
               <xsl:value-of select="$ItemGroupOID"/>.<xsl:value-of select="$whereRefItemOID"/>
            </xsl:variable>

            <xsl:choose>
               <xsl:when test="$whereOP = 'IN' or $whereOP = 'NOTIN'">
                  <xsl:variable name="CheckValue" select="./odm:CheckValue"/>
                  <fo:inline >
                     <fo:basic-link color="blue" text-decoration="underline">
                        <xsl:attribute name="internal-destination">
                           <xsl:value-of select="$ItemGroupOID"/>.<xsl:value-of select="$whereRefItemOID"/>
                        </xsl:attribute>
                        <xsl:value-of select="$whereRefItemName"/>
                     </fo:basic-link>
                  </fo:inline>
                  <xsl:text> </xsl:text>
                  <xsl:variable name="Nvalues" select="count(./odm:CheckValue)"/>
                  <xsl:value-of select="$whereOP"/>
                  <xsl:text> </xsl:text>( <xsl:for-each select="./odm:CheckValue">
                     <xsl:variable name="CheckValueIN" select="."/>
                     <fo:block> "<xsl:value-of select="$CheckValueIN"/>" <xsl:if
                              test="$whereRefItemCodeList/odm:CodeListItem[@CodedValue=$CheckValueIN]"> (<xsl:value-of
                                 select="$whereRefItemCodeList/odm:CodeListItem[@CodedValue=$CheckValueIN]/odm:Decode/odm:TranslatedText"
                                 />) </xsl:if>
                        <xsl:if test="position() != $Nvalues">
                           <xsl:value-of select="', '"/>
                        </xsl:if>
                     </fo:block>
                  </xsl:for-each> ) </xsl:when>
               <xsl:when test="$whereOP = 'EQ'">
                  <xsl:variable name="CheckValueEQ" select="./odm:CheckValue"/>
                  <fo:inline >
                     <fo:basic-link color="blue" text-decoration="underline">
                        <xsl:attribute name="internal-destination">
                           <xsl:value-of select="$ItemGroupOID"/>.<xsl:value-of select="$whereRefItemOID"/>
                        </xsl:attribute>
                        <xsl:value-of select="$whereRefItemName"/>
                     </fo:basic-link>
                  </fo:inline>
                  <xsl:text> </xsl:text>
                  <xsl:value-of select="$whereOP"/>
                  <xsl:text> </xsl:text>
                  <xsl:value-of select="odm:CheckValue"/>
                  <xsl:if test="$whereRefItemCodeList/odm:CodeListItem[@CodedValue=$CheckValueEQ]"> (<xsl:value-of
                           select="$whereRefItemCodeList/odm:CodeListItem[@CodedValue=$CheckValueEQ]/odm:Decode/odm:TranslatedText"
                           />) </xsl:if>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:variable name="CheckValueOTH" select="./odm:CheckValue"/>
                  <fo:inline >
                     <fo:basic-link color="blue" text-decoration="underline">
                        <xsl:attribute name="internal-destination">
                           <xsl:value-of select="$ItemGroupOID"/>.<xsl:value-of select="$whereRefItemOID"/>
                        </xsl:attribute>
                        <xsl:value-of select="$whereRefItemName"/>
                     </fo:basic-link>
                  </fo:inline>
                  <xsl:text/>
                  <xsl:value-of select="$whereOP"/>
                  <xsl:text/>
                  <xsl:value-of select="$CheckValueOTH"/>

               </xsl:otherwise>
            </xsl:choose>

            <fo:block/>
            <xsl:if test="$thisRangeCheck != $LastRangeCheck">
               <xsl:text> AND </xsl:text>
            </xsl:if>

         </xsl:for-each>

         <xsl:if test="$thisWhereRef != $LastWhereRef">
            <xsl:text> OR </xsl:text>
            <!-- only if this is not the last WhereRef in the ItemREf  -->
         </xsl:if>

      </xsl:for-each>
   </xsl:template>

   <!-- Display CodeList table                               -->
   <xsl:template name="displayCodeListItemsTable">
      <xsl:variable name="n_extended" select="count(odm:CodeListItem/@def:ExtendedValue)"/>

      <fo:table xsl:use-attribute-sets="wholeTable">
         <fo:table-column column-width="5.8cm"/>
         <fo:table-column column-width="17cm"/>

         <fo:table-header>
            <fo:table-row xsl:use-attribute-sets="trh">
               <fo:table-cell xsl:use-attribute-sets="tcl">
                  <fo:block>Permitted Value (Code)</fo:block>
               </fo:table-cell>
               <fo:table-cell xsl:use-attribute-sets="tcl">
                  <fo:block>Display Value (Decode)</fo:block>
               </fo:table-cell>
            </fo:table-row>
         </fo:table-header>
         <fo:table-body>      

            <xsl:for-each select="./odm:CodeListItem">
               <xsl:sort data-type="number" select="@Rank" order="ascending"/>
               <xsl:sort data-type="number" select="@OrderNumber" order="ascending"/>
               <fo:table-row xsl:use-attribute-sets="tr" page-break-inside="avoid">
                  <xsl:call-template name="rowClass">
                     <xsl:with-param name="rowNum" select="position()"/>
                  </xsl:call-template>
                  <fo:table-cell xsl:use-attribute-sets="tcl">
                     <fo:block>
                        <xsl:value-of select="@CodedValue"/>
                        <xsl:if test="./odm:Alias/@Context = 'nci:ExtCodeID'">
                           <xsl:text> [</xsl:text>
                           <fo:inline font-style="italic"><xsl:value-of select="./odm:Alias/@Name"/></fo:inline>                     
                           <xsl:text>]</xsl:text> 
                        </xsl:if>
                        <xsl:if test="@def:ExtendedValue='Yes'">
                           <xsl:text> [</xsl:text>
                           <fo:inline baseline-shift='10%'>*</fo:inline>
                           <xsl:text>]</xsl:text>
                        </xsl:if>
                     </fo:block>
                  </fo:table-cell>
                  <fo:table-cell xsl:use-attribute-sets="tcl">
                     <fo:block><xsl:value-of select="./odm:Decode/odm:TranslatedText"/>   </fo:block>
                  </fo:table-cell>
               </fo:table-row>
            </xsl:for-each>
         </fo:table-body>
      </fo:table>
      <xsl:if test="$n_extended &gt; 0">
         <fo:block xsl:use-attribute-sets="headfoot"><fo:inline baseline-shift='10%'>*</fo:inline> Extended Value</fo:block>
      </xsl:if>

   </xsl:template>

   <!-- Enumerated Items Table                               -->
   <xsl:template name="displayEnumeratedItemsTable">

      <xsl:variable name="n_extended" select="count(odm:EnumeratedItem/@def:ExtendedValue)"/>

      <fo:table xsl:use-attribute-sets="wholeTable">
         <fo:table-column column-width="22.8cm"/>

         <fo:table-header>
            <fo:table-row xsl:use-attribute-sets="trh">
               <fo:table-cell xsl:use-attribute-sets="tcl">
                  <fo:block>Permitted Value (Code)</fo:block>
               </fo:table-cell>
            </fo:table-row>
         </fo:table-header>
         <fo:table-body>        


            <xsl:for-each select="./odm:EnumeratedItem">
               <xsl:sort data-type="number" select="@Rank" order="ascending"/>
               <xsl:sort data-type="number" select="@OrderNumber" order="ascending"/>

               <fo:table-row xsl:use-attribute-sets="tr" page-break-inside="avoid">
                  <xsl:call-template name="rowClass">
                     <xsl:with-param name="rowNum" select="position()"/>
                  </xsl:call-template>
                  <fo:table-cell xsl:use-attribute-sets="tcl">
                     <fo:block>
                        <xsl:value-of select="@CodedValue"/>
                        <xsl:if test="./odm:Alias/@Context = 'nci:ExtCodeID'">
                           <xsl:text> [</xsl:text>
                           <fo:inline font-style="italic"><xsl:value-of select="./odm:Alias/@Name"/></fo:inline>                     
                           <xsl:text>]</xsl:text> 
                        </xsl:if>
                        <xsl:if test="@def:ExtendedValue='Yes'">
                           <xsl:text> [</xsl:text>
                           <fo:inline baseline-shift='10%'>*</fo:inline>
                           <xsl:text>]</xsl:text>
                        </xsl:if>
                     </fo:block>
                  </fo:table-cell>
               </fo:table-row>
            </xsl:for-each>
         </fo:table-body>
      </fo:table>
      <xsl:if test="$n_extended &gt; 0">
         <fo:block xsl:use-attribute-sets="headfoot"><fo:inline baseline-shift='10%'>*</fo:inline> Extended Value</fo:block>
      </xsl:if>

   </xsl:template>

   <!-- External Dictionaries   Pending                      -->
   <xsl:template name="AppendixExternalCodeLists">

      <xsl:if test="$g_seqCodeLists[odm:ExternalCodeList]">

         <fo:block break-before="page" xsl:use-attribute-sets="caption" space-before="20pt" id="externaldictionary">
            External Dictionaries
         </fo:block>   


         <fo:table xsl:use-attribute-sets="wholeTable">
            <fo:table-column column-width="10cm"/>
            <fo:table-column column-width="6.4cm"/>
            <fo:table-column column-width="6.4cm"/>

            <fo:table-header>
               <fo:table-row xsl:use-attribute-sets="trh">
                  <fo:table-cell xsl:use-attribute-sets="tcl">
                     <fo:block>Reference Name</fo:block>
                  </fo:table-cell>
                  <fo:table-cell xsl:use-attribute-sets="tcl">
                     <fo:block>External Dictionary</fo:block>
                  </fo:table-cell>
                  <fo:table-cell xsl:use-attribute-sets="tcl">
                     <fo:block>Dictionary Version</fo:block>
                  </fo:table-cell>
               </fo:table-row>
            </fo:table-header>
            <fo:table-body>      

               <xsl:for-each select="$g_seqCodeLists/odm:ExternalCodeList">

                  <fo:table-row xsl:use-attribute-sets="tr" page-break-inside="avoid">
                     <xsl:call-template name="rowClass">
                        <xsl:with-param name="rowNum" select="position()"/>
                     </xsl:call-template>
                     <fo:table-cell xsl:use-attribute-sets="tcl">

                        <xsl:attribute name="id">CL.<xsl:value-of select="../@OID"/></xsl:attribute>
                        <fo:block>
                           <xsl:value-of select="../@Name"/> (<xsl:value-of select="../@OID"/>)
                        </fo:block></fo:table-cell>

                     <fo:table-cell xsl:use-attribute-sets="tcl"><fo:block>
                           <xsl:value-of select="@Dictionary"/>
                        </fo:block></fo:table-cell>

                     <fo:table-cell xsl:use-attribute-sets="tcl"><fo:block>
                           <xsl:value-of select="@Version"/>
                        </fo:block></fo:table-cell>

                  </fo:table-row>
               </xsl:for-each>
            </fo:table-body>
         </fo:table>
      </xsl:if>
   </xsl:template>

   <!-- Template:    linkDecodeList                          -->
   <xsl:template name="linkDecodeList">
      <xsl:param name="itemDef"/>
      <xsl:variable name="CODE" select="$itemDef/odm:CodeListRef/@CodeListOID"/>
      <xsl:variable name="CodeListDef" select="$g_seqCodeLists[@OID=$CODE]"/>
      <xsl:variable name="n_items" select="count($CodeListDef/odm:CodeListItem|$CodeListDef/odm:EnumeratedItem)"/>

      <xsl:if test="$itemDef/odm:CodeListRef">

         <xsl:choose>
            <xsl:when test="$n_items &lt; 5 and $CodeListDef/odm:CodeListItem">
               <xsl:text>[</xsl:text>
               <xsl:for-each select="$CodeListDef/odm:CodeListItem">
                  <xsl:value-of select="concat('&quot;', @CodedValue, '&quot;')"/>
                  <xsl:text> = </xsl:text>
                  <xsl:value-of select="concat('&quot;', odm:Decode/odm:TranslatedText, '&quot;')"/>
                  <xsl:if test="@CodedValue != $CodeListDef/odm:CodeListItem[last()]/@CodedValue">, </xsl:if>
               </xsl:for-each>
               <xsl:text>]</xsl:text>
               <fo:block> <xsl:text> &lt;</xsl:text>
                  <fo:basic-link color="blue" text-decoration="underline" internal-destination="CL.{$CodeListDef/@OID}">
                     <xsl:value-of select="$CodeListDef/@Name"/>
                  </fo:basic-link>&gt;</fo:block>
            </xsl:when>
            <xsl:when test="$n_items &lt; 5 and $CodeListDef/odm:EnumeratedItem">
               <xsl:text>[</xsl:text>
               <xsl:for-each select="$CodeListDef/odm:EnumeratedItem">
                  <xsl:value-of select="concat('&quot;', @CodedValue, '&quot;')"/>
                  <xsl:if test="@CodedValue != $CodeListDef/odm:EnumeratedItem[last()]/@CodedValue">, </xsl:if>
               </xsl:for-each>
               <xsl:text>]</xsl:text>
               <fo:block><xsl:text> &lt;</xsl:text>
                  <fo:basic-link color="blue" text-decoration="underline" internal-destination="CL.{$CodeListDef/@OID}">
                     <xsl:value-of select="$CodeListDef/@Name"/>
                  </fo:basic-link>&gt;</fo:block>
            </xsl:when>
            <xsl:otherwise>
               <fo:basic-link color="blue" text-decoration="underline" internal-destination="CL.{$CodeListDef/@OID}">
                  <xsl:choose>
                     <xsl:when test="$g_seqCodeLists[@OID=$CODE]">
                        <xsl:value-of select="$CodeListDef/@Name"/>
                     </xsl:when>
                     <xsl:otherwise>
                        <xsl:value-of select="$itemDef/odm:CodeListRef/@CodeListOID"/>
                     </xsl:otherwise>
                  </xsl:choose>
               </fo:basic-link>
            </xsl:otherwise>
         </xsl:choose>

      </xsl:if>
   </xsl:template>

   <!-- Template:    rowClass                                -->
   <xsl:template name="rowClass">
      <!-- rowNum: current table row number (1-based) -->
      <xsl:param name="rowNum"/>

      <!-- set the class attribute to "tableroweven" for even rows, "tablerowodd" for odd rows -->
      <xsl:attribute name="background-color">
         <xsl:choose>
            <xsl:when test="$rowNum mod 2 = 0">
               <xsl:text>#E2E2E2</xsl:text>
            </xsl:when>
            <xsl:otherwise>
               <xsl:text>#FFFFFF</xsl:text>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:attribute>
   </xsl:template>

   <!-- Template:    displayItemDefOrigin                    -->	
   <xsl:template name="displayItemDefOrigin">
      <xsl:param name="itemDef"/>
      <!-- translate the value of the def:Origin/@Type attribute to uppercase
              in order to see whether it contains the word "CRF" case-insensitive -->
      <xsl:variable name="ORIGIN_UPPERCASE" select="translate($itemDef/def:Origin/@Type,$g_lowercase,$g_uppercase)"/>
      <xsl:choose>
         <!-- create a set of hyperlinks to CRF pages -->
         <xsl:when test="$ORIGIN_UPPERCASE = 'CRF'">

            <xsl:variable name="PageRefType" select="normalize-space($itemDef/def:Origin/def:DocumentRef/def:PDFPageRef/@Type)"/>
            <xsl:variable name="PageRefs" select="normalize-space($itemDef/def:Origin/def:DocumentRef/def:PDFPageRef/@PageRefs)"/>
            <xsl:variable name="PageFirst" select="normalize-space($itemDef/def:Origin/def:DocumentRef/def:PDFPageRef/@FirstPage)"/>
            <xsl:variable name="PageLast" select="normalize-space($itemDef/def:Origin/def:DocumentRef/def:PDFPageRef/@LastPage)"/>

            <xsl:value-of select="$itemDef/def:Origin/@Type"/>
            <xsl:choose>
               <xsl:when test="$PageRefType = $REFTYPE_NAMEDDESTINATION">
                  <xsl:text> Page </xsl:text>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:choose>
                     <xsl:when test="contains($PageRefs, ' ')">
                        <xsl:text> Pages </xsl:text>
                     </xsl:when>
                     <xsl:when test="string-length($PageFirst) &gt; 0 and string-length($PageLast) &gt; 0">
                        <xsl:text> Pages </xsl:text>
                     </xsl:when>
                     <xsl:otherwise>
                        <xsl:text> Page </xsl:text>
                     </xsl:otherwise>
                  </xsl:choose>
               </xsl:otherwise>
            </xsl:choose>

            <xsl:choose>
               <xsl:when test="$PageRefType = $REFTYPE_PHYSICALPAGE">
                  <xsl:call-template name="crfPageNumbers2Hyperlinks">
                     <xsl:with-param name="DefOriginString">
                        <xsl:choose>
                           <xsl:when test="$PageRefs"><xsl:value-of select="normalize-space($PageRefs)"/>
                           </xsl:when>
                           <xsl:when test="$PageFirst"><xsl:value-of select="normalize-space(concat($PageFirst, '-', $PageLast))"/>
                           </xsl:when>
                           <xsl:otherwise>
                           </xsl:otherwise>
                        </xsl:choose>
                     </xsl:with-param>
                     <xsl:with-param name="Separator">
                        <xsl:choose>
                           <xsl:when test="$PageRefs"><xsl:value-of select="' '"/>
                           </xsl:when>
                           <xsl:when test="$PageFirst"><xsl:value-of select="'-'"/>
                           </xsl:when>
                           <xsl:otherwise>
                           </xsl:otherwise>
                        </xsl:choose>
                     </xsl:with-param>
                  </xsl:call-template>
               </xsl:when>
               <xsl:when test="$PageRefType = $REFTYPE_NAMEDDESTINATION">
                  <xsl:call-template name="crfNamedDestinationHyperlink">
                     <xsl:with-param name="destination" select="$PageRefs"/>
                  </xsl:call-template>
               </xsl:when>
               <xsl:otherwise/>
            </xsl:choose>

         </xsl:when>
         <!-- all other cases, just print the content from the 'Origin' attribute -->
         <xsl:otherwise>
            <xsl:value-of select="$itemDef/def:Origin/@Type"/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <!-- Templates for special features like hyperlinks       -->
   <xsl:template name="crfPageNumbers2Hyperlinks">
      <xsl:param name="DefOriginString"/>
      <xsl:param name="Separator"/>
      <xsl:variable name="OriginString" select="$DefOriginString"/>

      <xsl:variable name="first">
         <xsl:choose>
            <xsl:when test="contains($OriginString,$Separator)">
               <xsl:value-of select="substring-before($OriginString,$Separator)"/>
            </xsl:when>
            <xsl:otherwise>
               <xsl:value-of select="$OriginString"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>

      <xsl:variable name="rest" select="substring-after($OriginString,$Separator)"/>
      <xsl:variable name="stringlengthfirst" select="string-length($first)"/>

      <xsl:if test="string-length($first) > 0">
         <xsl:choose>
            <xsl:when test="number($first)">
               <!-- it is a number, create the hyperlink -->
               <xsl:call-template name="crfSinglePageHyperlink">
                  <xsl:with-param name="pagenumber" select="$first"/>
               </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
               <!-- it is not a number -->
               <xsl:value-of select="$first"/>
               <xsl:value-of select="$Separator"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:if>

      <!-- split up the second part in words (recursion) -->
      <xsl:if test="string-length($rest) > 0">

         <xsl:choose>
            <xsl:when test="contains($rest,$Separator)">
               <xsl:call-template name="crfPageNumbers2Hyperlinks">
                  <xsl:with-param name="DefOriginString" select="$rest"/>
                  <xsl:with-param name="Separator" select="' '"/>
               </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
               <xsl:value-of select="$Separator"/>
               <xsl:text> </xsl:text>
               <xsl:call-template name="crfSinglePageHyperlink">
                  <xsl:with-param name="pagenumber" select="$rest"/>
               </xsl:call-template>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:if>
   </xsl:template>

   <!-- Hypertext Link to a single CRF Page                  -->
   <xsl:template name="crfSinglePageHyperlink">
      <xsl:param name="pagenumber"/>
      <!-- create the hyperlink itself -->
      <xsl:if test="$g_xndMetaDataVersion/def:AnnotatedCRF">
         <xsl:for-each select="$g_xndMetaDataVersion/def:AnnotatedCRF/def:DocumentRef">
            <xsl:variable name="leafIDs" select="@leafID"/>
            <xsl:variable name="leaf" select="../../def:leaf[@ID=$leafIDs]"/>
            <fo:basic-link color="blue" text-decoration="underline">
               <xsl:attribute name="external-destination">
                  <xsl:value-of select="concat($leaf/@xlink:href,'#page=',$pagenumber - 1)"/>
               </xsl:attribute>
               <xsl:value-of select="$pagenumber"/>
            </fo:basic-link>
            <xsl:text> </xsl:text>
         </xsl:for-each>
      </xsl:if>
   </xsl:template>

   <!-- Hypertext Link to a CRF Named Destination            -->
   <xsl:template name="crfNamedDestinationHyperlink">
      <xsl:param name="destination"/>
      <!-- create the hyperlink itself -->
      <xsl:if test="$g_xndMetaDataVersion/def:AnnotatedCRF">
         <xsl:for-each select="$g_xndMetaDataVersion/def:AnnotatedCRF/def:DocumentRef">
            <xsl:variable name="leafIDs" select="@leafID"/>
            <xsl:variable name="leaf" select="../../def:leaf[@ID=$leafIDs]"/>
            <fo:basic-link color="blue" text-decoration="underline">
               <xsl:attribute name="external-destination">
                  <xsl:value-of select="concat($leaf/@xlink:href,'#',$destination)"/>
               </xsl:attribute>
               <xsl:value-of select="$destination"/>          
            </fo:basic-link>
            <xsl:text> </xsl:text>
         </xsl:for-each>
      </xsl:if>
   </xsl:template>

   <!-- Template:    linkXPT                                 -->
   <xsl:template name="linkXPT">
      <xsl:choose>
         <xsl:when test="@SASDatasetName">
            <xsl:value-of select="concat(./odm:Description/odm:TranslatedText, ' (', @SASDatasetName, ') ')"/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:value-of select="concat(./odm:Description/odm:TranslatedText, ' (', @Name, ') ')"/>
         </xsl:otherwise>
      </xsl:choose>
      <fo:inline font-weight="normal">
         <xsl:text>[Location: </xsl:text>
         <fo:basic-link color="blue" text-decoration="underline">
            <xsl:attribute name="external-destination">
               <xsl:value-of select="def:leaf/@xlink:href"/>
            </xsl:attribute>
            <xsl:value-of select="def:leaf/def:title"/>
         </fo:basic-link>    
         <xsl:text>]</xsl:text>
      </fo:inline>
   </xsl:template>  



</xsl:stylesheet >