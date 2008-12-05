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
      
      def title(title=nil)
        @title = title.to_s unless title.nil?
        @title
      end

      def list_item(page)
        link_to page.name.titleize, slice_url(:page, page), :class => 'page_name'
      end
      
      def link_to_page(page, with_revision=false)
        if with_revision
          attrs = {:class => 'page_revision', :href => slice_url(:page, page, :revision => page.revision.id)}
          text = page.revision.id_abbrev
        end

        haml_tag(:a, attrs || { :href => slice_url(:page, page), :class => 'page' }) do
          haml_concat text || page.name.titleize
        end
      end
      
      def revert_link_for(page)
        message = URI.encode "Revert to #{page.revision}"
        link_to 'Revert', slice_url(:edit_page, page, :body => URI.encode(page.body), :message => message)
      end
      
      def link_to_page_with_revision(page)
        link_to_page(page, true)
      end
      
      def history_item(page)
        precede(time_lost_in_words(page.revision.date) + ' ago &mdash; ') do
          link_to_page_with_revision(page)
          haml_tag(:span, :class => 'commit_message') do
            haml_concat page.revision.short_message
          end
        end
      end
      
      def actions_for(page)
        capture_haml(page) do |p|
          link_to_page(p)
          haml_concat ' &mdash; '
          haml_concat link_to('Edit', slice_url(:edit_page, p))
          haml_concat '/'
          haml_concat link_to('History', slice_url(:history_page, p))
        end
      end
      
    end
  end
end