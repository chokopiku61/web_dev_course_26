require 'date'

comands = []
File.open(ARGV[0], 'r') do |file|
  file.each_line do |line|
    comands << line.gsub(/^\d+\.\s*/, "") 
  end
end

d1 = Date.parse(ARGV[1])
d2 = Date.parse(ARGV[2])

all_matchs = []
comands.combination(2).each do |team1, team2|
  all_matchs << "#{team1} vs #{team2}"
end

games_date = []
d1.upto(d2) do |date|
  if date.friday? || date.saturday? || date.sunday?
    games_date << date  
  end
end

puts games_date.size
days_per_match =  (games_date.size*6) / all_matchs.size.to_f
puts "Матчей в день (среднее): #{'%.2f' % days_per_match}"

