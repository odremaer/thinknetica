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
    key = gets.chomp
    case key
    when '0'
      print "Выход\n"
    when '1'
      actions_with_stations
    when '2'
      actions_with_trains
    when '3'
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
      create_station
      actions_with_stations
    when '2'
      print "#{@station_names}\n"
      actions_with_stations
    when '3'
      list_of_trains_on_station
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
          "(7) - вывести список вагонов у поезда\t (8) - занять место в пассажирском поезде\n"\
          "(9) - занять место в грузовом поезде\t (0)- назад\n"
    key = gets.chomp
    case key
    when '0'
      main_menu

    when '1'
      create_train
      actions_with_trains

    when '2'
      appoint_route
      actions_with_trains

    when '3'
      add_wagon
      actions_with_trains

    when '4'
      remove_wagon
      actions_with_trains

    when '5'
      move_train_forward
      actions_with_trains

    when '6'
      move_train_backward
      actions_with_trains

    when '7'
      show_train_wagons
      actions_with_trains

    when '8'
      take_up_place_in_passenger_train
      actions_with_trains

    when '9'
      take_up_volume_in_cargo_train
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

    when '1'
      create_route
      actions_with_routes

    when '2'
      add_station_to_route
      actions_with_routes

    when '3'
      remove_station_from_route
      actions_with_routes
    end
  end

  def create_station
    print 'Введите имя станции: '
    name = gets.chomp
    station = Station.new(name)
    @stations << station
    @station_names << station.name
    Station.add_obj(station)
    print "Успешно!\n"
  end

  def list_of_trains_on_station
    print 'Введите имя станции, на которой вы хотите посмотреть список поездов: '
    name = gets.chomp
    Station.all.each do |cur_station|
      if cur_station.name == name
        cur_station.trains_on_station { |train| puts train if train.current_station == name }
      end
    end
  end

  def create_train
    print "Выберите тип поезда:\n"\
          "(1) - грузовой\t (2) - пассажирский\n"
    pick = gets.chomp
    case pick
    when '1'
      print "Введите номер поезда\n"
      train_number = gets.chomp
      train = CargoTrain.new(train_number, 'cargo')
      @trains << train
      Train.add_obj(train)
      print "Успешно!\n"
    when '2'
      print "Введите номер поезда\n"
      train_number = gets.chomp
      train = PassengerTrain.new(train_number, 'passenger')
      @trains << train
      Train.add_obj(train)
      print "Успешно!\n"
    end
    print @trains
  end

  def appoint_route
    check_if_any_train_were_created
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
  end

  def add_wagon
    check_if_any_train_were_created
    print "Выберите тип вагона:\n"\
          "(1) - грузовой\t (2) - пассажирский\n"
    pick = gets.chomp
    case pick
    when '1'
      print "Укажите кол-во объема грузового вагона\n"
      capacity = gets.chomp
      wagon = CargoWagon.new(capacity.to_i)
      print "Введите номер поезда, к которому хотите прикрепить вагон\n"
      train_number = gets.chomp
      @trains.each do |cur_train|
        if cur_train.number == train_number
          current_train = cur_train
          if current_train.type == 'cargo'
            current_train.wagon = wagon
            print "Успешно!\n"
          else
            print "Это не грузовой поезд\n"
          end
        else
          print "Такого поезда не существует\n"
        end
      end

    when '2'
      print "Укажите кол-во мест в пассажирском вагоне\n"
      capacity = gets.chomp
      wagon = PassengerWagon.new(capacity.to_i)
      print "Введите номер поезда, к которому хотите прикрепить вагон\n"
      train_number = gets.chomp
      @trains.each do |cur_train|
        if cur_train.number == train_number
          current_train = cur_train
          if current_train.type == 'passenger'
            current_train.wagon = wagon
            print "Успешно!\n"
          else
            print "Это не пассажирский поезд\n"
          end
        else
          print "Такого поезда не существует\n"
        end
      end
    end
  end

  def remove_wagon
    check_if_any_train_were_created
    print "Введите номер поезда, от которого хотите отсоединить вагон\n"
    train_number = gets.chomp
    @trains.each do |cur_train|
      if cur_train.number == train_number
        cur_train.unattach_wagon
      else
        print "Такого поезда не существует\n"
      end
    end
  end

  def move_train_forward
    check_if_any_train_were_created
    print "Введите номер поезда, который хотите переместить вперед: \n"
    train_number = gets.chomp
    @trains.each do |cur_train|
      if cur_train.number == train_number
        if cur_train.move_forward.nil?
          print "Поезд дальше не едет, конечная станция\n"
        else
          cur_train.move_forward
          print "Успешно!\n"
        end
      else
        print 'Такого поезда не существует'
      end
    end
  end

  def move_train_backward
    check_if_any_train_were_created
    print "Введите номер поезда, который хотите переместить назад \n"
    train_number = gets.chomp
    @trains.each do |cur_train|
      if cur_train.number == train_number
        if cur_train.move_backward.nil?
          print 'Невозможно, поезд стоит на начальной станции'
        else
          cur_train.move_backward
          print "Успешно!\n"
        end
      else
        print 'Такого поезда не существует'
      end
    end
  end

  def show_train_wagons
    check_if_any_train_were_created
    print "Введите номер поезда, у которого хотите просмотреть вагоны \n"
    train_number = gets.chomp
    @trains.each do |train|
      train.return_wagons { |wagon| puts wagon } if train.number == train_number
    end
  end

  def take_up_place_in_passenger_train
    cur_train = 0
    print "Введите номер поезда, в котором хотите занять место \n"
    train_number = gets.chomp
    @trains.each do |train|
      if train.number == train_number
        take_up_place(train)
      else
        puts "Такого поезда нет\n"
      end
    end
  end

  def take_up_volume_in_cargo_train
    print "Введите номер поезда, в котором хотите занять место \n"
    train_number = gets.chomp
    @trains.each do |train|
      if train.number == train_number
        take_up_volume(train)
      else
        puts "Такого поезда нет\n"
      end
    end
  end

  def create_route
    print 'Введите название начальной станции: '
    starting_point = gets.chomp
    if @station_names.include?(starting_point)
      print 'Введите название конечной станции: '
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
  end

  def add_station_to_route
    print "Выберите маршрут, к которому хотите добавить промежуточную станцию: \n"
    @routes.length.times do |k|
      print "(#{k}) - #{@routes[k].all_stations}\n"
    end
    cur_route = gets.chomp.to_i
    print 'Введите название станции: '
    station_name = gets.chomp
    if @station_names.include?(station_name)
      @routes[cur_route].add_intermediate_station(station_name)
      print "Готово!\n"
    else
      print "Такой станции не существует\n"
    end
  end

  def remove_station_from_route
    print "Выберите маршрут, у которого хотите удалить промежуточную станцию: \n"
    @routes.length.times do |k|
      print "(#{k}) - #{@routes[k].all_stations}"
    end
    cur_route = gets.chomp.to_i
    print 'Введите название станции: '
    station_name = gets.chomp
    if @routes[cur_route].intermediate.include?(station_name)
      @routes[cur_route].remove_intermediate_station(station_name)
      print "Готово!\n"
    else
      print "Эта станция - не промежуточная\n"
    end
  end

  def take_up_volume(train)
    cur_wagon = 0
    print "Сколько объема хотите занять?\n"
    volume = gets.chomp.to_i
    cur_train = train
    if (cur_train.free_amount_of_places - volume).negative?
      print "Места нет, доступный объем - #{cur_train.free_amount_of_places}\n"
    else
      cur_train.wagons.each do |wagon|
        cur_wagon += 1
        if wagon.capacity - volume >= 0
          wagon.take_up_volume(volume)
          print "Оставшийся объем - #{cur_train.free_amount_of_places}\n"
          break
        else
          print "В #{cur_wagon} вагоне нет места\n"
        end
      end
    end
  end

  def take_up_place(train)
    cur_train = train
    if (cur_train.free_amount_of_places - 1).negative?
      puts 'Мест нет'
    else
      cur_train.wagons.each do |wagon|
        next unless wagon.capacity != 0

        wagon.take_a_seat
        print "#{cur_train.free_amount_of_places} - оставшееся место\n"
        break
      end
    end
  end

  def check_if_any_train_were_created
    if @trains.length.zero?
      print "Вы еще не создали ни одного поезда\n"
      actions_with_trains
    end
  end
end

Interface.new.main_menu
