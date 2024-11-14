<cfcomponent>
 	<cfset this.name="LOG">
	<cfset this.sessionManagement="yes"> 
	<cfset this.sessionTimeOut=#CreateTimeSpan(0,0,10,0)#>
	<cfset this.datasource="shopping">

	<cffunction name="onSessionEnd" returntype="void">
		<cfargument name="session" type="struct" required="true">
		<cflocation url="index.cfm" addtoken="false">
	</cffunction>

	<cffunction name="onError">
        <cfargument name="exception" required="true">
        <cfargument name="eventname" required="true">
        <cftry>
            <cfoutput>
                <cflog file="Application" type="message" text="#arguments.exception.message#">
                <cfmail to="developer@shopkart.com"
                        from="noreply@shopkart.com"
                        subject="Application Error in ShoppingKart"
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