function ShoppingCart() {
    if( ShoppingCart.unique !== undefined ){
        return ShoppingCart.unique;
    }
    ShoppingCart.unique = this;

    var allItemList = [];
    this.setAllItemList = function(list) {
        allItemList = list;
    };

    var itemListInStorage = window.sessionStorage.shoppingCart;
    var itemList = (itemListInStorage) ? JSON.parse(itemListInStorage) : [];
    addItemListToStorage();

    this.getItemList = function () { return itemList; };

    this.selectItem = function (item) {
        return this.selectItemByName(item.name);
    };

    this.selectItemByName = function (itemName) {
        for (var i in itemList){
            if (itemList[i].itemType.name === itemName)
                return itemList[i];
        }
        return null;
    };

    this.addItem = function (item, amount) {
        if(amount <= 0)
            return;
        var cartItem = this.selectItem(item);
        if (cartItem === null) {
            itemList.push({ "itemType": item, "amount": (amount || 1) });
        }
        else {
            cartItem.amount += amount || 1;
        }
        addItemListToStorage();
    };

    this.reduceItem = function (item, amount) {
        if(amount <= 0)
            return;
        var cartItem = this.selectItem(item);
        if (cartItem !== null) {
            if(cartItem.amount < (amount || 1)) {
                itemList.splice(itemList.indexOf(cartItem),1);
            }
            else {
                cartItem.amount -= amount || 1;
            }
        }
        addItemListToStorage();
    };

    this.updateItem = function (item, amount) {
        if(amount == null || amount < 0)
            return;
        var cartItem = this.selectItem(item);
        if (cartItem !== null) {
            if (cartItem.amount < amount)
              this.addItem(item, amount - cartItem.amount);
            else
              this.reduceItem(item, cartItem.amount - amount);
        }
        else {
            this.addItem(item, amount);
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
            }
        }
        return null;
    }
}
