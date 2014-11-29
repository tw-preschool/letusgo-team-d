function ShoppingCart() {
    if( ShoppingCart.unique !== undefined ){
        return ShoppingCart.unique; 
    }
    ShoppingCart.unique = this;

    var allItemList = [];
    this.setAllItemList = function(list) {
        allItemList = list;
    }

    var itemListInStorage = window.sessionStorage.shoppingCart;
    var itemList = (itemListInStorage) ? JSON.parse(itemListInStorage) : [];
    addItemListToStorage();

    this.selectItem = function (item) {
        for (var i in itemList){
            if (itemList[i].itemType.name === item.name)
                return itemList[i];
        }
        return null;
    };

    this.addItem = function (item, amount) {
        var cartItem = this.selectItem(item);
        if (cartItem == null) {
            itemList.push({ "itemType": item, "amount": (amount || 1) });
        }
        else {
            cartItem.amount += amount || 1;
        }
        addItemListToStorage();
    };

    this.addItemByName = function (itemName, amount) {
        this.addItem(getItemFrom(itemName), amount);
    };

    this.getTotalNumber = function (argument) {
        return itemList.length;
    };

    this.getItemList = function () {
        return itemList;
    };

    function addItemListToStorage() {
        window.sessionStorage.shoppingCart = JSON.stringify(itemList);
    }

    function getItemFrom(itemName) {
        var items = allItemList;
        for (var i = 0; i < items.length; i++) {
            if (items[i].name == itemName) {
                return items[i];
            };
        };
        return null;
    }
}