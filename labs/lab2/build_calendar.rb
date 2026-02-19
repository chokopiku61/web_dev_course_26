require 'date'

if ARGV.size < 4
  puts "НЕПРАВИЛЬНЫЙ ВЫЗОВ!"
  exit 1
end

unless File.exist?(ARGV[0])
  puts "ОШИБКА! Файл '#{ARGV[0]}' не найден"
  exit 1
end
commands = []
File.open(ARGV[0], 'r') do |file|
  file.each_line do |line|
    commands << line.gsub(/^\d+\.\s*/, "").strip
  end
end

d1 = Date.parse(ARGV[1])
d2 =  Date.parse(ARGV[2])

if d1 > d2
  puts "ОШИБКА! (#{d1}) позже чем (#{d2})"
  exit 1
end

all_matchs = []
(0..commands.size-1).step(2) do |i|
  all_matchs << "#{commands[i]} vs #{commands[i + 1]}"
end
(1..commands.size-2).step(2) do |i|
  all_matchs << "#{commands[i]} vs #{commands[i + 1]}"
end
j = 2
while j < commands.size
  i = 0
  (j..commands.size-1).each do |k|
    all_matchs << "#{commands[i]} vs #{commands[k]}"
    i += 1
  end
  j += 1
end

puts "Всего матчей: #{all_matchs.size}"

games_date = []
d1.upto(d2) do |date|
  if date.friday? || date.saturday? || date.sunday?
    games_date << date  
  end
end

total_slots = games_date.size * 3 * 2
if all_matchs.size > total_slots
  puts "ОШИБКА: Нужно #{all_matchs.size} слотов, доступно #{total_slots}"
  exit 1
end

matches_per_day = all_matchs.size.to_f / games_date.size
puts "Среднне кол-во матчей в день: #{matches_per_day}"


File.open(ARGV[3], 'w') do |f|
  games_date.each_with_index do |date, i|
    start_idx = (i * matches_per_day).to_i
    end_idx = ((i + 1) * matches_per_day).to_i
    days_matches = all_matchs[start_idx...end_idx]
    hours =  date.sunday? ? [12, 15, 18] : [18, 15, 12]
    days_matches.each_with_index do |match, match_idx|
      f << "#{date} #{hours[match_idx % 3]}:00 |   #{match}\n"
    end
  end
end

puts "Заполение окончено."