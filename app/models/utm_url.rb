class UtmUrl < ApplicationRecord
  validates_presence_of :original_url, :utm_source, :utm_medium, :utm_campaign, :utm_content, :utm_url
  validates_format_of :original_url, with: /\A(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?/ix, message: "输入的网址是无效的"

  def find_duplicate
    UtmUrl.find_by_utm_url(self.utm_url)
  end

  def new_utm_url?
    find_duplicate.nil?
  end

  def generate_utm_url
    source = self.source + '&' if self.source.present?
    source_link_type = 'sourceLinkType=' + self.source_link_type + '&' if self.source_link_type.present?
    source_obj_id = 'sourceObjID=' + self.source_obj_id + '&' if self.source_obj_id.present?

    source ||= ''
    source_link_type ||= ''
    source_obj_id ||= ''
    joiner = self.original_url.include?('?') ? '&' : '?'

    self.utm_url = (self.original_url + joiner + source + source_link_type + source_obj_id + 'utm_source=' + self.utm_source.to_s + '&utm_medium=' + self.utm_medium.to_s + '&utm_campaign=' + self.utm_campaign.to_s + '&utm_content=' + self.utm_content.to_s).gsub(/\s+/, "")
  end
end
