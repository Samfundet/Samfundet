# -*- encoding : utf-8 -*-
Rails.application.routes.draw do
  localized do
    root to: "site#index"
    get 'rss(/:type)', to: 'events#rss', defaults: { format: 'rss' }

    get 'contact', to: 'contact#index'
    post 'contact', to: 'contact#create'

    get 'search', to: 'search#search'

    get 'new-building', to: 'new_building#index'

    get 'auction', to: 'auction#index'

    resources :info_boxes

    # resources :crowd_funding_supporters, path: 'crowd-funding' do
    #   get :admin, on: :collection
    # end

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

      collection do
        get 'purchase_callback' => :purchase_callback_failure
        get 'purchase_callback/:tickets' => :purchase_callback_success
      end
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

    resources :admissions, only: :index

    resources :admissions, path_names: { show_public: '' } do
      get :show_public, on: :member, as: ''
    end

    # Everything closed period routes
    resources :everything_closed_periods, except: [:show]

    # Has to be above "resources :applicants" to get higher priority
    # because "/applicants/login" should match applicant_sessions#new
    # instead of applicants#show(login).
    scope "/applicants" do
      # ApplicantSessionsController
      get "new", to: "applicant_sessions#new", as: :applicants_login
      post "new" => "applicant_sessions#create",  as: :connect_applicant
      get "login", to: "user_sessions#new_applicant", as: :applicant_login

      # ApplicantsController
      patch "change_password/:id", to: "applicants#change_password", as: :change_password
      get "forgot_password", to: "applicants#forgot_password"
      post "generate_forgot_password_email", to: "applicants#generate_forgot_password_email"
      get "reset_password", to: "applicants#reset_password"
      get "verify_email", to: "applicants#verify_email"
      get "search", to: "applicants#search", as: :applicant_search
    end

    resources :applicants
    resources :groups, only: [:index, :new, :create, :edit, :update] do
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
    resources :members, only: [:control_panel, :show_roles]

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
        get :destroy, to: "campus#destroy"
      end
      resources :admissions, only: [:show, :new, :create, :edit, :update, :list] do

        get :statistics, on: :member
        get :overview, on: :member
        get :prepare_rejection_email, on: :member
        post :review_rejection_email, on: :member
        post :send_rejection_email, on: :member
        post :send_rejection_email_result, on: :member
        get :rejection_email_list, on: :member

        resources :groups, only: :show do
          get :applications, on: :member
          get :reject_calls, on: :member
          get :show_applicants_with_missing_interviews, to: 'groups#show_applicants_with_missing_interviews'
          resources :jobs, only: [:show, :new, :create, :edit, :update, :destroy] do
            get :search, on: :collection
            get :show_unprocessed
            resources :job_applications, only: :show do
              post :hidden_create, on: :collection
              get :reset_status
              resources :interviews, only: [:update, :show]
            end
          end
          # :applicants provides a scope (with applicant IDs in params and such),
          # but no actions of its own. Hence, only: []
          resources :applicants, only: [] do
            resources :log_entries, only: [:create, :destroy]

          end
        end
        get :show_interested_other_positions, to: 'applicants#show_interested_other_positions'
        get :show_applicants_missing_interviews, to: 'applicants#show_applicants_missing_interviews'
        get :show_unflagged_applicants, to: 'applicants#show_unflagged_applicants'
        get :edit_applicant, to: 'applicants#edit_applicant'

      end
      get :list, to: "admissions#list"
    end

    post "applicant/steal_identity", to: "applicants#steal_identity", as: :applicants_steal_identity
    get "konsert-og-uteliv", to: "site#concert", as: :concert
    get "login", to: "user_sessions#new", as: :login

    get "brosjyre", to: "site#brochure"
    get "strategi", to: "site#strategy"
    get "/valgundersokelse", to: "site#generic_redirect"

    post "logout" => "user_sessions#destroy", as: :logout
    get "members/control_panel" => "members#control_panel", as: :members_control_panel
    match "members/show_roles" => "members#show_roles", as: :members_show_roles, via: [:get, :post]
    get "members/search.:format" => "members#search", as: :members_search
    post "members/steal_identity" => "members#steal_identity", as: :members_steal_identity

    scope "/medlem" do
      get "login" => "member_sessions#new", as: :members_login
      post "login" => "member_sessions#create", as: :connect
    end

    resources :images do
      get :search, on: :collection
      post :search, on: :collection
    end

    namespace :sulten, path: "lyche" do
      get "/" => "lyche#index"
      get "/make_reservation" => "lyche#reservation"
      post "/make_reservation" => "lyche#reservation"
      get "/reservation/success" => "lyche#reservation_success"
      get "/reservation/failure" => "lyche#reservation_failure"
      get "/reservation/failure_day" => "lyche#reservation_failure_day"
      get "/menu" => "lyche#menu"
      get "/about" => "lyche#about"
      get "/contact" => "lyche#contact"
      #get "/reservasjon" => "reservations#new"
      get "/reservasjon_admin" => "reservations#admin_new"
      post "/reservasjon_admin" => "reservations#admin_create"
      get :admin, to: "admin#index"
      get :kjempelars, to: "admin#index"
      get "reservations/archive" => "reservations#archive"
      get "reservations/export" => "reservations#export"
      get "/admin/index" => "admin#index", as: :lyche_admin


      resources :closed_periods, except: [:show]
      get "/closed_periods/arkiv" => "closed_periods#archive", as: :closed_periods_archive

      resources :reservation_types
      resources :reservations do
        get :success, on: :collection
      end

      resources :tables

      resources :menu, path: "/admin/menu", only: [:index], as: :admin_menu
      resources :menu_items, path: "/admin/menu/item", only: [:new, :create, :edit, :update, :destroy]
      resources :menu_categories, path: "admin/menu/categories", only: [:new, :create, :edit, :update, :destroy]
    end

    #UKA 17 boksalg
    get '/bokhandel', to: redirect('https://samfundetbok.tabetalt.no/')

    get ":id" => "pages#show", :id => Page::NAME_FORMAT
  end
end

# Add Norwegian routes and prefix English ones with /en; this is handled
# by the 'rails-translate-routes' gem
#ActionController::Routing::Translator.translate_from_file('config/locales/routes/i18n-routes.yml')
