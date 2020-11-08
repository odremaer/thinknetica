class Route
  attr_accessor :all_stations
  attr_reader :route_name
  def initialize(route_name, start, finish)
    @route_name = route_name
    @start = start
    @finish = finish
    @intermediate = []
    @all_stations = [start, finish]
  end

  def add_intermediate_station(name)
    @intermediate << name
    @all_stations = [@start] + @intermediate + [@finish]
  end

  def remove_intermediate_station(name)
    @intermediate.delete(name)
    @all_stations = [@start] + @intermediate + [@finish]
  end
end
