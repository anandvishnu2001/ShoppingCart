function adjustNavbarPositions() {
    const mainNavHeight = $('#main-nav').innerHeight();
    $('#category-nav').css('top', mainNavHeight + 'px');
}

function changeQuantity(id,change) {
    $.ajax({
        url: '/components/control.cfc?method=editCart',
        type: 'GET',
        data: {
            "cart": id,
            "quantity": change
        },
        success: function(data){
            location.reload();
        }
    });
}

function removeCartProduct(id) {
    $.ajax({
        url: '/components/control.cfc?method=deleteCart',
        type: 'GET',
        data: {
            "cart": id
        },
        success: function(data){
            location.reload();
        }
    });
}

var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
  return new bootstrap.Tooltip(tooltipTriggerEl)
});

function removeCart(id) {
    $.ajax({
        url: '/components/control.cfc?method=deleteCart',
        type: 'GET',
        data: {
            "user": id
        },
        success: function(data){
            location.reload();
        }
    });
}

$(document).ready(adjustNavbarPositions);
$(window).resize(adjustNavbarPositions);

$(document).ready(function () {
    $("#address-card").hide();

    $("#order-card").hide();
    
    $('#paymentbtn').prop('disabled', true);

    $('input[type="radio"][name="address"]').change(function() {
        if ($('input[type="radio"][name="address"]:checked').length > 0) {
            $('#paymentbtn').prop('disabled', false);
        }
        else {
            $('#paymentbtn').prop('disabled', true);
        }
    });

    const url = new URLSearchParams(window.location.search);
    if(url.has('keyword'))
        $('#order-card').show();

    $("#account-btn").click(function () {
        $("#address-card").hide();
        $("#order-card").hide();
    });

    $("#order-btn").click(function () {
        $("#address-card").hide();
        $("#order-card").show();
    });

    $("#address-btn").click(function () {
        $("#order-card").hide();
        $("#address-card").show();
    });

    $('#modal').on('hidden.bs.modal',function(event){
        $('#addressForm').find('input').removeAttr('required').val();
        $('#addressForm')[0].reset();
        $('#shippingId').val('');
        $('#idType').val('');
        $('#shippingAddress').val('');
    });

    $('#modal').on('show.bs.modal',function(event){
        let button = $(event.relatedTarget);
        if(!$('#pay-mode').hasClass("d-none"))
          $('#pay-mode').addClass("d-none");
        if(!$('#paybtn').hasClass("d-none"))
          $('#paybtn').addClass("d-none");
        if(!$('#modify-mode').hasClass("d-none"))
          $('#modify-mode').addClass("d-none");
        if(!$('#okbtn').hasClass("d-none"))
          $('#okbtn').addClass("d-none");
        if(!$('.delete-mode').hasClass("d-none"))
          $('.delete-mode').addClass("d-none");
        if(!$('#dltbtn').hasClass("d-none"))
          $('#dltbtn').addClass("d-none");
        if(button.data("bs-action") !== "add") {
            $('#shippingId').val(button.data("bs-id"));
            if(button.data("bs-action") === "delete") {
                $('.delete-mode').removeClass("d-none");
                $('#dltbtn').removeClass("d-none");
            }
            else if(button.data("bs-action") === "edit") {
                $('#modify-mode').removeClass("d-none").find('input').attr('required', 'true');
                $('#okbtn').html('Update');
                $('#okbtn').removeClass("d-none");
                $.ajax({
                    url: '/components/control.cfc?method=getShipping',
                    type: 'GET',
                    data:  {
                        'id' : button.data("bs-id")
                    },
                    success: function(data){
                        let address = JSON.parse(data);
                        $('#name').val(address[0].name);
                        $('#phone').val(address[0].phone);
                        $('#house').val(address[0].house);
                        $('#street').val(address[0].street);
                        $('#city').val(address[0].city);
                        $('#state').val(address[0].state);
                        $('#country').val(address[0].country);
                        $('#pincode').val(address[0].pincode);
                    }
                });
            }
            else if(button.data("bs-action") === "pay") {
                $('#pay-mode').removeClass("d-none").find('input').attr('required', 'true');
                $('#paybtn').removeClass("d-none");
                $('#idType').val(button.data("bs-idtype"));
                $('#shippingAddress').val($('input[type="radio"][name="address"]:checked').val());
            }
        }
        else {
            $('#modify-mode').removeClass("d-none").find('input').attr('required', 'true');
            $('#okbtn').html('Save');
            $('#okbtn').removeClass("d-none");
        }
    });
});