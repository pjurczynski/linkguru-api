Rails.application.routes.draw do
  resources :links, except: [:new, :edit] do
    post :upvote
    post :downvote
  end

  resources :sessions, only: [:create] do
    collection do
      delete :destroy
    end
  end
end
