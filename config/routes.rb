Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: redirect('http://cinehello.com/activities/#/')
  get "nobodyknows", to: "shortened_urls#index"
  get "/:short_url", to: "shortened_urls#show"
  get "shortened/:short_url", to: "shortened_urls#shortened", as: :shortened
  post :"/shortened_urls", to: "shortened_urls#create"
  post :"/shortened_urls.json", to: "shortened_urls#create"
  get "/shortened_urls/fetch_original_url", to: "shortened_urls#fetch_original_url"
end
