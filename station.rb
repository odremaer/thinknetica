require_relative 'train'
require_relative 'instance_counter'

class Station
  attr_reader :name

  include InstanceCounter

  STATION_NAME_FORMAT = /^[a-z]+$/i.freeze

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

  def valid?
    validate!
    true
  rescue StandardError
    false
  end

  protected

  def validate!
    raise 'Вы ничего не ввели' if name.length.zero?
    raise "Некорректное имя станции\n Пример - Moscow" if name !~ STATION_NAME_FORMAT
  end
end
