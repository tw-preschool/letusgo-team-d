$(document).ready(function () {
	var itemsData;
	$.ajax({
	        url: '/products',
	        type: 'get',
	        timeout: 1000,
	        success: function (items) {
	            itemsData = items;
	        }
	 });

	function isUnsignedInteger(num){
		var reg = /^(0|([1-9]\d*))$/;
		return reg.test(num);
	}

	$('#submit').click(function(){
		var name = $('#item-name').val();
		var price = $('#item-price').val();
		var unit = $('#item-unit').val();
		var quantity = $('#item-quantity').val() || 0;
		var description = $('#item-description').val();

		if(!isUnsignedInteger(quantity)){
			alert("商品数量应为非负整数");
			return;
		}else{
			var item = hasOwnProduct(name,itemsData);
			if (item >= 0) {
				updateProduct(item,price,unit,quantity,description,itemsData);
			} else {
				addProduct(name,price,unit,quantity,description);
			}
		}
	});
});

function addProduct(name,price,unit,quantity,description){
	$.ajax({
		type: "post",
		url: "/products",
		data: {"name":name,"price":price,"unit":unit,"quantity":quantity,"description":description},
		dataType: "json",
		success: function (item) {
			alert("商品 "+name+" 添加成功!");
			window.location.reload();
		},
		error: function (response) {
			alert(JSON.stringify(response));
		}
	});
}


function hasOwnProduct(name,items){
	for (var item in items) {
		if(name == items[item].name){
			return item;
		}
	}
	return -1;
}


function updateProduct(item,price,unit,quantity,description,items){
	$.ajax({
		type: "post",
		url: "/products/update",
		data: {"id":items[item].id,"price":price,"name":items[item].name,"unit":unit,"quantity":quantity,"description":description},
		dataType: "json",
		success:function (data) {
			alert("商品 "+
				items[item].name+"已存过\n"+
				"原信息：\n"+
				"单价： "+items[item].price+
				"，单位："+items[item].unit+
				"，数量："+items[item].quantity+
				"，描述信息："+items[item].description+
				"\n更新为:\n"+name+
				"单价： "+price+"，单位："+unit+"，数量："+quantity+"，描述信息："+description
			);
			window.location.reload();
		}
	});
}
