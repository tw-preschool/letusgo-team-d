$(document).ready(function () {
    loadItems();
});

function loadItems() {
    $.ajax({
        url: '/products',
        type: 'get',

        error: function() {
            console.log('Failed to loading item list');
        },

        success: function (items) {
            shoppingCart.setAllItemList(items);
            $(".addCartButton").click(function() {
                itemName = $(this).parents("tr").find("td:first").html();
                shoppingCart.addItemByName(itemName);
                updateCountText();
            });
        }
    });
}
