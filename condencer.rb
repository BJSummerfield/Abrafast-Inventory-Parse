require 'csv'

edit = CSV.read('edit.csv')
#name = 1 Variation = 50
i = 0

# item = edit[2][1].split(' ')


# p item
# item[4] = "Wheel| Wheel Size|"
# item[7] = item[7] + ";"
# item[8] = "Hole|"

# item[9] = item[9].gsub("|",";")
# item = item.join(' ')
# item = item.gsub('; ', ';')

edit.each do |item|
  if i == 0
  end
  if i == 1
    item[1] = "Pearl Aluminum Oxide Grinding Wheel"
    item[50] = 'Wheel Size| 4-1/2" x 1/4"; 5" x 1/4"; 6" x 1/4"; 7" x 1/4"; 9" x 1/4" ~Hole| 5/8"-11; 7/8";'
  end
  if i > 1
    # Type-27 Flexible FAC Grinding Wheel| Wheel Size| 5" x 1/8";Hole| 7/8";Grit| 60 Grit
    if item[1].include?("Wheel Size")
      # puts item[1]
      item[1] = item[1].gsub('Type 27 Grinding Wheel Aluminum Oxide 1/4" Thick', 'Pearl Aluminum Oxide Grinding Wheel')
      item[1] = item[1].gsub(' x 5/8"-11 Spin On Hub', '')
      item[1] = item[1].gsub(' x 7/8" Arbor Hole', '')

      change = item[1].split(' ')
      # change[5] = "Wheel| Wheel Size|"
      change[9] = change[9] + ";"
      change[10] = "Hole|"

      change[9] = change[9].gsub("|",";")
      # change.pop
      change = change.join(' ')
      change = change.gsub('; ', ';')
      item[1] = change
      puts change
      puts item[1]
    else
      item[52] = "True"
    end
  end
  i += 1
end

CSV.open("Fix.CSV", "wb") do |csv|
  edit.each do |item|
    csv << item
  end
end

puts edit[1][50]


