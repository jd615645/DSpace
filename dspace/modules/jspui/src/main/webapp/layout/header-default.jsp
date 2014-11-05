<%--

    The contents of this file are subject to the license and copyright
    detailed in the LICENSE and NOTICE files at the root of the source
    tree and available online at

    http://www.dspace.org/license/

--%>
<%--
  - HTML header for main home page
  --%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>

<%@ page contentType="text/html;charset=UTF-8" %>

<%@ page import="java.util.List"%>
<%@ page import="java.util.Enumeration"%>
<%@ page import="org.dspace.app.webui.util.JSPManager" %>
<%@ page import="org.dspace.core.ConfigurationManager" %>
<%@ page import="org.dspace.app.util.Util" %>
<%@ page import="javax.servlet.jsp.jstl.core.*" %>
<%@ page import="javax.servlet.jsp.jstl.fmt.*" %>

<%
    String title = (String) request.getAttribute("dspace.layout.title");
    String navbar = (String) request.getAttribute("dspace.layout.navbar");
    boolean locbar = ((Boolean) request.getAttribute("dspace.layout.locbar")).booleanValue();

    String siteName = ConfigurationManager.getProperty("dspace.name");
    String feedRef = (String)request.getAttribute("dspace.layout.feedref");
    boolean osLink = ConfigurationManager.getBooleanProperty("websvc.opensearch.autolink");
    String osCtx = ConfigurationManager.getProperty("websvc.opensearch.svccontext");
    String osName = ConfigurationManager.getProperty("websvc.opensearch.shortname");
    List parts = (List)request.getAttribute("dspace.layout.linkparts");
    String extraHeadData = (String)request.getAttribute("dspace.layout.head");
    String extraHeadDataLast = (String)request.getAttribute("dspace.layout.head.last");
    String dsVersion = Util.getSourceVersion();
    String generator = dsVersion == null ? "DSpace" : "DSpace "+dsVersion;
    String analyticsKey = ConfigurationManager.getProperty("jspui.google.analytics.key");
%>

<!DOCTYPE html>
<html>
    <head>
        <title><%= siteName %>: <%= title %></title>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="Generator" content="<%= generator %>" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="shortcut icon" href="<%= request.getContextPath() %>/favicon.ico" type="image/x-icon"/>
	    <link rel="stylesheet" href="<%= request.getContextPath() %>/static/css/jquery-ui-1.10.3.custom/redmond/jquery-ui-1.10.3.custom.css" type="text/css" />
	    <link href="<%= request.getContextPath() %>/css/researcher.css" type="text/css" rel="stylesheet" />
       <link href="<%= request.getContextPath() %>/css/jdyna.css" type="text/css" rel="stylesheet" />
	    <link rel="stylesheet" href="<%= request.getContextPath() %>/static/css/bootstrap/bootstrap.min.css" type="text/css" />
	    <link rel="stylesheet" href="<%= request.getContextPath() %>/static/css/bootstrap/bootstrap-theme.min.css" type="text/css" />
	    <link href="<%= request.getContextPath() %>/static/css/font-awesome/css/font-awesome.min.css" rel="stylesheet">
		<link href="<%= request.getContextPath() %>/static/css/jstree/themes/default/style.min.css" rel="stylesheet"/>
	    <link rel="stylesheet" href="<%= request.getContextPath() %>/static/css/bootstrap/dspace-theme.css" type="text/css" />
<%
    if (!"NONE".equals(feedRef))
    {
        for (int i = 0; i < parts.size(); i+= 3)
        {
%>
        <link rel="alternate" type="application/<%= (String)parts.get(i) %>" title="<%= (String)parts.get(i+1) %>" href="<%= request.getContextPath() %>/feed/<%= (String)parts.get(i+2) %>/<%= feedRef %>"/>
<%
        }
    }
    
    if (osLink)
    {
%>
        <link rel="search" type="application/opensearchdescription+xml" href="<%= request.getContextPath() %>/<%= osCtx %>description.xml" title="<%= osName %>"/>
<%
    }

    if (extraHeadData != null)
        { %>
<%= extraHeadData %>
<%
        }
%>
        
	<script type='text/javascript' src="<%= request.getContextPath() %>/static/js/jquery/jquery-1.10.2.min.js"></script>
	<script type='text/javascript' src='<%= request.getContextPath() %>/static/js/jquery/jquery-ui-1.10.3.custom.min.js'></script>
	<script type='text/javascript' src='<%= request.getContextPath() %>/static/js/bootstrap/bootstrap.min.js'></script>
	<script type='text/javascript' src='<%= request.getContextPath() %>/static/js/holder.js'></script>
	<script type="text/javascript" src="<%= request.getContextPath() %>/utils.js"></script>
    <script type="text/javascript" src="<%= request.getContextPath() %>/static/js/choice-support.js"> </script>
    <script type="text/javascript" src="<%=request.getContextPath()%>/js/jdyna/jdyna.js"></script>
	<script type='text/javascript'>
		var j = jQuery.noConflict();
		var $ = jQuery.noConflict();
		var JQ = j;
		dspaceContextPath = "<%=request.getContextPath()%>";
	</script>
    <%--Gooogle Analytics recording.--%>
    <%
    if (analyticsKey != null && analyticsKey.length() > 0)
    {
    %>
        <script type="text/javascript">
            var _gaq = _gaq || [];
            _gaq.push(['_setAccount', '<%= analyticsKey %>']);
            _gaq.push(['_trackPageview']);

            (function() {
                var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
                ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
                var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
            })();
        </script>
    <%
    }
    if (extraHeadDataLast != null)
    { %>
		<%= extraHeadDataLast %>
		<%
		    }
    %>
    

<!-- HTML5 shim and Respond.js IE8 support of HTML5 elements and media queries -->
<!--[if lt IE 9]>
  <script src="<%= request.getContextPath() %>/static/js/html5shiv.js"></script>
  <script src="<%= request.getContextPath() %>/static/js/respond.min.js"></script>
<![endif]-->
  <script type="text/javascript" src="jquery.js"></script>
    </head>

    <%-- HACK: leftmargin, topmargin: for non-CSS compliant Microsoft IE browser --%>
    <%-- HACK: marginwidth, marginheight: for non-CSS compliant Netscape browser --%>
    <body class="undernavigation">
<a class="sr-only" href="#content">Skip navigation</a>
<header class="navbar navbar-inverse navbar-fixed-top">    
    <%
    if (!navbar.equals("off"))
    {
%>
            <div class="container">
                <dspace:include page="<%= navbar %>" />
            </div>
<%
    }
    else
    {
    	%>
        <div class="container">
            <dspace:include page="/layout/navbar-minimal.jsp" />
        </div>
<%    	
    }
%>
</header>

<main id="content" role="main">
<div class="container banner">
	<div class="row">
		<div class="col-md-9 brand">
		<h1><fmt:message key="jsp.layout.header-default.brand.heading" /></h1>
        <fmt:message key="jsp.layout.header-default.brand.description" /> 
        </div>
        <div class="col-md-3"><img class="pull-right" src="<%= request.getContextPath() %>/image/logo.gif">
        </div>
	</div>
</div>	
<br/>
                <%-- Location bar --%>
<%
    if (locbar)
    {
%>
<div class="container">
                <dspace:include page="/layout/location-bar.jsp" />
</div>                
<%
    }
%>


        <%-- Page contents --%>
<div class="container">
<% if (request.getAttribute("dspace.layout.sidebar") != null) { %>
    <div class="row">
        <div class="col-md-2 hidden-xs hidden-sm">
          <div class="panel panel-default">
            <div class="panel-heading">瀏覽全部</div>
            <ul class="list-group">
              <li class="list-group-item">校內出版品</li>
              <li class="list-group-item">社群與類別</li>
              <li class="list-group-item">資料類型</li>
              <li class="list-group-item">Hi-cited文章列表</li>
              <li class="list-group-item">Vestibulum at eros</li>
            </ul>
          </div>

          <div class="panel panel-default">
            <div class="panel-heading">相關連結</div>
            <ul class="list-group">
              <li class="list-group-item">著作權相關文件</li>
              <li class="list-group-item">
                <a href="http://tair.org.tw/" target="_blank">臺灣學術機構典藏</a>
              </li>
              <li class="list-group-item">
                <a href="http://ir.org.tw/" target="_blank">機構典藏計畫網站</a>
              </li>
              <li class="list-group-item">
                <a href="http://www.opendoar.org/" target="_blank">OpenDOAR</a>
              </li>
              <li class="list-group-item">
                <a href="http://roar.eprints.org/" target="_blank">ROAR</a>
              </li>
              <li class="list-group-item">
                <a href="http://www.oclc.org/oaister/" target="_blank">OAIster</a>
              </li>
              <li class="list-group-item">
                <a href="http://repositories.webometrics.info/" target="_blank">RWWR</a>
              </li>
              <li class="list-group-item">
                <a href="http://www.sherpa.ac.uk/index.html" target="_blank">SHERPA</a>
              </li>
              <li class="list-group-item">
                <a href="http://www.dspace.org/" target="_blank">DSPACE</a>
              </li>
              <li class="list-group-item">
                <a href="http://www.nchu.edu.tw/" target="_blank">興大首頁</a>
              </li>
              <li class="list-group-item">
                <a href="http://www.lib.nchu.edu.tw/" target="_blank">興大圖書館</a>
              </li>
              <li class="list-group-item">
                <a href="mailto:nchuir@gmail.com" target="_blank">與管理員聯絡</a>
              </li>
            </ul>
          </div>

          <div class="panel panel-default">
            <div class="panel-heading">學術資源</div>
            <ul class="list-group">
              <li class="list-group-item">
                <a href="http://www.ndltd.org/" target="_blank">NDLTD</a>
              </li>
              <li class="list-group-item">
                <a href="http://etds.lib.nchu.edu.tw/" target="_blank">興大電子學位論文服務</a>
              </li>
              <li class="list-group-item">
                <a href="http://ndltd.ncl.edu.tw/" target="_blank">臺灣碩博士論文系統</a>
              </li>
              <li class="list-group-item">
                <a href="http://www.grb.gov.tw/" target="_blank">政府研究資訊系統</a>
              </li>
              <li class="list-group-item">
                <a href="http://twpat.tipo.gov.tw/" target="_blank">中華民國專利資訊檢索系統</a>
              </li>
            </ul>
          </div>
        </div>
        <div class="col-md-7">
<% } %>		
<% if (request.getAttribute("dspace.layout.sidebar") == null) { %>
    <div class="row">
        <div class="col-md-2 hidden-xs hidden-sm">
          <div class="panel panel-default">
            <!-- Default panel contents -->
            <div class="panel-heading">瀏覽全部</div>

            <!-- List group -->
            <ul class="list-group">
              <li class="list-group-item">校內出版品</li>
              <li class="list-group-item">社群與類別</li>
              <li class="list-group-item">資料類型</li>
              <li class="list-group-item">Hi-cited文章列表</li>
              <li class="list-group-item">Vestibulum at eros</li>
            </ul>
          </div>
          <div class="panel panel-default">
            <!-- Default panel contents -->
            <div class="panel-heading">相關連結</div>

            <!-- List group -->
            <ul class="list-group">
              <li class="list-group-item">著作權相關文件</li>
              <li class="list-group-item">
                <a href="http://tair.org.tw/" target="_blank">臺灣學術機構典藏</a>
              </li>
              <li class="list-group-item">
                <a href="http://ir.org.tw/" target="_blank">機構典藏計畫網站</a>
              </li>
              <li class="list-group-item">
                <a href="http://www.opendoar.org/" target="_blank">OpenDOAR</a>
              </li>
              <li class="list-group-item">
                <a href="http://roar.eprints.org/" target="_blank">ROAR</a>
              </li>
              <li class="list-group-item">
                <a href="http://www.oclc.org/oaister/" target="_blank">OAIster</a>
              </li>
              <li class="list-group-item">
                <a href="http://repositories.webometrics.info/" target="_blank">RWWR</a>
              </li>
              <li class="list-group-item">
                <a href="http://www.sherpa.ac.uk/index.html" target="_blank">SHERPA</a>
              </li>
              <li class="list-group-item">
                <a href="http://www.dspace.org/" target="_blank">DSPACE</a>
              </li>
              <li class="list-group-item">
                <a href="http://www.nchu.edu.tw/" target="_blank">興大首頁</a>
              </li>
              <li class="list-group-item">
                <a href="http://www.lib.nchu.edu.tw/" target="_blank">興大圖書館</a>
              </li>
              <li class="list-group-item">
                <a href="mailto:nchuir@gmail.com" target="_blank">與管理員聯絡</a>
              </li>
            </ul>
          </div>
          <div class="panel panel-default">
            <div class="panel-heading">學術資源</div>
            <ul class="list-group">
              <li class="list-group-item">
                <a href="http://www.ndltd.org/" target="_blank">NDLTD</a>
              </li>
              <li class="list-group-item">
                <a href="http://etds.lib.nchu.edu.tw/" target="_blank">興大電子學位論文服務</a>
              </li>
              <li class="list-group-item">
                <a href="http://ndltd.ncl.edu.tw/" target="_blank">臺灣碩博士論文系統</a>
              </li>
              <li class="list-group-item">
                <a href="http://www.grb.gov.tw/" target="_blank">政府研究資訊系統</a>
              </li>
              <li class="list-group-item">
                <a href="http://twpat.tipo.gov.tw/" target="_blank">中華民國專利資訊檢索系統</a>
              </li>
            </ul>
          </div>
        </div>
        <div class="col-md-10">
<% } %>     
