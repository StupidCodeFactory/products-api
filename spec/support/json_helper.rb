module JsonHelper
  def parse_json_time(time_as_string)
    Time.zone.parse(time_as_string)
  end
end

RSpec.configure do |config|
  config.include JsonHelper
end
