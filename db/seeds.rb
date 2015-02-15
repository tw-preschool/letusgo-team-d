# encoding: utf-8
require './models/faq.rb'

Faq.delete_all
questions = []
questions.push :title => 'how to use the chat?', :content => 'to get loan more easily'
questions.push :title => 'where are the brokers come from?', :content => 'a very famous company'
questions.push :title => 'how to use the chat', :content => 'to get loan more easily'
questions.push :title => 'how to use the chat', :content => 'to get loan more easily'
questions.push :title => 'how to use the chat', :content => 'to get loan more easily'


questions.each do |question|
  puts Faq.create(question).to_json
end
