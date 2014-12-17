# encoding: utf-8
require './models/product.rb'
require './models/user.rb'

Product.delete_all
User.delete_all

items = []
users = []
items.push :name => '可口可乐', :unit => '瓶', :price => 3.00, :is_promotional => true, :quantity => 30, :description => "美国可口可乐公司"
items.push :name => '雪碧', :unit => '瓶', :price => 3.00, :is_promotional => true, :quantity => 0, :description => "美国可口可乐公司"
items.push :name => '苹果', :unit => '斤', :price => 5.50
items.push :name => '荔枝', :unit => '斤', :price => 15.00, :is_promotional => true, :quantity => 7, :description => "一种营养价值很高的水果"
items.push :name => '电池', :unit => '个', :price => 2.00, :is_promotional => false, :quantity => 3, :description => "一节更比六节强"
items.push :name => '方便面', :unit => '袋', :price => 4.50, :is_promotional => true, :quantity => 7, :description => "好劲道"

items.each do |item|
  puts Product.create(item).to_json
end

users.push :username => '1025922576@qq.com', :password => '891126', :name => 'zhaomengru', :address =>'xian', :telephone => '13474537486'

users.each do |user|
  puts User.create(user).to_json
end
