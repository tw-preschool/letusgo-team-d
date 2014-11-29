$(document).ready(function () {
    updateCountText();
});

var shoppingCart = new ShoppingCart();

function updateCountText () {
    $("#count").text(shoppingCart.getTotalNumber());
}