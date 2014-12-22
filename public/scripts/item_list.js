$(document).ready(function () {
    loadItems();

    $(window).bind('beforeunload',function(){
        $(window).bind('beforeunload',function(){
            $.ajax({
                url: '/update/cart_data',
                type: 'post',
                data: { cart_data: window.localStorage.shoppingCart },
                dataType: 'text',

                error: function() {
                    console.log('与后台购物车数据同步失败');
                },

                success: function (items) {}
            });
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
			                 distance: 5,
                       times: 1,
                       speed: 100
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
