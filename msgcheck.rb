
require 'csv'
qb = CSV.read('../csv/qb100319.csv', :encoding => 'windows-1251:utf-8')
web = CSV.read("../csv/wp100419.csv")

# web.each do |item|
#   if item[47] != "" && item[47].include?('$') && item[45] == "True"
#     message = item[47].split(" ")
#     message.each do |word|
#     multiple = 0
#       if word.to_i != 0
#         multiple = word
#       end
#       if multiple != 0
#         p " #{item[4]} - multiple = #{multiple} - #{item[47]}"
#       end
#     end
#   end
# end

web.each do |item|
  p item[4]

end

# CSV.open("../csv/edit1.CSV", "wb") do |csv|
#   web.each do |item|
#     csv << item
#   end
# end




# the_item = ""
# master = []
# p web[0][0]
# i = 0
# web[0].length.times do
#   array = []
#   array << web[0][i]
#   master << array
#   i+=1
# end

# i = 0
# array = []
# web.each do |item|
#     if item[4].include?("")
#       the_item = item
#     end
# end

# i = 0
# the_item.length.times do
#   master[i] << the_item[i]
#   i += 1
# end
# master.each do |item|
#   p item
# end





# p web[2]
# def write_file(web)
#   CSV.open("../csv/SSimport.csv", "wb") do |csv|
#     web.each do |item|
#         csv << web[0]
#         if item[4].include?("BB-12-BBSS3750-2.375")
#             csv << item
#         end
#     end
#   end
# end

# write_file(web)


# def check_message(web_item)
#   if item[47].split("$").last.to_i
#   end


#   if web_item[47] != ""
#     puts "Fixing Price Message"
#     msg = web_item[47]
#     msg = msg.split(" ")
#     msg.pop
#     msg << "$#{'%.2f' % $qbCP}"
#     msg = msg.join(" ")
#     puts "#{web_item[47]} -> #{msg}"
#     puts "*********************"
#     web_item[47] = msg
#     puts "\n"
#     puts "\n"
#   end
# end



