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
            displayItems(items);
            shoppingCart.setAllItemList(items);
            $(".addCartButton").click(function() {
                itemName = $(this).parent().prev().prev().prev().html();
                shoppingCart.addItemByName(itemName);
                updateCountText();
            });
        }
    });
}

function displayItems (items) {
    _(items).each(function (item) {
        var description = (item.description) ? item.description : '';
        var listItem = $('<tr>\
                    <td>' + item.name + '</td>\
                    <td>' + item.price + '</td>\
                    <td>' + item.unit + '</td>\
                    <td>' + description + '</td>\
                    <td> <button type="button" class="btn btn-primary addCartButton">加入购物车</button></td>\
                  </tr>');
        $('#items-table').append(listItem);
    });
}
