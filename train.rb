require_relative 'route'
require_relative 'wagon'

class Train
  attr_reader :type, :speed, :number, :wagons

  def initialize(number, type)  # type = freight or passenger
    @number = number
    @type = type
    @speed = 0
    @wagons = []
    @current_location = 0
  end

  def wagon=(wagon)
    @wagons << wagon
  end

  def unattach_wagon
    @wagons.pop
  end

  def speed_increase
    @speed += 10
  end

  def stop
    @speed = 0
  end

  def choose_route(route)
    @current_location = 0
    @route = route
  end

  def move_forward
    if @route.all_stations.length == @current_location - 1
      @current_location = 0
    else
      @current_location += 1
    end
  end

  def move_backward
    @current_location -= 1
    if @current_location == -1
      @current_location = @route.all_stations.length - 1
  end

  def previous_station
    @route.all_stations[@current_location-1]
  end

  def current_station
    @route.all_stations[@current_location]
  end

  def next_station
    @route.all_stations[@current_location+1]
  end
end

class PassengerTrain < Train
  def initialize(number, type)
    super
    @type = 'passenger'
  end
end

class CargoTrain < Train
  def initialize(number, type)
    super
    @type = 'cargo'
  end
end
