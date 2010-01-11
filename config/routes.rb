ActionController::Routing::Routes.draw do |map|

  # Internal Search API.
  map.search '/search.json', :controller => 'search', :action => 'search'

  # API Controller uses default routes, for now.

  # Workspace and surrounding HTML.
  map.with_options :controller => 'workspace' do |main|
    main.root
    main.home       '/home',        :action => 'home'
    main.results    '/results',     :action => 'index'
    main.signup     '/signup',      :action => 'signup'
    main.login      '/login',       :action => 'login'
    main.logout     '/logout',      :action => 'logout'
    main.todo       '/todo',        :action => 'todo'
  end

  # Map the static pages
  map.with_options :controller => 'static' do |main|
    Dir.glob(RAILS_ROOT + '/app/views/static/*.erb').each do |template|
      base = template.match(/([a-z][a-z_\-]*)\.erb$/i)[1]
      pretty = base.gsub('_', '-')
      main.static "/" + pretty, :action => base
    end
  end

  # Document representations and (private) sub-resources.
  map.resources  :documents,
                 :collection => {:metadata => :get, :dates => :get},
                 :member     => {:search => :get},
                 :has_many   => [:annotations]
  map.pdf        "/documents/:id/:slug.pdf",      :controller => :documents, :action => :send_pdf
  map.full_text  "/documents/:id/:slug.txt",      :controller => :documents, :action => :send_full_text
  map.page_text  "/documents/:id/pages/:page_name.txt", :controller => :documents, :action => :send_page_text, :conditions => {:method => :get}
  map.set_text   "/documents/:id/pages/:page_name.txt", :controller => :documents, :action => :set_page_text,  :conditions => {:method => :post}
  map.page_image "/documents/:id/pages/:page_name.gif", :controller => :documents, :action => :send_page_image


  # Bulk downloads.
  map.bulk_download '/download/*args.zip', :controller => 'download', :action => 'bulk_download'

  # Accounts and account management.
  map.resources :accounts
  map.with_options :controller => 'accounts' do |accounts|
    accounts.enable_account '/accounts/enable/:key', :action => 'enable'
  end

  # Saved Searches.
  map.resources :saved_searches

  # Labels.
  map.resources :labels, :member => {:documents => :get}

  # Bookmarks.
  map.resources :bookmarks

  # Asset packages.
  Jammit::Routes.draw(map)

  # Default routes:
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
  map.connect ':controller/:action.:format'
end
