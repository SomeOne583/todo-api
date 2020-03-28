Rails.application.routes.draw do
    devise_for :users, skip: %i[registrations sessions passwords]
    devise_scope :user do
        post "/signup", to: 'registrations#create'
        post '/login', to: 'sessions#create'
        delete '/logout', to: 'sessions#destroy'
    end
    post "/webhook", to: 'webhook#index'
    root "webhook#index"
end
