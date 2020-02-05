# -*- encoding : utf-8 -*-
Rails.application.routes.draw do
  localized do
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

    # Everything closed period routes
    resources :everything_closed_periods, except: [:show]

    # Has to be above "resources :applicants" to get higher priority
    # because "/applicants/login" should match applicant_sessions#new
    # instead of applicants#show(login).
    scope "/applicants" do
      # ApplicantSessionsController
      get "login", to: "applicant_sessions#new", as: :applicants_login
      post "login" => "applicant_sessions#create",  as: :connect_applicant

      # ApplicantsController
      patch "change_password/:id", to: "applicants#change_password", as: :change_password
      get "forgot_password", to: "applicants#forgot_password"
      post "generate_forgot_password_email", to: "applicants#generate_forgot_password_email"
      get "reset_password", to: "applicants#reset_password"
      get "search", to: "applicants#search", as: :applicant_search
    end

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
      resources :admissions, only: [:show, :new, :create, :edit, :update] do
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
        get :show_interested_other_positions, to: 'applicants#show_interested_other_positions'
        get :show_unflagged_applicants, to: 'applicants#show_unflagged_applicants'
      end
    end

    post "applicant/steal_identity", to: "applicants#steal_identity", as: :applicants_steal_identity
    get "konsert-og-uteliv", to: "site#concert", as: :concert
    get "login", to: "user_sessions#new", as: :login
    post "logout" => "user_sessions#destroy", as: :logout
    get "members/control_panel" => "members#control_panel", as: :members_control_panel
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
      get "/reservasjon" => "reservations#new"
      get "/reservasjon_admin" => "reservations#admin_new"
      post "/reservasjon_admin" => "reservations#admin_create"
      get :admin, to: "admin#index"
      get :kjempelars, to: "admin#index"
      get "reservations/archive" => "reservations#archive"
      get "reservations/export" => "reservations#export"
      get "reservations/calendar" => "reservations#calendar"
      get "/available" => "reservations#available"
      get "/admin/index" => "admin#index", as: :lyche_admin


      resources :closed_periods, except: [:show]
      get "/closed_periods/arkiv" => "closed_periods#archive", as: :closed_periods_archive

      resources :reservation_types
      resources :reservations do
        get :success, on: :collection
      end

      resources :tables
    end

    #UKA 17 boksalg
    get '/bokhandel', to: redirect('https://samfundetbok.tabetalt.no/')

    get ":id" => "pages#show", :id => Page::NAME_FORMAT
  end
end

# Add Norwegian routes and prefix English ones with /en; this is handled
# by the 'rails-translate-routes' gem
#ActionController::Routing::Translator.translate_from_file('config/locales/routes/i18n-routes.yml')
