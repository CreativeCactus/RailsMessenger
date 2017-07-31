Rails.application.routes.draw do
  root to: 'main#index', as: 'home'

  resources :messages
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html          messages GET    /messages(.:format)                     messages#index
  #              post   /messages(.:format)                     messages#create
  #  new_message get    /messages/new(.:format)                 messages#new
  # edit_message get    /messages/:id/edit(.:format)            messages#edit
  #      message get    /messages/:id(.:format)                 messages#show
  #              patch  /messages/:id(.:format)                 messages#update
  #              put    /messages/:id(.:format)                 messages#update
  #              delete /messages/:id(.:format)                 messages#destroy
  get '/messages/with/:user' => 'messages#findByUser'
end
