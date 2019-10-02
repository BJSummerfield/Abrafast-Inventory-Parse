require 'csv'

edit = CSV.read('../csv/edit.csv')
#name = 1 Variation = 50
i = 0

edit.each do |item|
  if i == 0
  end
  if i == 1
    item[50] = item[50].gsub('Carbon Steel', 'Zinc Plated')
    p item[50]
    # item[1] = "Drop In Anchor Coil Thread"
    # item[50] = 'Diameter| 1/2"; 3/4";'
  end
  if i >= 1
    item[1] = item[1].gsub('Carbon Steel', 'Zinc Plated')
    # puts item[1]
    # change = item[1].split(' ')
    # thing = change.delete_at(3)
    # change[-1] = change[-1] + "| Diameter| #{thing};"
    # change = change.join(" ")
    # item[1] = change
    # p item[1]
  end
    # item[5] = "'0" if i != 0
    # item[9] = "'0" if i != 0
    # item[14] = "'0" if i != 0
    # item[16] = "'1" if i != 0
    # item[17] = "'0" if i != 0
    # item[23] = "" if i == 1

  i += 1

end

# CSV.open("../csv/Fix.CSV", "wb") do |csv|
#   edit.each do |item|
#     csv << item
#   end
# end

# puts edit[1][50]


