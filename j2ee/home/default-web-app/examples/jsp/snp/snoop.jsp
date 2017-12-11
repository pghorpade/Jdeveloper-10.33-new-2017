<%@ include file="../demoUtil.jsp" %>

<html>
<!--
  Copyright (c) 1999 The Apache Software Foundation.  All rights 
  reserved.
-->

<body bgcolor="white">
<h1> Request Information </h1>
<font size="4">
JSP Request Method: <%= util.HTMLReplace(request.getMethod()) %>
<br>
Request URI: <%= util.HTMLReplace(request.getRequestURI()) %>
<br>
Request Protocol: <%= util.HTMLReplace(request.getProtocol()) %>
<br>
Servlet path: <%= util.HTMLReplace(request.getServletPath()) %>
<br>
Path info: <%= util.HTMLReplace(request.getPathInfo()) %>
<br>
Path translated: <%= util.HTMLReplace(request.getPathTranslated()) %>
<br>
Query string: <%= util.HTMLReplace(request.getQueryString()) %>
<br>
Content length: <%= request.getContentLength() %>
<br>
Content type: <%= util.HTMLReplace(request.getContentType()) %>
<br>
Server name: <%= util.HTMLReplace(request.getServerName()) %>
<br>
Server port: <%= request.getServerPort() %>
<br>
Remote user: <%= util.HTMLReplace(request.getRemoteUser()) %>
<br>
Remote address: <%= util.HTMLReplace(request.getRemoteAddr()) %>
<br>
Remote host: <%= util.HTMLReplace(request.getRemoteHost()) %>
<br>
Authorization scheme: <%= util.HTMLReplace(request.getAuthType()) %> 
<br>
Locale: <%= util.HTMLReplace(request.getLocale().toString()) %>
<hr>
The browser you are using is <%= util.HTMLReplace(request.getHeader("User-Agent")) %>
<hr>
</font>
</body>
</html>
