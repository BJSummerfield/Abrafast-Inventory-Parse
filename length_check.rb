require 'csv'
edit = CSV.read('../csv/sa.csv')

i = 0
edit.each do |item|
  if i > 0
    start = item[50].split('Length| ')[0]
    lengths = item[50].split('Length| ')[1]
    lengths = lengths.split('; ')
    lengths = lengths.sort_by { |s| s.split('-').map(&:to_r).inject(:+)}
    msg = "#{start}Length|"
    lengths.each do |length|
      msg += " #{length};"
    end
    item[50] = msg
  end
  i += 1
end



CSV.open("../csv/test.CSV", "wb") do |csv|
  edit.each do |item|
      csv << item
  end
end
