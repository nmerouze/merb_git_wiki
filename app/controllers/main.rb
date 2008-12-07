class MerbGitWiki::Main < MerbGitWiki::Application
  def pull
    Dir.chdir(Merb::Slices::config[:merb_git_wiki][:repository]) { `git pull` }
  end
end