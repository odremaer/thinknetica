require_relative 'company_name'

class Wagon
  attr_accessor :capacity
  # protected стоит по двум причинам:
  # 1 - на стороне пользователя эти методы должны быть недоступны, ибо они нужны только на программном уровне
  # 2 - чтобы использовать метод type в дочерних классах (с private тоже будет работать, но
  #     в руби договорились использовать для таких целей protected)

  include CompanyName
  protected
  attr_reader :type
end

class CargoWagon < Wagon
  attr_reader :occupied_capacity


  def take_up_volume(amount)
    if @capacity - amount >= 0
      @capacity -= amount
      @occupied_capacity += amount
    else
      "impossible"
    end
  end

  protected

  def initialize(capacity)
    @type = 'cargo'
    @capacity = capacity
    @occupied_capacity = 0
  end
end

class PassengerWagon < Wagon
  attr_reader :occupied_places


  def take_a_seat
    if @capacity == 0
      "impossible"
    else
    @capacity -= 1
    @occupied_places += 1
    end
  end

  protected

  def initialize(capacity)
    @type = 'passenger'
    @capacity = capacity
    @occupied_places = 0
  end
end
