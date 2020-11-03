require_relative 'train'

class Station
  attr_reader :trains_on_station, :name

  def initialize(name)
    @name = name
    @trains_on_station = []
  end

  def add_train(train)
    @trains_on_station << train
  end

  def trains_based_on_type(type)
    if type == 'cargo'
      return @trains_on_station.select { | train | train.type == 'cargo' }
    elsif type == 'passenger'
      return @trains_on_station.select { | train | train.type == 'passenger' }
    end
  end
end
