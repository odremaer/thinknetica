require_relative 'company_name'
require_relative 'accessors'
require_relative 'validation'

class Wagon
  include CompanyName
  include Accessors
  attr_accessor_with_history :capacity, :what

  include Validation
  validate :capacity, :presence
  validate :what, :presence
  validate :capacity, :format, /^[0-9]{1}$/
  validate :capacity, :check_type, String
  # protected стоит по двум причинам:
  # 1 - на стороне пользователя эти методы должны быть недоступны, ибо они нужны только на программном уровне
  # 2 - чтобы использовать метод type в дочерних классах (с private тоже будет работать, но
  #     в руби договорились использовать для таких целей protected)

  protected

  attr_reader :type
end

class CargoWagon < Wagon
  attr_reader :occupied_capacity

  def take_up_volume(amount)
    if @capacity - amount >= 0
      @capacity -= amount
      @occupied_capacity += amount
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
    if @capacity.zero?
      nil
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
