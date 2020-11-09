require_relative 'station'
require_relative 'train'
require_relative 'route'

class Interface
  def initialize
    @trains = []
    @stations = []
    @station_names = []
    @routes = []
  end

  def main_menu
    print "Зайдите в выбранную категорию(нажмите на нужную цифру):\n"\
          "(1) - действия со станциями\t (2) - действия с поездами\n"\
          "(3) - действия с маршрутами\t (0) - выход\n"
    STDOUT.flush
    key = gets.chomp
    if key == '0'
      print "Выход\n"
    elsif key == '1'
      actions_with_stations
    elsif key == '2'
      actions_with_trains
    elsif key == '3'
      actions_with_routes
    end
  end

  def actions_with_stations
    print "\nКатегория: действия со станциями\n"\
          "(1) - cоздать станцию\t (2) - просмотреть список станций\n"\
          "(3) - просмотреть список поездов на станции\t (0) - назад\n"
    key = gets.chomp
    case key
    when '1'
      print "Введите имя станции: "
      name = gets.chomp
      station = Station.new(name)
      @stations << station
      @station_names << station.name
      actions_with_stations
    when '2'
      print "#{@station_names}\n"
      actions_with_stations
    when '3'
      trains_on_current_station = []
      print "Введите имя станции, на которой вы хотите посмотреть список поездов: "
      name = gets.chomp
      @trains.length.times do |k|
          if name == @trains[k].current_station
            trains_on_current_station << @trains[k].number
          end
      end
      if trains_on_current_station.length != 0
        print "Список номеров поездов, находящихся на текущей станции: \n"\
              "#{trains_on_current_station}"
      else
        print "На этой станции нет поездов"
      end
    actions_with_stations
    when '0'
      main_menu
    end
  end

  def actions_with_trains
    print "Категория: действия с поездами\n"\
          "(1) - cоздать поезд\t (2) - назначить маршрут\n"\
          "(3) - добавить вагон\t (4) - отцепить вагон\n"\
          "(5) - переместить поезд вперед\t (6) - переместить поезд назад\n"\
          "(0)- назад\n"
    key = gets.chomp
    case key
    when '0'
      main_menu

    when '1'
      print "Выберите тип поезда:\n"\
            "(1) - грузовой\t (2) - пассажирский\n"
      pick = gets.chomp
      if pick == '1'
        print "Введите номер поезда\n"
        train_number = gets.chomp
        train = CargoTrain.new(train_number, 'cargo')
        @trains << train
      elsif pick == '2'
        print "Введите номер поезда\n"
        train_number = gets.chomp
        train = PassengerTrain.new(train_number, 'passenger')
        @trains << train
      end
    actions_with_trains

    when '2'
      print "Введите номер поезда, для которого хотите назначить маршрут:\n"
      train_number = gets.chomp
      @trains.each do |cur_train|
        if cur_train.number == train_number
          print "Выберите маршрут, который хотите назначить этому поезду: \n"
          @routes.length.times do |k|
            print "(#{k}) - #{@routes[k].all_stations}\n"
          end
          cur_route = gets.chomp.to_i
          cur_train.choose_route(@routes[cur_route])
        else
          print "Такого поезда не существует\n"
        end
      end
    actions_with_trains

    when '3'
      print "Выберите тип вагона:\n"\
            "(1) - грузовой\t (2) - пассажирский\n"
      pick = gets.chomp
      if pick == '1'
        wagon = CargoWagon.new
        print "Введите номер поезда, к которому хотите прикрепить вагон\n"
        train_number = gets.chomp
        @trains.each do |cur_train|
          if cur_train.number == train_number
            current_train = cur_train
            if current_train.type == 'cargo'
              current_train.wagon=wagon
            else
              print "Это не грузовой поезд\n"
            end
          else
            print "Такого поезда не существует\n"
          end
        end

      elsif pick == '2'
        wagon = PassengerWagon.new
        print "Введите номер поезда, к которому хотите прикрепить вагон\n"
        train_number = gets.chomp
        @trains.each do |cur_train|
          if cur_train.number == train_number
            current_train = cur_train
            if current_train.type == 'passenger'
              current_train.wagon=wagon
            else
              print "Это не пассажирский поезд\n"
            end
          else
          print "Такого поезда не существует\n"
          end
        end
      end
    actions_with_trains

    when '4' # unattach Wagon
      print "Введите номер поезда, от которого хотите отсоединить вагон\n"
      train_number = gets.chomp
      @trains.each do |cur_train|
        if cur_train.number == train_number
          cur_train.unattach_wagon
        else
          print "Такого поезда не существует\n"
        end
      end
    actions_with_trains

   when '5' # move train forward
      print "Введите номер позда, который хотите переместить вперед: \n"
      train_number = gets.chomp
      @trains.each do |cur_train|
        if cur_train.number == train_number
          cur_train.move_forward
        else
          print "Такого поезда не существует"
        end
      end
    actions_with_trains

   when '6' # move train backward
      print "Введите номер позда, который хотите переместить вперед: \n"
      train_number = gets.chomp
      @trains.each do |cur_train|
        if cur_train.number == train_number
          cur_train.move_forward
        else
          print "Такого поезда не существует"
        end
      end
    actions_with_trains
    end
  end

  def actions_with_routes
    print "Категория: действия с маршрутами\n"\
          "(1) - cоздать маршрут\t (2) - добавить станцию в маршрут\n"\
          "(3) - удалить станцию из маршрута\t"\
          "(0)- назад\n"
    key = gets.chomp
    case key
    when '0'
      main_menu
      when '1' # create route
      print "Введите название начальной станции: "
      starting_point = gets.chomp
      if @station_names.include?(starting_point)
        print "Введите название конечной станции: "
        last_point = gets.chomp
        if @station_names.include?(last_point)
          route = Route.new(starting_point, last_point)
          @routes << route
        else
          print "Такой станции не существует\n"
        end
      else
        print "Такой станции не существует\n"
      end
    actions_with_routes

    when '2' # add station to route
      print "Выберите маршрут, к которому хотите добавить промежуточную станцию: \n"
      @routes.length.times do |k|
        print "(#{k}) - #{@routes[k].all_stations}\n"
      end
      cur_route = gets.chomp.to_i
      print "Введите название станции: "
      station_name = gets.chomp
      if @station_names.include?(station_name)
        @routes[cur_route].add_intermediate_station(station_name)
        print "Готово!\n"
      else
        print "Такой станции не существует\n"
      end
    actions_with_routes

    when '3' # remove station from route
      print "Выберите маршрут, у которого хотите удалить промежуточную станцию: \n"
      @routes.length.times do |k|
        print "(#{k}) - #{@routes[k].all_stations}"
      end
      cur_route = gets.chomp.to_i
      print "Введите название станции: "
      station_name = gets.chomp
      if @routes[cur_route].intermediate.include?(station_name)
        @routes[cur_route].remove_intermediate_station(station_name)
        print "Готово!\n"
      else
        print "Эта станция - не промежуточная\n"
      end
    actions_with_routes
    end
  end
end

Interface.new.main_menu
