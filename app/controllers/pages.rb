class MerbGitWiki::Pages < MerbGitWiki::Application
  def index
    @pages = Page.find_all
    display @pages
  end
  
  def show
    @page = Page.find(params[:id])
    display @page
  end
  
  def edit
    @page = Page.find_or_create(params[:id])
    display @page
  end
  
  def update
    @page = Page.find_or_create(params[:id])
    @page.update_content(params[:content])
    redirect slice_url(:page, @page)
  end
end