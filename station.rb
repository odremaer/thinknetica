require_relative 'train'
require_relative 'instance_counter'
require_relative 'validation'

class Station
  attr_reader :name

  include InstanceCounter

  STATION_NAME_FORMAT = /^[a-z]+$/i.freeze
  include Validation
  validate :name, :format, STATION_NAME_FORMAT
  validate :name, :presence

  @@stations = []

  def self.all
    @@stations
  end

  def self.add_obj(station)
    @@stations << station
  end

  def initialize(name)
    @name = name
    validate!
    register_instance
  end

  def trains_on_station
    Train.trains.each do |train|
      yield(train)
    end
  end
end
