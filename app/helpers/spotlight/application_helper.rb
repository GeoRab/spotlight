module Spotlight
  module ApplicationHelper
    include CrudLinkHelpers
    include TitleHelper

    def application_name
      name = super

      if current_exhibit
        t :'spotlight.application_name', exhibit: current_exhibit.title, application_name: name
      else
        name
      end
    end

    # Can search for named routes directly in the main app, omitting
    # the "main_app." prefix
    def method_missing method, *args, &block
      if main_app_url_helper?(method)
        main_app.send(method, *args)
      else
        super
      end
    end

    def respond_to?(method)
      main_app_url_helper?(method) or super
    end

    def url_for_document document
      return nil if document.nil?

      if current_exhibit
        spotlight.exhibit_catalog_path(current_exhibit, document)
      else
        document
      end
    end

    def url_to_tag_facet tag
      if current_exhibit
        search_action_url(add_facet_params(Spotlight::SolrDocument.solr_field_for_tagger(current_exhibit), tag, {}))
      else
        search_action_url(q: tag)
      end
    end

    def should_render_index_field? document, field 
      super && field_enabled?(field)
    end

    def should_render_show_field? document, field
      super && field_enabled?(field, :show)
    end

    ##
    # TODO remove this when we use blacklight 5.2+
    # Returns a document presenter for the given document
    def presenter(document)
      presenter_class.new(document, self)
    end

    ##
    # Override Blacklight (5.2+) so we use our own presenter
    def presenter_class
      Spotlight::DocumentPresenter
    end
    private

    def field_enabled? field, view = nil
       field.enabled && field.send(view || document_index_view_type)
    end

    def main_app_url_helper?(method)
        (method.to_s.end_with?('_path') or method.to_s.end_with?('_url')) and
        main_app.respond_to?(method)
    end
  end
end
