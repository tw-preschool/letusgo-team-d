$(document).ready(function () {
    var cartList = JSON.parse(window.sessionStorage.shoppingCart);

    _(cartList).each(function (item) {
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

    $(function () {
        setSummary();
        var selectedInput;

        $(".add").click(function(){
            selectedInput = $(this).prev();
            selectedInput.val(parseInt(selectedInput.val()) + 1)
            if (parseInt(selectedInput.val()) != 1){
                $(this).prev().prev().attr('disabled',false);
            }
            setSubtotal();
        }) 
        
        $(".min").click(function(){
            selectedInput = $(this).next();
            if (parseInt(selectedInput.val()) == 1){
                $(this).attr('disabled',true);
            }
            else {
                selectedInput.val(parseInt(selectedInput.val()) - 1);
            }
            setSubtotal();
        })

        function setSubtotal() {
            var price = selectedInput.parent().prev().prev().html();
            selectedInput.parent().next().html((parseInt(selectedInput.val()) * price).toFixed(2));
            setSummary();
        }

        function setSummary() {
            var summary = 0;
            $("[id=subtotal]").each(function() {
                summary += parseFloat($(this).html());
            })
            $("#summary").text(summary.toFixed(2));
        }
    })
});

