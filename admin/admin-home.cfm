<cfif NOT structKeyExists(session, "check") 
    OR NOT session.check.access
    OR structKeyExists(url, "logout")>
        <cfif structKeyExists(url, "logout")
            AND url.logout EQ 1>
                <cfset structClear(session.check)>
        </cfif>
    <cfset session.check = {
        "access" = false
    }>
    <cflocation url="index.cfm" addToken="no">
</cfif>
<cfset control = CreateObject("component", "components.control")>
<cfif structKeyExists(form, 'okbtn')>
    <cfset variables.input = control.validate(form)>
    <cfif arrayLen(variables.input.message) EQ 0>
        <cfif structKeyExists(variables.input.data, 'category')>
            <cfset control.modifyCategory(variables.input.data)>
        <cfelseif  structKeyExists(variables.input.data, 'subcategory')>
            <cfset control.modifySubcategory(variables.input.data)>
        <cfelse>
            <cfset control.modifyProduct(variables.input.data)>
        </cfif>
    <cfelse>
        <div class="row">
            <cfoutput>#arrayToList(variables.input.message)#</cfoutput>
        </div>
    </cfif>
<cfelseif structKeyExists(form, 'dltbtn')>
    <cfset variables.section = {
        "admin" = session.check.admin,
        "section" = form.set,
        "id" = form.recordId
    }>
    <cfset control.deleteItem(variables.section)>
</cfif>
<html lang="en">
	<head>
		<link href="/css/admin.css" rel="stylesheet">
		<link href="/css/bootstrap.min.css" rel="stylesheet">
	</head>
	<body class="container-fluid p-0 d-flex flex-row align-items-center">
		<nav class="container-fluid p-1  navbar navbar-expand-lg navbar-light justify-content-between bg-success fw-bold fixed-top" data-bs-theme="dark">
            <a class="navbar-brand text-info" href="">
                <img src="/images/shop.png" width="40" height="40" class="rounded-pill">
                ShopKart
            </a>
            <ul class="navbar-nav nav-tabs nav-justified">
                <li class="nav-item">
                    <a class="nav-link bg-success text-info" href="admin-home.cfm?logout=1">
                        Log out
                    </a>
                </li>
            </ul>
		</nav>
		<div class="container-fluid row d-flex align-items-center justify-content-around rounded-3 mx-auto mt-5 p-3" data-bs-theme="dark">
            <div id="categories" class="card col-3 rounded-3 p-3">
                <p class="h2 card-header card-title text-center text-success">Categories</p>
                <div id="categorylist" class="card-body list-group">
                    <cfset categories = control.getCategory()>
                    <cfif arrayLen(categories) eq 0>
                        <li class="list-group-item">Category is empty</li>
                    <cfelse>
                        <cfoutput>
                            <cfloop array="#categories#" index="category">
                            <li class="list-group-item d-flex justify-content-end gap-2 <cfif structKeyExists(url, 'cat') AND category.id EQ url.cat>active</cfif>">
                                <a class="py-2 px-3 text-decoration-none list-group-item-action"
                                    href="admin-home.cfm?cat=#category.id#">
                                        #category.name#
                                </a>
                                <button class="btn btn-sm fw-bold btn-outline-success btn-block" data-bs-toggle="modal"
                                    data-bs-target="#chr(35)#modal" data-bs-action="edit" data-bs-set="category" data-bs-id="#category.id#">
                                        <img src="/images/edit.png" width="30" height="30" class="img-fluid">
                                </button>
                                <button class="btn btn-sm fw-bold btn-outline-danger btn-block" data-bs-toggle="modal"
                                    data-bs-target="#chr(35)#modal" data-bs-action="delete" data-bs-set="category" data-bs-id="#category.id#">
                                        <img src="/images/delete.png" width="30" height="30" class="img-fluid">
                                </button>
                            </li>
                            </cfloop>
                        </cfoutput>
                    </cfif>
                </div>
                <button id="addCategory" name="addCategory" class="card-footer btn btn-primary btn-block" data-bs-toggle="modal"
                    data-bs-target="#modal" data-bs-action="add" data-bs-set="category">
                    <img src="/images/add.png" width="30" height="30" class="img-fluid">
                </button>
            </div>
            <div id="subcategories" class="card col-3 rounded-3 p-3">
                <cfif structKeyExists(url, 'cat')>
                    <p class="h2 card-header card-title text-center text-success">Sub categories</p>
                    <div id="subcategorylist" class="card-body list-group">
                            <cfset categories = control.getSubcategory(category=url.cat)>
                            <cfif arrayLen(categories) eq 0>
                                <li class="list-group-item">Subcategory is empty</li>
                            <cfelse>
                                <cfoutput>
                                    <cfloop array="#categories#" index="category">
                                    <li class="list-group-item d-flex justify-content-end gap-2 <cfif structKeyExists(url, 'sub') AND category.id EQ url.sub>active</cfif>">
                                        <a class="py-2 px-3 text-decoration-none list-group-item-action"
                                            href="admin-home.cfm?cat=#category.category#&sub=#category.id#">
                                                #category.name#
                                        </a>
                                        <button class="btn btn-sm fw-bold btn-outline-success btn-block" data-bs-toggle="modal"
                                            data-bs-target="#chr(35)#modal" data-bs-action="edit" data-bs-set="subcategory"
                                            data-bs-id="#category.id#">
                                                <img src="/images/edit.png" width="30" height="30" class="img-fluid">
                                        </button>
                                        <button class="btn btn-sm fw-bold btn-outline-danger btn-block" data-bs-toggle="modal"
                                            data-bs-target="#chr(35)#modal" data-bs-action="delete" data-bs-set="subcategory" data-bs-id="#category.id#">
                                                <img src="/images/delete.png" width="30" height="30" class="img-fluid">
                                        </button>
                                    </li>
                                    </cfloop>
                                </cfoutput>
                            </cfif>
                    </div>
                    <button id="addSubcategory" name="addSubcategory" class="card-footer btn btn-primary btn-block"
                        data-bs-toggle="modal" data-bs-target="#modal" data-bs-action="add" data-bs-set="subcategory">
                        <img src="/images/add.png" width="30" height="30" class="img-fluid">
                    </button>
                </cfif>
            </div>
            <div id="products" class="card col-5 rounded-3 p-3">
                <cfif structKeyExists(url, 'sub')>
                    <p class="h2 card-header card-title text-center text-success">Products</p>
                    <div id="productlist" class="card-body list-group">
                            <cfset products = control.getProduct(subcategory=url.sub)>
                            <cfif arrayLen(products) eq 0>
                                <li class="list-group-item">Subcategory is empty</li>
                            <cfelse>
                                <cfoutput>
                                    <cfloop array="#products#" index="product">
                                    <li class="row list-group-item d-flex justify-content-between">
                                        <div class="col-7 d-flex gap-2">
                                            <div id="productpic#product.id#" class="flex-grow-1 carousel slide" data-bs-ride="carousel">
                                                <div class="carousel-inner">
                                                    <cfloop array="#product.images#" index="index" item="image">
                                                        <div class="carousel-item <cfif index EQ 1> active</cfif>">
                                                            <img src="/uploads/#image.image#" alt="Product image" class="d-block w-100">
                                                        </div>
                                                    </cfloop>
                                                </div>
                                                <button class="carousel-control-prev" type="button" data-bs-target="#chr(35)#productpic#product.id#" data-bs-slide="prev">
                                                    <span class="carousel-control-prev-icon"></span>
                                                </button>
                                                <button class="carousel-control-next" type="button" data-bs-target="#chr(35)#productpic#product.id#" data-bs-slide="next">
                                                    <span class="carousel-control-next-icon"></span>
                                                </button>
                                            </div>
                                            <div class="col-5 d-flex flex-column gap-2">
                                                <div class="d-flex gap-2">
                                                    <p class="py-2 px-3">#product.name#</p>
                                                    <p class="py-2 px-3">#product.price#</p>
                                                    </div>
                                                <p class="py-2 px-3">#product.description#</p>
                                            </div>
                                        </div>
                                        <div class="col-3 d-flex flex-column gap-2">
                                            <div class="d-flex gap-2">
                                                <button class="btn btn-sm fw-bold btn-outline-success btn-block" data-bs-toggle="modal"
                                                    data-bs-target="#chr(35)#modal" data-bs-action="edit" data-bs-set="product"
                                                    data-bs-id="#product.id#">
                                                        <img src="/images/edit.png" width="30" height="30" class="img-fluid">
                                                </button>
                                                <button class="btn btn-sm fw-bold btn-outline-danger btn-block" data-bs-toggle="modal"
                                                    data-bs-target="#chr(35)#modal" data-bs-action="delete" data-bs-set="product" data-bs-id="#product.id#">
                                                        <img src="/images/delete.png" width="30" height="30" class="img-fluid">
                                                </button>
                                            </div>
                                        </div>
                                    </li>
                                    </cfloop>
                                </cfoutput>
                            </cfif>
                    </div>
                    <button id="addProduct" name="addProduct" class="card-footer btn btn-primary btn-block" data-bs-toggle="modal"
                        data-bs-target="#modal" data-bs-action="add" data-bs-set="product">
                        <img src="/images/add.png" width="30" height="30" class="img-fluid">
                    </button>
                </cfif>
            </div>
            <div class="modal fade" id="modal" tabindex="-1" role="dialog">
                <div class="modal-dialog">
                    <div class="modal-content d-flex p-3">
                        <div class="modal-header d-flex">
                            <h2 id="modalhead" class="modal-title flex-grow-1 fw-bold text-info text-center"></h2>
                            <button type="button" class="btn-close border rounded" data-bs-dismiss="modal"></button>
                        </div>
                        <form id="modalForm" name="modalForm" class="modal-body d-flex flex-column gap-1" action="" method="post" enctype="multipart/form-data">
                            <div class="categoryText form-floating">
                                <input type="text" name="categoryText" id="categoryText" class="form-control text-warning" placeholder="">
                                <label for="categoryText" class="form-label text-light">Category</label>
                            </div>
                            <div class="categorySelect form-floating">
                                <select id="categorySelect" name="categorySelect" class="form-select text-warning" placeholder="">
                                        <option value=""></option>
                                </select>
                                <label for="categorySelect" class="form-label">Category</label>
                            </div>
                            <div class="subcategoryText form-floating">
                                <input type="text" name="subcategoryText" id="subcategoryText" class="form-control text-warning" placeholder="">
                                <label for="subcategoryText" class="form-label text-light">Sub category</label>
                            </div>
                            <div class="subcategorySelect form-floating">
                                <select id="subcategorySelect" name="subcategorySelect" class="form-select text-warning" placeholder="">
                                        <option value=""> </option>
                                </select>
                                <label for="subcategorySelect" class="form-label">Subcategory</label>
                            </div>
                            <fieldset id="product" class="d-flex flex-column rounded border gap-2 p-3">
                                <legend class="text-primary">
                                    Product Details
                                    <hr class="border-5">
                                </legend>
                                <div class="form-floating">
                                    <input class="form-control text-warning" type="text" id="productName" name="productName" placeholder="">
                                    <label for="productName" class="form-label text-light">Product Name</label>
                                </div>
                                <div class="form-floating">
                                    <textarea class="form-control text-warning" id="productDesc" name="productDesc" placeholder=""></textarea>
                                    <label for="productDesc" class="form-label text-light">Product Description</label>
                                </div>
                                <div class="form-floating">
                                    <input class="form-control text-warning" type="text" id="price" name="price" placeholder="">
                                    <label for="price" class="form-label text-light">Price</label>
                                </div>
                                <div class="form-floating">
                                    <input class="form-control text-warning" type="number" id="tax" name="tax" min="0" max="100" placeholder="">
                                    <label for="tax" class="form-label text-light">Tax Rate(%)</label>
                                </div>
                                <div id="imageModify" class="d-flex flex-column form-floating">
                                    <div id="imageList" class="d-flex flex-wrap p-1 gap-1">
                                    </div>
                                    <button type="button" id="addImagebtn" class="btn btn-outline-primary fw-bold">Add Image</button>
                                    <div id="imageAdd" class="list-group p-1 gap-1"></div>
                                </div>
                            </fieldset>
                            <input type="hidden" name="recordId" id="recordId">
                            <input type="hidden" name="set" id="set">
                            <fieldset class="delete-mode d-flex flex-column rounded border gap-2 p-3">
				                <legend class="text-warning">Are you sure you want to delete this contact?</legend>
                            </fieldset>
                        </form>
                        <div class="modal-footer d-flex justify-content-between">
                            <button name="okbtn" id="okbtn" type="submit" class="btn btn-outline-success fw-bold" form="modalForm"></button>
                            <button name="dltbtn" id="dltbtn" type="submit" class="btn btn-outline-success fw-bold" form="modalForm">Yes</button>
                            <button type="button" class="btn btn-outline-danger fw-bold" data-bs-dismiss="modal">Cancel</button>
                        </div>
                    </div>
                </div>
            </div>
		</div>
		<script type="text/javascript" src="/js/jQuery.js"></script>
		<script type="text/javascript" src="/js/admin-home.js"></script>
		<script type="text/javascript" src="/js/bootstrap.min.js"></script>
	</body>
</html>