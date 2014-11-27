$(document).ready(function () {
	$('#submit').click(function(){
		var name = $('#item-name').val();
		var price = $('#item-price').val();
		var unit = $('#item-unit').val();

		$.ajax({
				url: '/products',
				type: 'get',

				error: function() {
						console.log('Failed to loading item list');
				},

				success: function (items) {
						if(hasOwnProduct(name,price,items)){
						
						}else{
									$.ajax({
										type: "post",
										url: "/products",
										data: {"name":name,"price":price,"unit":unit},
										dataType: "json",
										success:alert("添加商品"+name+"成功")
									});
						}
				}
		});
	});
});


function hasOwnProduct(name,price,items){
	for (var item in items) {
			if(name == items[item].name){
				$.ajax({
					type: "post",
					url: "/products/update",
					data: {"id":items[item].id,"price":price},
					dataType: "json",
					success:
									alert(
									items[item].name+
									"，单价： "+items[item].price+
									"，单位："+items[item].unit+
									"\n更新为:\n"+name+
									"，单价： "+price+"，单位：")
				});
			return true;
		}
	}
	return false;
}
