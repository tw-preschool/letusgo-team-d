$(document).ready(function() {
    $('#register').remove();
    $('#registerForm').bootstrapValidator({
        feedbackIcons: {
            valid: 'glyphicon glyphicon-ok',
            invalid: 'glyphicon glyphicon-remove',
            validating: 'glyphicon glyphicon-refresh'
        },
        fields: {
          username: {
              validators: {
                  notEmpty:{
                      message: 'email不能为空'
                  },
                  emailAddress: {
                      message: '请输入正确的email'
                  }
              }
          },
          password: {
            validators: {
                notEmpty:{
                    message: '密码不能为空'
                },
                stringLength: {
                    min:6,
                    message: '长度不得小于6个字符'
                },
                identical: {
                  field: 'confirmPassword',
                  message: '两次密码应一致'
                }
            }
          },
          confirmPassword: {
            validators: {
                notEmpty:{
                    message: '密码不能为空'
                },
                stringLength: {
                    min:6,
                    message: '长度不得小于6个字符'
                },
                identical: {
                  field: 'password',
                  message: '两次密码应一致'
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
