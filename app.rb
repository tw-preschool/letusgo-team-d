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
require './models/order'
require './models/cart_item'

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
        if session[:username] == "admin"
            redirect '/admin/orders'
        else
            content_type :html
            erb :login
        end
    end

    # We should use POST way to make user logout if there's more demands.
    get '/admin_logout' do
      if session[:username] == "admin"
        flash[:success] = "Admin登出成功！"
        session[:username] = nil
        redirect '/'
      else
        flash[:warning] = "Session失效，请先登录再进行操作！"
        redirect '/login'
      end
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

    get '/admin/orders' do
      if session[:username] == "admin"
        @orders = Order.all
        content_type :html
        erb :'pages/admin_order_list'
      else
        flash[:warning] = "Session失效，请先登录再进行操作！"
        redirect '/login'
      end
    end

    post '/login' do
      if params['username'] == "admin" and params["pwd"] == "admin"
        session[:username] = "admin"
        flash[:success] = "登录成功！"
        redirect "/admin/orders"
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

    get '/orders/:id' do
        if session[:username] != "admin"
            flash[:warning] = "Session失效，请先登录再进行操作！"
            redirect '/login'
        end
        begin
            @order = Order.find params[:id]
            @shopping_cart = ShoppingCart.new
            @shopping_cart.init_with_order @order
            content_type :html
            erb :'/pages/admin_order_detail'
        rescue  ActiveRecord::RecordNotFound => e
            [404, {:message => e.message}.to_json]
        end
    end

    post '/pay' do
        begin
            cart_data = JSON.parse params[:cart_data]
            @shopping_cart = ShoppingCart.new()
            @shopping_cart.init_with_data cart_data
            @shopping_cart.update_price
            order = Order.create
            order.init_by @shopping_cart
        rescue
            flash[:error] = "付款失败，请稍后再试！"
            redirect '/pages/cart'
        end

        flash[:success] = "付款成功，欢迎继续选购！"
        content_type :html
        erb :'/pages/pay_success'
    end

    post '/products/update' do
      if params[:quantity].to_i < 0
        #puts params[:quantity]
        #flash.now[:warning] = "失效"
        #redirect "/admin"
      else
        product = Product.find(params[:id])
        product.update_attributes(
            :name => params[:name],
            :price => params[:price],
            :unit => params[:unit],
            :quantity => params[:quantity],
            :description => params[:description],
            :is_promotional => params[:is_promotional]
        )
        product.to_json
      end
    end

    post '/products' do
        product = Product.create(:name => params[:name],
                            :price => params[:price],
                            :unit => params[:unit],
                            :quantity => params[:quantity],
                            :description => params[:description])

        if product.save
            [201, {:message => "products/#{product.id}"}.to_json]
        else
            halt 500, {:message => "create product failed"}.to_json
        end
    end

    delete '/products/:id' do
        product = Product.find(params[:id])
        product.destroy
        [201, {:message => "delect success"}.to_json]
    end

    post '/pages/payment' do
        cart_data = JSON.parse params[:cart_data]
        @shopping_cart = ShoppingCart.new()
        @shopping_cart.init_with_data cart_data
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
