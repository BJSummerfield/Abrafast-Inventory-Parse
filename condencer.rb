require 'csv'

edit = CSV.read('../csv/sa.csv')
#name = 1 Variation = 50
#Select Diameter| 5/16" Phillips Head; 3/8" Hex Head; 1/2" Hex Head; 11/16" Hex Head; ~Grip Length| .08" - .40"; .031" - .63";
#Thin Wall (TW) Bolt Zinc Nickle| Select Diameter| 5/16" Phillips Head;Grip Length| .08" - .40"
i = 0
# finishes = []
diameters =[]
lengths = []
edit.each do |item|
  if i > 1
    if item[1].include?('Anchor Size')

      # finish = 'Zinc Plated' if item[1].include?('Zinc')
      # finish = 'Mechanical Galvanized' if item[1].include?('Mech.')
      diameter = item[1].split(' ')[-3]

      length = item[1].split(' ').pop
      # p "#{diameter} - #{length}"
      diameters << diameter unless diameters.include?(diameter)
      # finishes << finish unless finishes.include?(finish)
      lengths << length unless lengths.include?(length)
      item[1] = "ConFlex Large Diameter Masonry Screw Anchor| Diameter| #{diameter};Length| #{length}"
    else
      item[52] = "True" if i != 0 || i != 1
    end
  end
  i += 1
end
p diameters
variation = ""
diameters = diameters.sort_by { |s| s.split.map(&:to_r).inject(:+)}
lengths = lengths.sort_by { |s| s.split.map(&:to_r).inject(:+)}

# variation += "Finish |"
# finishes.each do |i|
#   variation += " #{i};"
# end
# p diameters
variation += "Diameter |"
diameters.each do |i|
  variation += " #{i};"
end

variation += " ~Length|"
  lengths.each do |i|
    variation += " #{i};"
  end

edit[1][4] = nil
edit[1][50] = variation
edit[1][1] = "ConFlex Large Diameter Masonry Screw Anchor"
edit[1][25] = "Adhesive & Mechanical Anchoring Sys ~ Concrete Screw Anchors"


CSV.open("../csv/Fix.CSV", "wb") do |csv|
  edit.each do |item|
    if item[52] != 'True'
      csv << item
    end
  end
end



