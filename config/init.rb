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

use_orm :datamapper
use_test :rspec
use_template_engine :haml

Merb::Plugins.config[:haml][:attr_wrapper] = '"'
 
Merb::Config.use do |c|
  c[:session_store] = 'cookie'
  c[:session_secret_key]  = '98b17286ace00b9628adaf07299eb9ffe7621825'
  c[:exception_details] = true
  c[:reload_templates] = true
  c[:reload_classes] = true
  c[:reload_time] = 0.5
  c[:ignore_tampered_cookies] = true
  c[:log_auto_flush ] = true
  c[:log_level] = :debug

  c[:log_stream] = STDOUT
  c[:log_file]   = nil
end