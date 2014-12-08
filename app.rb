#encoding=UTF-8

require 'sinatra'
require 'sinatra/base'
require 'rack-flash'
require 'sinatra/contrib'
require 'sinatra/reloader'
require 'rack/contrib'
require 'active_record'

require 'json'

require './models/product'
require './models/shopping_cart'

class POSApplication < Sinatra::Base
    dbconfig = YAML.load(File.open("config/database.yml").read)

    configure do
        use Rack::Session::Pool, exprie_after: 60 * 60 * 24
        use Rack::Flash, :sweep => true
        helpers Sinatra::ContentFor
    end

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

    get '/admin' do
      if session[:username] == "admin"
        content_type:html
        erb :'pages/admin'
      else
        flash[:warning] = "Session失效，请先登录再进行操作！"
        redirect '/login'
      end
    end

    post '/login' do
      if params['username'] == "admin" and params["pwd"] == "admin"
        session[:username] = "admin"
        flash[:success] = "登录成功！"
        redirect "/admin"
      else
        flash[:error] = "用户名/密码错误，请重试！"
        redirect '/login'
      end
    end

    get '/add' do
        content_type :html
        erb :'pages/add'
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

    post '/products/update' do
        product = Product.find(params[:id])
        product.update_attributes(
            :name => params[:name],
            :price => params[:price],
            :unit => params[:unit],
            :description => params[:description],
            :is_promotional => params[:is_promotional]
        )

        if product.save
            [201, {:message => "products/#{product.id}"}.to_json]
        else
            halt 500, {:message => "create product failed"}.to_json
        end
    end

    post '/products' do
        product = Product.create(:name => params[:name],
                            :price => params[:price],
                            :unit => params[:unit],
                            :description => params[:description])

        if product.save
            [201, {:message => "products/#{product.id}"}.to_json]
        else
            halt 500, {:message => "create product failed"}.to_json
        end
    end

    post '/products/delete' do
        product = Product.find(params[:id])
        product.delete
    end

    post '/pages/payment' do
        cart_data = JSON.parse params[:cart_data]
        @shopping_cart = ShoppingCart.new()
        @shopping_cart.init_with_Data cart_data
        @shopping_cart.update_price
        
        content_type :html
        erb :'/pages/payment'
    end

    get %r{/?[(views)(pages)]/([^/\.]+)[/.html]?} do |page|
        content_type :html
        erb "pages/#{page}".to_sym
    end

    after do
        ActiveRecord::Base.connection.close
    end
end
