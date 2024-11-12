<cfset control = CreateObject("component", "components.control")>
<cfif structKeyExists(session, 'user') 
    AND session.user.access>
    <cfset variables.carter = control.getCart(session.user.user)>
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
                Shopping Cart
            </a>
            <ul class="flex-grow-1 navbar-nav nav-tabs nav-justified">
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" href="" data-bs-toggle="dropdown">
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
                        <cfif structKeyExists(variables, 'carter')
                            AND arrayLen(variables.carter) GT 0>
                            <cfoutput>
                                <span class="badge bg-danger rounded-pill">#arrayLen(variables.carter)#</span>
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
        <div class="container-fluid d-flex flex-row flex-wrap justify-content-evenly mt-5 gap-5 p-5">
            <cfif structKeyExists(url, 'pro')>
                <cfset products = control.getProduct(product=url.pro)>
                <cfoutput>
                    <div class="container d-flex justify-content-center p-3 gap-5">
                        <cfset breadcrumbSub = control.getSubcategory(subcategory=products[1].subcategory)>
                        <cfset breadcrumbCat = control.getCategory(category=breadcrumbSub[1].category)>
                        <ul class="breadcrumb">
                            <li class="breadcrumb-item"><a class="text-decoration-none" href="index.cfm">Home</a></li>
                            <li class="breadcrumb-item">
                                <a class="text-decoration-none" href="index.cfm?cat=#breadcrumbCat[1].id#">
                                    #breadcrumbCat[1].name#
                                </a>
                            </li>
                            <li class="breadcrumb-item">
                                <a class="text-decoration-none" href="index.cfm?cat=#breadcrumbCat[1].id#&sub=#breadcrumbSub[1].id#">
                                    #breadcrumbSub[1].name#
                                </a>
                            </li>
                            <li class="breadcrumb-item active">#products[1].name#</li>
                        </ul>
                    </div>
                    <div class="card bg-light w-75 fw-bold p-5">
                        <div class="card-body d-flex row flex-wrap gap-5">
                            <img class="card-img col-md-6 w-25 h-auto img-fluid img-thumbnail" src="/uploads/#products[1].image#"
                                alt="Card image" data-bs-theme="dark">
                            <div class="col-md-6 d-flex flex-column justify-content-evenly align-items-center fw-bold">
                                <h1 class="card-title text-dark">#products[1].name#</h1>
                                <h3 class="card-text text-muted">#products[1].description#</h3>
                                <h2 class="card-text text-danger">#products[1].price+(products[1].price*products[1].tax/100)#</h2>
                                <div class="container-fluid btn-group btn-group-lg">
                                    <a class="card-link btn btn-success" href="cart.cfm?pro=#products[1].id#">
                                        Add to <img src="/images/cart.png" class="img-fluid" alt="Cart" width="30" height="30">
                                    </a>
                                    <a class="card-link btn btn-success" href="payment.cfm?pro=#products[1].id#">
                                        Buy Now
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                </cfoutput>
            <cfelse>
                <h1 class="text-center text-warning">Product Not Selected!!</h1>
            </cfif>
        </div>
		<script type="text/javascript" src="/js/jQuery.js"></script>
		<script type="text/javascript" src="/js/home.js"></script>
		<script type="text/javascript" src="/js/bootstrap.min.js"></script>
		<script type="text/javascript" src="/js/bootstrap.bundle.min.js"></script>
	</body>
</html>