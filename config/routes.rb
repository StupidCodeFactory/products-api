Rails.application.routes.draw do
  scope module: 'v1' do
    resources :products
  end
end
