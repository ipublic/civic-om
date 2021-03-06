CivicOm::Application.routes.draw do
  
  devise_for :users
  resources :users, :only => :show

  ## Send user to login page if a subdomain is present
  # constraints(Subdomain) do
  #   match '/' => 'sites/public/home#index'
  # end

  root :to => "community/home#index"

  match '/support' => 'admin/home#support', :as => :support

  # js access to methods
  # match '/admin/dashboards/new_group' => 'sites/admin/dashboards#new_group'
  # match '/admin/dashboards/new_measure' => 'sites/admin/dashboards#new_measure'

  # match "site" => "admin/sites#show"
  
  # match '/admin' => 'admin/home#index', :as => :admin_root
  # match '/about' => 'admin/home#about', :as => :about

  namespace :community do
    resources :home, :only => :index
  end

  scope ":authority_id" do
    scope :module => "sites" do
      namespace :admin do

        resources :home, :only => :index
        
        resources :topics do
          member do
            get :show_metadata
            get :show_properties
            get :show_records
          end
        end

        resources :data_sources do
          member do
            get :file_source
            post :upload_file
            get :parse
            put :publish
            # get :extract
            # get :show_raw_records
            get :show_records
            get :show_locations
            get :show_metadata
            get :show_associations
            get :show_ddl
          end
        end
        
        resources :maps
        resources :dashboards do
          collection do
            get :new_group
            get :new_measure
          end
        end

        resources :contacts do
          collection do
            get :new_email
            get :new_telephone
            get :new_address
          end
          #     member do
          #       get :show_contact
          #     end
        end

        resources :settings, :only => :index
        resource :site, :except => :destroy

      end
    
      namespace :public do
        resources :home, :only => :index
        resources :maps, :only => [:index, :show]
        resources :dashboards, :only => [:index, :show]
      end
    end
  end
  
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
