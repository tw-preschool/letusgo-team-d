$(document).ready(function() {
    $('#registerForm').bootstrapValidator({
        feedbackIcons: {
            valid: 'glyphicon glyphicon-ok',
            invalid: 'glyphicon glyphicon-remove',
            validating: 'glyphicon glyphicon-refresh'
        },
        fields: {
          login_name: {
              validators: {
                  emailAddress: {
                      message: '请输入正确的email'
                  }
              }
          },
          password: {
            validators: {
                stringLength: {
                    min:6,
                    message: '长度不得小于6个字符'
                }
            }
          },
          name: {
                validators: {
                    regexp: {
                        regexp: /[\u4e00-\u9fa5a-zA-Z]+$/,
                        message: '姓名中不可包含数字或下划线或特殊字符'
                    }
                }
          },
          telephone: {
              validators:{
                  stringLength: {
                    min:8,
                    max:11,
                    message: '请输入8～11位正确电话号码'
                  },
                  regexp: {
                    regexp: /^[0-9]+$/
                  }
              }
          }
        },
        submitHandler: function(validator, form, submitButton) {

        }
    });
});
