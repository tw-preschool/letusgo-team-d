$(document).ready(function () {
    loadItems();

    $(window).bind('beforeunload',function(){
        console.log('开始与后台同步购物车数据');
        $.ajax({
            url: '/update/cart_data',
            type: 'post',
            data: { cart_data: window.localStorage.shoppingCart },
            dataType: 'text',

            error: function() {
                console.log('Failed to loading item list');
            },

            success: function (items) {
                itemList = items;
            }
        });
    });
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
                $("#cart").shake({
			                 direction: "up",
			                 distance: 10,
                       times: 1
		            });
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
