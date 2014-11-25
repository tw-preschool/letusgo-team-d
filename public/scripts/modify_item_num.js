function add_count(){
  var num=parseInt($("#item-num").val());
  document.getElementById("item-num").setAttribute("value",num+1);
}
function min_count(){
  var num=parseInt($("#item-num").val());
  if(num>1)
    document.getElementById("item-num").setAttribute("value",num-1);
}
