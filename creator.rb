require 'csv'
edit = CSV.read('../csv/edit.csv')
system("csvgrep -c 2 -m '' ../csv/edit.csv > ../csv/original.csv")
original = CSV.read('../csv/original.csv')
# catagories = CSV.read('../csv/cat.csv')

item_name = "FIX Hook & Loop TZ Pyramid Disc"
#name = 1 Variation = 50
#Select Diameter| 5/16" Phillips Head; 3/8" Hex Head; 1/2" Hex Head; 11/16" Hex Head; ~Grip Grit| .08" - .40"; .031" - .63";
#Thin Wall (TW) Bolt Zinc Nickle| Select Diameter| 5/16" Phillips Head;Grip Grit| .08" - .40"
# cats = 'BOA Pipe Sander Abrasive Grinding Belts'
discs = []
grits = []
variation = ""
 i = 0
edit.each do |item|
  if i != 0
    item[0] = nil
    item[1] = item[1].gsub('  ', ' ')
    grit = item[1].split('x ')[-1]
    disc = item[1].split(' ')[7]

    grits << grit unless grits.include?(grit)
    discs << disc unless discs.include?(disc)
    item[1] = "#{item_name}| Disc Size| #{disc};Grit| #{grit}"
    item[14] = "0"
  end
  i += 1
end

# newfile = []
# catagories.each do |cata|
#   if cata[1] == 'Name'
#     newfile << cata
#   end
#   if cata[1] == cats
#     cata[17] = 'True'
#     newfile << cata
#   end
# end


# CSV.open("../csv/newcata.csv", 'wb') do |csv|
#   newfile.each do |item|
#     csv << item
#   end
# end


CSV.open("../csv/FIX.CSV", "wb") do |csv|
  edit.each do |item|
      csv << item
  end
end

# grits = grits.sort_by { |s| s.split('-').map(&:to_r).inject(:+)}

variation += "Disc Size |"
discs.each do |i|
  variation += " #{i};"
end

variation += "~Grit|"
grits.each do |i|
  variation += " #{i};"
end
p discs
p grits
# variation += " ~Diameter|"
# diameters.each do |i|
#   variation += " #{i};"
# end
#desciption
edit[1][2] = 'Various Disc Sizes & Grits Available <br>10 Per Pack'
themsg = edit[1][3].split('">')
# edit[1][3] = edit[1][3].gsub(' 220 Grit', "")
edit[1][0] = nil
edit[1][47] = nil
edit[1][24] = nil
edit[1][23] = nil
edit[1][13] = nil
edit[1][4] = nil
edit[1][52] = 'False'
edit[1][50] = variation
edit[1][1] = item_name
edit[1][25] = 'Finishing and Polishing Belts & Discs ~ BOA Pipe Sander Abrasive Grinding Belts'
# edit[1][25] = "Structural Products ~ Structural Bolts"

CSV.open("../csv/var.CSV", "wb") do |csv|
  csv << edit[0]
  csv << edit[1]
end

original.each do |item|
  if item[52] != "Delete"
    item[52] = 'True'
  end
end

CSV.open("../csv/original1.CSV", "wb") do |csv|
  original.each do |item|
    csv << item
  end
end
system("csvstack ../csv/var.CSV ../csv/FIX.CSV ../csv/original1.csv > ../csv/fix1.csv")
system("rm ../csv/var.csv ../csv/original1.csv ../csv/original.csv ../csv/fix.csv")




