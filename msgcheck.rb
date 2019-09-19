require 'date'
# require 'csv'
# qb = CSV.read('items.csv', :encoding => 'windows-1251:utf-8')
# web = CSV.read("bb.csv")
# newfile = CSV.open('newfile.csv')

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

# web.each do |item|
#   if item[47] != ""
#     sample = item[47]

#     sample = sample.split(" ")
#     sample.pop
#     sample << "$5.45"
#     sample = sample.join(" ")
#     p "#{sample} :: #{item[4]}"
#   end
# end
date = DateTime.now
p "#{date.month}-#{date.day}-#{date.year}"


