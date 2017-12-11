<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page contentType="text/html;charset=utf-8"%>
<jsp:directive.page import="oracle.security.jazn.sso.app.*" />
<jsp:directive.page import="oracle.security.jazn.util.Env" />
<jsp:directive.page import="oracle.security.jazn.resources.FrameworkResourceBundle" />
<jsp:directive.page import="oracle.security.jazn.util.Resources" />
<jsp:declaration>
 private static final String MAX_LOGIN_ATTEMPTS = "max-login-attempts";
 private int _maxLoginAttempts = 3;
 private int _sessionTimeout;
 private SSOServletConfig _config;
 
 public void jspInit()
 {
    _config = new SSOServletConfig(application);
    if (null != _config)
    {
       Integer var = (Integer)_config.getProperty(Env.JSSO_PROPERTY_LOGIN_MAX_ATTEMPTS);
       _maxLoginAttempts = var.intValue();
       
       var = (Integer)_config.getProperty(Env.JSSO_PROPERTY_SESSION_TIMEOUT);
       _sessionTimeout = var.intValue();
    }
 } 
</jsp:declaration>
<jsp:scriptlet>
   FrameworkResourceBundle _bundle = FrameworkResourceBundle.getResourceBundle(request.getLocales());

   Integer attempts = (Integer)session.getAttribute(MAX_LOGIN_ATTEMPTS);
   int loginAttempts = 0;
   if (null != attempts)
   {
      loginAttempts = attempts.intValue();
      if (loginAttempts >= _maxLoginAttempts)
      {
         RequestDispatcher rd = application.getRequestDispatcher("/WEB-INF/loginerror.jsp");
         rd.forward(request, response);   
      }
   }
   session.setMaxInactiveInterval(_sessionTimeout);
   String dir = _bundle.isLocaleRTL() ? "rtl" : "ltr"; 
</jsp:scriptlet>
<html lang="<%=_bundle.getResourceLocale().getLanguage()%>"    dir="<%=dir%>">
  <head>
    <title><%= _bundle.getString(Resources.Key.JSSO_JSP_PAGE_TITLE) %></title>
    <style type="text/css">
      .TableStyle { 
         background-color: #e8eefa;
         border-color: #C3D9FF;
         border-width: 1px;
         border-style: solid;
      }
      .AllText {
         font-family: Arial, Helvetica, Geneva, sans-serif times;
         font-size: 10pt;
      }
      .Form {
         background-color: #ffffff; 
         border-color: #C3D9FF;
         border-width: 1px;
      }
      .ErrorMsg { 
         font-family: Arial, Helvetica, Geneva, sans-serif; 
         font-size: 10pt;
         color: #ff0000;
      }
      .FieldText { font-family: Arial, Helvetica, Geneva, sans-serif; }
      .Title { 
         color: #336699; 
         font-family: Arial, Helvetica, Geneva, sans-serif times;
         font-size: 20pt;
      }
    </style>
  </head>
  <body class="AllText" onload="javascript:document.loginForm.j_username.focus()">
   <center>
    <br/><br/>
    <br/>
   </center>
    <p/>
    <form action="j_security_check" name="loginForm"
          autocomplete="Off" 
          method="post">
        <table cellspacing="1" cellpadding="1" class="TableStyle"
               border="0" align="center" width="50%">
          <tbody>
            <tr align="center">
              <td>&nbsp;&nbsp;</td>
              <td>&nbsp;&nbsp;</td>
            </tr>
            <tr><td align="center" colspan="2"><%= _bundle.getString(Resources.Key.JSSO_JSP_LOGIN_MSG) %></td></tr>
            <%
            if (loginAttempts > 0)
            {
            %>
        <tr>
        <td class="ErrorMsg" align="center" colspan="2">
            <%= _bundle.getString(Resources.Key.JSSO_JSP_INVALID_CREDENTIAL) %>
        </td>
        </tr>
            <%
            }
            %>
            <tr align="center">
              <td>&nbsp;&nbsp;</td>
              <td>&nbsp;&nbsp;</td>
            </tr>
            <tr align="center">
               <td colspan="2">
                  <table>
                     <tr align="center">
                       <td align="right">
                          <label for="username">
                          <%= _bundle.getString(Resources.Key.JSSO_JSP_LOGIN_USERNAME) %>:
                          </label>
                       </td>
                       <td align="left">
                         <input class="FieldText" type="text" id="username"
                                name="j_username" size="32" 
                                maxlength="64" tabindex="1"/>
                       </td>
                     </tr>
                     <tr align="center">
                       <td align="right">
                          <label for="password">
                              <%= _bundle.getString(Resources.Key.JSSO_JSP_LOGIN_PASSWORD) %>:
                          </label>
                       </td>
                       <td align="left">
                         <input class="FieldText" type="password" id="password"
                                name="j_password" size="32" 
                                maxlength="64" tabindex="2"/>
                       </td>
                     </tr>
                  </table>
               </td>
            </tr>
            <tr align="center">
              <td>&nbsp;&nbsp;</td>
              <td>&nbsp;&nbsp;</td>
            </tr>
            <tr align="center">
              <td colspan="2" align="center">
                <input type="submit" name="submit" 
                       value="<%= _bundle.getString(Resources.Key.JSSO_JSP_LOGIN_SUBMIT_TEXT) %>" tabindex="3"/>
                &nbsp;&nbsp;
                <input type="reset" name="reset" 
                       value="<%= _bundle.getString(Resources.Key.JSSO_JSP_LOGIN_CANCEL_TEXT) %>" tabindex="4"/>
              </td>
            </tr>
            <tr align="center">
              <td>&nbsp;&nbsp;</td>
              <td>&nbsp;&nbsp;</td>
            </tr>
         </tbody>
        </table>
    </form>
  </body>
</html>
