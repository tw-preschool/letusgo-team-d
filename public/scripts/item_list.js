$(document).ready(function () {
    loadAllItems();
});

function loadAllItems() {
    $.ajax({
        url: '/products',
        type: 'get',
        timeout: 1000,

        error: function() {
            console.log('Failed to loading item list');
        },

        success: function (items) {
            displayItems(items);
        }
    });
}

function displayItems (items) {
    _(items).each(function (item) {
        var listItem = $('<tr>\
                    <td>' + item.name + '</td>\
                    <td>' + item.price + '</td>\
                    <td>' + item.unit + '</td>\
                  </tr>');
        $('#item-table').append(listItem);
    });
}
