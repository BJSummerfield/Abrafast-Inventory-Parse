require 'csv'

qb = CSV.read('../csv/qb100419.csv', :encoding => 'windows-1251:utf-8')
web = CSV.read("../csv/wp100419.csv")
$items_checked
$web_item = ""
$qb_item = ""
$webCP = ""
$qbCP = ""
$pack_size = 0
$no_match = []

def checker(web,qb)
  $items_checked = 0
  matches_found = 0
  nilPN = 0
  web.each do |web_item|
    if part_number_match(web_item,qb)
      $webCP = ('%.2f' % $web_item[13]).delete('.').to_i
      $qbCP = ('%.2f' % $qb_item[4]).delete('.').to_i
    end
    # multiple_check
  end
  puts "Items Checked = #{items_checked}"
  puts "Total Matches = #{matches_found}"
  puts "Total nil PN = #{nilPN}"
  puts "Total non-Match = #{$no_match.length}"
  # write_no_match(web)
end

def part_number_match(web_item,qb)
  item_found = false
  #Only Searches for Enabled items and items that do not have variations
  if web_item[45] != "False" && web_item[50] == nil
    $items_checked += 1
    webPN = web_item[4]
    if webPN == nil
      nilPN += 1
    end
    qb.each do |qb_item|
      qbPN = qb_item[1].split(':')[-1]
      if qbPN != nil && webPN != nil && qbPN == webPN
        item_found = true
        matches_found += 1
        $web_item = web_item
        $qb_item = qb_item
        break
      end
    end
    #Takes all web items that were not matched and moves them to $no_match
    if item_found == false && webPN != nil
      $no_match << web_item
    end
  end
end

def check_multiples()
  $pack_size = 0
  msg_break = $web_item[47].split(" ")
  $pack_size = msg_break[msg_break.length - 3].to_i
  if $pack_size != 0
    $packsize_price = $qbCP * $pack_size
    if msg_break != []
      if $webCP == $packsize_price
        $needs_fix = false
      end
    end
  end
end

def write_no_match(web)
  CSV.open("../csv/nomatch.csv", 'wb') do |csv|
    csv << web[0]
    $no_match.each do |web_item|
      csv << web_item
    end
  end
end


checker(web,qb)
