class PageNotFound < Merb::ControllerExceptions::NotFound
  attr_reader :name, :revision

  def initialize(name, revision)
    @name = name
    @revision = revision
  end
end

class Page
  class << self
    attr_accessor :repo

    def find_all
      return [] if repo.tree.contents.empty?
      repo.tree.contents.collect { |blob| new(blob) }
    end

    def find(name, revision='HEAD')
      blob = find_blob(name, revision)
      raise PageNotFound.new(name, revision) unless blob
      new(blob)
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
      def create_blob_for(page_name)
        Grit::Blob.create(repo, :name => page_name + PageExtension, :data => '')
      end

      def find_blob(name, treeish='HEAD')
        repo.tree(treeish)/(name + PageExtension)
      end
  end

  def initialize(blob)
    @blob = blob
  end

  def to_html
    body.linkify.to_html
  end

  def to_s
    name
  end

  def new?
    @blob.id.nil?
  end

  def latest?
    (revisions.first.tree/@blob.name).id == @blob.id
  end

  def name
    @name ||= @blob.name.without_ext
  end

  def body
    @blob.data
  end

  def revisions
    @revisions ||= begin
      return [] if new?
      Page.repo.log('master', @blob.name)
    end
  end

  def revision
    # TODO: WTF!!!??
    @revision ||= begin
      revisions.select do |commit|
        commit.tree(commit, @blob.name).contents.detect do |blob|
          blob.id == @blob.id
        end
      end.last
    end
  end

  def update!(content, message='')
    return if content == body
    File.open(file_name, 'w') { |f| f << content }
    add_to_index_and_commit!(message)
  end

  private
    def add_to_index_and_commit!(custom_commit_message='')
      Dir.chdir(GitRepository) { Page.repo.add(@blob.name) }
      Page.repo.commit_index(commit_message(custom_commit_message))
    end

    def file_name
      File.join(GitRepository, name + PageExtension)
    end

    def commit_message(message = '')
      return message unless message.empty?
      new? ? "Created #{name}" : "Edited #{name}"
    end
end