<!--
~   Copyright (c) 2018 WSO2 Inc. (http://wso2.com) All Rights Reserved.
~
~   Licensed under the Apache License, Version 2.0 (the "License");
~   you may not use this file except in compliance with the License.
~   You may obtain a copy of the License at
~
~        http://www.apache.org/licenses/LICENSE-2.0
~
~   Unless required by applicable law or agreed to in writing, software
~   distributed under the License is distributed on an "AS IS" BASIS,
~   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
~   See the License for the specific language governing permissions and
~   limitations under the License.
-->
<%
    final HttpSession currentSession =  request.getSession(false);
    if (currentSession != null
            && currentSession.getAttribute("authenticated") != null
                &&  (boolean)currentSession.getAttribute("authenticated")) {
        // Logged in session. Direct to Home
        response.sendRedirect("home.jsp");
        return;
    } else {
        response.sendRedirect("oauth2-authorize-user.jsp?reset=true");
    }
%>
