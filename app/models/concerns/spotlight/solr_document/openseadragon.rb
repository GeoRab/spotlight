module Spotlight::SolrDocument::Openseadragon
  def to_openseadragon
    # TODO get height and width from the image
    Openseadragon::Image.new(id: stanford_document_id, height: 400, width: 800)
  end

  protected

    def stanford_document_id
      if md = /.+\/image\/(\w+\/\w*)_full/.match(full_image_url)
        return CGI.escape(md[1])
      end
    end

    def full_image_url
      self['full_image_url_ssm'].first
    end
end
