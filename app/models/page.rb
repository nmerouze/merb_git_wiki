class PageNotFound < Merb::ControllerExceptions::NotFound 
  attr_reader :name

  def initialize(name)
    @name = name
  end
end

class Page
  class << self
    attr_accessor :repo

    def find_all
      return [] if repo.tree.contents.empty?
      repo.tree.contents.collect { |blob| new(blob) }
    end

    def find(name)
      page_blob = find_blob(name)
      raise PageNotFound.new(name) unless page_blob
      new(page_blob)
    end

    def find_or_create(name)
      find(name)
    rescue PageNotFound
      new(create_blob_for(name))
    end

    def css_class_for(name)
      find(name)
      'exists'
    rescue PageNotFound
      'unknown'
    end

    private
      def find_blob(page_name)
        repo.tree/(page_name + PageExtension)
      end

      def create_blob_for(page_name)
        Grit::Blob.create(repo, :name => page_name + PageExtension, :data => '')
      end
  end

  def initialize(blob)
    @blob = blob
  end

  def to_html
    content.auto_link.wiki_link.to_html
  end

  def to_s
    name
  end

  def new?
    @blob.id.nil?
  end

  def name
    @blob.name.without_ext
  end

  def content
    @blob.data
  end

  def update_content(new_content)
    return if new_content == content
    File.open(file_name, 'w') { |f| f << new_content }
    add_to_index_and_commit!
  end

  private
    def add_to_index_and_commit!
      Dir.chdir(GitRepository) { Page.repo.add(@blob.name) }
      Page.repo.commit_index(commit_message)
    end

    def file_name
      File.join(GitRepository, name + PageExtension)
    end

    def commit_message
      new? ? "Created #{name}" : "Updated #{name}"
    end
end