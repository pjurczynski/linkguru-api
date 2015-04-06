Rails.application.routes.draw do
  resources :links, except: [:new, :edit]
  resources :sessions, only: [:create] do
    collection do
      delete :destroy
    end
  end
end
