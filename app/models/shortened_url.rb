class ShortenedUrl < ApplicationRecord
  dragonfly_accessor :qr_code

  UNIQUE_ID_LENGTN = 3
  validates :original_url, presence: { message: "请输入网址" }
  validates_format_of :original_url, with: /\A(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?\z/ix, message: "输入的网址是无效的"

  before_create :generate_short_url
  def generate_short_url
    url = ([*('a'..'z'),*('A'..'Z'),*('0'..'9')]).sample(UNIQUE_ID_LENGTN).join
    old_url = ShortenedUrl.where(short_url: url).last
    if old_url.present?
      self.generate_short_url
    else
      self.short_url = url
    end
  end

  def find_duplicate
    ShortenedUrl.find_by_sanitize_url(self.sanitize_url)
  end

  def new_url?
    find_duplicate.nil?
  end

  def sanitize
    self.original_url.strip!
    self.sanitize_url = self.original_url.downcase.gsub(/(https?:\/\/)|(www\.)/, "")
    self.sanitize_url = "http://#{self.sanitize_url}"
  end
end
