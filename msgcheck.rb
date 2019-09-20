
require 'csv'
qb = CSV.read('../csv/quickbooks.csv', :encoding => 'windows-1251:utf-8')
web = CSV.read("../csv/webproducts.csv")

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
# i = 0
web.each do |item|
    if item[47] != ""
  puts "#{item[4]}  ::   #{item[47]}"
#   if item[47] != ""
#     sample = item[47]

#     sample = sample.split(" ")
#     sample = sample.last.split("$")
#     sample = sample.pop
#     if sample.to_i == item[13].to_i
#       puts 'true'
#     end
#     p "#{sample} #{item[13]}"
#     sample = sample.join(" ")
#     p "#{sample} :: #{item[4]} :: #{item[13]}"
#     i += 1
#   end
    end
end

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



