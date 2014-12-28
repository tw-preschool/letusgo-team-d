# encoding: utf-8

require_relative '../spec_helper'

describe 'User Order List', :type => :feature, :js => true do

    before :each do
       User.destroy_all
       User.create(username:"2901222852@qq.com",password:"123456")
       visit '/login'

       fill_in 'login-name', :with => "2901222852@qq.com"
       fill_in 'login-password', :with => "123456"
       select "普通用户", :from => "select"
       click_button 'login-button'
    end

    it "should see '您还没有购买任何商品哦!' when user's order is empty" do
      visit '/user/orders'

      expect(page).to have_content("您还没有购买任何商品哦！")
    end


    it "should see the order when user's order is not empty" do
  
       Product.destroy_all
       Product.create(name: "香蕉", price: 2.5, unit: "斤", quantity: 2, description:"贱卖了贱卖了")
       Product.create(name: "雪碧", price: 3.5, unit: "瓶", quantity: 20)

      visit '/pages/items'
      click_button 'addToCart_2'

      visit '/views/cart.html'
      expect(page).to have_content("雪碧")
      click_button 'pay'
      expect(page).to have_content("付款")
      click_button 'pay'

      page.find(:xpath,"//a[contains(@href,'#')]").click
      page.find(:xpath,"//a[contains(@href,'/user/orders')]").click

      expect(page).to have_content ("查看详细信息")

      order =Order.find_by_id(1)
      page.find(:xpath,"//a[contains(@href,'/order/#{order.number}')]").click

      expect(page).to have_content("雪碧")
      expect(page).to have_content("3.5")
      expect(page).to have_content("瓶")
      expect(page).to have_content("购物清单")
      expect(page).to have_content("订单详细信息")

    end
end
