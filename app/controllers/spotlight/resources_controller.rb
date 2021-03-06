module Spotlight
  class ResourcesController < ApplicationController
    before_filter :authenticate_user!, except: [:show]

    load_resource :exhibit, class: Spotlight::Exhibit
    before_filter :build_resource, only: [:create]

    load_and_authorize_resource through: :exhibit
    helper_method :from_popup?

    def new

      @resource.attributes = resource_params if params[:resource]

      ## TODO: in Rails 4.1, replace this with a variant
      if from_popup?
        render layout: 'spotlight/popup'
      else
        render
      end
    end

    def create
      @resource.attributes = resource_params

      if @resource.save
        if from_popup?
          render layout: false, text: "<html><script>window.close();</script></html>"
        else
          redirect_to admin_exhibit_catalog_index_path(@resource.exhibit)
        end
      else
        render action: 'new'
      end
    end

    protected
    def resource_params
      params.require(:resource).permit(:url)
    end

    def build_resource
      @resource ||= @exhibit.resources.build(resource_params).becomes_provider
    end

    def from_popup?
      params.fetch(:popup, false)
    end
  end
end
