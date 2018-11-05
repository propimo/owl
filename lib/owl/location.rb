class Location
  attr_reader :latitude, :longitude

  EARTH_RADIUS = 6371

  def initialize(latitude, longitude)
    if latitude.nil? ||
       longitude.nil? ||
       latitude < -90 ||
       latitude > 90 ||
       longitude < -180 ||
       longitude > 180
      raise ArgumentError.new("Invalid latitude/longitude values")
    else
      @longitude, @latitude = longitude.to_f, latitude.to_f
    end
  end

  def distance_to(other_location)
    return 0 if self == other_location

    lon1 = longitude
    lat1 = latitude
    lon2 = other_location.longitude
    lat2 = other_location.latitude

    d_lat = to_rad(lat2 - lat1)
    d_lon = to_rad(lon2 - lon1)

    a = Math.sin(d_lat / 2) * Math.sin(d_lat / 2) +
        Math.cos(to_rad(lat1)) * Math.cos(to_rad(lat2)) *
        Math.sin(d_lon / 2) * Math.sin(d_lon / 2)
    c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a))

    EARTH_RADIUS * c
  end

  def ==(other_location)
    other_location.class == self.class && longitude = other_location.longitude && latitude == other_location.latitude
  end

  def to_s
    "#{latitude}, #{longitude}"
  end

  def to_a
    [latitude, longitude]
  end

  private
    def to_rad(num)
      num * Math::PI / 180
    end
end
