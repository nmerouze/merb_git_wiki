merb_gems_version = "1.0.3"
dm_gems_version   = "0.9.7"

dependency "merb-action-args", merb_gems_version
dependency "merb-assets", merb_gems_version  
dependency "merb-cache", merb_gems_version   
dependency "merb-helpers", merb_gems_version 
dependency "merb-mailer", merb_gems_version  
dependency "merb-slices", merb_gems_version  
dependency "merb-auth-core", merb_gems_version
dependency "merb-auth-more", merb_gems_version
dependency "merb-auth-slice-password", merb_gems_version
dependency "merb-param-protection", merb_gems_version
dependency "merb-exceptions", merb_gems_version
 
dependency "dm-core", dm_gems_version         
dependency "dm-aggregates", dm_gems_version   
dependency "dm-migrations", dm_gems_version   
dependency "dm-timestamps", dm_gems_version   
dependency "dm-types", dm_gems_version        
dependency "dm-validations", dm_gems_version  

dependency 'mojombo-grit', :require_as => 'grit'
dependency 'RedCloth'

use_orm :datamapper
use_test :rspec
use_template_engine :haml

Merb::Plugins.config[:haml][:attr_wrapper] = '"'
 
Merb::Config.use do |c|
  c[:session_store] = 'cookie'
  c[:session_secret_key]  = '98b17286ace00b9628adaf07299eb9ffe7621825'
  c[:reload_templates] = true
end
 
Merb::BootLoader.before_app_loads do
  require Merb.root / 'lib' / 'core_ext'
  
  GitRepository = Merb.root / 'wiki'
  PageExtension = '.textile'
  Homepage = 'Home'
end
 
Merb::BootLoader.after_app_loads do
  begin
    Page.repo = Grit::Repo.new(GitRepository)
  rescue Grit::InvalidGitRepositoryError, Grit::NoSuchPathError
    Merb.logger.error "#{GitRepository}: Not a git repository."
  end
end