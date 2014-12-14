$("#pay").click(function(){
    var postForm = document.createElement("form");
    postForm.action = '/pay';
    postForm.method = 'post';
    postForm.enctype = 'multipart/form-data';
    postForm.style.display = 'none';
    var postText = document.createElement("textarea");
    postText.name = "cart_data";
    postText.value = window.sessionStorage.shoppingCart;
    postForm.appendChild(postText);
    document.body.appendChild(postForm);
    postForm.submit();
    return false;
});