require_relative 'station'
require_relative 'train'
require_relative 'route'


stations = []
station_names = []
while true do
  print "Зайдите в выбранную категорию(нажмите на нужную цифру):\n"\
        "(1) - действия со станциями\t (2) - действия с поездами\n"\
        "(3) - действия с маршрутами\t (0) - выход\n"
  STDOUT.flush
  key = gets.chomp
  if key == '0'
    break
  end
    if key == '1'
      # создавать станции, просмотреть список станций и список поездов на станции
      print "Категория: действия со станциями\n"\
            "(1) - cоздать станцию\t (2) - просмотреть список станций\n"\
            "(3) - просмотреть список поездов на станции\t (0) - назад\n"
      key = gets.chomp
      if key == '1'
        print "Введите имя станции: "
        name = gets.chomp
        station = Station.new(name)
        stations << station
        station_names << station.name
      elsif key == '2'
        print "#{station_names}\n"
      elsif key == '3'
        print "Введите имя станции, на которой вы хотите посмотреть список поездов: "
        name = gets.chomp
        index = station_names.index(name)
        if station_names.include?(name)
          trains_on_current_station = stations[index].trains_on_station
          if trains_on_current_station.length == 0
            "\n На этой станции нет поездов"
          else
            print "#{trains_on_current_station}\n"
          end
        else
          print "Такой станции не существует\n"
        end
      end

    elsif key == '2'
      # создать поезд, назначить маршрут поезду, добавить вагон к поезду, отцепить вагон от поезда, перемещать поезда
      # vpered nazad
      print "Категория: действия с поездами\n"\
            "(1) - cоздать поезд\t (2) - назначить маршрут\n"\
            "(3) - добавить вагон\t (4) - отцепить вагон\n"\
            "(5) - переместить поезд вперед\t (6) - переместить поезд назад\n"\
            "(0)- назад\n"
      key = gets.chomp
      if key == '1'

      end
    elsif key == '3'
      print "Категория: действия с маршрутами\n"\
            "(1) - cоздать маршрут\t (2) - добавить станцию в маршрут\n"\
            "(3) - удалить станцию из маршрута\t (4) - назначить маршрут поезду\n"\
            "(0)- назад\n"
      key = gets.chomp
    elseif key == '0'
      break
    end
end
