require_relative 'route'
require_relative 'wagon'
require_relative 'company_name'
require_relative 'instance_counter'
require_relative 'validation'

class Train
  attr_reader :type, :speed, :number, :wagons, :route

  include CompanyName
  include InstanceCounter

  NUMBER_FORMAT = /^[a-z1-9]{3}(-[a-z1-9]{2})?$/i.freeze
  include Validation
  validate :number, :format, NUMBER_FORMAT

  @@trains = []

  def self.find(number)
    @@sought_train = @@trains.select { |train| train.number == number.to_s }
    if @@sought_train == []
      nil
    else
      @@sought_train[0]
    end
  end

  def self.add_obj(train)
    @@trains << train
  end

  def self.trains
    @@trains
  end

  def initialize(number, type)  # type = freight or passenger
    @number = number
    @type = type
    @speed = 0
    @wagons = []
    @current_location = 0
    @free_amount_of_places = 0
    validate!
    register_instance
  end

  def wagon=(wagon)
    @wagons << wagon
  end

  def unattach_wagon
    @wagons.pop
  end

  def return_wagons
    @wagons.each do |wagon|
      yield(wagon)
    end
  end

  def free_amount_of_places
    @free_amount_of_places = 0
    @wagons.each { |wagon| @free_amount_of_places += wagon.capacity }
    @free_amount_of_places
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
    if @current_location == @route.all_stations.length - 1
      nil
    else
      @current_location += 1
    end
  end

  def move_backward
    if @current_location.zero?
      nil
    else
      @current_location -= 1
    end
  end

  def previous_station
    @route.all_stations[@current_location - 1]
  end

  def current_station
    @route.all_stations[@current_location]
  end

  def next_station
    @route.all_stations[@current_location + 1]
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
