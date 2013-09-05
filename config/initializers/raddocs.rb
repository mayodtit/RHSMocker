Raddocs.configure do |config|
  # output dir from RAD
  config.docs_dir = Rails.root.join("tmp", "docs")

  # Should be in the form of text/vnd.com.example.docs+plain
  config.docs_mime_type = /text\/docs\+plain/

  config.use_http_basic_auth = true
  config.http_basic_auth_username = ENV['API_DOCS_USERNAME']
  config.http_basic_auth_password = ENV['API_DOCS_PASSWORD']
end
