class Wagon
  # protected стоит по двум причинам:
  # 1 - на стороне пользователя эти методы должны быть недоступны, ибо они нужны только на программном уровне
  # 2 - чтобы использовать метод type в дочерних классах (с private тоже будет работать, но
  #     в руби договорились использовать для таких целей protected)

  protected

  attr_reader :type
end

class CargoWagon < Wagon
  protected

  def initialize
    @type = 'cargo'
  end
end

class PassengerWagon < Wagon
  protected

  def initialize
    @type = 'passenger'
  end
end
