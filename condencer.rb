require 'csv'
edit = CSV.read('../csv/edit.csv')
#name = 1 Variation = 50
#Select Diameter| 5/16" Phillips Head; 3/8" Hex Head; 1/2" Hex Head; 11/16" Hex Head; ~Grip Grit| .08" - .40"; .031" - .63";
#Thin Wall (TW) Bolt Zinc Nickle| Select Diameter| 5/16" Phillips Head;Grip Grit| .08" - .40"
i = 0
wheelsizes = []
diameters =[]
grits = []
variation = ""
edit.each do |item|
  if i >= 1
    if item[1].include?('Wheel Size')
      item[1] = item[1].gsub('4-1/4', '4')
      wheelsize = item[1].split(' ')[-4]
      grit = item[1].split(' ')[-2]
      diameter = '4-1/8"'
      diameters << diameter unless diameters.include?(diameter)
      wheelsizes << wheelsize unless wheelsizes.include?(wheelsize)
      grits << grit unless grits.include?(grit)
      item[1] = "PTX Interleaf (Combi) Wheel| Wheel Size| #{wheelsize};Diameter| #{diameter};Grit| #{grit}"
      item[14] = "0"
    else
      item[52] = "True"
    end
  end
  i += 1
end

diameters = diameters.sort_by { |s| s.split('"')[0].split('-').map(&:to_r).inject(:+)}
wheelsizes = wheelsizes.sort_by { |s| s.split('"')[0].split('-').map(&:to_r).inject(:+)}
grits = grits.sort_by { |s| s.split('-').map(&:to_r).inject(:+)}

variation += "Wheel Size |"
wheelsizes.each do |i|
  variation += " #{i};"
end

variation += " ~Diameter|"
diameters.each do |i|
  variation += " #{i};"
end

variation += " ~Grit|"
grits.each do |i|
    variation += " #{i};"
end
edit[1][0] = nil
edit[1][4] = nil
edit[1][52] = 'False'
edit[1][50] = variation
edit[1][1] = "PTX Interleaf (Combi) Wheel"
# edit[1][25] = "Structural Products ~ Structural Bolts"

CSV.open("../csv/FIX.CSV", "wb") do |csv|
  edit.each do |item|
      csv << item
  end
end



