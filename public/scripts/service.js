function loadAllItems() {
    var itemList;
    $.ajax({
        url: '/products',
        type: 'get',

        error: function() {
            console.log('Failed to loading item list');
        },

        success: function (items) {
            itemList = items;
        }
    });
    return itemList;
}
