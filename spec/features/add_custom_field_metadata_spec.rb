require 'spec_helper'

describe "Adding custom metadata field data" do
  let(:admin) { FactoryGirl.create(:exhibit_admin) }
  let(:custom_field) { FactoryGirl.create(:custom_field) }
  let(:config) { Spotlight::Exhibit.default.blacklight_configuration }
  before do
    login_as(admin)
    config.index_fields[custom_field.field] = { enabled: true, show: true }
    config.save!
  end

  it "should work" do
    visit spotlight.exhibit_catalog_path(Spotlight::Exhibit.default, "gn425sk0502")

    expect(page).to have_link "Enter curation mode."

    click_on "Enter curation mode."

    fill_in "Some Field", with: "My new custom field value"

    click_on "Save changes"

    expect(::SolrDocument.find("gn425sk0502").sidecar(Spotlight::Exhibit.default).data).to include "field_name" => "My new custom field value"

    visit spotlight.exhibit_catalog_path(Spotlight::Exhibit.default, "gn425sk0502")

    expect(page).to have_content "Some Field"
    expect(page).to have_content "My new custom field value"

  end
end
