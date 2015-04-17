Rails.application.routes.draw do
  resources :links, except: [:new, :edit] do
    post :upvote
    post :downvote
  end

  namespace 'slack' do
    resources :links, only: :create do
    end
  end

  resources :sessions, only: [:create] do
    collection do
      delete :destroy
      post :refresh
    end
  end
end
