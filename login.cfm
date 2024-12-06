<cfif structKeyExists(url, 'log') AND url.log EQ 0
	AND session.user.access>
		<cfset structClear(session.user)>
		<cfset session.user = {
			'access' = false
		}>
</cfif>
<cfif structKeyExists(form, "btn")>
	<cfset variables.error = application.control.userLogin(user=form.user, password=form.password)>
	<cfif len(variables.error) EQ 0
		AND session.user.access>
			<cfif structKeyExists(url, 'site')>
				<cfif url.site EQ 'cart'>
					<cfset variables.site = "/cart">
					<cfif structKeyExists(url, 'pro')>
						<cfset variables.site = variables.site & "/#url.pro#">
					</cfif>
						<cflocation url="#variables.site#" addToken="no">
				<cfelseif url.site EQ 'pay' AND structKeyExists(url, 'pro')>
					<cflocation url="/payment/#url.pro#" addToken="no">
				</cfif>
			<cfelse>
				<cflocation url="/home" addToken="no">
			</cfif>
	<cfelse>
        <nav class="alert alert-danger alert-dismissible fade show text-center z-3 fw-bold">
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            <cfoutput>#variables.error#!!!</cfoutput>
        </nav>
	</cfif>
</cfif>
<html lang="en">
	<head>
		<link href="/css/admin.css" rel="stylesheet">
		<link href="/css/bootstrap.min.css" rel="stylesheet">
	</head>
	<body class="container-fluid h-100 p-0 d-flex flex-column justify-content-center align-items-center">
		<nav id="main-nav" class="container-fluid navbar navbar-expand-lg justify-content-between bg-primary gap-5 z-2 fw-bold fixed-top" data-bs-theme="dark">
            <a class="navbar-brand ms-2" href="/home">
                <img src="/images/shop.png" width="40" height="40" class="img-fluid">
                ShopKart
            </a>
            <ul class="navbar-nav nav-tabs nav-justified w-25">
                <li class="nav-item">
                    <a class="nav-link" href="/cart">
                        <img src="/images/cart.png" class="img-fluid" alt="Cart" width="30" height="30">
                    </a>
                </li>
            </ul>
		</nav>
		<div class="card col-lg-4 col-md-6 col-8 rounded-3 z-1 mx-auto mt-5 p-3">
			<p class="h1 card-header card-title text-center text-primary">USER LOGIN</p>
			<form name="login" id="login" class="card-body d-flex flex-column was-validated gap-2" action="" method="post">
				<div class="form-floating">
					<input type="email" class="form-control" name="user" id="user" placeholder="" autofocus required>
					<label for="user" class="form-label">Email</label>
				</div>
				<div class="form-floating">
					<input type="password" class="form-control" name="password" id="password" placeholder="" required>
					<label for="password" class="form-label">Password</label>
				</div>
				<span id="feedback" class="border-3 text-center text-danger bg-warning invisible"></span>
			</form>
			<button name="btn" id="btn" type="submit" class="card-footer btn btn-success btn-block" form="login">
				Log in
			</button>
		</div>
		<script type="text/javascript" src="/js/jQuery.js"></script>
		<script type="text/javascript" src="/js/home.js"></script>
		<script type="text/javascript" src="/js/bootstrap.min.js"></script>
		<script type="text/javascript" src="/js/bootstrap.bundle.min.js"></script>
	</body>
</html>