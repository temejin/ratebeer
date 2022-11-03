class Weather < OpenStruct
  def self.rendered_fields
    [:temperature, :wind_speed, :wind_dir, :weather_icons]
  end
end
