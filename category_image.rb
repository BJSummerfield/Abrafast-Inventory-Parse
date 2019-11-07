puts "Cat Name"
the_name = gets.chomp
system("csvgrep -c 3 -m '#{the_name}' ../csv/ce.csv | csvcut -c 2,8")


