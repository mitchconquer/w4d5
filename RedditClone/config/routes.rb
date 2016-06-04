Rails.application.routes.draw do
  resources :users, only: [:new, :create]
  resource :session, only: [:new, :create, :destroy]
  resources :subs
  resources :posts, except: [:index, :new, :create] do
    resources :comments, except: [:index, :show]
  end

  get "subs/:sub_id/posts/new", to: "posts#new", as: 'sub_posts_new'
  post "subs/:sub_id/posts", to: "posts#create", as: 'sub_posts_create'
  get "subs/:sub_id/posts/:post_id/edit", to: "posts#edit", as: 'edit_sub_post'
  patch "subs/:sub_id/posts/:post_id", to: "posts#update", as: 'update_sub_post'

  get 'login', to: 'sessions#new'

end
