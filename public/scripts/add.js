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

	$('#submit').click(function(){
		var name = $('#item-name').val();
		var price = $('#item-price').val();
		var unit = $('#item-unit').val();

		var item = hasOwnProduct(name,itemsData);
		if (item >= 0) {
			updateProduct(item,price,unit,itemsData);
		} else {
			addProduct(name,price,unit);
		}
	});
});

function addProduct(name,price,unit){
	$.ajax({
		type: "post",
		url: "/products",
		data: {"name":name,"price":price,"unit":unit},
		dataType: "json",
		success:alert("添加商品"+name+"成功")
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


function updateProduct(item,price,unit,items){
	$.ajax({
		type: "post",
		url: "/products/update",
		data: {"id":items[item].id,"price":price,"unit":unit},
		dataType: "json",
		success:
			alert("商品 "+
			items[item].name+"已存过\n"+
			"原信息：\n"+
			"单价： "+items[item].price+
			"，单位："+items[item].unit+
			"\n更新为:\n"+name+
			"单价： "+price+"，单位："+unit)
	});
}
