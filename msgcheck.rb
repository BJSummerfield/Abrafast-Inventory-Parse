require 'csv'
web = CSV.read("../csv/FIX.csv")
# i = 0
  web.each do |web_item|
      if web_item[1].include?('M8 x 50')
        web_item[1] = web_item[1].gsub('fits 5/16"', 'Fits 11/32"')
        # split = web_item[1].split(' M8 x 50 ')
        # p split[1]
      elsif web_item[50] != nil
        # p web_item[50]
        web_item[50] = web_item[50].gsub('(fits 5/16" Hole)','(Fits 11/32" Hole)')
        # p web_item[50]
      end

  end

CSV.open("../csv/the_fix.csv", 'wb') do |csv|
  web.each do |web_item|
    csv << web_item
  end
end


