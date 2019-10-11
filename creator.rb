require 'csv'
edit = CSV.read('../csv/edit.csv')

item_name = "PTX TZ Pyramid Belt (Closed)"
#name = 1 Variation = 50
#Select Diameter| 5/16" Phillips Head; 3/8" Hex Head; 1/2" Hex Head; 11/16" Hex Head; ~Grip Grit| .08" - .40"; .031" - .63";
#Thin Wall (TW) Bolt Zinc Nickle| Select Diameter| 5/16" Phillips Head;Grip Grit| .08" - .40"

grits = []
variation = ""
 i = 0
edit.each do |item|
  if i != 0
    item[1] = item[1].gsub('  ', ' ')
    grit = item[1].split('x ')[-1]
    grits << grit unless grits.include?(grit)
    item[1] = "#{item_name}| Grit| #{grit}"
    item[14] = "0"
  end
  i += 1
end

CSV.open("../csv/FIX.CSV", "wb") do |csv|
  edit.each do |item|
      csv << item
  end
end

# grits = grits.sort_by { |s| s.split('-').map(&:to_r).inject(:+)}

variation += "Grit |"
grits.each do |i|
  variation += " #{i};"
end

# variation += " ~Diameter|"
# diameters.each do |i|
#   variation += " #{i};"
# end
#desciption
edit[1][2] = '1.2" Wide x 24" Long <br> Various Grits Available <br> 10 Per Pack'
themsg = edit[1][3].split('">')
# edit[1][3] = '<p><span style="font-size: large;">1.2" Wide x 24" Long <br /><br /></span><span style="font-size: large;">For coarse and initial grinding, rust removal and smoothing round metal pipes. For use with grinding belt rollers. Can be used on closed pipe constructions.</span></p>'
edit[1][0] = nil
edit[1][47] = nil
edit[1][24] = nil
edit[1][23] = nil
edit[1][13] = nil
edit[1][4] = nil
edit[1][52] = 'False'
edit[1][50] = variation
edit[1][1] = item_name
# edit[1][25] = "Structural Products ~ Structural Bolts"

CSV.open("../csv/var.CSV", "wb") do |csv|
  csv <<edit[0]
  csv << edit[1]
end

system("csvstack ../csv/var.CSV ../csv/FIX.CSV > ../csv/fix1.csv")
# system("csvstack ../csv/var.CSV ../csv/FIX.CSV > fix1.csv")




