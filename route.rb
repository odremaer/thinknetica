require_relative 'instance_counter'

class Route
  attr_accessor :all_stations
  attr_reader :route_name, :intermediate

  include InstanceCounter

  def initialize(start, finish)
    @start = start
    @finish = finish
    @intermediate = []
    @all_stations = [start, finish]
    register_instance
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
