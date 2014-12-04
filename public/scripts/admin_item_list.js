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
    _(items).each(function (item) {
        var listItem = $('<tr>\
                    <td>' + item.name + '</td>\
                    <td>' + item.price + '</td>\
                    <td>' + item.unit + '</td>\
                    <td>' + 'item.promotion' + '</td>\
                    <td><button type="button" class="btn btn-primary item-edit">修改</button><button type="button" class="btn btn-primary item-delete">删除</button></td>\
                  </tr>');
        $('#product-table-list').append(listItem);
    });
  }

  function editItem(){
    var editRow = $(this).parent().siblings();
    for(var i=0;i<editRow.length;i++){
      tdclick($(editRow[i]));
    }
    var btnParent = $(this).parent();
    btnParent.append($('<button type="button" class="btn btn-success item-confirm">确定</button>'));
    btnParent.append($('<button type="button" class="btn btn-warning item-cancel">取消</button>'));
    btnParent.find(".item-edit").remove();
    btnParent.find(".item-delete").remove();

    $(".item-confirm").on("click", confirmItem);
    $(".item-cancel").on("click", cancelItem);
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
        type: "post",
        url: "/products/delete",
        data: {"id":itemData[index].id},
        dataType: "json",
        success:
          alert("商品 "+name+"信息已删除!")
      });
    }
  }


  function confirmItem(){
    var inputnode = $(this).parent().siblings().find("input");
    for(var i = 0; i<inputnode.length; i++){
      var inputtext = $(inputnode[i]).val();
      var tdNode = $(inputnode[i]).parent();
      tdNode.html(inputtext);

    }

    var btnParent = $(this).parent();
    btnParent.append($('<button type="button" class="btn btn-primary item-edit">修改</button>'));
    btnParent.append($('<button type="button" class="btn btn-danger item-delete">删除</button>'));
    btnParent.find(".item-confirm").remove();
    btnParent.find(".item-cancel").remove();

    $(".item-edit").on("click", editItem);
    $(".item-delete").on("click", deleteItem);

    var index = -1;
    var name = $(inputnode[0]).val();
    var price = $(inputnode[1]).val();
    var unit = $(inputnode[2]).val();
    for (var i in itemData) {
      if(name == itemData[i].name){
        index = i;
        break;
      }
    }

    updateProductAdmin(index, name, price, unit, itemData);

  }

  function updateProductAdmin(index,name,price,unit,itemData){
    $.ajax({
      type: "post",
      url: "/products/update",
      data: {"id":itemData[index].id,"name":name, "price":price,"unit":unit},
      dataType: "json",
      success:
        alert("商品 "+name+"信息已更新!")
    });
  }

  function cancelItem(editRow){
    var inputnode = $(this).parent().siblings().find("input");
    for(var i = 0; i<inputnode.length; i++){
      var tdNode = $(inputnode[i]).parent();
      tdNode.html(tdNode[0].getAttribute("value"));
    }

      var btnParent = $(this).parent();
      btnParent.append($('<button type="button" class="btn btn-primary item-edit">修改</button>'));
      btnParent.append($('<button type="button" class="btn btn-danger item-delete">删除</button>'));
      btnParent.find(".item-confirm").remove();
      btnParent.find(".item-cancel").remove();

      $(".item-edit").on("click", editItem);
      $(".item-delete").on("click", deleteItem);

  }


  function tdclick(editRow){
    var td = editRow;
    var text = td.text();
    td.attr("value",text);
    td.html("");
    var input = $("<input>");
    input.attr("value",text);
    input.keyup(function(event){
      var myEvent = event || window.event;
      var kcode = myEvent.keyCode;
      if(kcode == 13){
        var inputnode = $(this);
        var inputtext = inputnode.val();
        var tdNode = inputnode.parent();
        tdNode.html(inputtext);
        tdNode.click(tdclick);
      }
    });
    td.append(input);
    var inputdom = input.get(0);
    inputdom.select();
    td.unbind("click");
  }

});
