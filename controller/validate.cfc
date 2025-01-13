<cfcomponent>
    <cffunction  name="validate" access="public">
        <cfargument  name="data" type="struct" required="true">
        <cfset local.input = {
            "data" = {
                "admin" = session.check.admin
            },
            "message" = []
        }>
        <cfif structKeyExists(arguments.data, 'recordId') AND len(arguments.data.recordId) NEQ 0>
            <cfset local.input.data['id'] = arguments.data.recordId>
            <cfset local.input.data['action'] = 'edit'>
        <cfelse>
            <cfset local.input.data['action'] = 'add'>
        </cfif>
        <cfif structKeyExists(arguments.data, 'categorySelect') AND len(arguments.data.categorySelect) NEQ 0>
            <cfset local.input.data['categorySelect'] = arguments.data.categorySelect>
            <cfif structKeyExists(arguments.data, 'subcategorySelect') AND len(arguments.data.subcategorySelect) NEQ 0>
                <cfset local.input.data['subcategorySelect'] = arguments.data.subcategorySelect>
                <cfif structKeyExists(arguments.data, 'productName') AND len(arguments.data.productName) NEQ 0>
                    <cfset local.input.data['name'] = arguments.data.productName>
                <cfelse>
                    <cfset arrayAppend(local.input.message, '*Product name required')>
                </cfif>
                <cfif structKeyExists(arguments.data, 'productDesc') AND len(arguments.data.productDesc) NEQ 0>
                    <cfset local.input.data['description'] = arguments.data.productDesc>
                <cfelse>
                    <cfset arrayAppend(local.input.message, '*Product description required')>
                </cfif>
                <cfif structKeyExists(arguments.data, 'price') AND len(arguments.data.price) NEQ 0>
                    <cfset local.input.data['price'] = arguments.data.price>
                <cfelse>
                    <cfset arrayAppend(local.input.message, '*Product price required')>
                </cfif>
                <cfif structKeyExists(arguments.data, 'tax') AND len(arguments.data.tax) NEQ 0>
                    <cfset local.input.data['tax'] = arguments.data.tax>
                <cfelse>
                    <cfset arrayAppend(local.input.message, '*Product tax rate not specified')>
                </cfif>
                <cfif NOT structKeyExists(arguments.data, 'recordId')
                    OR (structKeyExists(arguments.data, 'productPics') 
                        AND listLen(arguments.data.productPics) NEQ 0)>
                            <cfset uploadDir = expandPath('/uploads/')>        
                            <cfif not directoryExists(uploadDir)>
                                <cfdirectory action="create" directory="#uploadDir#">
                            </cfif>
                            <cffile action="uploadAll"
                                filefield="productPics"
                                destination="#uploadDir#"
                                nameConflict="makeunique">
                            <cfset local.input.data['images'] = []>
                            <cfloop array="#cffile.uploadAllResults#" item="item">
                                <cfset arrayAppend(local.input.data['images'], item.serverFile)>
                            </cfloop>
                <cfelseif local.input.data['action'] EQ 'add'>
                    <cfset arrayAppend(local.input.message, '*Product image(s) required')>
                </cfif>
            <cfelseif len(arguments.data.subcategoryText) NEQ 0>
                <cfset local.input.data['subcategory'] = arguments.data.subcategoryText>
            <cfelse>
                <cfset arrayAppend(local.input.message, '*Subcategory required')>
            </cfif>
        <cfelseif len(arguments.data.categoryText) NEQ 0>
            <cfset local.input.data['category'] = arguments.data.categoryText>
        <cfelse>
            <cfset arrayAppend(local.input.message, '*Category required')>
        </cfif>
        <cfreturn local.input>
    </cffunction>
</cfcomponent>