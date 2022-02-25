<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html>
<!--
~ Copyright (c) 2018 WSO2 Inc. (http://wso2.com) All Rights Reserved.
~
~ Licensed under the Apache License, Version 2.0 (the "License");
~ you may not use this file except in compliance with the License.
~ You may obtain a copy of the License at
~
~ http://www.apache.org/licenses/LICENSE-2.0
~
~ Unless required by applicable law or agreed to in writing, software
~ distributed under the License is distributed on an "AS IS" BASIS,
~ WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
~ See the License for the specific language governing permissions and
~ limitations under the License.
-->
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.logging.Level"%>
<%@page import="com.nimbusds.jwt.SignedJWT"%>
<%@page import="org.wso2.sample.identity.oauth2.OAuth2Constants"%>
<%@page import="org.json.JSONObject"%>
<%@page import="java.util.Properties"%>
<%@page import="org.wso2.sample.identity.oauth2.SampleContextEventListener"%>
<%@page import="org.wso2.sample.identity.oauth2.CommonUtils"%>
<%@page import="com.nimbusds.jwt.ReadOnlyJWTClaimsSet"%>
<%@page import="java.util.logging.Logger"%>

<%
    final Logger logger = Logger.getLogger(getClass().getName());
    final HttpSession currentSession =  request.getSession(false);

    if (currentSession == null || currentSession.getAttribute("authenticated") == null) {
        // A direct access to home. Must redirect to index
        response.sendRedirect("index.jsp");
        return;
    }

    final Properties properties = SampleContextEventListener.getProperties();
    final String sessionState = (String) currentSession.getAttribute(OAuth2Constants.SESSION_STATE);

    final JSONObject requestObject = (JSONObject) currentSession.getAttribute("requestObject");
    final JSONObject responseObject = (JSONObject) currentSession.getAttribute("responseObject");

    final String idToken = (String) currentSession.getAttribute("idToken");

    String name = "";

    Map<String, Object> customClaimValueMap = new HashMap<>();
    Map<String, String> oidcClaimDisplayValueMap = new HashMap();

    if (idToken != null) {
        try {
            name = SignedJWT.parse(idToken).getJWTClaimsSet().getStringClaim("username");
            if (name == null) {
                name = SignedJWT.parse(idToken).getJWTClaimsSet().getStringClaim("email");
            }

            if (name == null) {
                name = SignedJWT.parse(idToken).getJWTClaimsSet().getStringClaim("preferred_username");
            }

            ReadOnlyJWTClaimsSet claimsSet = SignedJWT.parse(idToken).getJWTClaimsSet();
            System.out.println(claimsSet.toJSONObject().toJSONString());

        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error when getting id_token details.", e);
        }
    }
%>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="description" content="Guardio Partner">
    <link rel="icon" type="image/x-icon" href="img/favicon.ico">

    <title>Guardio Partner Portal</title>

    <!-- Bootstrap Material Design CSS -->
    <link href="libs/bootstrap-material-design_4.0.0/css/bootstrap-material-design.min.css" rel="stylesheet">
    <!-- Font Awesome icons -->
    <link href="libs/fontawesome-5.2.0/css/fontawesome.min.css" rel="stylesheet">
    <link href="libs/fontawesome-5.2.0/css/solid.min.css" rel="stylesheet">
    <!-- Highlight styles -->
    <link href="libs/highlight_9.12.0/styles/atelier-cave-light.css" rel="stylesheet">

    <!-- Custom styles -->
    <link href="css/spinner.css" rel="stylesheet">
    <link href="css/custom.css" rel="stylesheet">
    <link href="css/dispatch.css" rel="stylesheet">
    <link href="css/themes/default/theme.min.css" rel="stylesheet">
    <link href="css/guardio.css" rel="stylesheet">

    <!-- Analytics -->
    <!-- jsp:include page="analytics.jsp"/ -->
    <style type="text/css">
        .partner-card {
            background: #7b95ca;
            border-radius: 0;
            height: 250px;
            display: flex;
            flex-direction: column;
            flex-wrap: nowrap;
            align-content: center;
            justify-content: center;
            align-items: center;
        }

        .partner-card  .ui.header {
            margin-bottom: 30px;
        }

        .partner-card .ui.tiny.image {

        }
    </style>
</head>

<body class="app-home dispatch">
<div id="actionContainer">
    <nav class="ui borderless top fixed app-header menu inverted">
        <div class="ui fluid container">
            <a class="header item" href="home.jsp">
                <div class="product-title" style="margin-top: 0px;">
                    <div class="theme-icon inline auto transparent product-logo">
                        <img src="img/guardio-logo.svg" width="30px" />
                    </div>
                    <h1 class="product-title-text" style="margin-top: 0px;">
                        Guardio<span class="portal-name"> Partner Portal</span>
                    </h1>
                </div>
            </a>

            <div class="right menu">
                <div role="listbox" aria-expanded="false" class="ui floating item dropdown user-dropdown">
                    <span class="user-dropdown-trigger" href="#" id="navbarDropdownMenuLink"
                        data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                        <div class="username"><%=name%></div>
                        <div class="ui circular image user-image mini user-avatar">
                            <div class="wrapper">
                                <img alt="avatar" src="img/avatar.png">
                            </div>
                        </div>
                    </span>

                    <div class="dropdown-menu menu transition visible" aria-labelledby="navbarDropdownMenuLink">
                            <a class="dropdown-item" target="_blank" href="<%=properties.getProperty("userPortalURL")%>">
                                My Account
                            </a>
                            <a class="item" href='<%=properties.getProperty("OIDC_LOGOUT_ENDPOINT")%>?post_logout_redirect_uri=<%=properties.getProperty("post_logout_redirect_uri")%>&id_token_hint=<%=idToken%>&session_state=<%=sessionState%>'>
                                Logout
                            </a>
                    </div>
                    <div class="menu" aria-labelledby="navbarDropdownMenuLink">
                        <div class="divider"></div>
                        <div role="option" class="item action-panel">
                            <a class="action-button" href="/user-portal/logout">Logout</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </nav>

    <main role="main" class="main-content">
        <div class="ui container dashboard-content">
            <div class="ui divider hidden"></div>
            <div class="ui grid">
                <div class="row">
                    <div class="sixteen wide column">
                        <h1 class="ui header">Welcome to the Parner Portal</h1>
                    </div>
                </div>
                <div class="row">
                    <div class="sixteen wide column">
                        <div class="ui two column grid">
                            <div class="column">
                                <div class="ui inverted segment relaxed partner-card" style="background: #47210f;">
                                    <h2 class="ui header">Products</h2>
                                    <img class="ui tiny image" src="https://www.svgrepo.com/show/406828/package.svg">
                                </div>
                            </div>
                            <div class="column">
                                <div class="ui inverted segment partner-card" style="background: #aabde8;">
                                    <h2 class="ui header">Marketplace</h2>
                                    <img class="ui tiny image" src="https://www.svgrepo.com/show/375440/google-cloud-marketplace.svg">
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="sixteen wide column">
                        <div class="ui three column grid">
                            <div class="column">
                                <div class="ui inverted segment partner-card" style="background: #000000;">
                                    <h2 class="ui header">Content</h2>
                                    <img class="ui tiny image" src="https://www.svgrepo.com/show/219271/content.svg">
                                </div>
                            </div>
                            <div class="column">
                                <div class="ui inverted segment partner-card" style="background: #dd5323;">
                                    <h2 class="ui header">Dashboards</h2>
                                    <img class="ui tiny image" src="https://www.svgrepo.com/show/237110/dashboard.svg">
                                </div>
                            </div>
                            <div class="column">
                                <div class="ui inverted segment partner-card" style="background: #121149;">
                                    <h2 class="ui header">Settings</h2>
                                    <img class="ui tiny image" src="https://www.svgrepo.com/show/38283/settings.svg">
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </main><!-- /.container -->

    <div id="app-footer" class="ui borderless bottom fixed app-footer menu inverted">
        <div class="item copyright">
            <p>Guardio Partner &copy;
                <script>document.write(new Date().getFullYear());</script> | Powered by
                <span style="display: inline-block; height: 14px; width: 20px; width: 40px; vertical-align: bottom;">
                    <svg viewBox="29 -6.639 72 27.639">
                        <path fill="#FFF" d="M90.804 3.776l-.01-.115h-3.375l-.035.063c-.402.711-.798 1.425-1.193 2.14l-.348.626c-.601-1.454-1.198-2.908-1.795-4.363-.63-1.535-1.26-3.07-1.895-4.603l-.11-.266-.119.262A631.674 631.674 0 0080.565.541a479.296 479.296 0 01-1.905 4.212c-.897-.008-1.794-.007-2.695-.006-.823.001-1.648.002-2.475-.004l-.128-.001.002.128c.004.278.044.554.083.821l.021.148h.108c1.432-.002 2.863-.002 4.293-.001h1.512l.034-.073c.44-.972.878-1.947 1.316-2.921.421-.938.842-1.875 1.267-2.811.643 1.552 1.279 3.106 1.917 4.661.558 1.359 1.115 2.719 1.677 4.077l.098.237.127-.224c.576-1.025 1.147-2.054 1.719-3.082l.528-.951h2.74l.01-.115c.02-.253.017-.527-.01-.86z"></path>
                        <path fill="#FFF" d="M29-6.61c.849.001 1.696-.002 2.545.002 2.065 5.082 4.121 10.169 6.198 15.247 2.069-5.093 4.122-10.194 6.213-15.278 2.067 5.095 4.138 10.188 6.205 15.283 2.068-5.084 4.126-10.172 6.198-15.255.857.001 1.716-.002 2.573.001-2.883 7.122-5.778 14.24-8.658 21.364-.008.103-.157.273-.192.074-2.042-5.053-4.094-10.1-6.127-15.157-2.084 5.111-4.142 10.233-6.216 15.347A14572.55 14572.55 0 0129-6.61zM60.721-5.513c1.362-.97 3.118-1.239 4.751-1.046 1.875.271 3.473 1.576 4.363 3.213-.618.407-1.25.793-1.865 1.205-.329-.36-.55-.802-.893-1.15-.453-.498-1.041-.895-1.709-1.027-1.316-.275-2.805.074-3.734 1.083-.996 1.055-1.006 3.01.193 3.919.841.609 1.756 1.108 2.677 1.586 1.174.532 2.363 1.052 3.429 1.787.741.523 1.531 1.047 2 1.847.684 1.164.755 2.589.537 3.894-.291 1.735-1.421 3.248-2.881 4.192-1.289.842-2.883 1.128-4.401.968-1.382-.108-2.744-.654-3.748-1.624-1.047-.983-1.665-2.335-1.985-3.718.763-.234 1.526-.463 2.288-.698.283 1.176.807 2.364 1.789 3.12.933.742 2.211.893 3.355.68 1.338-.239 2.507-1.217 3.011-2.474.314-.84.416-1.786.158-2.653-.175-.6-.595-1.103-1.111-1.443a23.384 23.384 0 00-3.385-1.869 16.78 16.78 0 01-2.603-1.436c-.654-.453-1.336-.917-1.767-1.604-.69-1.087-.784-2.461-.533-3.698.245-1.244 1.032-2.337 2.064-3.054z"></path>
                        <path fill="#FFF" d="M81.274-6.596c1.743-.113 3.52.152 5.121.864 3.276 1.389 5.746 4.501 6.343 8.011.419 2.347.048 4.832-1.074 6.939-1.465 2.814-4.231 4.91-7.342 5.546-2.047.43-4.217.261-6.168-.498a10.824 10.824 0 01-4.76-3.617 10.718 10.718 0 01-2.128-5.908c-.145-2.528.646-5.1 2.194-7.105 1.841-2.442 4.761-4.027 7.814-4.232zm-1.297 2.449A8.64 8.64 0 0074.488.138c-.785 1.439-1.099 3.101-1.022 4.731h.024c.004.283.047.565.088.846.455 2.707 2.287 5.133 4.77 6.303a8.599 8.599 0 006.453.409c1.752-.574 3.295-1.744 4.35-3.254a8.58 8.58 0 001.538-4.546 5.025 5.025 0 00-.009-.841 8.645 8.645 0 00-1.596-4.581 8.651 8.651 0 00-4.566-3.258 8.568 8.568 0 00-4.541-.094zM93.688 3.447a6.424 6.424 0 013.479.015c1.542.453 2.786 1.721 3.318 3.223.526 1.563.294 3.35-.576 4.747-.709 1.137-1.603 2.146-2.506 3.132-1.461 1.578-2.927 3.152-4.387 4.732 2.661-.004 5.322-.001 7.983-.002-.001.568.001 1.136-.001 1.705-3.943-.004-7.886.003-11.829-.003 2.519-2.731 5.062-5.44 7.571-8.18.917-1.088 1.998-2.181 2.249-3.64.232-1.143-.129-2.387-.985-3.189-1.102-1.147-2.93-1.389-4.359-.759.04-.591.11-1.188.043-1.781z"></path>
                    </svg>
                </span> Identity Server
            </p>
        </div>
    </div>
</div>
<!-- JQuery -->
<script src="libs/jquery_3.3.1/jquery.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/semantic-ui/2.4.1/semantic.min.js"
        integrity="sha256-t8GepnyPmw9t+foMh3mKNvcorqNHamSKtKRxxpUEgFI=" crossorigin="anonymous"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.9.3/Chart.min.js"
        integrity="sha256-R4pqcOYV8lt7snxMQO/HSbVCFRPMdrhAFMH+vr9giYI=" crossorigin="anonymous"></script>
<!-- Popper -->
<script src="libs/popper_1.12.9/popper.min.js"></script>
<!-- Bootstrap Material Design JavaScript -->
<script src="libs/bootstrap-material-design_4.0.0/js/bootstrap-material-design.min.js"></script>
<!-- Moment -->
<script src="libs/moment_2.11.2/moment.min.js"></script>
<!-- Highlight -->
<script src="libs/highlight_9.12.0/highlight.pack.js"></script>
<!-- Clipboard -->
<script src="libs/clipboard/clipboard.min.js"></script>
<!-- Custom Js -->
<script src="js/custom.v1.0.js"></script>
<!-- SweetAlerts -->
<script src="libs/sweetalerts/sweetalert.2.1.2.min.js"></script>

    <script>
        var ctx = document.getElementById("ticket-stats-chart").getContext("2d");
        var chart = new Chart(ctx, {
            type: "bar",
            data: {
                labels: ["Jun 2019", "Jul 2019", "Aug 2019", "Sep 2019", "Oct 2019", "Nov 2019", "Dec 2019", "Jan 2020", "Feb 2020", "Mar 2020", "Apr 2020", "May 2020"],
                datasets: [{
                    label: "Ticket Count",
                    backgroundColor: "orange",
                    borderColor: "royalblue",
                    data: [26.4, 39.8, 66.8, 66.4, 40.6, 55.2, 77.4, 69.8, 57.8, 76, 110.8, 142.6],
                }]
            },
            options: {
                layout: {
                    padding: 0,
                },
                legend: {
                    position: "bottom",
                },
                title: {
                    display: true,
                    text: "Count"
                },
                scales: {
                    yAxes: [{
                        scaleLabel: {
                            display: true,
                            labelString: "Ticket count"
                        }
                    }],
                    xAxes: [{
                        scaleLabel: {
                            display: true,
                            labelString: "Month of the Year"
                        }
                    }]
                }
            }
        });
    </script>
    <script>
        var claimctx = document.getElementById("current-cliam-state").getContext('2d');

        var config = {
            type: 'doughnut',
            data: {
                labels: ['Closed', 'Open'],
                datasets: [{
                    label: "Your Ticket Status",
                    backgroundColor: ["#3e95cd", "#8e5ea2"],
                    data: [12, 2]
                }]
            },
            options: {
                responsive: true,
                tooltips: {
                    mode: "index",
                    intersect: false,
                },
                hover: {
                    mode: "nearest",
                    intersect: true
                },
                scales: {
                    x: {
                        display: true,
                        scaleLabel: {
                            display: true,
                            labelString: "Status"
                        }
                    },
                    y: {
                        display: true,
                        scaleLabel: {
                            display: true,
                            labelString: "Value"
                        }
                    }
                }
            }
        };

        var myChart = new Chart(claimctx, config);
    </script>
</body>
</html>
