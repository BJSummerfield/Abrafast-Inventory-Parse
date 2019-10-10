require 'csv'
edit = CSV.read('../csv/sa.csv')

i = 0
edit.each do |item|
  if i > 0
    if i ==1
      item[50] = item[50].split(' ')
      2.times do
        item[50].pop
      end
      item[50] = item[50].join(' ')
    else
     item[1] = item[1].gsub('5_1/2', '5-1/2') if item[1].include?('5_1/2')
     item[1] = item[1].gsub('6_1/4', '6-1/4') if item[1].include?('6_1/4')
    end
  end
  i += 1
end

CSV.open("../csv/test.CSV", "wb") do |csv|
  edit.each do |item|
      csv << item
  end
end
