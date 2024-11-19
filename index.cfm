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
<cfif structKeyExists(url, 'range')>
    <cfset argumentCollection.range = url.range>
</cfif>
<cfif structKeyExists(url, 'keyword')>
    <cfset argumentCollection.search = url.keyword>
<cfelseif structKeyExists(url, 'sub')>
    <cfset argumentCollection.subcategory = url.sub>
<cfelseif structKeyExists(url, 'cat')>
    <cfset argumentCollection.category = url.cat>
</cfif>
<cfset products = control.getProduct(argumentCollection=argumentCollection)>
<cfif structKeyExists(form, 'filterbtn')
    AND structKeyExists(form, 'check')
    AND len(form.check) GT 0>
        <cflocation  url="index.cfm?range=#form.check#" addToken="no">
</cfif>
<html lang="en">
	<head>
		<link href="/css/admin.css" rel="stylesheet">
		<link href="/css/bootstrap.min.css" rel="stylesheet">
	</head>
	<body class="container-fluid p-0 d-flex flex-column align-items-center">
		<nav id="main-nav" class="container-fluid navbar navbar-expand-lg justify-content-between bg-primary gap-5 z-3 fw-bold fixed-top" data-bs-theme="dark">
            <a class="flex-grow-1 navbar-brand ms-2" href="index.cfm">
                <img src="/images/shop.png" width="40" height="40" class="img-fluid">
                ShopKart
            </a>
            <form class="flex-grow-1 d-flex">
                <input name="keyword" id="keyword" class="form-control me-2" type="search" placeholder="Search for products" required>
                <button name="search" id="search" class="btn btn-primary" type="submit" value="keyword">
                    <img src="/images/search.png" class="img-fluid" alt="Cart" width="30" height="30">
                </button>
            </form>
            <ul class="flex-grow-1 navbar-nav nav-tabs nav-justified">
                <li class="nav-item dropdown" title="Menu">
                    <a class="nav-link dropdown-toggle <cfif structKeyExists(url, 'cat')>active</cfif>" href="" data-bs-toggle="dropdown">
                        <img src="/images/menu.png" class="img-fluid" alt="Cart" width="30" height="30">
                    </a>
                    <ul class="dropdown-menu">
                        <cfset categories = control.getCategory()>
                        <cfloop array="#categories#" item="item">
                            <cfoutput>
                                <li>
                                    <a id="#item.id#" class="dropdown-item" href="index.cfm?cat=#item.id#">#item.name#</a>
                                </li>
                            </cfoutput>
                        </cfloop>
                    </ul>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="cart.cfm">
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
            <nav id="category-nav" class="container-fluid navbar navbar-expand-lg justify-content-center bg-secondary z-2 fixed-top" data-bs-theme="dark">
                <ul class="flex-grow-1 navbar-nav nav-tabs nav-justified">
                    <cfset categories = control.getCategory()>
                    <cfloop array="#categories#" item="category">
                        <cfoutput>
                            <li class="nav-item dropdown">
                                <a id="#category.id#" class="nav-link
                                    <cfif category.id EQ url.cat>active</cfif>
                                    dropdown-toggle" 
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
                        <img src="/images/banner-1.jpg" alt="Product image" class="d-block w-100">
                        <div class="carousel-caption d-none d-md-block text-warning font-monospace">
                            <h3>SHOPKART</h3>
                            <h5>Welcome to the shopping paradise.</h5>
                        </div>
                    </div>
                    <div class="carousel-item">
                        <img src="/images/banner-2.jpg" alt="Product image" class="d-block w-100">
                    </div>
                    <div class="carousel-item">
                        <img src="/images/banner-3.jpg" alt="Product image" class="d-block w-100">
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
            <button class="btn btn-outline-primary" data-bs-toggle="modal" data-bs-target="#modal" data-bs-action="filter">Filter</button>
            <div class="border border-2 border-secondary rounded d-flex justify-content-center align-items-center p-1 gap-1">
                <p class="text-center text-success">
                    PRICE
                </p>
                <cfoutput>
                    <cfset variables.url = cgi.HTTP_URL>
                    <cfset variables.url = REReplace(variables.url, "[&?]sort=[^&]*", "", "all")>
                    <cfset variables.url = variables.url & (find('?', variables.url) ? '&' : '?')>
                    <a href="#variables.url#sort=pricelow" class="btn btn-success">Low to High</a>
                    <a href="#variables.url#sort=pricehigh" class="btn btn-success">High to Low</a>
                </cfoutput>
            </div>
        </div>
        <div class="container-fluid d-flex flex-row flex-wrap justify-content-evenly gap-5 p-5">
            <cfif arrayLen(products) NEQ 0>
                <cfloop array="#products#" item="product">
                    <cfoutput>
                        <a class="card bg-light text-decoration-none fw-bold col-3 p-3" href="product.cfm?pro=#product.id#">
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
        <div class="modal fade" id="modal" tabindex="-1" role="dialog" data-bs-theme="dark">
            <div class="modal-dialog">
                <div class="modal-content d-flex p-3">
                    <div class="modal-header d-flex">
                        <h2 id="modalhead" class="modal-title flex-grow-1 fw-bold text-primary text-center">Shipping Address Details</h2>
                        <button type="button" class="btn-close border rounded" data-bs-dismiss="modal"></button>
                    </div>
                    <form id="addressForm" name="addressForm" class="modal-body d-flex flex-column gap-2 p-3" action="" method="post" enctype="multipart/form-data">
                        <div class="form-check">
                            <input class="form-check-input bg-primary" type="radio" name="check" value="10000">
                            <label class="form-check-label text-white">Price less than 10000</label>
                        </div>
                        <div class="form-check">
                            <input class="form-check-input bg-primary" type="radio" name="check" value="10000,50000">
                            <label class="form-check-label text-white">Price 10000 to 50000</label>
                        </div>
                        <div class="form-check">
                            <input class="form-check-input bg-primary" type="radio" name="check" value="50000,100000">
                            <label class="form-check-label text-white">Price 50000 to 100000</label>
                        </div>
                        <div class="form-check">
                            <input class="form-check-input bg-primary" type="radio" name="check" value="100000,max">
                            <label class="form-check-label text-white">Price more than 100000</label>
                        </div>
                    </form>
                    <div class="modal-footer d-flex justify-content-between">
                        <button name="filterbtn" id="filterbtn" type="submit" class="btn btn-outline-success fw-bold" form="addressForm">Filter</button>
                        <button type="button" class="btn btn-outline-danger fw-bold" data-bs-dismiss="modal">Cancel</button>
                    </div>
                </div>
            </div>
        </div>
		<script type="text/javascript" src="/js/jQuery.js"></script>
		<script type="text/javascript" src="/js/home.js"></script>
		<script type="text/javascript" src="/js/bootstrap.min.js"></script>
		<script type="text/javascript" src="/js/bootstrap.bundle.min.js"></script>
	</body>
</html>