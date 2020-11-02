class Station
  attr_reader :trains_on_station

  def initialize(name)
    @name = name
    @trains_on_station = []
  end

  def add_train(train)
    @trains_on_station << train
  end

  def trains_based_on_type(type)
    if type == 'freight'
      return @trains_on_station.select { | train | train.type == 'freight' }
    elsif type == 'passenger'
      return @trains_on_station.select { | train | train.type == 'passenger' }
    end
  end
end


class Train
  attr_reader :type, :speed, :wagons

  def initialize(type, wagons)  # type = freight or passenger
    @number = ('a'..'z').to_a.shuffle[0,8].join
    @type = type
    @wagons = wagons
    @speed = 0
  end

  def speed_increase
    @speed += 10
  end

  def stop
    @speed = 0
  end

  def attach_wagon
    if @speed == 0
      @wagons += 1
    else
      puts "Для этого действия поезд должен стоять на месте"
    end
  end

  def unattach_wagon
    if @speed == 0
      @wagon -= 1
    else
      puts "Для этого действия поезд должен стоять на месте"
    end
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


class Route
  attr_accessor :all_stations

  def initialize(start, finish)
    @start = start
    @finish = finish
    @intermediate = []
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
