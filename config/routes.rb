Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: redirect('http://cinehello.com/activities/#/')
  get "nobodyknows", to: "shortened_urls#index"
  get :"/shortened_urls.png", to: "shortened_urls#png_way"
  get "/:short_url", to: "shortened_urls#show"
  get "shortened/:short_url", to: "shortened_urls#shortened", as: :shortened
  post :"/shortened_urls", to: "shortened_urls#create"
  post :"/shortened_urls.json", to: "shortened_urls#create"
  get "/shortened_urls/fetch_original_url", to: "shortened_urls#fetch_original_url"
  # get "/utm_urls/new", to: "utm_urls#new"
  resources :utm_urls
  resources :shortened_urls, only: :create
end
