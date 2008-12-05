class MerbGitWiki::Pages < MerbGitWiki::Application
  def index
    @pages = Page.find_all
    display @pages
  end
  
  def show
    if params[:revision].blank?
      @page = Page.find(params[:id])
    else
      @page = Page.find(params[:id], params[:revision])
    end
    display @page
  end
  
  def history
    @page = Page.find(params[:id])
    @revisions = @page.revisions.map do |revision|
      Page.find(params[:id], revision.id)
    end
    display @page
  end
  
  def edit
    @page = Page.find_or_create(params[:id])
    display @page
  end
  
  def update
    @page = Page.find_or_create(params[:id])
    @page.update!(params[:body], params[:message])
    redirect slice_url(:page, @page)
  end
end