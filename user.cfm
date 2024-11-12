<cfset control = CreateObject("component", "components.control")>
<cfif NOT structKeyExists(session, "user") 
    OR NOT session.user.access>
        <cflocation  url="login.cfm?log=1" addToken="no">
<cfelse>
    <cfset variables.carter = control.getCart(session.user.user)>
</cfif>
<cfif structKeyExists(form, 'okbtn')>
    <cfset variables.shipping = {
        'name' = form.name,
        'phone' = form.phone,
        'house' = form.house,
        'street' = form.street,
        'city' = form.city,
        'state' = form.state,
        'country' = form.country,
        'pincode' = form.pincode,
        'user' = session.user.user
    }>
    <cfif structKeyExists(form, 'shippingId') AND len(form.shippingId) NEQ 0>
        <cfset variables.shipping['id'] = form.shippingId>
    </cfif>
    <cfset variables.error = control.modifyShipping(data=variables.shipping)>
    <cfif arrayLen(variables.error) NEQ 0>
        <nav class="alert alert-danger alert-dismissible fade show text-center mt-5 z-3 fw-bold">
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            <cfoutput>
                #arrayToList(variables.error)#
            </cfoutput>
        </nav>
    </cfif>
<cfelseif structKeyExists(form, 'dltbtn')>
    <cfset control.deleteShipping(id=form.shippingId)>
<cfelseif structKeyExists(form, 'emailbtn')>
    <cfset variables.message = control.userEmailChange(user=session.user.user,email=form.email)>
    <cfif len(variables.message) NEQ 0>
        <nav class="alert alert-danger alert-dismissible fade show text-center mt-5 z-3 fw-bold">
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            <cfoutput>
                #variables.message#
            </cfoutput>
        </nav>
    </cfif>
</cfif>
<html lang="en">
	<head>
		<link href="/css/admin.css" rel="stylesheet">
		<link href="/css/bootstrap.min.css" rel="stylesheet">
	</head>
	<body class="container-fluid p-0 d-flex flex-column align-items-center">
		<nav id="main-nav" class="container-fluid navbar navbar-expand-lg justify-content-center bg-primary gap-5 z-1 fw-bold fixed-top" data-bs-theme="dark">
            <div class="flex-grow-1">
                <a class="navbar-brand ms-2" href="index.cfm">
                    <img src="/images/shop.png" width="40" height="40" class="img-fluid">
                    Shopping Cart
                </a>
            </div>
            <ul class="flex-grow-1 navbar-nav nav-tabs nav-justified">
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
                    <a class="nav-link" href="login.cfm?log=0">
                        <img src="/images/logout.png" class="img-fluid" alt="Login" width="30" height="30">
                    </a>
                </li>
            </ul>
		</nav>
        <div class="container-fluid d-flex flex-row flex-wrap align-items-start justify-content-start z-0 h-100 p-0 mt-5">
            <cfoutput>
                <div class="bg-dark h-100 d-flex flex-column align-items-center fw-bold col-4 gap-5 p-5">
                    <a href="user.cfm">
                        <img class="img-fluid img-thumbnail rounded-circle" src="/uploads/#session.user.image#"
                            alt="Card image" height="80" data-bs-theme="dark">
                    </a>
                    <div class="d-grid fw-bold gap-5">
                        <button id="account-btn" class="btn fw-bold btn-outline-primary btn-block">
                            <img src="/images/account.png" class="img-fluid" alt="Login" width="40" height="40">
                            Account Details
                        </button>
                        <button id="address-btn" class="btn fw-bold btn-outline-primary btn-block">
                            <img src="/images/address.png" class="img-fluid" alt="Login" width="40" height="40">
                            Manage Addresses
                        </button>
                        <button id="order-btn" class="btn fw-bold btn-outline-primary btn-block">
                            <img src="/images/order.png" class="img-fluid" alt="Login" width="40" height="40">
                            Order Details
                        </button>
                    </div>
                </div>
            </cfoutput>
            <div class="h-100 d-flex flex-column z-0 fw-bold col-8 p-5">
                <div id="address-card" class="card z-1 bg-light h-100 fw-bold">
                    <h1 class="card-header card-title text-white bg-primary">Manage Addresses</h1>
                    <div class="card-body overflow-y-scroll d-grid gap-5 m-2">
                        <cfset variables.addresses = control.getShipping(user=session.user.user)>
                        <cfloop array="#variables.addresses#" item="address">
                            <cfoutput>
                                <div class="card">
                                    <div class="card-header d-flex justify-content-evenly bg-primary gap-3">
                                        <h4 class="flex-grow-1 text-white">#address.name#</h4>
                                        <button class="btn btn-success" data-bs-toggle="modal" data-bs-target="#chr(35)#modal"
                                            data-bs-action="edit" data-bs-id="#address.id#">
                                                Edit
                                        </button>
                                        <button class="btn btn-danger" data-bs-toggle="modal" data-bs-target="#chr(35)#modal"
                                            data-bs-action="delete" data-bs-id="#address.id#">
                                                Remove
                                        </button>
                                    </div>
                                    <div class="card-body">
                                        <h4 class="text-muted">#address.phone#</h4>
                                        <h5 class="text-muted">
                                            #address.house#,
                                            #address.street#,
                                            #address.city#,
                                            #address.state#,
                                            #address.country#,
                                            PIN-#address.pincode#
                                        </h5>
                                    </div>
                                </div>
                            </cfoutput>
                        </cfloop>
                    </div>
                    <button id='add' class="card-footer btn fw-bold btn-primary btn-block" data-bs-toggle="modal" data-bs-target="#modal"
                        data-bs-action="add">
                            <h3>Add Address</h3>
                    </button>
                </div>
                <div id="order-card" class="card z-1 bg-light h-100 fw-bold">
                    <div class="card-header d-flex text-white bg-primary">
                        <h1 class="flex-grow-1 card-title">Order History</h1>
                        <form class="d-flex">
                            <input name="keyword" id="keyword" class="form-control me-2" type="text" placeholder="Search" required>
                            <button name="search" id="search" class="btn btn-primary" type="submit" value="keyword">
                                <img src="/images/search.png" class="img-fluid" alt="Cart" width="30" height="30">
                            </button>
                        </form>
                    </div>
                    <div class="card-body overflow-y-scroll d-grid gap-5 m-2">
                        <cfif structKeyExists(url, 'keyword')>
                            <cfset variables.orders = control.getOrder(user=session.user.user,search=url.keyword)>
                        <cfelse>
                            <cfset variables.orders = control.getOrder(user=session.user.user)>
                        </cfif>
                        <cfloop array="#variables.orders#" item="order">
                            <cfoutput>
                                <div class="card">
                                    <div class="card-header d-flex justify-content-evenly bg-primary gap-5">
                                        <h5 class="flex-grow-1">
                                            <span class="text-white">Order No :</span>
                                            <span class="text-muted">#order.id#</span>
                                        </h5>
                                        <a class="btn btn-danger" href="order-invoice.cfm?order=#order.id#">pdf</a>
                                    </div>
                                    <cfset variables.total = 0>
                                    <cfset variables.tax = 0>
                                    <ul class="card-body list-group p-0">
                                        <cfloop array="#order.items#" item="item">
                                            <li class="list-group-item d-flex justify-content-between">
                                                <div class="col-7 d-flex flex-column">
                                                    <p class="card-text">
                                                        <span class="text-dark">Item :</span>
                                                        <span class="text-muted">#item.name#</span>
                                                    </p>
                                                    <p class="card-text">
                                                        <span class="text-dark">Quantity :</span>
                                                        <span class="text-muted">#item.quantity#</span>
                                                    </p>
                                                    <p class="card-text">
                                                        <span class="text-dark">Price :</span>
                                                        <span class="text-muted">
                                                            #chr(8377)#
                                                            #numberFormat(item.price+(item.price*item.tax/100),'__.00')#
                                                        </span>
                                                    </p>
                                                    <p class="card-text">
                                                        <span class="text-dark">Tax :</span>
                                                        <span class="text-muted">
                                                            #item.tax#%
                                                        </span>
                                                    </p>
                                                    <p class="card-text">
                                                        <span class="text-dark">Total Amount :</span>
                                                        <span class="text-muted">
                                                            #chr(8377)#
                                                            #numberFormat((item.price+(item.price*item.tax/100))*item.quantity,'__.00')#
                                                        </span>
                                                    </p>
                                                    <p class="card-text">
                                                        <span class="text-dark">Total Tax :</span>
                                                        <span class="text-muted">
                                                            #chr(8377)#
                                                            #numberFormat((item.price*item.tax/100)*item.quantity,'__.00')#
                                                        </span>
                                                    </p>
                                                    <cfset variables.total += (item.price+(item.price*item.tax/100))*item.quantity>
                                                    <cfset variables.tax += (item.price*item.tax/100)*item.quantity>
                                                </div>
                                            </li>
                                        </cfloop>
                                    </ul>
                                    <div class="card-footer">
                                        <div class="d-flex justify-content-between">
                                            <p class="row card-text">
                                                <span class="text-dark">Date of Purchase :</span>
                                                <span class="col-12 text-muted">#dateTimeFormat(order.date,'medium')#</span>
                                            </p>
                                            <p class="card-text">
                                                <span class="text-dark">Total Billed Amount :</span>
                                                <span class="text-muted">
                                                    #chr(8377)#
                                                    #numberFormat(variables.total,'__.00')#
                                                </span>
                                            </p>
                                            <p class="card-text">
                                                <span class="text-dark">Total Estimated Tax :</span>
                                                <span class="text-muted">
                                                    #chr(8377)#
                                                    #numberFormat(variables.tax,'__.00')#
                                                </span>
                                            </p>
                                        </div>
                                        <p class="card-text d-flex gap-3">
                                            <span class="text-dark">Address :</span>
                                            <span class="col-10 text-muted">
                                                #order.shipping.name# #order.shipping.phone#<br>
                                                #order.shipping.house#, #order.shipping.street#,
                                                #order.shipping.city#, #order.shipping.state#,
                                                #order.shipping.country#, PIN - #order.shipping.pincode#
                                            </span>
                                        </p>
                                    </div>
                                </div>
                            </cfoutput>
                        </cfloop>
                    </div>
                </div>
                <cfoutput>
                    <div class="h-100 position-absolute z-0 d-flex flex-column align-items-center fw-bold">
                        <h1 class="container-fluid text-center">
                            <span class="text-muted">Name of User :</span>
                            <span class="text-primary">#session.user.name#</span>
                        </h1>
                        <div class="container-fluid h-50 d-flex flex-column fw-bold">
                            <cfoutput>
                                <form class="container-fluid" action="" method="post">
                                    <fieldset class="d-flex flex-wrap border border-2 rounded gap-5 p-3">
                                        <legend>Email</legend>
                                        <div class="col-8 form-floating">
                                            <input class="flex-grow-1 form-control bg-primary text-light fw-bold" type="text" id="email" 
                                                name="email" placeholder="" value="#session.user.email#">
                                            <label for="email" class="form-label">Email</label>
                                        </div>
                                        <button id="emailbtn" name="emailbtn" type="submit" class="btn btn-outline-success fw-bold">Change</button>
                                    </fieldset>
                                </form>
                                <form class="container-fluid">
                                    <fieldset class="d-flex flex-wrap border border-2 rounded gap-5 p-3">
                                        <legend>Password</legend>
                                        <div class="col-5 form-floating">
                                            <input class="form-control bg-primary text-light fw-bold" type="text" id="currentPassword"
                                                name="currentPassword" placeholder="">
                                            <label for="currentPassword" class="form-label">Current Password</label>
                                        </div>
                                        <div class="col-5 form-floating">
                                            <input class="form-control bg-primary text-light fw-bold" type="text" id="newPassword"
                                                name="newPassword" placeholder="">
                                            <label for="newPassword" class="form-label">New Password</label>
                                        </div>
                                        <div class="col-5 form-floating">
                                            <input class="form-control bg-primary text-light fw-bold" type="text" id="confirmPassword"
                                                name="confirmPassword" placeholder="">
                                            <label for="confirmPassword" class="form-label">Confirm Password</label>
                                        </div>
                                        <button id="passwordbtn" name="passwordbtn" type="submit" class="btn btn-outline-success fw-bold">Change</button>
                                    </fieldset>
                                </form>
                            </cfoutput>
                        </div>
                    </div>
                </cfoutput>
            </div>
            <div class="modal fade" id="modal" tabindex="-1" role="dialog" data-bs-theme="dark">
                <div class="modal-dialog">
                    <div class="modal-content d-flex p-3">
                        <div class="modal-header d-flex">
                            <h2 id="modalhead" class="modal-title flex-grow-1 fw-bold text-primary text-center">Shipping Address Details</h2>
                            <button type="button" class="btn-close border rounded" data-bs-dismiss="modal"></button>
                        </div>
                        <form id="addressForm" name="addressForm" class="modal-body d-flex flex-column gap-2 p-3" action="" method="post" enctype="multipart/form-data">
                            <fieldset id="modify-mode" class="d-flex flex-column rounded border gap-2 p-3">
                                <div class="form-floating">
                                    <input class="form-control text-warning" type="text" id="name" name="name" placeholder="">
                                    <label for="name" class="form-label text-light">Name</label>
                                </div>
                                <div class="form-floating">
                                    <input class="form-control text-warning" type="text" id="phone" name="phone" placeholder="">
                                    <label for="phone" class="form-label text-light">Phone</label>
                                </div>
                                <div class="form-floating">
                                    <input class="form-control text-warning" type="text" id="house" name="house" placeholder="">
                                    <label for="house" class="form-label text-light">House/Flat</label>
                                </div>
                                <div class="form-floating">
                                    <input class="form-control text-warning" type="text" id="street" name="street" placeholder="">
                                    <label for="street" class="form-label text-light">Street</label>
                                </div>
                                <div class="form-floating">
                                    <input class="form-control text-warning" type="text" id="city" name="city" placeholder="">
                                    <label for="city" class="form-label text-light">City</label>
                                </div>
                                <div class="form-floating">
                                    <input class="form-control text-warning" type="text" id="state" name="state" placeholder="">
                                    <label for="state" class="form-label text-light">State</label>
                                </div>
                                <div class="form-floating">
                                    <input class="form-control text-warning" type="text" id="country" name="country" placeholder="">
                                    <label for="country" class="form-label text-light">Country</label>
                                </div>
                                <div class="form-floating">
                                    <input class="form-control text-warning" type="text" id="pincode" name="pincode" placeholder="">
                                    <label for="pincode" class="form-label text-light">Pincode</label>
                                </div>
                            </fieldset>
                            <fieldset class="delete-mode d-flex flex-column rounded border gap-2 p-3">
				                <legend class="text-center text-warning">Are you sure you want to remove this address?</legend>
                            </fieldset>
                            <input type="hidden" name="shippingId" id="shippingId">
                        </form>
                        <div class="modal-footer d-flex justify-content-between">
                            <button name="okbtn" id="okbtn" type="submit" class="btn btn-outline-success fw-bold" form="addressForm"></button>
                            <button name="dltbtn" id="dltbtn" type="submit" class="btn btn-outline-success fw-bold" form="addressForm">Yes</button>
                            <button type="button" class="btn btn-outline-danger fw-bold" data-bs-dismiss="modal">Cancel</button>
                        </div>
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