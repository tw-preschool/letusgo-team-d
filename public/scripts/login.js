$(document).ready(function () {
  $('#loginSubmit').click(function(){

    var username = $('#username').val();
    var password = $('#password').val();

    alert(username+password);
    $.ajax({
	         type: "POST",
	         url: "/login",
	         data: {"username":username,"password":password},
	         dataType: "json",

           success: function () {
               
           }
        });
  });
});
