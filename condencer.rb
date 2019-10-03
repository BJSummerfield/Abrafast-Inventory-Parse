require 'csv'

edit = CSV.read('../csv/edit.csv')
#name = 1 Variation = 50
#Select Diameter| 5/16" Phillips Head; 3/8" Hex Head; 1/2" Hex Head; 11/16" Hex Head; ~Grip Length| .08" - .40"; .031" - .63";
#Thin Wall (TW) Bolt Zinc Nickle| Select Diameter| 5/16" Phillips Head;Grip Length| .08" - .40"
i = 0
p edit[1][1]
finishes = []
diameters =[]
lengths = []
edit.each do |item|
  if i > 1
    if item[1].include?('Length')
      finish = "Zinc Plated" if item[1].include?('Zinc')
      finish = "Mechanical Galvanized" if item[1].include?('Mech.')
      finish = "303/304 Stainless Steel" if item[1].include?('303/304')
      finish = "316 Stainless Steel" if item[1].include?('316')
      diameter = item[1].split(' ')[2] if item[1].include?("Wedge Anchor")
      diameter = item[1].split(' ')[3] if item[1].include?("Wedge All Anchor")
      diameter = '1/2"' if item[1].include?("Wedge  All Anchor")
      length = item[1].split(' ').pop
      diameters << diameter unless diameters.include?(diameter)
      finishes << finish unless finishes.include?(finish)
      lengths << length unless lengths.include?(length)
      item[1] = "MKT Sup-R Stud +| Finish| #{finish};Diameter| #{diameter};Length| #{length}"
    else
      item[52] = "True" if i != 0 || i != 1
    end
  end
  i += 1
end

variation = ""
diameters = diameters.sort_by { |s| s.split.map(&:to_r).inject(:+)}
lengths = lengths.sort_by { |s| s.split.map(&:to_r).inject(:+)}

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

edit[1][50] = variation
edit[1][1] = "MKT Sup-R Stud +"
edit[1][25] = "Adhesive & Mechanical Anchoring Sys ~ Wedge Anchors"


CSV.open("../csv/Fix.CSV", "wb") do |csv|
  edit.each do |item|
    csv << item
  end
end



