$(document).ready(function () {
    var itemData;
    $.ajax({
        url: '/products',
        type: 'get',

        error: function() {
            alert('Failed to loading item list');
        },

        success: function (items) {
            itemData = items;
            displayItems(items);
            $(".item-edit").on("click", editItem);
            $(".item-delete").on("click", deleteItem);
        }
    });

  function displayItems (items) {
    $("[name='promotion-checkbox']").bootstrapSwitch('toggleReadonly');
    $("[name='promotion-checkbox']").bootstrapSwitch('onText', '买二送一');
    $("[name='promotion-checkbox']").bootstrapSwitch('offText', '无');
    $("[name='promotion-checkbox']").bootstrapSwitch('onColor', 'info');
  }

  function editItem(){
    $(this).parent().prev().find("input").bootstrapSwitch('toggleReadonly');

    var editRow = $(this).parent().siblings();
    for(var i=0;i<editRow.length-1;i++){
      tdclick($(editRow[i]));
    }
    var btnParent = $(this).parent();
    btnParent.append($('<button type="button" class="btn btn-success item-confirm">确定</button>'));
    btnParent.append($('<button type="button" class="btn btn-primary item-cancel">取消</button>'));
    btnParent.find(".item-edit").remove();
    btnParent.find(".item-delete").remove();

    $(".item-confirm").on("click", confirmItem);
    $(".item-cancel").on("click", cancelItem);

    $("body").keydown(function(e){
      if(e.keyCode==13)
        $(".item-confirm").click();
      });
  }

  function deleteItem(){
    if(confirm("确定删除吗?")){
      var itemLine = $(this).parent().parent();
      var name = $($(this).parent().siblings()[0]).text();

      var index = -1;
      for (var i in itemData) {
        if(name == itemData[i].name){
          index = i;
          break;
        }
      }

      itemLine.remove();

      $.ajax({
        type: "delete",
        url: "/products/"+itemData[index].id,
        dataType: "json",
        success:function (data) {
            alert("商品 "+name+" 删除成功!");
        }
      });
    }
  }

  function isUnsignedInteger(num){
    var reg = /^(0|([1-9]\d*))$/;
    return reg.test(num);
  }

  function confirmItem(){
    $(this).parent().prev().find("input").bootstrapSwitch('toggleReadonly');
    var isPromotional = $(this).parent().prev().find("input").bootstrapSwitch('state');
    var inputnode = $(this).parent().siblings().find("input");

    var index = -1;
    var name = $(inputnode[0]).val();
    var price = $(inputnode[1]).val();
    var unit = $(inputnode[2]).val();
    var quantity = $(inputnode[3]).val();
    var description = $(inputnode[4]).val();

    if(!isUnsignedInteger(quantity)){
      alert("商品数量应为非负整数");
    }else{
      for(var i = 0; i<inputnode.length-1; i++){
        var inputtext = $(inputnode[i]).val();
        var tdNode = $(inputnode[i]).parent();
        if(i != inputnode.length-2){
          tdNode.html(inputtext);
        }else{
          var pTag = $("<p></p>");
          tdNode.find("input").replaceWith(pTag);
          tdNode.find("p").html(inputtext);
        }
      }
      recoveryEditButton($(this).parent());
      for (var i in itemData) {
        if(name == itemData[i].name){
          index = i;
          break;
        }
      }
      updateProductAdmin(index,name,price,unit,quantity,description,isPromotional,itemData);
    }
  }

  function updateProductAdmin(index,name,price,unit,quantity,description,isPromotional,itemData){
      $.ajax({
      type: "post",
      url: "/products/update",
      data: {"id":itemData[index].id, "name":name, "price":price, "unit":unit,"quantity":quantity,"description":description, "is_promotional": isPromotional },
      dataType: "json",
      success:function (item) {
          alert("商品 "+item.name+" 信息已更新!");
      }
    });
  }

  function cancelItem(editRow){
    $(this).parent().prev().find("input").bootstrapSwitch('toggleReadonly');

    var inputnode = $(this).parent().siblings().find("input");
    for(var i = 0; i<inputnode.length-1; i++){
      var tdNode = $(inputnode[i]).parent();
      tdNode.html(tdNode[0].getAttribute("value"));
    }

    recoveryEditButton($(this).parent());
  }

  function recoveryEditButton(btnParent){
    btnParent.append($('<button type="button" class="btn btn-primary item-edit">修改</button>'));
    btnParent.append($('<button type="button" class="btn btn-primary item-delete">删除</button>'));
    btnParent.find(".item-confirm").remove();
    btnParent.find(".item-cancel").remove();

    btnParent.find(".item-edit").on("click", editItem);
    btnParent.find(".item-delete").on("click", deleteItem);
  }

  function tdclick(editRow){
    var td = editRow;
    var text = td.text();
    td.attr("value",text);
    td.html("");
    var input = $("<input>");
    input.attr("value",text);
    td.append(input);
  }
});
