require 'csv'
edit = CSV.read('../csv/a490canada.csv')
#name = 1 Variation = 50
#Select Diameter| 5/16" Phillips Head; 3/8" Hex Head; 1/2" Hex Head; 11/16" Hex Head; ~Grip Length| .08" - .40"; .031" - .63";
#Thin Wall (TW) Bolt Zinc Nickle| Select Diameter| 5/16" Phillips Head;Grip Length| .08" - .40"
i = 0
finishes = ['Plain']
diameters =[]
lengths = []
variation = ""
edit.each do |item|
  if i >= 1
    if item[1].include?('Length')
      finish = 'Plain' if item[1].include?('Plain')
      finish = 'Hot Dipped Galvanized' if item[1].include?('Galvanized')
      item[1] = item[1].gsub('  ', ' ')
      item[1] = item[1].gsub('- 9','-9')
      item[1] = item[1].gsub('- 8','-8')
      item[1] = item[1].gsub('- 7','-7')

      diameter = item[1].split(' ')[4]
      length = item[1].split(' ').pop
      diameters << diameter unless diameters.include?(diameter)
      finishes << finish unless finishes.include?(finish)
      lengths << length unless lengths.include?(length)
      item[1] = "A490 Heavy Hex Bolt - Canadian| Finish| #{finish};Diameter| #{diameter};Length| #{length}"
    else
      item[52] = "True"
    end
  end
  i += 1
end

diameters = diameters.sort_by { |s| s.split('"')[0].split('-').map(&:to_r).inject(:+)}
lengths = lengths.sort_by { |s| s.split('-').map(&:to_r).inject(:+)}

variation += "Finish |"
finishes.each do |i|
  variation += " #{i};"
end

variation += " ~Diameter|"
diameters.each do |i|
  variation += " #{i};"
end

variation += " ~Length|"
lengths.each do |i|
    variation += " #{i};"
end
edit[1][0] = nil
edit[1][4] = nil
edit[1][52] = 'False'
edit[1][50] = variation
edit[1][1] = "A490 Heavy Hex Bolt - Canadian"
edit[1][25] = "Structural Products ~ Structural Bolts"

CSV.open("../csv/FIX.CSV", "wb") do |csv|
  edit.each do |item|
      csv << item
  end
end



