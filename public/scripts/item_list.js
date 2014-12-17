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
            displayDescriptions(items);
            shoppingCart.setAllItemList(items);
            $(".addCartButton").click(function() {
                itemName = $(this).parents("tr").find("td:first").html();
                shoppingCart.addItemByName(itemName);
                updateCountText();
            });
        }
    });
}

function displayDescriptions (items) {
    _(items).each(function (item) {
        $('#items-table p').readmore({
            speed: 75,
            maxHeight: 20
        });    
    });
}