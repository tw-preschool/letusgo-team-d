# encoding: utf-8

require_relative '../spec_helper'


describe 'User Pages', :type => :feature do

  before :each do
    Product.create(name: "Apple", price: 2.5, unit: "斤", quantity: 2, description:"红富士")
    Product.create(name: "雪碧", price: 3.5, unit: "瓶", quantity: 20)
  end

  describe "Index page" do
    it "should display correct content at index page" do
      visit '/'
      expect(page).to have_content("Welcome to Let's Go")
    end
  end

  describe "Item list page", :js => true do
    it "should show item list when enter items.html" do
      visit '/pages/items'

      expect(page).to have_content("名称")
      expect(page).to have_content("Apple")
      expect(page).to have_content("2.5")
      expect(page).to have_content("斤")
      expect(page).to have_content("红富士")
    end
  end

  describe "Shopping cart page", :js => true do
    it "should be empty when just entered website" do
      visit '/pages/cart'
      
      expect(page.find('tbody').text).to eq("")
      expect(page).to have_content('总计：0.00元')
    end

    it "should get an item in shopping_cart when add items" do
      visit '/pages/items'
      page.find(:xpath, '//button[../../td[contains(.,"Apple")]]').click
      1.upto(3) { page.find(:xpath, '//button[../../td[contains(.,"雪碧")]]').click }
      visit '/pages/cart'
      expect(page).to have_selector(:xpath, '//td[../td[contains(.,"Apple")]][contains(.,"2.50")]')
      expect(page).to have_selector(:xpath, '//td[../td[contains(.,"雪碧")]][contains(.,"10.50")]')
    end
  end
  
end