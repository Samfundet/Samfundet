# -*- encoding : utf-8 -*-
Rails.application.routes.draw do

  root to: "site#index"
  get 'rss(/:type)', to: 'events#rss', defaults: { format: 'rss' }

  get 'contact', to: 'contact#index'
  post 'contact', to: 'contact#create'

  get 'search', to: 'search#search'
  #resources :search, only: [:new, :create, :search]
  ############################
  ##  Routes for events     ##
  ############################

  resources :events do
    get :buy, on: :member, action: "buy"
    post :buy, on: :member, action: "buy"
    get :search, on: :collection
    post :search, on: :collection
    get :archive_search, on: :collection
    post :archive_search, on: :collection
    get :admin, on: :collection
    get :archive, on: :collection
    get :ical, on: :collection, defaults: { format: 'ics' }
    get :rss, on: :collection, defaults: { format: 'rss' }

    #collection do
    #  get 'purchase_callback', to: :purchase_callback_failure
  #    get 'purchase_callback/:tickets', to: :purchase_callback_success
    #end
  end

  resources :front_page_locks, only: [:edit, :update] do
    post :clear, on: :member
  end

  ############################
  ##  Routes for pages      ##
  ############################

  resources :pages, path: "information" do
    collection do
      get "admin"
      get "admin/graph", to:"pages#graph"
      post "preview"
    end

    member do
      get "history"
    end
  end

  ############################
  ##  Routes for documents  ##
  ############################

  resources :documents, only: [:index, :new, :create, :edit, :update, :destroy] do
    get :admin, on: :collection
  end

  ############################
  ##  Routes for areas      ##
  ############################
  resources :areas, only: [:edit, :update]

  ############################
  ##  Routes for blog       ##
  ############################

  resources :blogs do
    get :admin, on: :collection
  end

  ############################
  ##  Routes for admissions ##
  ############################

  resources :admissions, only: [:index, :new, :create, :edit, :update]

  # Everything closed period routes
  resources :everything_closed_periods, except: [:show]

  # Has to be above "resources :applicants" to get higher priority
  # because "/applicants/login" should match applicant_sessions#new
  # instead of applicants#show(login).
  scope "/applicants" do
    # ApplicantSessionsController
    match "login" => "applicant_sessions#new",
          as: :applicants_login,
          via: :get
    match "login" => "applicant_sessions#create",
          as: :connect_applicant,
          via: :post

    # ApplicantsController
    match "change_password/:id" => "applicants#change_password", as: :change_password, via: :get
    match "forgot_password" => "applicants#forgot_password", via: :get
    match "generate_forgot_password_email" => "applicants#generate_forgot_password_email",
          via: :post
    match "reset_password" => "applicants#reset_password", via: :get
  end

  match "applicants/search" => "applicants#search",
        as: :applicant_search
  resources :applicants
  resources :groups, only: [:new, :create, :edit, :update] do
    get :admin, on: :collection
  end

  # The reason why job applications are not nested with applicants is that
  # a job application should be able to exist without the presence of an
  # applicant. That is, you should be able to register an application before
  # you register as an applicant.
  resources :job_applications, only: [:index, :create, :update, :destroy] do
    member do
      post :up
      post :down
    end
  end

  resources :jobs, only: :show
  resources :members, only: [:control_panel]

  resources :roles, only: [:index, :show, :new, :create, :edit, :update] do
    post :pass, on: :member
    resources :members_roles, only: [:create, :destroy]
    get :one_year_old, on: :collection
  end

  # If a resource is logically nested within another, the routes should
  # reflect that
  namespace :admissions_admin do
    resources :campus, path: 'campus' do
      get :admin, on: :collection
      get :deactivate, to: "campus#deactivate"
      get :activate, to: "campus#activate"
    end
    resources :admissions, only: :show do
      get :statistics, on: :member
      resources :groups, only: :show do
        get :applications, on: :member
        get :reject_calls, on: :member
        resources :jobs, only: [:show, :new, :create, :edit, :update, :destroy] do
          get :search, on: :collection
          resources :job_applications, only: :show do
            post :hidden_create, on: :collection
            resources :interviews, only: [:update, :show]
          end
        end
        # :applicants provides a scope (with applicant IDs in params and such),
        # but no actions of its own. Hence, only: []
        resources :applicants, only: [] do
          resources :log_entries, only: [:create, :destroy]
        end
      end
      get 'show_interested_other_positions', to: 'applicants#show_interested_other_positions'
    end
  end

  match "applicant/steal_identity" => "applicants#steal_identity",
        as: :applicants_steal_identity,
        via: :post
  match "konsert-og-uteliv" => "site#concert",
        as: :concert,
        via: :get
  match "login" => "user_sessions#new",
        as: :login,
        via: :get
  match "logout" => "user_sessions#destroy",
        as: :logout,
        via: :post
  match "members/control_panel" => "members#control_panel",
        as: :members_control_panel,
        via: :get
  match "members/search.:format" => "members#search",
        as: :members_search,
        via: :get
  match "members/steal_identity" => "members#steal_identity",
        as: :members_steal_identity,
        via: :post

  scope "/medlem" do
    match "login" => "member_sessions#new",
          as: :members_login,
          via: :get
    match "login" => "member_sessions#create",
          as: :connect,
          via: :post
  end

  resources :images do
    get :search, on: :collection
    post :search, on: :collection
  end

  namespace :sulten, path: "lyche" do
    get "/reservasjon" => "reservations#new"
    get "/reservasjon_admin" => "reservations#admin_new"
    post "/reservasjon_admin" => "reservations#admin_create"
    get :admin, to: "admin#index"
    get :kjempelars, to: "admin#index"
    get "reservations/archive" => "reservations#archive"
    get "reservations/export" => "reservations#export"
    get "/available" => "reservations#available"

    resources :reservation_types
    resources :reservations do
      get :success, on: :collection
    end

    resources :tables
  end
  
  #UKA 17 boksalg 
  match '/bokhandel' => redirect('https://samfundetbok.tabetalt.no/') 
  
  get ":id" => "pages#show", :id => Page::NAME_FORMAT
end

# Add Norwegian routes and prefix English ones with /en; this is handled
# by the 'rails-translate-routes' gem
#ActionController::Routing::Translator.translate_from_file('config/locales/routes/i18n-routes.yml')
