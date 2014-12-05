require 'sinatra'
require 'sinatra/base'
require 'rack-flash'
require 'sinatra/contrib'
require 'sinatra/reloader'
require 'rack/contrib'
require 'active_record'

require 'json'

require './models/product'

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
        redirect '/login'
      end
    end

    post '/login' do
      if params['username'] == "admin" and params["pwd"] == "admin"
        session[:username] = "admin"
        redirect "/admin"
      else
        flash[:notice] = "Authentication failed,please try again!"
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

    get %r{/?[(views)(pages)]/([^/\.]+)[/.html]?} do |page|
        content_type :html
        erb "pages/#{page}".to_sym
    end

    after do
        ActiveRecord::Base.connection.close
    end
end
