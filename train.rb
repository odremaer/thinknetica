require_relative 'route'
require_relative 'wagon'

class Train
  attr_reader :type, :speed

  def initialize(number, type, wagon)  # type = freight or passenger
    @number = number
    @type = type
    @wagons << wagon
    @speed = 0
  end

  def speed_increase
    @speed += 10
  end

  def stop
    @speed = 0
  end

  def choose_route(route)
    @route = route
    @current_location = 0
  end

  def move_forward
    @current_location += 1
  end

  def move_backward
    @current_location -= 1
  end

  def previous_station
    if @route.all_stations.length == 0
      puts "Станций нет"
    else
      puts "Предыдущая станция - #{@route.all_stations[@current_location-1]}"
    end
  end

  def current_station
    if @route.all_stations.length == 0
      puts "Станций нет"
    else
      puts "Текущая станция - #{@route.all_stations[@current_location]}"
    end
  end

  def next_station
    if @route.all_stations.length == 0
      puts "Станций нет"
    else
      puts "Следующая станция - #{@route.all_stations[@current_location+1]}"
    end
  end
end

class PassengerTrain < Train
  def initialize(number, type, wagon)
    super
    @type = 'passenger'
  end
end

class CargoTrain < Train
  def initialize(number, type, wagon)
    super
    @type = 'cargo'
  end
end
