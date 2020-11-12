require_relative 'train'
require_relative 'instance_counter'

class Station
  attr_reader :trains_on_station, :name

  include InstanceCounter

  @@stations = []

  def self.all
    @@stations
  end

  def self.add_obj(station)
    @@stations << station
  end

  def initialize(name)
    @name = name
    @trains_on_station = []
    register_instance
  end

  def add_train(train)
    @trains_on_station << train
  end
end
