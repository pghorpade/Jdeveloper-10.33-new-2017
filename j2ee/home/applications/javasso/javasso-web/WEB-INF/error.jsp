<%@ page isErrorPage="true" contentType="text/html;charset=utf-8"%>
<jsp:directive.page import="oracle.security.jazn.resources.FrameworkResourceBundle" />
<jsp:directive.page import="oracle.security.jazn.util.Resources" />
<jsp:scriptlet>
   FrameworkResourceBundle _bundle = FrameworkResourceBundle.getResourceBundle(request.getLocales());
</jsp:scriptlet>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="<%=_bundle.getResourceLocale().getLanguage()%>">
  <head>
    <title><%= _bundle.getString(Resources.Key.JSSO_JSP_ERROR_PAGE_TITLE) %></title>
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
         <%= _bundle.getString(Resources.Key.JSSO_JSP_ERROR_MSG_TITLE) %>
         </td>
      </tr>
      <tr align="center">
         <td>&nbsp;&nbsp;</td>
      </tr>
      <tr>
         <td>      
            <div align="center">
      <%= _bundle.getString(Resources.Key.JSSO_JSP_ERROR_MSG) %>
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
