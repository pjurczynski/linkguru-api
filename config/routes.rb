Rails.application.routes.draw do
  resources :links, except: [:new, :edit] do
    post :upvote
    post :downvote
  end

  namespace 'slack' do
    resources :links, only: :create do
      collection do
        post :last_upvote
        post :last_downvote
      end
    end
  end

  resources :sessions, only: [:create] do
    collection do
      delete :destroy
      post :refresh
    end
  end
end
