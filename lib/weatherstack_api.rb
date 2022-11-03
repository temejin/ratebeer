class WeatherstackApi
  def self.weather_in(city)
    city = city.downcase
    Rails.cache.fetch("#{city}Weather", expires_in: 3.hour) { get_weather_in(city) }
  end

  def self.get_weather_in(city)
    params = {
      access_key: key,
      query: city,
      units: 'm'
    }
    url = URI('http://api.weatherstack.com/current')
    url.query = URI.encode_www_form(params)
    response = HTTParty.get(url)
    weather_info = response.parsed_response['current']
    return nil if weather_info.nil?

    Weather.new(weather_info)
  end

  def self.key
    return nil if Rails.env.test?
    raise 'WEATHERSTACK_APIKEY env variable not defined' if ENV['WEATHERSTACK_APIKEY'].nil?

    ENV.fetch('WEATHERSTACK_APIKEY')
  end
end
