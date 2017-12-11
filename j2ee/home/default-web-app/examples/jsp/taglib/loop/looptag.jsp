<%@ page session="false" %>
<%@ taglib uri="http://www.orionserver.com/examples/jsp/taglib/loop/looptags.jar" prefix="test" %>

<html>
<title>Loop tag example</title>

<body bgcolor="white">

<h1>A tag loops through dynamic attributes.</h1>
This example shows how to use a simple loop-tag with dynamic attributes. Try reloading the page a few times. The numbers of rows and columns are different each time.
<p/>

    <% int x = 0; %>
    <table border="2">
        <test:loop count="10">
            <tr>
                <test:loop count="<%= Math.random() * 10f %>">
                    <td><%= x++ %></td>
                </test:loop>
            </tr>
        </test:loop>
    </table>

</body>
</html>

