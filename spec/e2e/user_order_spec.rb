# encoding: utf-8

require_relative '../spec_helper'

describe 'User Order List', :type => :feature, :js => true do

    before :each do
       User.destroy_all
       User.create(username:"zhaomengru@yahoo.com",password:"123456")
       visit '/login'

       fill_in 'login-name', :with => "zhaomengru@yahoo.com"
       fill_in 'login-password', :with => "123456"
       select "普通用户", :from => "select"
       click_button 'login-button'
    end

    it "should see '您还没有购买任何商品哦!' when user's order is empty" do
      visit '/user/orders'

      expect(page).to have_content("您还没有购买任何商品哦！")
    end


    it "should see the order when user's order is not empty" do
      #create the order for the current user
      page.set_rack_session username: "zhaomengru@yahoo.com"
      Order.destroy_all
      username = page.get_rack_session_key('username')
      id = User.find_by_username(username).id
      Order.create(id: 1, user_id: id, number: "14193952032", sum: 3.0, discount: 0.0, time: "2014-12-24 04:26:43")
      #return to the index page,click the "我的订单" button
      visit '/'

      page.find(:xpath,"//a[contains(@href,'#')]").click
      page.find(:xpath,"//a[contains(@href,'/user/orders')]").click

      expect(page).to have_content("14193952032")

    end
end
