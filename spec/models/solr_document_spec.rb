require 'spec_helper'

describe SolrDocument do
  subject { ::SolrDocument.new(id: 'abcd123') }
  its(:to_key) {should == ['abcd123']}
  its(:persisted?) {should be_true}

  it "should have tags on the exhibit" do
    expect(subject.tags_from(Spotlight::Exhibit.default)).to be_empty
  end

  it "should be able to add tags" do
    expect {
      Spotlight::Exhibit.default.tag(subject, with: "paris, normandy", on: :tags)
    }.to change { ActsAsTaggableOn::Tag.count}.by(2)
    subject.tags_from(Spotlight::Exhibit.default).should eq ['paris', 'normandy']
  end

  it "should have find" do
    expect(::SolrDocument.find('pz918yt4565')).to be_kind_of SolrDocument
  end

  describe "#sidebar" do
    it "should return a sidecar for adding exhibit-specific fields" do
      expect(subject.sidecar(Spotlight::Exhibit.default)).to be_kind_of Spotlight::SolrDocumentSidecar
    end
  end

  describe "#update" do
    it "should store sidecar data on the sidecar object" do
      mock_sidecar = double
      subject.stub(sidecar: mock_sidecar)
      mock_sidecar.should_receive(:update).with(data: { 'a' => 1 })
      subject.update Spotlight::Exhibit.default, sidecar: { data: { 'a' => 1 }}
    end
    it "should store tags" do
      subject.update Spotlight::Exhibit.default, exhibit_tag_list: "paris, normandy"
      subject.tags_from(Spotlight::Exhibit.default).should eq ['paris', 'normandy']
    end
  end
end

