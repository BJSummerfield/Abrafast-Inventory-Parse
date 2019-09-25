
require 'csv'

cat = CSV.read('../csv/catagor.CSV')

id_check = []
cat.each do |item1|
  if id_check.include?(item1[0])
    else
      id_check << item1[0]
      cat.each do |item2|
      if item1[1].to_s == item2[1].to_s && item1[0] != item2[0]
        id_check << item2[0]
        if item1[15] != 'True'
          i = 4
          while i <= 15
            item2[i] = item1[i]
            i += 1
          end
          item1[17] = "True"
        end
      end
    end
  end
end

CSV.open("../csv/catagory.CSV", "wb") do |csv|
  cat.each do |web_item|
    csv << web_item
  end
end





