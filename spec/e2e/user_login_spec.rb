# encoding: utf-8
require_relative '../spec_helper'
describe "login page", :type =>:feature do

  before :each do
    User.create(username:"ww@163.com",name:"wen",password:"123456",password_comfirmation:"123456",address:"xd",telephone:"15102955665")
  end
  context "in login page" do
    it "should be login success when the user existed in the database" do
      visit '/login'
      fill_in 'login-name', :with => "ww@163.com"
      fill_in 'login-password', :with => "123456"
      select "普通用户", :from => "select"
      click_button 'login-button'
    #  expect(page).to have_content("ww@163.com")
      #added_item = User.last
      #expect(added_item.username).to eq 'ww@163.com'
      #page.find(:xpath, '//div[@class="alert alert-danger"]')
      #expect(page).to have_content("管理员用户名")
    #  sleep 2
    #  visit '/'
    #  flash[:success].should == '登录成功'
    end

    it "should be login success when admin users" do
      visit '/login'
      fill_in 'login-name', :with => "admin"
      fill_in 'login-password', :with => "admin"
      select "管理员", :from => "select"
      click_button 'login-button'

      sleep 2
      #expect(page).to have_content("登录成功")
    end
  end
end
