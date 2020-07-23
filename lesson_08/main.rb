require_relative "route"
require_relative "station"
require_relative "train_passenger"
require_relative "train_cargo"
require_relative "wagon_passenger"
require_relative "wagon_cargo"

routes = []

loop do
  system("clear")
  puts "\
0. Создать данные
1. Создать станции
2. Создать поезда
3. Создать маршрут
4. Назначить маршрут
5. Прицепить вагоны
6. Отцепить вагоны
7. Переместить поезд
8. Список станций и поездов
9. Занять место или объём в вагоне
00. Выход"
  print"> "

  answer = gets.chomp
  system("clear")

  case answer
    when "0"
      Station.new("Голутвин")
      Station.new("Луховицы")
      Station.new("Кривандино")
      Station.new("Курская")
      Station.new("Кусково")
      Station.new("Реутово")
      Station.new("Фрязево")
      Station.new("Павловский Посад")
      Station.new("Люблино-Сортировочное")
      Station.new("Царицыно")
      Station.new("Серпухов")
      PassengerTrain.new("ПАС-01")
      PassengerTrain.new("ПАС-02")
      PassengerTrain.new("ПАС-03")
      CargoTrain.new("ГРЗ-01")
      CargoTrain.new("ГРЗ-02")
      Train.find("ПАС-01").attach(PassengerWagon.new(20))
      Train.find("ПАС-01").attach(PassengerWagon.new(25))
      Train.find("ПАС-02").attach(PassengerWagon.new(20))
      Train.find("ПАС-02").attach(PassengerWagon.new(25))
      Train.find("ПАС-03").attach(PassengerWagon.new(20))
      Train.find("ПАС-03").attach(PassengerWagon.new(30))
      Train.find("ПАС-03").attach(PassengerWagon.new(30))
      Train.find("ГРЗ-01").attach(CargoWagon.new(100))
      Train.find("ГРЗ-01").attach(CargoWagon.new(110))
      Train.find("ГРЗ-01").attach(CargoWagon.new(110))
      Train.find("ГРЗ-01").attach(CargoWagon.new(100))
      Train.find("ГРЗ-02").attach(CargoWagon.new(100))
      Train.find("ГРЗ-02").attach(CargoWagon.new(120))
      Train.find("ГРЗ-02").attach(CargoWagon.new(120))
      Train.find("ГРЗ-02").attach(CargoWagon.new(100))
      routes.append(Route.new(Station.find("Голутвин"), Station.find("Курская")))
      routes.last.add_station(Station.find("Луховицы"))
      routes.last.add_station(Station.find("Кривандино"))
      routes.append(Route.new(Station.find("Кривандино"), Station.find("Павловский Посад")))
      routes.last.add_station(Station.find("Курская"))
      routes.last.add_station(Station.find("Кусково"))
      routes.last.add_station(Station.find("Реутово"))
      routes.last.add_station(Station.find("Фрязево"))
      routes.append(Route.new(Station.find("Голутвин"), Station.find("Серпухов")))
      routes.last.add_station(Station.find("Кривандино"))
      routes.last.add_station(Station.find("Кусково"))
      routes.last.add_station(Station.find("Фрязево"))
      routes.last.add_station(Station.find("Люблино-Сортировочное"))
      routes.append(Route.new(Station.find("Голутвин"), Station.find("Серпухов")))
      routes.last.add_station(Station.find("Реутово"))
      routes.append(Route.new(Station.find("Кривандино"), Station.find("Люблино-Сортировочное")))
      Train.find("ПАС-01").route = routes[0]
      Train.find("ПАС-02").route = routes[1]
      Train.find("ПАС-03").route = routes[2]
      Train.find("ГРЗ-01").route = routes[3]
      Train.find("ГРЗ-02").route = routes[4]
      Train.find("ПАС-02").move_forward
      Train.find("ПАС-03").move_forward
      Train.find("ПАС-03").move_forward
      Train.find("ПАС-03").move_forward
      Train.find("ГРЗ-01").move_forward
      Train.find("ГРЗ-01").move_forward
      Train.find("ГРЗ-02").move_forward
      puts "Тестовые данные созданы"
      puts "Нажмите [Enter] для выхода..."
      gets

    when "1"
      puts "Введите станции:"
      loop do
        begin
          name = gets.chomp
          break if name.empty?   # Признак окончания ввода списка станций
          Station.new(name)
        rescue RuntimeError => ex
          puts ex.message
          retry
        end
      end

    when "2"
      puts "Введите пассажирские поезда в формате XXX-XX:"
      loop do
        begin
          name = gets.chomp
          break if name.empty?   # Признак окончания ввода списка поездов
          train = PassengerTrain.new(name)
          puts "Создан поезд #{train.name}"
        rescue RuntimeError => ex
          puts ex.message
          retry
        end
      end

      puts "Введите грузовые поезда в формате XXX-XX:"
      loop do
        begin
          name = gets.chomp
          break if name.empty?   # Признак окончания ввода списка поездов
          train = CargoTrain.new(name)
          puts "Создан поезд #{train.name}"
        rescue RuntimeError => ex
          puts ex.message
          retry
        end
      end

    when "3"
      buffer = []
      puts "Введите станции маршрута:"
      loop do
        name = gets.chomp
        break if name.empty?   # Признак окончания ввода списка станций
        station = Station.find(name)
        if !station
          puts "Станция не найдена"
        else
          buffer << station
        end
      end
      begin
        routes.append(Route.new(buffer.first, buffer.last))
        buffer[1..buffer.size - 2].each { |name| routes.last.add_station(name) }
      rescue RuntimeError => ex
        puts ex.message
        puts
        puts "Нажмите [Enter] для выхода..."
        gets
      end

    when "4"
      train = nil
      puts "Введите название поезда:"
      loop do
        name = gets.chomp
        break if name.empty?
        train = Train.find(name)
        break if train
        puts "Поезд не найден"
      end
      if train
        puts "Введите номер маршрута (начиная с единицы):"
        loop do
          route = gets.chomp.to_i
          break if route == 0
          if routes[route - 1]
            train.route = routes[route - 1]
            break
          else
            puts "Маршрут не найден"
          end
        end
      end

    when "5"
      train = nil
      puts "Введите название поезда:"
      loop do
        name = gets.chomp
        break if name.empty?
        train = Train.find(name)
        break if train
        puts "Поезд не найден"
      end
      if train
        puts "Введите количество прицепляемых вагонов:"
        n = gets.to_i
        if train.class == CargoTrain
          puts "Введите объём каждого вагона:"
          n.times { train.attach(CargoWagon.new(gets.to_i)) }
        elsif train.class == PassengerTrain
          puts "Введите количество мест для каждого вагона:"
          n.times { train.attach(PassengerWagon.new(gets.to_i)) }
        end
      end

    when "6"
      train = nil
      puts "Введите название поезда:"
      loop do
        name = gets.chomp
        break if name.empty?
        train = Train.find(name)
        break if train
        puts "Поезд не найден"
      end
      if train
        puts "Введите количество отцепляемых вагонов:"
        gets.chomp.to_i.times do
          if train.class == CargoTrain
            train.detach(train.wagons.last)
          elsif train.class == PassengerTrain
            train.detach(train.wagons.last)
          end
        end
      end

    when "7"
      train = nil
      puts "Введите название поезда:"
      loop do
        name = gets.chomp
        break if name.empty?
        train = Train.find(name)
        break if train
        puts "Поезд не найден"
      end
      if train
        puts "Маршрут:"
        train.route.stations.each { |station| puts station.name }
        puts "Поезд на станции:"
        puts train.route.stations[train.cur_station_index].name
        puts "Куда переместить? (""<"", "">"")"
        loop do
          direction = gets.chomp
          case direction
            when ">"
              train.move_forward
            when "<"
              train.move_backward
            when ""
              break
          end
          puts train.route.stations[train.cur_station_index].name
        end
      end

    when "8"
      Station.all.each do |name, station|
        puts "#{name}"
        station.each_train do |train|
          puts "    #{train.class} #{train.name} (#{train.wagons.size})"
          train.each_wagon do |i, wagon|
            puts "        #{wagon.class} #{i} (свободно #{wagon.free}, занято #{wagon.occupied})"
          end
        end
      end
      puts
      puts "Нажмите [Enter] для выхода..."
      gets

    when "9"
      train = nil
      puts "Введите название поезда:"
      loop do
        name = gets.chomp
        break if name.empty?
        train = Train.find(name)
        break if train
        puts "Поезд не найден"
      end
      if train
        wagon = nil
        puts "#{train.class} (#{train.wagons.size})"
        puts "Введите номер вагона:"
        loop do
          number = gets.to_i
          wagon = train.wagons[number - 1]
          break if wagon
          puts "Такого вагона нет"
        end
        case wagon.class.to_s
          when "PassengerWagon"
            begin
              wagon.take
            rescue RuntimeError => ex 
              puts ex.message
              puts "Нажмите [Enter] для выхода..."
              gets
            end
          when "CargoWagon"
            puts "Свободно #{wagon.free}"
            puts "Введите загружаемый объём:"
            begin
              wagon.take(gets.to_i)
            rescue RuntimeError => ex
              puts ex.message
              retry
            end
        end
      end      

    when "00"
      break
  end
end
