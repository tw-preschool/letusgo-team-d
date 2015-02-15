#encoding=UTF-8
require 'rubygems'
require 'sinatra'
require 'sinatra/base'
require 'sinatra/contrib'
require 'active_record'
require 'sinatra/jsonp'

require './models/faq'
class FaqApplication < Sinatra::Base
    dbconfig = YAML.load(File.open("config/database.yml").read)
    register Sinatra::Contrib
    helpers Sinatra::Jsonp


    configure :development do
        require 'sqlite3'
        ActiveRecord::Base.establish_connection(dbconfig['development'])
    end

    configure :test do
        require 'sqlite3'
        ActiveRecord::Base.establish_connection(dbconfig['test'])
    end


    before do
        content_type :json
    end

    get '/' do
        content_type :html
        erb :index
    end

    get '/faqs' do
      begin
            faqs = Faq.all || []
            JSONP faqs,'functionA'
        rescue ActiveRecord::RecordNotFound => e
            [404, {:message => e.message}.to_json]
        end
    end

    after do
        ActiveRecord::Base.connection.close
    end
end
