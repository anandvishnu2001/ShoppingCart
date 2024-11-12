<cfif structKeyExists(session, "check") 
    AND session.check.access>
	    <cflocation url="admin-home.cfm" addToken="no">
<cfelse>
	<cfset session.check = {
        "access" = false
    }>
</cfif>
<cfif structKeyExists(form, "btn")>
    <cfset control = CreateObject("component", "components.control")>
	<cfset control.adminLogin(admin=form.admin, password=form.password)>
    <cfif session.check.access>
		<cflocation url="admin-home.cfm" addToken="no">
	<cfelse>
		<cflocation url="index.cfm" addToken="no">
	</cfif>
</cfif>
<html lang="en">
	<head>
		<link href="/css/admin.css" rel="stylesheet">
		<link href="/css/bootstrap.min.css" rel="stylesheet">
	</head>
	<body class="container-fluid p-0 d-flex flex-row align-items-center">
		<nav class="container-fluid p-1  navbar navbar-expand-lg justify-content-between bg-success navbar-light fw-bold fixed-top" data-bs-theme="dark">
				<a class="navbar-brand text-info" href="">
					<img src="/images/shop.png" width="40" height="40" class="rounded-pill">
					Shopping Cart
				</a>
				<ul class="navbar-nav nav-tabs nav-justified">
					<li class="nav-item">
						<a class="nav-link bg-success text-info" href="">
							Log in
						</a>
					</li>
				</ul>
		</nav>
		<div class="card col-lg-4 col-md-6 col-8 rounded-3 mx-auto mt-5 mb-3 p-3" data-bs-theme="dark">
			<p class="h1 card-header card-title text-center text-success">ADMIN LOGIN</p>
			<form name="login" id="login" class="card-body d-flex flex-column was-validated gap-2" action="" method="post">
				<div class="form-floating">
					<input type="text" class="form-control" name="admin" id="admin" placeholder="" autofocus required>
					<label for="admin" class="form-label">Admin</label>
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
		<script type="text/javascript" src="/js/jQuery.js"></script><!---
		<script type="text/javascript" src="/js/admin.js"></script>--->
		<script type="text/javascript" src="/js/bootstrap.min.js"></script>
	</body>
</html>