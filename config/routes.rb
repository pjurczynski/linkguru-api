Rails.application.routes.draw do
  resources :links, except: [:new, :edit]
end
