<cfset control = CreateObject("component", "components.control")>
<cfif NOT (structKeyExists(session, "user") 
    AND session.user.access)>
        <cfset session.user = {
            "access" = false
        }>
<cfelse>
</cfif>
<cfset argumentCollection = {}>
<cfif structKeyExists(url, 'sort')>
    <cfset argumentCollection.sort = url.sort>
<cfelse>
    <cfset argumentCollection.sort = 'random'>
</cfif>
<cfif structKeyExists(url, 'filter')
    AND ((structKeyExists(url, 'minPrice')
            AND len(url.minPrice) GT 0)
        OR (structKeyExists(url, 'maxPrice')
            AND len(url.maxPrice) GT 0))>
    <cfset variables.range = ''>
    <cfif len(url.minPrice) GT 0>
        <cfset variables.range = listAppend(variables.range, url.minPrice)>
    <cfelse>
        <cfset variables.range = listAppend(variables.range, 'MIN')>
    </cfif>
    <cfif len(url.maxPrice) GT 0>
        <cfset variables.range = listAppend(variables.range, url.maxPrice)>
    <cfelse>
        <cfset variables.range = listAppend(variables.range, 'MAX')>
    </cfif>
    <cfset argumentCollection.range = variables.range>
</cfif>
<cfif structKeyExists(url, 'keyword')>
    <cfset argumentCollection.search = url.keyword>
<cfelseif structKeyExists(url, 'sub')>
    <cfset argumentCollection.subcategory = url.sub>
<cfelseif structKeyExists(url, 'cat')>
    <cfset argumentCollection.category = url.cat>
</cfif>
<cfset products = control.getProduct(argumentCollection=argumentCollection)>
<html lang="en">
	<head>
		<link href="/css/admin.css" rel="stylesheet">
		<link href="/css/bootstrap.min.css" rel="stylesheet">
	</head>
	<body class="container-fluid p-0 d-flex flex-column align-items-center">
		<nav id="main-nav" class="container-fluid navbar navbar-expand-lg justify-content-between bg-primary gap-5 z-3 fw-bold fixed-top" data-bs-theme="dark">
            <a class="navbar-brand ms-2" href="/home">
                <img src="/images/shop.png" width="40" height="40" class="img-fluid">
                ShopKart
            </a>
            <form class="flex-grow-1 d-flex">
                <input name="keyword" id="keyword" class="form-control me-2" type="search" placeholder="Search for products" required>
                <button name="search" id="search" class="btn btn-primary" type="submit" value="keyword">
                    <img src="/images/search.png" class="img-fluid" alt="Cart" width="30" height="30">
                </button>
            </form>
            <ul class="navbar-nav nav-tabs nav-justified w-25">
                <li class="nav-item dropdown" title="Menu">
                    <a class="nav-link <cfif structKeyExists(url, 'cat')>active</cfif>" href="" data-bs-toggle="dropdown">
                        <img src="/images/menu.png" class="img-fluid" alt="Cart" width="30" height="30">
                    </a>
                    <ul class="dropdown-menu">
                        <cfset categories = control.getCategory()>
                        <cfloop array="#categories#" index="index" item="item">
                            <cfoutput>
                                <li>
                                    <a id="#item.id#" class="dropdown-item" href="index.cfm?cat=#item.id#">#item.name#</a>
                                </li>
                            </cfoutput>
                        </cfloop>
                    </ul>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="cart">
                        <img src="/images/cart.png" class="img-fluid" alt="Cart" width="30" height="30">
                        <cfif structKeyExists(session.user, 'user')
                            AND control.countCart() GT 0>
                            <cfoutput>
                                <span class="badge bg-danger rounded-pill">#control.countCart()#</span>
                            </cfoutput>
                        </cfif>
                    </a>
                </li>
                <li class="nav-item">
                    <cfif structKeyExists(session, 'user')
                        AND session.user.access>
                            <a class="nav-link" href="user.cfm">
                                <cfoutput>
                                    <img src="/uploads/#session.user.image#" class="rounded-circle" alt="Login" width="30" height="30">
                                </cfoutput>
                            </a>
                    <cfelse>
                        <a class="nav-link" href="login.cfm">
                            <img src="/images/login.png" class="img-fluid" alt="Login" width="30" height="30">
                        </a>
                    </cfif>
                </li>
            </ul>
		</nav>
        <cfif structKeyExists(url, 'cat')>
            <nav id="category-nav" class="container-fluid navbar navbar-expand-lg justify-content-between bg-secondary z-2 fixed-top" data-bs-theme="dark">
                <ul class="flex-grow-1 navbar-nav nav-tabs nav-justified">
                    <cfset categories = control.getCategory()>
                    <cfloop array="#categories#" item="category">
                        <cfoutput>
                            <li class="nav-item dropdown">
                                <a id="#category.id#" class="nav-link
                                    <cfif category.id EQ url.cat>active</cfif>
                                    " 
                                    href="index.cfm?cat=#category.id#"
                                    data-bs-toggle="dropdown">
                                    #category.name#
                                </a>
                                <ul class="dropdown-menu">
                                    <cfset subcategories = control.getSubcategory(category.id)>
                                    <cfloop array="#subcategories#" item="subcategory">
                                        <cfoutput>
                                            <li>
                                                <a id="#subcategory.id#" class="dropdown-item" 
                                                    href="index.cfm?cat=#category.id#&sub=#subcategory.id#">
                                                        #subcategory.name#
                                                </a>
                                            </li>
                                        </cfoutput>
                                    </cfloop>
                                </ul>
                            </li>
                        </cfoutput>
                    </cfloop>
                </ul>
            </nav>
        </cfif>
        <nav id="banner"  class="container-fluid carousel slide navbar navbar-expand-lg justify-content-center align-items-center h-75 mt-5" data-bs-ride="carousel" data-bs-theme="dark">
            <div class="carousel-indicators">
                <button type="button" data-bs-target="#banner" data-bs-slide-to="0" class="active p-3" aria-current="true" aria-label="Slide 1"></button>
                <button type="button" data-bs-target="#banner" data-bs-slide-to="1" class="p-3" aria-label="Slide 2"></button>
                <button type="button" data-bs-target="#banner" data-bs-slide-to="2" class="p-3" aria-label="Slide 3"></button>
            </div>
            <div class="carousel-inner">
                <div class="carousel-item active">
                    <img src="/images/banner-1.jpg" alt="Banner image" class="d-block w-100">
                    <div class="carousel-caption w-25 d-none d-md-block mx-auto my-5" data-bs-theme="light">
                        <h3 class="card">Welcome to ShopKart</h3>
                    </div>
                </div>
                <div class="carousel-item">
                    <img src="/images/banner-2.jpg" alt="Banner image" class="d-block w-100">
                </div>
                <div class="carousel-item">
                    <img src="/images/banner-3.jpg" alt="Banner image" class="d-block w-100">
                </div>
            </div>
            <button class="carousel-control-prev" type="button" data-bs-target="#banner" data-bs-slide="prev">
                <span class="carousel-control-prev-icon p-5"></span>
            </button>
            <button class="carousel-control-next" type="button" data-bs-target="#banner" data-bs-slide="next">
                <span class="carousel-control-next-icon p-5"></span>
            </button>
		</nav>
        <div class="container d-flex justify-content-center p-1 gap-5">
            <div class="dropdown">
                <button class="btn btn-outline-primary" data-bs-toggle="dropdown" data-bs-auto-close="outside">Filter</button>
                <form  class="dropdown-menu gap-2 p-3" action="" method="get">
                    <p>Filter By Price<p>
                    <div class="form-floating">
                        <input class="form-control bg-primary" type="number" name="minPrice" id="minPrice" min="0" placeholder="">
                        <label class="form-label" for="minPrice">Minimum</label>
                    </div>
                    <div class="form-floating">
                        <input class="form-control bg-primary" type="number" name="maxPrice" id="maxPrice" placeholder="">
                        <label class="form-label" for="maxPrice">Maximum</label>
                    </div>
                    <button name="filter" id="filter" type="submit" value="price" class="btn btn-outline-success">Filter</button>
                </form>
            </div>
            <cfoutput>
                <cfset variables.url = "/index.cfm?">
                <cfif len(cgi.Query_String) NEQ 0>
                    <cfset variables.querystring = REReplace(cgi.Query_String, "[&?]sort=[^&]*", "", "all")>
                    <cfset variables.url = variables.url & variables.querystring & "&">
                </cfif>
                <a href="#variables.url#sort=pricelow" class="btn btn-success">Low to High</a>
                <a href="#variables.url#sort=pricehigh" class="btn btn-success">High to Low</a>
            </cfoutput>
        </div>
        <div class="container-fluid d-flex flex-row flex-wrap justify-content-evenly gap-5 p-5">
            <cfif arrayLen(products) NEQ 0>
                <cfloop array="#products#" item="product">
                    <cfoutput>
                        <a class="card bg-light text-decoration-none fw-bold col-3 p-3" href="product/#product.id#">
                            <div class="card-body d-flex row flex-wrap">
                                <div id="productpic#product.id#" class="card-img col-md-6 w-50 carousel slide" data-bs-ride="carousel">
                                    <div class="carousel-inner">
                                        <cfloop array="#product.images#" index="index" item="image">
                                            <div class="carousel-item <cfif index EQ 1> active</cfif>">
                                                <img src="/uploads/#image.image#" alt="Product image" class="d-block w-100">
                                            </div>
                                        </cfloop>
                                    </div>
                                </div>
                                <div class="col-md-6 d-flex flex-column justify-content-evenly fw-bold">
                                    <p class="h4 card-title text-info">#product.name#</p>
                                    <p class="card-text text-danger">#product.price#</p>
                                </div>
                            </div>
                        </a>
                    </cfoutput>
                </cfloop>
            <cfelse>
                <h1 class="bg-warning shadow text-center text-dark">Products items Empty!!</h1>
            </cfif>
        </div>
		<script type="text/javascript" src="/js/jQuery.js"></script>
		<script type="text/javascript" src="/js/home.js"></script>
		<script type="text/javascript" src="/js/bootstrap.min.js"></script>
		<script type="text/javascript" src="/js/bootstrap.bundle.min.js"></script>
	</body>
</html>