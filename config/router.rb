Merb::Router.prepare do
  resources :pages
  match('/').to(:controller => 'pages', :action => 'index')
end