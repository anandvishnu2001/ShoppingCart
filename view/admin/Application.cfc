<cfcomponent>
 	<cfset this.name="ADMIN">
	<cfset this.sessionManagement="yes"> 
	<cfset this.sessionTimeOut=#CreateTimeSpan(0,0,10,0)#>
	<cfset this.datasource="shopping">

    <cffunction name="onApplicationStart" returnType="void">
        <cfset application.control = CreateObject("component", "components.control")>
    </cffunction>

    <cffunction name="onSessionStart" returnType="void">
        <cfset session.check = {
            'access' = false
        }>
    </cffunction>

	<cffunction name="onRequestStart" returnType="void">
        <cfargument name="requestname" required="true">
        <cfif structKeyExists(url,"reload") AND url.reload EQ 1>
            <cfset onApplicationStart()>
            <cflocation url="#CGI.SCRIPT_NAME#" addToken="no">
        </cfif>
        <cfif NOT(structKeyExists(session,"check") 
                    AND session.check.access)
                    AND NOT arrayFindNoCase(["log.cfm"], ListLast(CGI.SCRIPT_NAME,'/'))>
		    <cflocation url="/admin/log" addToken="no">
	    </cfif>
    </cffunction>

	<cffunction name="onError">
        <cfargument name="exception" required="true">
        <cfargument name="eventname" required="true">
        <cftry>
            <cfoutput>
                <cflog file="Application" type="message" text="#arguments.exception.message#">
                <cfmail to="developer@shopkart.com"
                        from="noreply@shopkart.com"
                        subject="Application Error in ShopKart Admin Module"
                        type="html">
                    <html>
                        <body class="error">
                            <cfdump var="#arguments.exception#" format="html">
                        </body>
                    </html>
                </cfmail>
            </cfoutput>
            <cfcatch type="any">
                <cflog file="Application" type="error" text="Failed to send error email: #cfcatch.message#">
            </cfcatch>
        </cftry>
    </cffunction>
</cfcomponent>