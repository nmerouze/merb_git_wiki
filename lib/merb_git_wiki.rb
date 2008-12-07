if defined?(Merb::Plugins)
  
  $:.unshift File.dirname(__FILE__)

  load_dependency 'merb-slices'
  Merb::Plugins.add_rakefiles "merb_git_wiki/merbtasks", "merb_git_wiki/slicetasks", "merb_git_wiki/spectasks"

  # Register the Slice for the current host application
  Merb::Slices::register(__FILE__)
  
  # Slice configuration - set this in a before_app_loads callback.
  # By default a Slice uses its own layout, so you can swicht to 
  # the main application layout or no layout at all if needed.
  # 
  # Configuration options:
  # :layout - the layout to use; defaults to :merb_git_wiki
  # :mirror - which path component types to use on copy operations; defaults to all
  Merb::Slices::config[:merb_git_wiki][:layout] ||= :merb_git_wiki
  Merb::Slices::config[:merb_git_wiki][:repository] ||= Merb.root / 'wiki'
  Merb::Slices::config[:merb_git_wiki][:format] ||= 'textile'
  Merb::Slices::config[:merb_git_wiki][:homepage] ||= 'Home'
  
  # All Slice code is expected to be namespaced inside a module
  module MerbGitWiki
    
    # Slice metadata
    self.description = "MerbGitWiki is a git-wiki powered by Merb and in a slice form."
    self.version = "0.1.2"
    self.author = "Nicolas Mérouze"
    
    # Stub classes loaded hook - runs before LoadClasses BootLoader
    # right after a slice's classes have been loaded internally.
    def self.loaded
    end
    
    # Initialization hook - runs before AfterAppLoads BootLoader
    def self.init     
      repository = Merb::Slices::config[:merb_git_wiki][:repository]
      begin
        Page.repo = Grit::Repo.new(repository)
      rescue Grit::InvalidGitRepositoryError, Grit::NoSuchPathError
        FileUtils.mkdir_p(repository) unless File.directory?(repository)
        Dir.chdir(repository) { `git init` }
        Page.repo = Grit::Repo.new(repository)
      rescue
        Merb.logger.error "#{repository}: Not a git repository."
      end
    end
    
    # Activation hook - runs after AfterAppLoads BootLoader
    def self.activate
    end
    
    # Deactivation hook - triggered by Merb::Slices.deactivate(MerbGitWiki)
    def self.deactivate
    end
    
    # Setup routes inside the host application
    #
    # @param scope<Merb::Router::Behaviour>
    #  Routes will be added within this scope (namespace). In fact, any 
    #  router behaviour is a valid namespace, so you can attach
    #  routes at any level of your router setup.
    #
    # @note prefix your named routes with :merb_git_wiki_
    #   to avoid potential conflicts with global named routes.
    def self.setup_router(scope)
      scope.resources :pages, :member => { :history => :get }
      scope.match('/pull').to(:controller => 'main', :action => 'pull')
      scope.match('/').to(:controller => 'pages',
        :action => 'show',
        :id => Merb::Slices::config[:merb_git_wiki][:homepage])
    end
    
  end
  
  # Setup the slice layout for MerbGitWiki
  #
  # Use MerbGitWiki.push_path and MerbGitWiki.push_app_path
  # to set paths to merb_git_wiki-level and app-level paths. Example:
  #
  # MerbGitWiki.push_path(:application, MerbGitWiki.root)
  # MerbGitWiki.push_app_path(:application, Merb.root / 'slices' / 'merb_git_wiki')
  # ...
  #
  # Any component path that hasn't been set will default to MerbGitWiki.root
  #
  # Or just call setup_default_structure! to setup a basic Merb MVC structure.
  MerbGitWiki.setup_default_structure!
  
  # Add dependencies for other MerbGitWiki classes below. Example:
  # dependency "merb_git_wiki/other"
  require 'core_ext'
  
  dependency 'mojombo-grit', :require_as => 'grit'
  dependency 'RedCloth'
  
end