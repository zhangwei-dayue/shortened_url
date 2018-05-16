json.extract! @url, :original_url, :created_at
if @url.qr_code_stored?
  json.qr_code_url [@host, @url.qr_code.thumb('300x300#').url].join
end