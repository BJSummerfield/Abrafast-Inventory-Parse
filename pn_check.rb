require 'csv'
edit = CSV.read('../csv/edit.csv')

i = 0
edit.each do |item|
  if i != 0
    item[17] = "True"
  end
  i += 1
end

CSV.open("../csv/Fix.CSV", "wb") do |csv|
  edit.each do |item|
      csv << item
  end
end
