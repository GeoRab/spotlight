module Spotlight
  class HomePagesController < Spotlight::PagesController
    include Blacklight::SolrHelper

    load_and_authorize_resource through: :exhibit, singleton: true, instance_name: 'page'

    before_filter :attach_breadcrumbs

    def edit
      add_breadcrumb t(:'spotlight.curation.sidebar.feature_pages'), exhibit_feature_pages_path(@exhibit)
      add_breadcrumb @page.title, [:edit, @exhibit, @page]
      super
    end

    def index
      redirect_to exhibit_feature_pages_path(@exhibit)
    end

    def show
      (@response, @document_list) = get_search_results

      if @page.nil? or !@page.published?
        render '/catalog/index'
      else
        render 'show'
      end
    end

    def _prefixes
      @_prefixes ||= super + ['catalog']
    end
    
    private

    def allowed_page_params
      super.concat [:display_title]
    end

    def search_action_url *args
      exhibit_catalog_index_url(@page.exhibit, *args)
    end
  end
end
