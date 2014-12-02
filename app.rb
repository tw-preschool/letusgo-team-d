require 'sinatra'
require "sinatra/contrib"
require 'rack/contrib'
require 'active_record'
require 'json'

require './models/product'

class POSApplication < Sinatra::Base
    enable :sessions
    helpers Sinatra::ContentFor
    dbconfig = YAML.load(File.open("config/database.yml").read)

    configure :development do
        require 'sqlite3'
        ActiveRecord::Base.establish_connection(dbconfig['development'])
    end

    configure :test do
        require 'sqlite3'
        ActiveRecord::Base.establish_connection(dbconfig['test'])
    end

    use Rack::PostBodyContentTypeParser

    before do
        content_type :json
    end

    get '/' do
        content_type :html
        erb :index
    end

    get '/login' do
        content_type:html
        erb :login
    end

    post '/login' do
      if params[:username]='admin' and params[:password]='admin'
        session['username']=params[:username]
      else
        redirect '/index'
      end
    end

    get '/add' do
        content_type :html
        erb :add
    end

    get %r{views/([^/\.]+)[\.html]?} do |page|
        content_type :html
        erb page.to_sym
    end


    get '/products' do
        begin
            products = Product.all || []
            products.to_json
        rescue ActiveRecord::RecordNotFound => e
            [404, {:message => e.message}.to_json]
        end
    end

    get '/products/:id' do
        begin
            product = Product.find(params[:id])
            product.to_json
        rescue  ActiveRecord::RecordNotFound => e
            [404, {:message => e.message}.to_json]
        end
    end

    get '/*' do
        content_type :html
        erb :index
    end

    post '/products/update' do
        product = Product.find(params[:id])
        product.update_attributes(:price => params[:price],
                                  :unit => params[:unit])

        if product.save
            [201, {:message => "products/#{product.id}"}.to_json]
        else
            halt 500, {:message => "create product failed"}.to_json
        end
    end

    post '/products' do
        product = Product.create(:name => params[:name],
                            :price => params[:price],
                            :unit => params[:unit])

        if product.save!
            puts Product.last.name
            [201, {:message => "products/#{product.id}"}.to_json]
        else
            halt 500, {:message => "create product failed"}.to_json
        end
    end

    after do
        ActiveRecord::Base.connection.close
    end
end
