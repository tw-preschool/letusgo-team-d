# encoding: utf-8
require_relative '../spec_helper'

describe "register page", :type =>:feature do

  before :each do
    User.create(username:"ww@163.com",name:"wen",password:"123456",password_comfirmation:"123456",address:"xd",telephone:"15102955665")
  end

  context "register", :js => true do
    it "success when input correctly",focus: true do
      visit '/user/register'

      fill_in 'register-username', :with => 'd@outlook.com'
      fill_in 'register-password', :with => '111222'
      fill_in 'register-confirmPassword', :with => '111222'
      fill_in 'register-name', :with => 'd'
      fill_in 'register-address', :with => '西电'
      fill_in 'register-telephone', :with => '15155555555'
      click_button 'loginSubmit'
      sleep 1
      expect(page).to have_content("注册成功")
      fill_in 'login-name', :with => "d@outlook.com"
      fill_in 'login-password', :with => "111222"
      select "普通用户", :from => "select"
      click_button 'login-button'
      added_item = User.last
      expect(added_item.username).to eq 'd@outlook.com'
      expect(added_item.name).to eq 'd'
      expect(added_item.address).to eq '西电'
      expect(added_item.telephone).to eq '15155555555'

    end
  end
  context "should raise error", :js => true do
    it " when input a wrong email",focus: false do
      visit '/user/register'
      fill_in 'register-username', :with => 'd.com'
      expect(page).to have_content("请输入正确的email")
    end
    it "when input a wrong password",focus: false do
      visit '/user/register'
      fill_in 'register-password', :with => '111'
      expect(page).to have_content("长度不得小于6个字符")
    end
    it "when password and confirmPassword are different",focus: false do
      visit '/user/register'
      fill_in 'register-password', :with => '111222'
      fill_in 'register-confirmPassword', :with => '111111'
      expect(page).to have_content("两次密码应一致")
    end
    it "when input a wrong name",focus: false do
      visit '/user/register'
      fill_in 'register-name', :with => '#'
      expect(page).to have_content("姓名中不可包含数字或下划线或特殊字符")
    end
    it "when input a wrong telephone number",focus: false do
      visit '/user/register'
      fill_in 'register-telephone', :with => '185467'
      expect(page).to have_content("请输入8～11位正确电话号码")
    end

  end

end
