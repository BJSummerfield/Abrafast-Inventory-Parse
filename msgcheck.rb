require 'csv'
web = CSV.read("../csv/captured.csv")
i = 0
web.each do |web_item|
  if i != 0
  array = web_item[47].split(' ')
  price = array[-1]
  qty = array[-3]
  msg = "#{qty} Per Box = #{price}"
  web_item[47] = msg
  p web_item[47]
end
  i += 1
end

CSV.open("../csv/msg_fix.csv", 'wb') do |csv|
  web.each do |web_item|
    csv << web_item
  end
end


