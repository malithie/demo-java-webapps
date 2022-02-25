<%--
  ~ Copyright (c) 2020, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
  ~
  ~  WSO2 Inc. licenses this file to you under the Apache License,
  ~  Version 2.0 (the "License"); you may not use this file except
  ~  in compliance with the License.
  ~  You may obtain a copy of the License at
  ~
  ~    http://www.apache.org/licenses/LICENSE-2.0
  ~
  ~ Unless required by applicable law or agreed to in writing,
  ~ software distributed under the License is distributed on an
  ~ "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
  ~ KIND, either express or implied.  See the License for the
  ~ specific language governing permissions and limitations
  ~ under the License.
--%>
<%--<jsp:directive.include file="/includes/config.jsp"/>--%>

<%!
    private static final String GOOGLE_ANALYTICS_TOKEN;
    private static final String MIXPANEL_TOKEN;
    static {
        GOOGLE_ANALYTICS_TOKEN = System.getenv("GA_INTERNAL_TRACKING_TOKEN");
        MIXPANEL_TOKEN = System.getenv("MIXPANEL_INTERNAL_TRACKING_TOKEN");
    }
%>

<%
    if (GOOGLE_ANALYTICS_TOKEN != null) {
%>
    <%-- Init Google Analytics --%>
    <script async src="https://www.googletagmanager.com/gtag/js?id=<%=GOOGLE_ANALYTICS_TOKEN%>"></script>
    <script>
        window.dataLayer = window.dataLayer || [];
        function gtag(){dataLayer.push(arguments);}
        gtag("js", new Date());

        gtag("config", "<%=GOOGLE_ANALYTICS_TOKEN%>");
    </script>
<%
    }
%>

<%
    if (MIXPANEL_TOKEN != null) {
%>
    <%-- Init Mixpanel --%>
    <script type="text/javascript">(function(c,a){if(!a.__SV){var b=window;try{var d,m,j,k=b.location,f=k.hash;d=function(a,b){return(m=a.match(RegExp(b+"=([^&]*)")))?m[1]:null};f&&d(f,"state")&&(j=JSON.parse(decodeURIComponent(d(f,"state"))),"mpeditor"===j.action&&(b.sessionStorage.setItem("_mpcehash",f),history.replaceState(j.desiredHash||"",c.title,k.pathname+k.search)))}catch(n){}var l,h;window.mixpanel=a;a._i=[];a.init=function(b,d,g){function c(b,i){var a=i.split(".");2==a.length&&(b=b[a[0]],i=a[1]);b[i]=function(){b.push([i].concat(Array.prototype.slice.call(arguments,
        0)))}}var e=a;"undefined"!==typeof g?e=a[g]=[]:g="mixpanel";e.people=e.people||[];e.toString=function(b){var a="mixpanel";"mixpanel"!==g&&(a+="."+g);b||(a+=" (stub)");return a};e.people.toString=function(){return e.toString(1)+".people (stub)"};l="disable time_event track track_pageview track_links track_forms track_with_groups add_group set_group remove_group register register_once alias unregister identify name_tag set_config reset opt_in_tracking opt_out_tracking has_opted_in_tracking has_opted_out_tracking clear_opt_in_out_tracking people.set people.set_once people.unset people.increment people.append people.union people.track_charge people.clear_charges people.delete_user people.remove".split(" ");
        for(h=0;h<l.length;h++)c(e,l[h]);var f="set set_once union unset remove delete".split(" ");e.get_group=function(){function a(c){b[c]=function(){call2_args=arguments;call2=[c].concat(Array.prototype.slice.call(call2_args,0));e.push([d,call2])}}for(var b={},d=["get_group"].concat(Array.prototype.slice.call(arguments,0)),c=0;c<f.length;c++)a(f[c]);return b};a._i.push([b,d,g])};a.__SV=1.2;b=c.createElement("script");b.type="text/javascript";b.async=!0;b.src="undefined"!==typeof MIXPANEL_CUSTOM_LIB_URL?
        MIXPANEL_CUSTOM_LIB_URL:"file:"===c.location.protocol&&"//cdn4.mxpnl.com/libs/mixpanel-2-latest.min.js".match(/^\/\//)?"https://cdn4.mxpnl.com/libs/mixpanel-2-latest.min.js":"//cdn4.mxpnl.com/libs/mixpanel-2-latest.min.js";d=c.getElementsByTagName("script")[0];d.parentNode.insertBefore(b,d)}})(document,window.mixpanel||[]);
        mixpanel.init("<%=MIXPANEL_TOKEN%>");
    </script>
<%
    }
%>
<script>
    let event_name      = "wso2_generic_event";
    let currentLocation = window.location.href;

    // event_name = currentLocation.slice("https://is.wso2isdemo.com/carbon/".length, currentLocation.search(".jsp"))

    let pageVisitTime = new Date().getTime();
    let eventFired = false;

    // Fire an analytics event
    let fireEvent = (event_type) => {
        let pageLeaveTime = new Date().getTime();
        let timeStayed    = (pageLeaveTime - pageVisitTime) / 1000 % 60

        let event_properties = {
            "event_type": event_type,
            "value": timeStayed.toString(),
        };

        <%
            if (GOOGLE_ANALYTICS_TOKEN != null) {
        %>
                gtag("event", currentLocation, event_properties);
        <%
            }
        %>
        <%
            if (MIXPANEL_TOKEN != null) {
        %>
                mixpanel.track(currentLocation, event_properties);
        <%
            }
        %>
        eventFired = true;
    }

    document.querySelectorAll("*").forEach(function(e) {
        e.addEventListener("submit", function(){
            if(!eventFired) {
                fireEvent("submitted")
            }
        });
    });

    window.addEventListener("beforeunload", (e) => {
        if(!eventFired) {
            fireEvent("left")
        }
    });
</script>
