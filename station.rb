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
end
