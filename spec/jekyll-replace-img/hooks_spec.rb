# frozen_string_literal: true

RSpec.describe JekyllReplaceImg do
  let(:site_config) do
    overrides["replace_img"] = plugin_config if plugin_config
    overrides
  end
  let(:overrides) { {} }
  let(:plugin_config) { nil }
  let(:site) { fixture_site("site", site_config) }
  let(:page) { page_by_path(site, "page.md") }
  let(:html_page) { page_by_path(site, "html-page.html") }
  let(:post) { doc_by_path(site, "_posts/2016-01-01-test.md") }

  subject { described_class.new(site.config) }

  before(:each) do
    site.reset
    site.read
  end

  context "generating" do
    before { site.render }

    it "should replace images" do
      img = page.css("hy-img")[0]
      expect(img).not_to be_nil
    end

    it "should copy the attributes" do
      img = page.css("hy-img")[0]
      expect(img.attributes).not_to be_nil
    end

    it "should copy the correct attributes" do
      img = page.css("hy-img")[0]
      expect(img.attributes["src"].value).to eql "https://via.placeholder.com/150"
      expect(img.attributes["alt"].value).to eql "An image"
    end

    it "should have a noscript child" do
      img = page.css("hy-img")[0]
      expect(img.css("noscript")).not_to be_nil
    end

    it "should ignore ignored images" do
      img = page.css("img[data-ignore]")[0]
      hy_img = page.css("hy-img[data-ignore]")[0]
      expect(img).not_to be_nil
      expect(hy_img).to be_nil
    end

    context "custom replacement" do
      let(:plugin_config) { { "replacement" => "<progressive-img %<attributes>s />" } }

      it "should replace images" do
        expect(page.css("progressive-img")[0]).not_to be_nil
      end

      it "should copy the attributes" do
        img = page.css("progressive-img")[0]
        expect(img.attributes).not_to be_nil
      end

      it "should copy the correct attributes" do
        img = page.css("progressive-img")[0]
        expect(img.attributes["src"].value).to eql "https://via.placeholder.com/150"
        expect(img.attributes["alt"].value).to eql "An image"
      end
    end

    context "custom regex and replacement" do
      let(:plugin_config) do
        {
          "re_img"      => "<img.*?src=\"(?<src>.*?)\".*?/>",
          "replacement" => "<progressive-img src=\"%<src>s\" />",
        }
      end

      it "should replace images" do
        img = page.css("progressive-img")[0]
        expect(img).not_to be_nil
      end

      it "should copy the attributes" do
        img = page.css("progressive-img")[0]
        expect(img.attributes).not_to be_nil
      end

      it "should copy the correct attributes" do
        img = page.css("progressive-img")[0]
        expect(img.attributes["src"].value).to eql "https://via.placeholder.com/150"
        expect(img.attributes["alt"]).to be_nil
      end
    end

    context "custom ignore" do
      let(:plugin_config) do
        {
          "re_ignore" => "via.placeholder.com",
        }
      end

      it "should ignore the images" do
        expect(page.css("hy-img")[0]).to be_nil
      end
    end
  end
end
