Rails.application.routes.draw do
  namespace :api, defaults: { format: :json } do
    resources :events, only: [:create, :show, :update, :index, :destroy]
  end
end
