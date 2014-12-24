$(document).ready(function () {
    // var cartList = JSON.parse(window.localStorage.shoppingCart);
    var shoppingCart = new ShoppingCart();

    _(shoppingCart.getItemList()).each(function (item) {
        var subtotal = item.itemType.price * item.amount;
        var listItem = $('<tr>\
                    <td>' + item.itemType.name + '</td>\
                    <td id="price">' + item.itemType.price + '</td>\
                    <td>' + item.itemType.unit + '</td>\
                    <td><button class="btn btn-default min">-</button>\
                        <input id="item-num" type="text" value="' + item.amount + '">\
                        <button class="btn btn-default add">+</button></td>\
                    <td id="subtotal">' + subtotal.toFixed(2) + '</td>\
                  </tr>');
        $('#cart-table').append(listItem);
    });

    $(".min").each(function(){
        selectedInput = $(this).next();
        if (parseInt(selectedInput.val()) <= 0)
          $(this).attr('disabled', true);
    });

    $(function () {
        setSummary();
        var selectedInput;

        $(".add").click(function(){
            selectedInput = $(this).prev();
            selectedInput.val(parseInt(selectedInput.val()) + 1);
            if (parseInt(selectedInput.val()) > 0){
                $(this).prev().prev().attr('disabled',false);
            }
            updateCart();
        });

        $(".min").click(function(){
            selectedInput = $(this).next();
            selectedInput.val(parseInt(selectedInput.val()) - 1);
            if (parseInt(selectedInput.val()) <= 0){
                $(this).attr('disabled',true);
            }
            updateCart();
        });

        $("#item-num").on("mouseleave", function(){
            selectedInput = $(this);
            if (selectedInput.val() <= 0){
                //$(this).attr('disabled',true);
                selectedInput.val(0);
            }
            updateCart();

        });

        $("#pay").click(function(){
            var postForm = document.createElement("form");
            postForm.action = '/pages/payment';
            postForm.method = 'post';
            postForm.enctype = 'multipart/form-data';
            // postForm.dataType = 'json';
            postForm.style.display = 'none';
            // postForm.dataset = window.localStorage.shoppingCart;
            var postText = document.createElement("textarea");
            postText.name = "cart_data";
            postText.value = window.localStorage.shoppingCart;
            postForm.appendChild(postText);
            document.body.appendChild(postForm);
            postForm.submit();
            return false;
        });

        function updateCart() {
            var amount = selectedInput.val();
            var item = shoppingCart.selectItemByName(selectedInput.parent().prev().prev().prev().html());
            shoppingCart.updateItem(item.itemType, amount);
            setSubtotal();
        }

        function setSubtotal() {
            var price = selectedInput.parent().prev().prev().html();
            selectedInput.parent().next().html((parseInt(selectedInput.val()) * price).toFixed(2));
            setSummary();
        }

        function setSummary() {
            var summary = 0;
            $("[id=subtotal]").each(function() {
                summary += parseFloat($(this).html());
            });
            $("#summary").text(summary.toFixed(2));
        }
    });

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
