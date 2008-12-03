require File.dirname(__FILE__) + '/../spec_helper'

describe "MerbGitWiki::Main (controller)" do
  
  # Feel free to remove the specs below
  
  before :all do
    Merb::Router.prepare { add_slice(:MerbGitWiki) } if standalone?
  end
  
  after :all do
    Merb::Router.reset! if standalone?
  end
  
  it "should have access to the slice module" do
    controller = dispatch_to(MerbGitWiki::Main, :index)
    controller.slice.should == MerbGitWiki
    controller.slice.should == MerbGitWiki::Main.slice
  end
  
  it "should have an index action" do
    controller = dispatch_to(MerbGitWiki::Main, :index)
    controller.status.should == 200
    controller.body.should contain('MerbGitWiki')
  end
  
  it "should work with the default route" do
    controller = get("/merb_git_wiki/main/index")
    controller.should be_kind_of(MerbGitWiki::Main)
    controller.action_name.should == 'index'
  end
  
  it "should work with the example named route" do
    controller = get("/merb_git_wiki/index.html")
    controller.should be_kind_of(MerbGitWiki::Main)
    controller.action_name.should == 'index'
  end
    
  it "should have a slice_url helper method for slice-specific routes" do
    controller = dispatch_to(MerbGitWiki::Main, 'index')
    
    url = controller.url(:merb_git_wiki_default, :controller => 'main', :action => 'show', :format => 'html')
    url.should == "/merb_git_wiki/main/show.html"
    controller.slice_url(:controller => 'main', :action => 'show', :format => 'html').should == url
    
    url = controller.url(:merb_git_wiki_index, :format => 'html')
    url.should == "/merb_git_wiki/index.html"
    controller.slice_url(:index, :format => 'html').should == url
    
    url = controller.url(:merb_git_wiki_home)
    url.should == "/merb_git_wiki/"
    controller.slice_url(:home).should == url
  end
  
  it "should have helper methods for dealing with public paths" do
    controller = dispatch_to(MerbGitWiki::Main, :index)
    controller.public_path_for(:image).should == "/slices/merb_git_wiki/images"
    controller.public_path_for(:javascript).should == "/slices/merb_git_wiki/javascripts"
    controller.public_path_for(:stylesheet).should == "/slices/merb_git_wiki/stylesheets"
    
    controller.image_path.should == "/slices/merb_git_wiki/images"
    controller.javascript_path.should == "/slices/merb_git_wiki/javascripts"
    controller.stylesheet_path.should == "/slices/merb_git_wiki/stylesheets"
  end
  
  it "should have a slice-specific _template_root" do
    MerbGitWiki::Main._template_root.should == MerbGitWiki.dir_for(:view)
    MerbGitWiki::Main._template_root.should == MerbGitWiki::Application._template_root
  end

end