require 'open-uri'

module Merb
  module MerbGitWiki
    module ApplicationHelper
      
      # @param *segments<Array[#to_s]> Path segments to append.
      #
      # @return <String> 
      #  A path relative to the public directory, with added segments.
      def image_path(*segments)
        public_path_for(:image, *segments)
      end
      
      # @param *segments<Array[#to_s]> Path segments to append.
      #
      # @return <String> 
      #  A path relative to the public directory, with added segments.
      def javascript_path(*segments)
        public_path_for(:javascript, *segments)
      end
      
      # @param *segments<Array[#to_s]> Path segments to append.
      #
      # @return <String> 
      #  A path relative to the public directory, with added segments.
      def stylesheet_path(*segments)
        public_path_for(:stylesheet, *segments)
      end
      
      # Construct a path relative to the public directory
      # 
      # @param <Symbol> The type of component.
      # @param *segments<Array[#to_s]> Path segments to append.
      #
      # @return <String> 
      #  A path relative to the public directory, with added segments.
      def public_path_for(type, *segments)
        ::MerbGitWiki.public_path_for(type, *segments)
      end
      
      # Construct an app-level path.
      # 
      # @param <Symbol> The type of component.
      # @param *segments<Array[#to_s]> Path segments to append.
      #
      # @return <String> 
      #  A path within the host application, with added segments.
      def app_path_for(type, *segments)
        ::MerbGitWiki.app_path_for(type, *segments)
      end
      
      # Construct a slice-level path.
      # 
      # @param <Symbol> The type of component.
      # @param *segments<Array[#to_s]> Path segments to append.
      #
      # @return <String> 
      #  A path within the slice source (Gem), with added segments.
      def slice_path_for(type, *segments)
        ::MerbGitWiki.slice_path_for(type, *segments)
      end
      
      def slice_css_include_tag(*stylesheets)
        css_include_tag(*stylesheets.map { |s| stylesheet_path(s) })
      end
      
      def title(title = nil)
        @title = title.to_s unless title.nil?
        @title
      end
      
      def decoded_message
        URI.decode(params[:message] || '')
      end
      
      def history_item(page)
        precede(page.revision.date.formatted(:db) + ' / ') do
          haml_concat link_to page.revision.short_message, slice_url(:page, page, :revision => page.revision.id)
        end
      end
      
      def title_for(page)
        if page.latest?
          title page.name.titleize
        else
          title "#{page.name.titleize} / #{page.revision.id_abbrev}"
        end
      end
      
      def actions_for(page)
        link_to('All pages', slice_url(:pages)) << ' / ' <<
        edit_link_for(page) << ' / ' <<
        link_to('History', slice_url(:history_page, page))
      end
      
      def edit_link_for(page)
        if page.latest?
          link_to('Edit', slice_url(:edit_page, page))
        else
          message = URI.encode "Revert to #{page.revision}"
          link_to('Revert', slice_url(:edit_page, page, :body => URI.encode(page.body), :message => message))
        end
      end
      
      def body_for(page)
        params[:body] || page.body
      end
      
    end
  end
end