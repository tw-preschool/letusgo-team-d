# encoding: utf-8
require './models/product.rb'

Product.delete_all

items = []
items.push :name => '可口可乐', :unit => '瓶', :price => 3.00, :is_promotional => true
items.push :name => '雪碧', :unit => '瓶', :price => 3.00, :is_promotional => true
items.push :name => '苹果', :unit => '斤', :price => 5.50, :is_promotional => true
items.push :name => '荔枝', :unit => '斤', :price => 15.00, :is_promotional => true
items.push :name => '电池', :unit => '个', :price => 2.00, :is_promotional => false
items.push :name => '方便面', :unit => '袋', :price => 4.50, :is_promotional => true

items.each do |item|
  puts Product.create item
end
