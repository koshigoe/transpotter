Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  scope 'v:version', constraints: { version: /\d+\.\d+/ } do
    resources :authentications, only: [:create]
    resources :ftp_accounts, path: 'ftp-accounts', only: [:show, :create]
  end
end
