require 'rubygems'
require 'rake/gempackagetask'

require 'merb-core'
require 'merb-core/tasks/merb'

GEM_NAME = "merb_git_wiki"
AUTHOR = "Nicolas Merouze"
EMAIL = "nicolas.merouze@gmail.com"
HOMEPAGE = "http://github.com/nmerouze/merb_git_wiki"
SUMMARY = "MerbGitWiki is a git-wiki powered by Merb and in a slice form."
GEM_VERSION = "0.1.1"

spec = Gem::Specification.new do |s|
  s.rubyforge_project = 'merb'
  s.name = GEM_NAME
  s.version = GEM_VERSION
  s.platform = Gem::Platform::RUBY
  s.has_rdoc = true
  s.extra_rdoc_files = ["README", "LICENSE", 'TODO']
  s.summary = SUMMARY
  s.description = s.summary
  s.author = AUTHOR
  s.email = EMAIL
  s.homepage = HOMEPAGE
  s.add_dependency('merb-slices', '>= 1.0.3')
  s.require_path = 'lib'
  s.files = %w(LICENSE README Rakefile TODO) + Dir.glob("{lib,spec,app,public,stubs}/**/*")
end

Rake::GemPackageTask.new(spec) do |pkg|
  pkg.gem_spec = spec
end

desc "Install the gem"
task :install do
  Merb::RakeHelper.install(GEM_NAME, :version => GEM_VERSION)
end

desc "Uninstall the gem"
task :uninstall do
  Merb::RakeHelper.uninstall(GEM_NAME, :version => GEM_VERSION)
end

desc "Create a gemspec file"
task :gemspec do
  File.open("#{GEM_NAME}.gemspec", "w") do |file|
    file.puts spec.to_ruby
  end
end

require 'spec/rake/spectask'
require 'merb-core/test/tasks/spectasks'
desc 'Default: run spec examples'
task :default => 'spec'
