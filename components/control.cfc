<cfcomponent>
    <cffunction  name="adminLogin" access="public">
        <cfargument  name="admin" type="string" required="true">
        <cfargument  name="password" type="string" required="true">
        <cfquery name="local.checkLog">
            SELECT
                adminid,
                name,
                email,
                status
            FROM
                admin
            WHERE
                name = <cfqueryparam value="#arguments.admin#" cfsqltype="cf_sql_varchar">
            AND
                password = <cfqueryparam value="#arguments.password#" cfsqltype="cf_sql_varchar">
        </cfquery>
        <cfif local.checkLog.recordCount NEQ 0>
            <cfset session.check = {
                "access" = true,
                "admin" = local.checkLog.adminid,
                "name" = local.checkLog.name
            }>
        <cfelse>
            <cfset structClear(session.check)>
            <cfset session.check.access = false>
        </cfif>
    </cffunction>

    <cffunction  name="userLogin" access="public">
        <cfargument  name="user" type="string" required="true">
        <cfargument  name="password" type="string" required="true">
        <cfset local.message = "">
        <cfif len(arguments.user) NEQ 0 
            AND len(arguments.password) NEQ 0>
                <cfquery name="local.checkLog">
                    SELECT
                        userid,
                        username,
                        email,
                        password,
                        phone,
                        image,
                        status
                    FROM
                        user
                    WHERE
                        email = <cfqueryparam value="#arguments.user#" cfsqltype="cf_sql_varchar">
                </cfquery>
                <cfif local.checkLog.recordCount NEQ 0
                    AND local.checkLog.password EQ arguments.password>
                        <cfset session.user = {
                            "access" = true,
                            "user" = local.checkLog.userid,
                            "name" = local.checkLog.username,
                            "email" = local.checkLog.email,
                            "phone" = local.checkLog.phone,
                            "image" = local.checkLog.image
                        }>
                <cfelse>
                    <cfset local.message = "*Invalid email or password">
                    <cfset structClear(session.user)>
                    <cfset session.user.access = false>
                </cfif>
            <cfelse>
                <cfset local.message = "*Missing email or password">
        </cfif>
        <cfreturn local.message>
    </cffunction>

    <cffunction  name="userEmailChange" access="public">
        <cfargument  name="user" type="string" required="true">
        <cfargument  name="email" type="string" required="true">
        <cfset local.message = "">
        <cfif len(arguments.user) NEQ 0 
            AND len(arguments.email) NEQ 0>
                <cfquery name="local.checkLog">
                    SELECT
                        email
                    FROM
                        user
                    WHERE
                        email = <cfqueryparam value="#arguments.email#" cfsqltype="cf_sql_varchar">
                </cfquery>
                <cfif local.checkLog.recordCount EQ 0>
                    <cfquery name="local.checkLog">
                        UPDATE
                            user
                        SET
                            email = <cfqueryparam value="#arguments.email#" cfsqltype="cf_sql_varchar">
                        WHERE
                            userid = <cfqueryparam value="#arguments.user#" cfsqltype="cf_sql_varchar">
                    </cfquery>
                    <cfset session.user.email = arguments.email>
                <cfelse>
                    <cfset local.message = "*This email already has an account">
                </cfif>
            <cfelse>
                <cfset local.message = "*Missing email">
        </cfif>
        <cfreturn local.message>
    </cffunction>

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

    <cffunction  name="modifyCategory" access="public">
        <cfargument  name="data" type="struct" required="true">
        <cfif arguments.data.action EQ "add">
            <cfquery name="local.add">
                INSERT INTO
                    category(
                        name,
                        status,
                        createdat,
                        createdby
                    )
                VALUES(
                    <cfqueryparam value="#arguments.data.category#" cfsqltype="cf_sql_varchar">,
                    1,
                    <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp">,
                    <cfqueryparam value="#arguments.data.admin#" cfsqltype="cf_sql_integer">
                );
            </cfquery>
        <cfelseif arguments.data.action EQ "edit">
            <cfquery name="local.edit">
                UPDATE
                    category
                SET
                    name = <cfqueryparam value="#arguments.data.category#" cfsqltype="cf_sql_varchar">,
                    lasteditedat = <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp">,
                    lasteditedby = <cfqueryparam value="#arguments.data.admin#" cfsqltype="cf_sql_integer">
                WHERE
                    categoryid = <cfqueryparam value="#arguments.data.id#" cfsqltype="cf_sql_varchar">
            </cfquery>
        </cfif>
    </cffunction>

    <cffunction  name="modifySubcategory" access="public">
        <cfargument  name="data" type="struct" required="true">
        <cfif arguments.data.action EQ "add">
            <cfquery name="local.add">
                INSERT INTO
                    subcategory(
                        name,
                        categoryid,
                        status,
                        createdat,
                        createdby
                    )
                VALUES(
                    <cfqueryparam value="#arguments.data.subcategory#" cfsqltype="cf_sql_varchar">,
                    <cfqueryparam value="#arguments.data.categorySelect#" cfsqltype="cf_sql_integer">,
                    <cfqueryparam value="1" cfsqltype="cf_sql_integer">,
                    <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp">,
                    <cfqueryparam value="#arguments.data.admin#" cfsqltype="cf_sql_integer">
                );
            </cfquery>
        <cfelseif arguments.data.action EQ "edit">
            <cfquery name="local.edit">
                UPDATE
                    subcategory
                SET
                    <cfif structKeyExists(arguments.data, 'subcategory')>
                        name = <cfqueryparam value="#arguments.data.subcategory#" cfsqltype="cf_sql_varchar">,
                    </cfif>
                    categoryid = <cfqueryparam value="#arguments.data.categorySelect#" cfsqltype="cf_sql_integer">,
                    lasteditedat = <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp">,
                    lasteditedby = <cfqueryparam value="#arguments.data.admin#" cfsqltype="cf_sql_integer">
                WHERE
                    subcategoryid = <cfqueryparam value="#arguments.data.id#" cfsqltype="cf_sql_varchar">
            </cfquery>
        </cfif>
    </cffunction>

    <cffunction  name="modifyProduct" access="public">
        <cfargument  name="data" type="struct" required="true">
        <cfif arguments.data.action EQ "add">
            <cfquery name="local.add" result="result">
                INSERT INTO
                    product(
                        name,
                        description,
                        price,
                        tax,
                        subcategoryid,
                        status,
                        createdat,
                        createdby
                    )
                VALUES(
                    <cfqueryparam value="#arguments.data.name#" cfsqltype="cf_sql_varchar">,
                    <cfqueryparam value="#arguments.data.description#" cfsqltype="cf_sql_varchar">,
                    <cfqueryparam value="#arguments.data.price#" cfsqltype="cf_sql_decimal">,
                    <cfqueryparam value="#arguments.data.tax#" cfsqltype="cf_sql_integer">,
                    <cfqueryparam value="#arguments.data.subcategorySelect#" cfsqltype="cf_sql_integer">,
                    1,
                    <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp">,
                    <cfqueryparam value="#arguments.data.admin#" cfsqltype="cf_sql_integer">
                );
            </cfquery>
            <cfset local.key = result.GENERATEDKEY>
        <cfelseif arguments.data.action EQ "edit">
            <cfquery name="local.edit">
                UPDATE
                    product
                SET
                    name = <cfqueryparam value="#arguments.data.name#" cfsqltype="cf_sql_varchar">,
                    description = <cfqueryparam value="#arguments.data.description#" cfsqltype="cf_sql_varchar">,
                    price = <cfqueryparam value="#arguments.data.price#" cfsqltype="cf_sql_decimal">,
                    tax = <cfqueryparam value="#arguments.data.tax#" cfsqltype="cf_sql_integer">,
                    subcategoryid = <cfqueryparam value="#arguments.data.subcategorySelect#" cfsqltype="cf_sql_integer">,
                    lasteditedat = <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp">,
                    lasteditedby = <cfqueryparam value="#arguments.data.admin#" cfsqltype="cf_sql_integer">
                WHERE
                    productid = <cfqueryparam value="#arguments.data.id#" cfsqltype="cf_sql_varchar">
            </cfquery>
            <cfset local.key = arguments.data.id>
        </cfif>
        <cfif arrayLen(arguments.data.images) NEQ 0>
            <cfquery name="local.image">
                INSERT INTO
                    image(
                        productid,
                        image,
                        status
                    )
                VALUES
                    <cfloop array="#arguments.data.images#" item="pic">
                        (
                            <cfqueryparam value="#arguments.data.id#" cfsqltype="cf_sql_integer">,
                            <cfqueryparam value="#pic#" cfsqltype="cf_sql_varchar">,
                            1
                        )
                        <cfif arrayLast(arguments.data.images) NEQ pic>,</cfif>
                    </cfloop>
                ;
            </cfquery>
        </cfif>
        <cfset local.sub = {
            action: 'edit',
            categorySelect: arguments.data.categorySelect,
            id: arguments.data.subcategorySelect,
            admin: arguments.data.admin
        }>
        <cfset variable = modifySubcategory(local.sub)>
    </cffunction>

    <cffunction  name="deleteImage" access="remote" returnFormat="JSON">
        <cfargument  name="image" type="integer" required="false">
        <cfargument  name="product" type="integer" required="false">
        <cfquery name="local.edit">
            UPDATE
                image
            SET
                status = 0
            WHERE
                <cfif structKeyExists(arguments, 'image')>
                    imageid = <cfqueryparam value="#arguments.image#" cfsqltype="cf_sql_integer">
                <cfelseif structKeyExists(arguments, 'product')>
                    productid = <cfqueryparam value="#arguments.product#" cfsqltype="cf_sql_integer">
                </cfif>
        </cfquery>
    </cffunction>

    <cffunction  name="getCategory" access="remote" returnFormat="JSON">
        <cfargument  name="category" type="string" required="false">
        <cfquery name="local.list">
            SELECT
                categoryid,
                name,
                createdat,
                createdby
            FROM
                category
            WHERE
                status = 1
            <cfif structKeyExists(arguments, 'category')>
                    AND categoryid = <cfqueryparam value="#arguments.category#" cfsqltype="cf_sql_integer">
            </cfif>
            ;
        </cfquery>
        <cfset local.output = []>
        <cfoutput query="local.list">
            <cfset arrayAppend(local.output, {
                "id" : local.list.categoryid,
                "name" : local.list.name,
                "createdat" : local.list.createdat,
                "createdby": local.list.createdby 
            })>
        </cfoutput>
        <cfreturn local.output>
    </cffunction>

    <cffunction  name="getSubcategory" access="remote" returnFormat="JSON">
        <cfargument  name="category" type="integer" required="false">
        <cfargument  name="subcategory" type="integer" required="false">
        <cfquery name="local.list">
            SELECT
                subcategoryid,
                name,
                status,
                createdat,
                createdby,
                categoryid
            FROM
                subcategory
            WHERE
                status = 1
                <cfif structKeyExists(arguments, 'category')>
                    AND
                        categoryid = <cfqueryparam value="#arguments.category#" cfsqltype="cf_sql_integer">
                </cfif>
                <cfif structKeyExists(arguments, 'subcategory')>
                    AND
                        subcategoryid = <cfqueryparam value="#arguments.subcategory#" cfsqltype="cf_sql_integer">
                </cfif>
            ;
        </cfquery>
        <cfset local.output = []>
        <cfoutput query="local.list">
            <cfset arrayAppend(local.output, {
                "id" : local.list.subcategoryid,
                "name" : local.list.name,
                "createdat" : local.list.createdat,
                "createdby": local.list.createdby,
                "category" : local.list.categoryid
            })>
        </cfoutput>
        <cfreturn local.output>
    </cffunction>

    <cffunction  name="getProduct" access="remote" returnFormat="JSON">
        <cfargument  name="category" type="integer" required="false">
        <cfargument  name="subcategory" type="integer" required="false">
        <cfargument  name="product" type="integer" required="false">
        <cfargument  name="search" type="string" required="false">
        <cfargument  name="sort" type="string" required="false">
        <cfargument  name="range" type="string" required="false">
        <cfargument  name="status" type="string" required="false">
        <cfquery name="local.list">
            SELECT
                productid,
                name,
                description,
                price,
                tax,
                status,
                createdat,
                lasteditedat,
                createdby,
                lasteditedby,
                subcategoryid
            FROM
                product
            WHERE
                <cfif NOT structKeyExists(arguments, 'status')>
                    status = 1
                </cfif>
                <cfif structKeyExists(arguments, 'category')>
                    AND
                        subcategoryid IN (
                            SELECT
                                subcategoryid
                            FROM
                                subcategory
                            WHERE
                                categoryid = <cfqueryparam value="#arguments.category#" cfsqltype="cf_sql_integer">
                        )
                <cfelseif structKeyExists(arguments, 'subcategory')>
                    AND
                        subcategoryid = <cfqueryparam value="#arguments.subcategory#" cfsqltype="cf_sql_integer">
                </cfif>
                <cfif structKeyExists(arguments, 'product')>
                    <cfif NOT structKeyExists(arguments, 'status')>
                        AND
                    </cfif>
                        productid = <cfqueryparam value="#arguments.product#" cfsqltype="cf_sql_integer">
                </cfif>
                <cfif structKeyExists(arguments, 'search') AND arguments.search GT 0>
                    AND
                        name LIKE <cfqueryparam value="%#arguments.search#%" cfsqltype="cf_sql_varchar">
                </cfif>
                <cfif structKeyExists(arguments, 'range')>
                    <cfset local.rangeLen = listLen(arguments.range)>
                    <cfif local.rangeLen GT 1>
                        <cfset local.rangeArray = listToArray(arguments.range)>
                        <cfif local.rangeArray[2] EQ 'max'>
                            AND
                                price > <cfqueryparam value="#local.rangeArray[1]#" cfsqltype="cf_sql_decimal">
                        <cfelse>
                            AND
                                price
                                    BETWEEN
                                        <cfqueryparam value="#local.rangeArray[1]#" cfsqltype="cf_sql_decimal">
                                    AND
                                        <cfqueryparam value="#local.rangeArray[2]#" cfsqltype="cf_sql_decimal">
                        </cfif>
                    <cfelseif local.rangeLen GT 0>
                        AND
                            price < <cfqueryparam value="#arguments.range#" cfsqltype="cf_sql_decimal">
                    </cfif>
                </cfif>
                <cfif structKeyExists(arguments, 'sort')>
                    <cfif arguments.sort EQ 'random'>
                        ORDER BY RAND()
                        <cfif NOT structKeyExists(arguments, 'range')>
                            LIMIT 6
                        </cfif>
                    <cfelseif arguments.sort EQ 'pricelow'>
                        ORDER BY price ASC
                    <cfelseif arguments.sort EQ 'pricehigh'>
                        ORDER BY price DESC
                    </cfif>
                </cfif>
            ;
        </cfquery>
        <cfset local.output = []>
        <cfoutput query="local.list">
            <cfquery name="local.image">
                SELECT
                    imageid,
                    image
                FROM
                    image
                WHERE
                    status = 1
                AND
                    productid = <cfqueryparam value="#local.list.productid#" cfsqltype="cf_sql_decimal">
            </cfquery>
            <cfset local.images = []>
            <cfloop query="local.image">
                <cfset arrayAppend(local.images, {
                    "id" : local.image.imageid,
                    "image" : local.image.image
                })>
            </cfloop>
            <cfset arrayAppend(local.output, {
                "id" : local.list.productid,
                "name" : local.list.name,
                "images" : local.images,
                "description" : local.list.description,
                "price" : local.list.price,
                "tax" : local.list.tax,
                "createdat" : local.list.createdat,
                "lasteditedat" : local.list.lasteditedat,
                "createdby": local.list.createdby,
                "lasteditedby": local.list.lasteditedby,
                "subcategory" : local.list.subcategoryid
            })>
        </cfoutput>
        <cfreturn local.output>
    </cffunction>

    <cffunction  name="addCart" access="remote" returnFormat="JSON">
        <cfargument  name="product" type="integer" required="true">
        <cfargument  name="user" type="integer" required="true">
        <cfquery name="local.list">
            SELECT
                cartid
            FROM
                cart
            WHERE
                productid = <cfqueryparam value="#arguments.product#" cfsqltype="cf_sql_integer">
            AND
                userid = <cfqueryparam value="#arguments.user#" cfsqltype="cf_sql_integer">
            AND
                status = <cfqueryparam value="1" cfsqltype="cf_sql_integer">
        </cfquery>
        <cfif local.list.recordCount NEQ 0>
            <cfquery name="local.edit" result="result">
                UPDATE
                    cart
                SET
                    quantity = quantity + 1
                WHERE
                    cartid = <cfqueryparam value="#local.list.cartid#" cfsqltype="cf_sql_integer">
            </cfquery>
        <cfelse>
            <cfquery name="local.add">
                INSERT INTO
                    cart(
                        productid,
                        userid,
                        quantity,
                        status
                    )
                VALUES(
                    <cfqueryparam value="#arguments.product#" cfsqltype="cf_sql_integer">,
                    <cfqueryparam value="#arguments.user#" cfsqltype="cf_sql_integer">,
                    1,
                    1
                )
            </cfquery>
        </cfif>
    </cffunction>

    <cffunction  name="editCart" access="remote" returnFormat="JSON">
        <cfargument  name="product" type="integer" required="false">
        <cfargument  name="change" type="string" required="false">
        <cfif structKeyExists(arguments, 'change')>
            <cfquery name="local.check">
                SELECT
                    quantity
                FROM
                    cart
                WHERE
                    userid = <cfqueryparam value="#session.user.user#" cfsqltype="cf_sql_integer">
                AND
                    productid = <cfqueryparam value="#arguments.product#" cfsqltype="cf_sql_integer">
            </cfquery>
        </cfif>
        <cfquery name="local.edit">
            UPDATE
                cart
            SET
                <cfif structKeyExists(arguments, 'change') 
                    AND (local.check.quantity GT 1
                        OR arguments.change EQ 'increase'
                        OR arguments.change NEQ 'delete')>
                    quantity = quantity 
                        <cfif arguments.change EQ 'increase'>
                            +
                        <cfelseif arguments.change EQ 'decrease'>
                            -
                        </cfif>
                    1
                <cfelse>
                    status = 0
                </cfif>
            WHERE
                userid = <cfqueryparam value="#session.user.user#" cfsqltype="cf_sql_integer">
                <cfif structKeyExists(arguments, 'product')>
                    AND
                        productid = <cfqueryparam value="#arguments.product#" cfsqltype="cf_sql_integer">
                </cfif>
        </cfquery>
    </cffunction>

    <cffunction  name="getCart" access="remote" returnFormat="JSON">
        <cfargument  name="user" type="integer" required="true">
        <cfquery name="local.list">
            SELECT
                c.cartid,
                c.productid,
                c.quantity,
                p.name,
                p.price,
                p.tax,
                m.imageid,
                m.image
            FROM
                cart c
            INNER JOIN
                product p ON p.productid = c.productid
            INNER JOIN
                image m ON m.productid = p.productid
            WHERE
                c.userid = <cfqueryparam value="#arguments.user#" cfsqltype="cf_sql_integer">
            AND
                c.status = 1
        </cfquery>
        <cfset local.output = {
            'user' = arguments.user,
            'items' = []
        }>
        <cfloop query="local.list" group="productid">
            <cfset local.images = []>
            <cfloop>
                <cfset arrayAppend(local.images, {
                    'id' = local.list.imageid,
                    'image' = local.list.image
                })>
            </cfloop>
            <cfset arrayAppend(local.output.items, {
                "id" : local.list.cartid,
                "product" : local.list.productid,
                "quantity" : local.list.quantity,
                "price" : local.list.price,
                "tax" : local.list.tax,
                "name" : local.list.name,
                "images" : local.images
            })>
        </cfloop>
        <cfreturn local.output>
    </cffunction>

    <cffunction  name="modifyShipping" access="remote" returnFormat="JSON">
        <cfargument  name="data" type="struct" required="true">
        <cfset local.error = []>
        <cfif len(arguments.data.name) EQ 0>
            <cfset arrayAppend(local.error, "*Name required")>
        </cfif>
        <cfif len(arguments.data.phone) EQ 0>
            <cfset arrayAppend(local.error, "*Phone required")>
        </cfif>
        <cfif len(arguments.data.house) EQ 0>
            <cfset arrayAppend(local.error, "*House required")>
        </cfif>
        <cfif len(arguments.data.street) EQ 0>
            <cfset arrayAppend(local.error, "*Street required")>
        </cfif>
        <cfif len(arguments.data.city) EQ 0>
            <cfset arrayAppend(local.error, "*City required")>
        </cfif>
        <cfif len(arguments.data.state) EQ 0>
            <cfset arrayAppend(local.error, "*State required")>
        </cfif>
        <cfif len(arguments.data.country) EQ 0>
            <cfset arrayAppend(local.error, "*Country required")>
        </cfif>
        <cfif len(arguments.data.pincode) EQ 0>
            <cfset arrayAppend(local.error, "*Pincode required")>
        </cfif>
        <cfif arrayLen(local.error) EQ 0>
            <cfif structKeyExists(arguments.data, 'id')>
                <cfquery name="local.edit">
                    UPDATE
                        shipping
                    SET
                        name = <cfqueryparam value="#arguments.data.name#" cfsqltype="cf_sql_varchar">,
                        phone = <cfqueryparam value="#arguments.data.phone#" cfsqltype="cf_sql_decimal">,
                        house = <cfqueryparam value="#arguments.data.house#" cfsqltype="cf_sql_varchar">,
                        street = <cfqueryparam value="#arguments.data.street#" cfsqltype="cf_sql_varchar">,
                        city = <cfqueryparam value="#arguments.data.city#" cfsqltype="cf_sql_varchar">,
                        state = <cfqueryparam value="#arguments.data.state#" cfsqltype="cf_sql_varchar">,
                        country = <cfqueryparam value="#arguments.data.country#" cfsqltype="cf_sql_varchar">,
                        pincode = <cfqueryparam value="#arguments.data.pincode#" cfsqltype="cf_sql_varchar">,
                        lasteditedat = <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp">
                    WHERE
                        shippingid = <cfqueryparam value="#arguments.data.id#" cfsqltype="cf_sql_integer">
                </cfquery>
            <cfelse>
                <cfquery name="local.add">
                    INSERT INTO
                        shipping(
                            name,
                            phone,
                            house,
                            street,
                            city,
                            state,
                            country,
                            pincode,
                            userid,
                            createdat,
                            status
                        )
                    VALUES(
                        <cfqueryparam value="#arguments.data.name#" cfsqltype="cf_sql_varchar">,
                        <cfqueryparam value="#arguments.data.phone#" cfsqltype="cf_sql_decimal">,
                        <cfqueryparam value="#arguments.data.house#" cfsqltype="cf_sql_varchar">,
                        <cfqueryparam value="#arguments.data.street#" cfsqltype="cf_sql_varchar">,
                        <cfqueryparam value="#arguments.data.city#" cfsqltype="cf_sql_varchar">,
                        <cfqueryparam value="#arguments.data.state#" cfsqltype="cf_sql_varchar">,
                        <cfqueryparam value="#arguments.data.country#" cfsqltype="cf_sql_varchar">,
                        <cfqueryparam value="#arguments.data.pincode#" cfsqltype="cf_sql_varchar">,
                        <cfqueryparam value="#arguments.data.user#" cfsqltype="cf_sql_integer">,
                        <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp">,
                        1
                    )
                </cfquery>
            </cfif>
        </cfif>
        <cfreturn local.error>
    </cffunction>

    <cffunction  name="getShipping" access="remote" returnFormat="JSON">
        <cfargument  name="user" type="integer" required="false">
        <cfargument  name="id" type="integer" required="false">
        <cfquery name="local.list">
            SELECT
                shippingid,
                name,
                phone,
                house,
                street,
                city,
                state,
                country,
                pincode
            FROM
                shipping
            WHERE
                <cfif structKeyExists(arguments, 'user')>
                        userid = <cfqueryparam value="#arguments.user#" cfsqltype="cf_sql_integer">
                    AND
                        status = 1
                <cfelseif structKeyExists(arguments, 'id')>
                    shippingid = <cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_integer">
                </cfif>
            ;
        </cfquery>
        <cfset local.output = []>
        <cfoutput query="local.list">
            <cfset arrayAppend(local.output, {
                "id" : local.list.shippingid,
                'name' = local.list.name,
                'phone' = local.list.phone,
                'house' = local.list.house,
                'street' = local.list.street,
                'city' = local.list.city,
                'state' = local.list.state,
                'country' = local.list.country,
                'pincode' = local.list.pincode
            })>
        </cfoutput>
        <cfreturn local.output>
    </cffunction>

    <cffunction  name="deleteShipping" access="remote" returnFormat="JSON">
        <cfargument  name="id" type="integer" required="false">
        <cfquery name="local.edit">
            UPDATE
                shipping
            SET
                status = 0
            WHERE
                <cfif structKeyExists(arguments, 'id')>
                    shippingid = <cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_integer">
                <cfelseif structKeyExists(arguments, 'user')>
                    userid = <cfqueryparam value="#arguments.user#" cfsqltype="cf_sql_integer">
                </cfif>
        </cfquery>
    </cffunction>

    <cffunction  name="payOrder" access="public">
        <cfargument  name="data" type="struct" required="true">
        <cfset local.output = {
            'error' = []
        }>
        <cfif arguments.data.cardno NEQ "1234567890654321">
            <cfset arrayAppend(local.output.error, "*incorrect card no")>
        </cfif>
        <cfif arguments.data.expiry NEQ "01/30">
            <cfset arrayAppend(local.output.error, "*incorrect expiration date")>
        </cfif>
        <cfif arguments.data.cvv NEQ "321">
            <cfset arrayAppend(local.output.error, "*incorrect cvv")>
        </cfif>
        <cfif arguments.data.cardname NEQ "ANAND VISHNU K V">
            <cfset arrayAppend(local.output.error, "*incorrect holder name")>
        </cfif>
        <cfif arrayLen(local.output.error) EQ 0>
            <cfset local.id = createUUID()>
            <cfquery name="local.add">
                INSERT INTO
                    ordercart(
                        orderdate,
                        shippingid,
                        orderid,
                        userid
                    )
                VALUES(
                    <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp">,
                    <cfqueryparam value="#arguments.data.address#" cfsqltype="cf_sql_integer">,
                    <cfqueryparam value="#local.id#" cfsqltype="cf_sql_varchar">,
                    <cfqueryparam value="#arguments.data.user#" cfsqltype="cf_sql_integer">
                );
            </cfquery>
            <cfset local.output['order'] = local.id>
            <cfset local.items = []>
            <cfif arguments.data.idType EQ 'cart'>
                <cfset local.cart = getCart(arguments.data.user)>
                <cfloop array="#local.cart#" item="item">
                    <cfset local.product = getProduct(product=item.product)>
                    <cfset arrayAppend(local.items, {
                        'product' = item.product,
                        'quantity' = item.quantity,
                        'tax' = local.product[1].tax,
                        'price' = local.product[1].price
                    })>
                </cfloop>
                <cfset deleteCart(user=arguments.data.user)>
            <cfelseif arguments.data.idType EQ 'product'>
                <cfset local.product = getProduct(product=arguments.data.id)>
                <cfset arrayAppend(local.items, {
                        'product' = local.product[1].id,
                        'quantity' = 1,
                        'tax' = local.product[1].tax,
                        'price' = local.product[1].price
                    })>
            </cfif>
            <cfif arrayLen(local.items) GT 0>
                <cfloop array="#local.items#" item="item">
                    <cfquery name="local.add" result="result">
                        INSERT INTO
                            orderitem(
                                quantity,
                                price,
                                tax,
                                orderid,
                                productid
                            )
                        VALUES(
                            <cfqueryparam value="#item.quantity#" cfsqltype="cf_sql_varchar">,
                            <cfqueryparam value="#item.price#" cfsqltype="cf_sql_decimal">,
                            <cfqueryparam value="#item.tax#" cfsqltype="cf_sql_integer">,
                            <cfqueryparam value="#local.id#" cfsqltype="cf_sql_varchar">,
                            <cfqueryparam value="#item.product#" cfsqltype="cf_sql_integer">
                        )
                    </cfquery>
                </cfloop>
            </cfif>
        </cfif>
        <cfreturn local.output>
    </cffunction>
    
    <cffunction name="paymentMail" access="public">
        <cfargument name="order" type="string" required="false">
        <cfset local.order = getOrder(order=arguments.order)>
        <cftry>
            <cfoutput>
                <cfmail to="#session.user.email#"
                        from="noreply@shopkart.com"
                        type="html"
                        subject="Order Confirmation">
                    <html>
                        <style>
                            strong{
                                font-family: Georgia;
                            }
                            .pop{
                                margin-top: 30px;
                                width: 100%;
                                box-shadow: 0px 0px 10px blue;
                                background-color: yellow;
                                display: flex;
                                flex-direction: column;
                                justify-content: center;
                                align-items: center;
                            }
                            .border{
                                margin-top: 50px;
                                margin-left: auto;
                                margin-right: auto;
                                width: 80%;
                                border: 10px solid blue;
                                padding: 5px;
                            }
                            .head{
                                margin-top: 10px;
                                width: 100%;
                                text-align: center;
                            }
                            .text-right{
                                text-align: right;
                            }
                            .table{
                                width: 100%;
                                border: 1px double black;
                                margin-top: 20px;
                                color: white;
                                background-color: cyan;
                            }
                            .table th,.table td{
                                border: 1px solid black;
                                padding: 10px;
                            }
                            .box{
                                margin: 20px;
                                border: 1px solid black;
                                padding: 10px;
                            }
                        </style>
                        <body>
                            <div class="pop">
                                <h2 style="color: green;">Your Order #local.order[1].id# Was Placed Successfully</h2>
                                <h2 style="color: blue">Thank you for purchasing from <strong style="color: blue">ShopKart</strong></h2>
                            </div>
                            <div class="border">
                                <div class="head">
                                    <h2>
                                        <strong style="color: blue;">ShopKart</strong>
                                    </h2>
                                    <h3>
                                        <strong>INVOICE</strong>
                                    </h3>
                                </div>

                                <div class="box">
                                    <p><strong>Order Number:</strong> #local.order[1].id#</p>
                                    <p><strong>Invoice Date:</strong> #dateFormat(local.order[1].date, "mm/dd/yyyy")#</p>
                                </div>

                                <div class="box">
                                    <p><strong>Bill To:</strong></p>
                                    <p>Contact Name: #local.order[1].shipping.name#</p>
                                    <p>
                                        Shipping Address:
                                            #local.order[1].shipping.house#,
                                            #local.order[1].shipping.street#,
                                            #local.order[1].shipping.city#,
                                            #local.order[1].shipping.state#,
                                            #local.order[1].shipping.country#
                                            PIN - #local.order[1].shipping.pincode#
                                    </p>
                                    <p>Phone: #local.order[1].shipping.phone#</p>
                                </div>

                                <table class="table">
                                    <thead>
                                        <tr style="background-color: skyblue;">
                                            <th>Item Name</th>
                                            <th>Qty</th>
                                            <th>Unit Price</th>
                                            <th>Tax Rate</th>
                                            <th>Total</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <cfset local.total = 0>
                                        <cfset local.tax = 0>
                                        <cfloop array="#local.order[1].items#" index="item">
                                            <tr>
                                                <td>#item.name#</td>
                                                <td>#item.quantity#</td>
                                                <td>#chr(8377)##numberFormat(item.price,'__.00')#</td>
                                                <td>#item.tax#%</td>
                                                <td>#chr(8377)##numberFormat(item.quantity*(item.price+(item.price*item.tax/100)),'__.00')#</td>
                                            </tr>
                                            <cfset local.total += item.quantity*(item.price+(item.price*item.tax/100))>
                                            <cfset local.tax += item.quantity*(item.price*item.tax/100)>
                                        </cfloop>
                                    </tbody>
                                </table>

                                <p class="text-right"><strong>Total Due:</strong> #chr(8377)##numberFormat(local.total, '__.00')#</p>
                                <hr>
                                <p class="text-right"><strong>Tax:</strong> #chr(8377)##numberFormat(local.tax, '__.00')#</p>
                                <hr>
                                <p class="text-right"><strong>Total Payed:</strong> #chr(8377)##numberFormat(local.total, '__.00')#</p>
                                <hr>

                                <div style="margin-top: 30px;">
                                    <p><strong>Payment Information:</strong> This invoice was paid by card ending in XX4321. The payment has been confirmed and processed.</p>
                                    <p style="text-align: center;">Thank you for shopping with us!</p>
                                </div>
                            </div>
                        </body>
                    </html>
                </cfmail>
            </cfoutput>
            <cfcatch type="any">
                <cflog file="Application" type="error" text="Failed to send error email: #cfcatch.message#">
            </cfcatch>
        </cftry>
    </cffunction>

    <cffunction  name="getOrder" access="remote" returnFormat="JSON">
        <cfargument  name="user" type="integer" required="true">
        <cfargument  name="order" type="string" required="false">
        <cfargument  name="search" type="string" required="false">
        <cfquery name="local.list">
            SELECT
                o.orderid,
                o.orderdate,
                s.name,
                s.phone,
                s.house,
                s.street,
                s.city,
                s.state,
                s.country,
                s.pincode,
                i.productid,
                i.quantity,
                i.price,
                i.tax
                p.name,
                m.imageid,
                m.image
                
            FROM
                ordercart o
            INNER JOIN
                shipping s ON o.shippingid = s.shippingid
            INNER JOIN
                orderitem i ON o.orderid = i.orderid
            INNER JOIN
                product p ON i.productid = p.productid
            INNER JOIN
                image m ON p.productid = m.productid
            WHERE
                o.userid = <cfqueryparam value="#arguments.user#" cfsqltype="cf_sql_integer">
                <cfif structKeyExists(arguments, 'search')>
                    AND
                        o.orderid = <cfqueryparam value="#arguments.search#" cfsqltype="cf_sql_varchar">
                <cfelseif structKeyExists(arguments, 'order')>
                    AND
                        o.orderid = <cfqueryparam value="#arguments.order#" cfsqltype="cf_sql_varchar">
                </cfif>
            ;
        </cfquery>
        <cfset local.output = []>
        <cfloop query="local.list" group="orderid">
            <cfset local.items = []>
            <cfloop group="productid">
                <cfset local.images = []>
                <cfloop>
                    <cfset arrayAppend(local.images, {
                        'id' = local.list.imageid,
                        'image' = local.list.image
                    })>
                </cfloop>
                <cfset arrayAppend(local.items, {
                    'product' = local.list.productid,
                    'price' = local.list.price,
                    'quantity' = local.list.quantity,
                    'tax' = local.list.tax,
                    'name' = local.list.name,
                    'images' = local.images
                })>
            </cfloop>
            <cfset arrayAppend(local.output, {
                "id" : local.list.orderid,
                'date' = local.list.orderdate,
                'shipping' = {
                    'name' = local.list.name,
                    'phone' = local.list.phone,
                    'house' = local.list.house,
                    'street' = local.list.street,
                    'city' = local.list.city,
                    'state' = local.list.state,
                    'country' = local.list.country,
                    'pincode' = local.list.pincode
                },
                'items' = local.items
            })>
        </cfloop>
        <cfreturn local.output>
    </cffunction>

	<cffunction name="deleteItem" access="public">
		<cfargument name="data" type="struct" required="true">
        <cfif arguments.data.section EQ "category">
            <cfquery name="local.deleteCategories">
                UPDATE category
                SET
                    status = 0,
                    deletedat = <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp">,
                    deletedby = <cfqueryparam value="#arguments.data.admin#" cfsqltype="cf_sql_integer">
                WHERE
                    categoryid = <cfqueryparam value="#arguments.data.id#" cfsqltype="cf_sql_integer">
            </cfquery>
            <cfquery name="local.deleteSubCategories">
                UPDATE subcategory
                SET
                    status = 0,
                    deletedat = <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp">,
                    deletedby = <cfqueryparam value="#arguments.data.admin#" cfsqltype="cf_sql_integer">
                WHERE
                    categoryid = <cfqueryparam value="#arguments.data.id#" cfsqltype="cf_sql_integer">
            </cfquery>
            <cfquery name="local.deleteProducts">
                UPDATE product
                SET
                    status = 0,
                    deletedat = <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp">,
                    deletedby = <cfqueryparam value="#arguments.data.admin#" cfsqltype="cf_sql_integer">
                WHERE
                    subcategoryid IN (
                        SELECT subcategoryid
                        FROM subcategory
                        WHERE categoryid = <cfqueryparam value="#arguments.data.id#" cfsqltype="cf_sql_integer">
                    )
            </cfquery>
        <cfelseif arguments.data.section EQ "subcategory">
            <cfquery name="local.deleteSubCategories">
                UPDATE subcategory
                SET
                    status = 0,
                    deletedat = <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp">,
                    deletedby = <cfqueryparam value="#arguments.data.admin#" cfsqltype="cf_sql_integer">
                WHERE
                    subcategoryid = <cfqueryparam value="#arguments.data.id#" cfsqltype="cf_sql_integer">
            </cfquery>
            <cfquery name="local.deleteProducts">
                UPDATE product
                SET
                    status = 0,
                    deletedat = <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp">,
                    deletedby = <cfqueryparam value="#arguments.data.admin#" cfsqltype="cf_sql_integer">
                WHERE
                    subcategoryid = <cfqueryparam value="#arguments.data.id#" cfsqltype="cf_sql_integer">
            </cfquery>
        <cfelseif arguments.data.section EQ "product">
            <cfquery name="local.deleteProducts">
                UPDATE product
                SET
                    status = 0,
                    deletedat = <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp">,
                    deletedby = <cfqueryparam value="#arguments.data.admin#" cfsqltype="cf_sql_integer">
                WHERE
                    productid = <cfqueryparam value="#arguments.data.id#" cfsqltype="cf_sql_integer">
            </cfquery>
        </cfif>
    </cffunction>
</cfcomponent>