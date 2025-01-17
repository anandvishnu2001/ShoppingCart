<cfif structKeyExists(form, 'dltbtn') OR structKeyExists(url, 'action')>
    <cfset argumentCollection = {}>
    <cfif structKeyExists(form, 'dltbtn')>
        <cfset argumentCollection.change = 'delete'>
        <cfif structKeyExists(form, 'product') AND len(form.product) NEQ 0>
            <cfset argumentCollection.product = form.product>
        </cfif>
    </cfif>
    <cfif structKeyExists(url, 'action')>
        <cfset argumentCollection.change = url.action>
        <cfif structKeyExists(url, 'id')>
            <cfset argumentCollection.product = url.id>
        </cfif>
    </cfif>
    <cfset application.control.editCart(argumentCollection=argumentCollection)>
    <cflocation  url="/cart" addToken="no">
</cfif>
<cfif session.user.access>
    <cfif structKeyExists(url, 'pro')>
        <cfset application.control.addCart(product=url.pro,user=session.user.user)>
        <cflocation  url="/cart" addToken="no">
    </cfif>
    <cfset variables.carter = application.control.getCart(session.user.user)>
<cfelse>
    <cfset variables.carter = {}>
</cfif>
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
            <ul class="navbar-nav nav-tabs nav-justified w-25">
                <li class="nav-item">
                    <a class="nav-link active" href="/cart">
                        <img src="/images/cart.png" class="img-fluid" alt="Cart" width="30" height="30">
                        <cfif structKeyExists(session.user, 'user')
                            AND application.control.countCart() GT 0>
                            <cfoutput>
                                <span class="badge bg-danger rounded-pill">#application.control.countCart()#</span>
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
                        <a class="nav-link" href="/log">
                            <img src="/images/login.png" class="img-fluid" alt="Login" width="30" height="30">
                        </a>
                    </cfif>
                </li>
            </ul>
		</nav>
        <div class="container-fluid d-flex flex-row justify-content-evenly align-items-start gap-5 p-5 mt-5">
            <div class="card bg-light fw-bold col-6 p-3">
                <ul class="card-body list-group d-flex flex-column p-5">
                    <cfset variables.cartTotal = 0>
                    <cfif session.user.access
                        AND structKeyExists(variables.carter, 'items')
                        AND arrayLen(variables.carter.items) NEQ 0>
                        <cfloop array="#variables.carter.items#" item="item">
                            <cfoutput>
                                <li class="list-group-item d-flex flex-column gap-3 p-5">
                                    <div class="d-flex flex-row flex-wrap justify-content-evenly">
                                        <div id="productpic#item.product#" class="card-img w-25 carousel slide" data-bs-ride="carousel" data-bs-theme="dark">
                                            <div class="carousel-inner">
                                                <cfloop array="#item.images#" index="index" item="image">
                                                    <div class="carousel-item <cfif index EQ 1> active</cfif>">
                                                        <img src="/uploads/#image.image#" alt="Product image" class="d-block w-100">
                                                    </div>
                                                </cfloop>
                                            </div>
                                            <button class="carousel-control-prev" type="button" data-bs-target="#chr(35)#productpic#item.product#" data-bs-slide="prev">
                                                <span class="carousel-control-prev-icon"></span>
                                            </button>
                                            <button class="carousel-control-next" type="button" data-bs-target="#chr(35)#productpic#item.product#" data-bs-slide="next">
                                                <span class="carousel-control-next-icon"></span>
                                            </button>
                                        </div>
                                        <div class="col-5 d-flex flex-column justify-content-evenly fw-bold">
                                            <p class="h4 card-title text-info">#item.name#</p>
                                        <p class="card-text text-danger">#numberFormat(item.totalprice)#</p>
                                        </div>
                                    </div>
                                    <div class="d-flex justify-content-evenly">
                                        <a class="btn btn-secondary rounded-pill"
                                            <cfif item.quantity GT 1>
                                                href="/cart.cfm?action=decrease&id=#item.product#"
                                            <cfelse>
                                                data-bs-toggle="modal" data-bs-target="#chr(35)#deleter" data-bs-id="#item.product#"
                                            </cfif>>
                                            -
                                        </a>
                                        <p class="card-text text-muted">#item.quantity#</p>
                                        <a class="btn btn-secondary rounded-pill" href="/cart.cfm?action=increase&id=#item.product#">+</a>
                                        <button class="btn btn-danger" data-bs-toggle="modal" data-bs-target="#chr(35)#deleter"
                                            data-bs-id="#item.product#">
                                                Remove item
                                        </button>
                                    </div>
                                </li>
                            </cfoutput>
                        </cfloop>
                    <cfelseif session.user.access>
                        <div class="col-md-6 col-12 d-grid mx-auto">
                            <h1 class="bg-warning shadow text-center text-dark">Cart is Empty!!</h1>
                            <a class="btn btn-outline-info" href="/home">Explore our products</a>
                        </div>
                    <cfelse>
                        <div class="col-md-6 col-12 d-grid mx-auto">
                            <h1 class="bg-warning shadow text-center text-dark">Missing your cart</h1>
                            <h3 class="text-center text-muted">Login to see your items</h3>
                            <a class="btn btn-outline-success btn-block"
                                <cfif structKeyExists(url, 'pro')>
                                    <cfoutput>href="/log/cart/#url.pro#"</cfoutput>
                                <cfelse>
                                    href="/log/cart"
                                </cfif>
                                >
                                Login
                            </a>
                        </div>
                    </cfif>
                </ul>
            </div>
            <cfif structKeyExists(variables.carter, 'items')
                AND arrayLen(variables.carter.items) NEQ 0>
                <div class="card bg-light fw-bold col-4 p-3 gap-5 p-5">
                    <cfoutput>
                        <p class="card-text bg-info text-center text-danger">Total Price :<br>#numberFormat(variables.carter.totalprice)#</p>
                        <a class="btn btn-success" href="payment">Check out</a>
                        <button class="btn btn-danger" data-bs-toggle="modal" data-bs-target="#chr(35)#deleter">
                            Empty cart
                        </button>
                    </cfoutput>
                </div>
            </cfif>
        </div>
        <div class="modal fade" id="deleter" tabindex="-1" role="dialog" data-bs-theme="dark">
            <div class="modal-dialog">
                <div class="modal-content d-flex p-3">
                    <div class="modal-header d-flex">
                        <h2 id="modalhead" class="modal-title flex-grow-1 fw-bold text-warning text-center"></h2>
                        <button type="button" class="btn-close border rounded" data-bs-dismiss="modal"></button>
                    </div>
                    <form id="modalForm" name="modalForm" action="" method="post">
                        <input type="hidden" name="product" id="product">
                    </form>
                    <div class="modal-footer d-flex justify-content-between">
                        <button name="dltbtn" id="dltbtn" type="submit" class="btn btn-outline-success fw-bold" form="modalForm">Yes</button>
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