$(document).ready(function () {
  $.ajax({
    url: 'pages/payment',
    type: 'post',
    dataType: "json",
    data: window.sessionStorage.shoppingCart,
    error: function() {
      console.log('Failed to loading item list');
    },

    success: function (data) {

    }
  });
});
