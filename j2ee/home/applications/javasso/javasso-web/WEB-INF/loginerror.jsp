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
   Integer attempts = (Integer) session.getAttribute(MAX_LOGIN_ATTEMPTS);
   if (null == attempts)
   {
      attempts = new Integer(0);
   }
   synchronized (session)
   {
      attempts = new Integer(attempts.intValue() + 1);
      session.setAttribute(MAX_LOGIN_ATTEMPTS, attempts);
   }
   int a = attempts.intValue();
   if (a < _maxLoginAttempts)
   {
      RequestDispatcher rd = application.getRequestDispatcher("/WEB-INF/login.jsp");
      rd.forward(request, response);
   }
</jsp:scriptlet>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="<%=_bundle.getResourceLocale().getLanguage()%>">
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
         font-size: 14pt;
         color: #ff0000;
      }
      .Title { 
         color: #336699; 
         font-family: Arial, Helvetica, Geneva, sans-serif times;
         font-size: 20pt;
      }
    </style>
  </head>
  <body class="AllText">
   <center>
    <br/><br/>
    <br/>

    <p/>
    <table class="TableStyle" width="50%">
      <tr align="center">
         <td>&nbsp;&nbsp;</td>
      </tr>
      <tr>
         <td class="ErrorMsg" align="center">
         <%= _bundle.getString(Resources.Key.JSSO_JSP_LOGINERR_MSG_TITLE) %>
         </td>
      </tr>
      <tr align="center">
         <td>&nbsp;&nbsp;</td>
      </tr>
      <tr>
         <td>      
            <div align="center">
            <%= _bundle.getString(Resources.Key.JSSO_JSP_LOGINERR_MSG, 
                                  Integer.toString((_sessionTimeout/60))) %>
            </div>
         </td>
      </tr>
      <tr align="center">
         <td>&nbsp;&nbsp;</td>
      </tr>
    </table>
   </center>
  </body>
</html>
