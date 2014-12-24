$(document).ready(function () {
    updataShoppingCart();
    updateCountText();
});

var shoppingCart = new ShoppingCart();

function updateCountText () {
    $("#count").text(shoppingCart.getTotalNumber());
}

function updataShoppingCart () {
    $.ajax({
        url: '/cart_data',
        type: 'get',
        dataType: "text",

        error: function(error) {
            console.log(error);
        },

        success: function(cart_data) {
            window.localStorage.shoppingCart = cart_data;
        }
    });
}
