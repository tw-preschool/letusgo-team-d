$(document).ready(function () {
	$('#submit').click(function(){
		var name = $('#item-name').val();
		var price = $('#item-price').val();
		var unit = $('#item-unit').val();
        $.ajax({
	         type: "POST",
	         url: "/products",
	         data: {"name":name,"price":price,"unit":unit},
	         dataType: "json",
	         success: function(data){
	                     
	                  }
        });
	});
});
