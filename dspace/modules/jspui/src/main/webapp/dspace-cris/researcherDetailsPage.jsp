<%--

    The contents of this file are subject to the license and copyright
    detailed in the LICENSE and NOTICE files at the root of the source
    tree and available online at

    https://github.com/CILEA/dspace-cris/wiki/License

--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>
<%@ taglib uri="http://displaytag.sf.net" prefix="display"%>
<%@ page import="org.dspace.app.cris.integration.RPAuthority"%>
<%@ page import="org.dspace.app.cris.network.NetworkPlugin"%>
<%@ page import="org.dspace.core.ConfigurationManager" %>
<%@ page import="org.dspace.app.webui.util.UIUtil" %>

<%@ taglib uri="jdynatags" prefix="dyna"%>
<%@ taglib uri="researchertags" prefix="researcher"%>
<c:set var="root" scope="request"><%=request.getContextPath()%></c:set>
<c:set var="entity" value="${researcher}" scope="request" />
<c:choose>
<c:when test="${param.onlytab}">
<c:forEach items="${tabList}" var="areaIter" varStatus="rowCounter">
	<c:if test="${areaIter.id == tabId}">
	<c:set var="area" scope="request" value="${areaIter}"></c:set>
	<c:set var="currTabIdx" scope="request" value="${rowCounter.count}" />
	<jsp:include page="singleTabDetailsPage.jsp"></jsp:include>
	</c:if>
</c:forEach>
</c:when>
<c:otherwise>
<c:forEach items="${tabList}" var="areaIter" varStatus="rowCounter">
	<c:if test="${areaIter.id == tabId}">
	<c:set var="currTabIdx" scope="request" value="${rowCounter.count}" />
	</c:if>
</c:forEach>
<%
    String subscribe = request.getParameter("subscribe");
	boolean showSubMsg = false;
	boolean showUnSubMsg = false;
	if (subscribe != null && subscribe.equalsIgnoreCase("true"))
	{
	    showSubMsg = true;
	}
	if (subscribe != null && subscribe.equalsIgnoreCase("false"))
	{
	    showUnSubMsg = true;
	}
	
    // Is the logged in user an admin
    Boolean admin = (Boolean)request.getAttribute("is.admin");
    boolean isAdmin = (admin == null ? false : admin.booleanValue());
    // Get the current page, minus query string
    String currentPage = UIUtil.getOriginalURL(request);
    int c = currentPage.indexOf( '?' );
    if( c > -1 )
    {
        currentPage = currentPage.substring( 0, c );
    }
    
    boolean networkModuleEnabled = ConfigurationManager.getBooleanProperty(NetworkPlugin.CFG_MODULE,"network.enabled");
%>
<c:set var="admin" scope="request"><%=isAdmin%></c:set>
<c:set var="dspace.cris.navbar" scope="request">

</c:set>
<c:set var="dspace.layout.head.last" scope="request">
	
    <script type="text/javascript"><!--

		var j = jQuery;
    
	    var activeTab = function(){
    		var ajaxurlrelations = "<%=request.getContextPath()%>/cris/${specificPartPath}/viewNested.htm";
		   	j('.nestedinfo').each(function(){
				var id = j(this).html();
				j.ajax( {
					url : ajaxurlrelations,
					data : {																			
						"parentID" : ${entity.id},
						"typeNestedID" : id,
						"pageCurrent": j('#nested_'+id+"_pageCurrent").html(),
						"limit": j('#nested_'+id+"_limit").html(),
						"editmode": j('#nested_'+id+"_editmode").html(),
						"totalHit": j('#nested_'+id+"_totalHit").html(),
						"admin": ${admin},
						"externalJSP": j('#nested_'+id+"_externalJSP").html()
					},
					success : function(data) {																										
						j('#viewnested_'+id).html(data);
						var ajaxFunction = function(page){
							j.ajax( {
								url : ajaxurlrelations,
								data : {																			
									"parentID" : ${entity.id},
									"typeNestedID" : id,													
									"pageCurrent": page,
									"limit": j('#nested_'+id+"_limit").html(),
									"editmode": j('#nested_'+id+"_editmode").html(),
									"totalHit": j('#nested_'+id+"_totalHit").html(),
									"admin": ${admin},
									"externalJSP": j('#nested_'+id+"_externalJSP").html()
								},
								success : function(data) {									
									j('#viewnested_'+id).html(data);
									postfunction();
								},
								error : function(data) {
								}
							});		
						};
						var postfunction = function(){
							j('#nested_'+id+'_next').click(
									function() {
								    	ajaxFunction(parseInt(j('#nested_'+id+"_pageCurrent").html())+1);
										
							});
							j('#nested_'+id+'_prev').click(
									function() {
										ajaxFunction(parseInt(j('#nested_'+id+"_pageCurrent").html())-1);
							});
							j('.nested_'+id+'_nextprev').click(
									function(){
										ajaxFunction(j(this).attr('id').substr(('nested_'+id+'_nextprev_').length));
							});
						};
						postfunction();
					},
					error : function(data) {
					}
				});
			});
    	};
    	
		j(document).ready(function()
		{
			
			j("#tabs").tabs({
				cache: true,
				selected: ${currTabIdx-1},
				load: function(event, ui){
					activeTab();
				},
				"activate": function( event, ui ) {
					j("li.ui-tabs-active").toggleClass("ui-tabs-active ui-state-active active");
				},
				"beforeActivate": function( event, ui ) {
	   			 j("li.active").toggleClass("active");
				},
		   		"create": function( event, ui ) {
		               j("div.ui-tabs").toggleClass("ui-tabs ui-widget ui-widget-content ui-corner-all tabbable");
		               j("ul.ui-tabs-nav").toggleClass("ui-tabs-nav ui-helper-reset ui-helper-clearfix ui-widget-header ui-corner-all nav nav-tabs");
		               j("li.ui-tabs-active").toggleClass("ui-state-default ui-corner-top ui-tabs-active ui-state-active active");
		               j("li.ui-state-default").toggleClass("ui-state-default ui-corner-top");
		               j("div.ui-tabs-panel").toggleClass("ui-tabs-panel ui-widget-content ui-corner-bottom tab-content with-padding");
		        }
			});

			activeTab();
		});
		-->
	</script>
    
</c:set>

<dspace:layout titlekey="jsp.researcher-page.details">


<div id="content">
<div class="row">
	<div class="col-lg-12">
		<div class="form-inline">
	         <div class="form-group">
			 	<h1>
				 	<fmt:message key="jsp.layout.detail.title-first" /> 
				 	<c:choose>
						<c:when test="${!empty entity.preferredName.value}">
							${entity.preferredName.value}
						</c:when>
						<c:otherwise>
							${entity.fullName}
						</c:otherwise>
					</c:choose>
				</h1>
				<%
		    	if (isAdmin) {
				%>
				<fmt:message key="jsp.cris.detail.info.sourceid.none" var="i18nnone" />
				<div class="cris-record-info">
					<span class="cris-record-info-sourceid"><b><fmt:message key="jsp.cris.detail.info.sourceid" /></b> ${!empty researcher.sourceID?researcher.sourceID:i18nnone}</span>
					<span class="cris-record-info-sourceref"><b><fmt:message key="jsp.cris.detail.info.sourceref" /></b> ${!empty researcher.sourceRef?researcher.sourceRef:i18nnone}</span>
					<span class="cris-record-info-created"><b><fmt:message key="jsp.cris.detail.info.created" /></b> ${researcher.timeStampInfo.timestampCreated.timestamp}</span>
					<span class="cris-record-info-updated"><b><fmt:message key="jsp.cris.detail.info.updated" /></b> ${researcher.timeStampInfo.timestampLastModified.timestamp}</span>
				</div>
			 	<%
		    	}
				%>
			 </div>
			 <div class="form-group pull-right" style="margin-top:1.5em;">
				<div class="btn-group">
					<% if(networkModuleEnabled) { %>
					  <a class="btn btn-default" href="<%= request.getContextPath() %>/cris/network/${researcher.crisID}"><i class="fa fa-globe"></i> <fmt:message key="jsp.cris.detail.link.network" /> </a>
					<% } %>
					<a class="btn btn-default"  href="<%= request.getContextPath() %>/cris/stats/rp.html?id=${researcher.uuid}"><i class="fa fa-bar-chart-o"></i> <fmt:message key="jsp.cris.detail.link.statistics" /> </a>
	  				<c:choose>
        					<c:when test="${!subscribed}">
                				<a class="btn btn-default" href="<%= request.getContextPath() %>/cris/tools/subscription/subscribe?uuid=${researcher.uuid}"><i class="fa fa-bell"></i> <fmt:message key="jsp.cris.detail.link.email.alert" /></a>
        					</c:when>
        					<c:otherwise>
                				<a class="btn btn-default" href="<%= request.getContextPath() %>/cris/tools/subscription/unsubscribe?uuid=${researcher.uuid}"><i class="fa fa-stop"></i> <fmt:message key="jsp.cris.detail.link.email.alert.remove" /> </a>
        					</c:otherwise>
					</c:choose>
	  				<a class="btn btn-default" href="<%= request.getContextPath() %>/open-search?query=author_authority:${authority}&amp;format=rss"><i class="fa fa-rss"></i> <fmt:message key="jsp.cris.detail.link.rssfeed" /></a>
				</div>
				<c:if test="${researcher_page_menu && !empty researcher}">
				<div class="btn-group">
						<c:if test="${!empty addModeType && addModeType=='display'}">
							<a class="btn btn-default" href="<%= request.getContextPath() %>/cris/tools/rp/editDynamicData.htm?id=${researcher.id}&anagraficaId=${researcher.dynamicField.id}<c:if test='${!empty tabIdForRedirect}'>&tabId=${tabIdForRedirect}</c:if>"><i class="fa fa-edit"></i> <fmt:message key="jsp.layout.navbar-hku.staff-mode.edit.primary-data"/></a>
						 </c:if>
						<button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown">
		    				<i class="fa fa-cog"></i> <i class="fa fa-caret-down"></i>
		  				</button>
						<ul class="dropdown-menu" role="menu">
							<c:if test="${!empty addModeType && addModeType=='display'}">
						    <li>
								<a href="<%= request.getContextPath() %>/cris/tools/rp/editDynamicData.htm?id=${researcher.id}&anagraficaId=${researcher.dynamicField.id}<c:if test='${!empty tabIdForRedirect}'>&tabId=${tabIdForRedirect}</c:if>"><i class="fa fa-pencil-square-o"></i> <fmt:message key="jsp.layout.navbar-hku.staff-mode.edit.primary-data"/></a>
							</li>
							<li>
								<a href="${root}/cris/uuid/${researcher.uuid}/relMgmt/publications"><i class="fa fa-book"></i> <fmt:message key="jsp.layout.navbar-hku.staff-mode.manage-publication"/></a>
							</li>
							</c:if>
							<c:if test="${admin}">				
								<li>
									<a href="${root}/cris/tools/rp/rebindItemsToRP.htm?id=${researcher.id}"><i class="fa fa-search"></i> <fmt:message key="jsp.layout.navbar-hku.staff-mode.bind.items"/></a>
								</li>
							</c:if>
						</ul>
					</div> 
					
<%-- 					<div class="btn-group">
						<a class="btn btn-default" href="${root}/cris/uuid/${researcher.uuid}/relMgmt/publications"><i class="fa fa-book"></i> <fmt:message key="jsp.layout.navbar-hku.staff-mode.manage-publication"/></a>
					</div> --%>
				</c:if>
			 </div>
		</div>
	</div>
</div>
	<c:if test="${!entity.status}">
		<p class="warning">
			<fmt:message
				key="jsp.layout.hku.detail.researcher-disabled" /><a				
				href="<%= request.getContextPath() %>/cris/tools/rp/editDynamicData.htm?id=${researcher.id}&anagraficaId=${researcher.dynamicField.id}<c:if test='${!empty tabIdForRedirect}'>&tabId=${tabIdForRedirect}</c:if>"><fmt:message
				key="jsp.layout.hku.detail.researcher-disabled.fixit" /></a>
		</p>
	</c:if>

	<c:if test="${pendingItems > 0}">
		<p class="warning pending">
			<fmt:message
				key="jsp.layout.hku.detail.researcher-pending-items">
				<fmt:param>${pendingItems}</fmt:param>
			</fmt:message> <fmt:message
				key="jsp.layout.hku.detail.researcher-goto-pending-items">
				<fmt:param><%=request.getContextPath()%>/dspace-admin/authority?authority=<%=RPAuthority.RP_AUTHORITY_NAME%>&key=${authority_key}</fmt:param>
			</fmt:message>
		</p>	
	</c:if>

	<c:if test="${not empty messages}">
	<div class="message" id="successMessages">
		<c:forEach var="msg" items="${messages}">
				<div id="authority-message">${msg}</div>
		</c:forEach>
	</div>
	<c:remove var="messages" scope="session" />
	</c:if>
	
		<div id="researcher">
			<jsp:include page="commonDetailsPage.jsp"></jsp:include>
		</div>
</div>

</dspace:layout>
</c:otherwise>
</c:choose>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/cris_page.js"></script>
