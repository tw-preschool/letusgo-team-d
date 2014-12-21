#encoding=UTF-8

require 'sinatra'
require 'sinatra/base'
require 'rack-flash'
require 'sinatra/contrib'
require 'sinatra/reloader'
require 'sinatra/authorize'
require 'rack/contrib'
require 'active_record'

require 'json'

require './models/product'
require './models/shopping_cart'
require './models/order'
require './models/user'
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
        if session[:admin_name] == "admin"
            redirect '/admin/orders'
        else
            content_type :html
            erb :login
        end
    end

    # We should use POST way to make user logout if there's more demands.
    get '/logout' do
      if session[:username] or session[:admin_name]
        session.inspect
        session.clear
        flash[:success] = "退出成功！"
        redirect '/login'
      else
        flash[:warning] = "请先登录再进行操作！"
        redirect '/login'
      end
    end

    get '/admin' do
      if session[:admin_name] == "admin"
        content_type:html
        erb :'pages/admin'
      else
        flash[:warning] = "请先登录再进行操作！"
        redirect '/login'
      end
    end

    get '/admin/orders' do
      if session[:admin_name] == "admin"
        @orders = Order.order("time DESC")
        content_type :html
        erb :'pages/admin_order_list'
      else
        flash[:warning] = "请先登录再进行操作！"
        redirect '/login'
      end
    end

    post '/adminLogin' do
      if params['username'] == "admin" and params["password"] == "admin"
        session[:admin_name] = "admin"
        if session[:username]
          session[:username] = nil
          flash[:success] = "普通用户身份已退出，以管理员身份登录成功！"
        else
          flash[:success] = "登录成功！"
        end
        redirect "/admin/orders"
      else
        flash[:error] = "管理员用户名/密码错误，请重试！"
        redirect '/login'
      end
    end

    post '/userLogin' do
        @user = User.authenticate(params[:username], params[:password])
        if @user
          session[:username] = @user.username
          flash[:success] = "登录成功！"
          @shopping_cart = @user.cart_data.to_s
          content_type :html
          erb :'/pages/user_login_success'
        else
          flash[:error] = "用户名或密码错误，请确认后重试"
          redirect '/login'
        end
    end

    get '/add' do
        content_type :html
        erb :'pages/add'
    end

    get '/user/register' do
        content_type :html
        erb :'pages/register'
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

    get '/order/:number' do
        if session[:admin_name] != "admin"
            flash[:warning] = "请先登录再进行操作！"
            redirect '/login'
        end
        begin
            @order = Order.find_by_number params[:number]
            @shopping_cart = ShoppingCart.new
            @shopping_cart.init_with_order @order
            content_type :html
            erb :'/pages/admin_order_detail'
        rescue  ActiveRecord::RecordNotFound => e
            [404, {:message => e.message}.to_json]
        end
    end

    post '/pay' do
        if session[:username].nil?
            flash[:warning] = "请登录后再进行购物！"
            redirect '/login'
        end
        current_user = User.find_by_username session[:username]

        order = Order.create
        pay_success_msg = "付款成功，欢迎继续选购！"
        begin
            cart_data = JSON.parse params[:cart_data]
            @shopping_cart = ShoppingCart.new()
            @shopping_cart.init_with_data cart_data
            @shopping_cart.update_price
            if @shopping_cart.shopping_list == []
                order.delete
                pay_success_msg = "您选择了一个空订单，现已将购物车清空"
            else
                order.init_by @shopping_cart
            end
        rescue RangeError => e
            order.destory
            flash[:error] = "#{e.message}"
            redirect '/pages/cart'
        rescue
            order.destory
            flash[:error] = "付款失败，请稍后再试！"
            redirect '/pages/cart'
        end

        current_user.update_attributes(:cart_data => nil)
        flash[:success] = pay_success_msg
        content_type :html
        erb :'/pages/pay_success'
    end

    get '/cart_data' do
        if session[:username].nil?
            flash[:warning] = "请登录后再进行购物！"
            redirect '/login'
        else
            current_user = User.find_by_username session[:username]
            [201, current_user.cart_data.to_json]
        end
    end

    post '/update/cart_data' do
        if session[:username].nil?
            flash[:warning] = "请登录后再进行购物！"
            redirect '/login'
        end
        current_user = User.find_by_username session[:username]
        current_user.cart_data = params[:cart_data]
        current_user.save
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



    post '/user/register' do
        user = User.create(:username => params[:username],
                            :password => params[:password],
                            :name => params[:name],
                            :address => params[:address],
                            :telephone => params[:telephone])

        if user.save
            flash[:success]="注册成功，请登录"
            redirect '/login'

        else
            flash[:error]="注册失败，请重新注册"
            redirect '/user/register'
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
