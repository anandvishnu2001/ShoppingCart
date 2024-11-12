<cfcomponent>
 	<cfset this.name="LOG">
	<cfset this.sessionManagement="yes"> 
	<cfset this.sessionTimeOut=#CreateTimeSpan(0,0,10,0)#>
	<cfset this.datasource="address">
	<cffunction name="onSessionEnd" returntype="void">
		<cfargument name="session" type="struct" required="true">
		<cflocation url="index.cfm" addtoken="false">
	</cffunction>
</cfcomponent>