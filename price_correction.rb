require 'csv'
require "date"
file_name = "Web_Products"

qb = CSV.read('../csv/qb100419.csv', :encoding => 'windows-1251:utf-8')
web = CSV.read("../csv/wp100719a.csv")

date = DateTime.now
$date = "#{date.month}-#{date.day}-#{date.year}"
$new_file_name = "#{file_name}-#{$date}.csv"

def checker(web,qb)
  #Reporting information
  $no_match = []
  $items_changed = 0
  $items_checked = 0
  $matches_found = 0
  $nilPN = 0
  #Scans all web products
  web.each do |web_item|
    $web_item = web_item
    part_number_match(web_item,qb)
    if $item_found == true
    if $web_item[13] != "CustomerPrice" && $qb_item[4] != nil
      #converts the current web price & QB price to non-decimal x 100
      $webCP = ('%.2f' % $web_item[13]).delete('.').to_i
      $qbCP = ('%.2f' % $qb_item[4]).delete('.').to_i
      #checks for price message multiples
      check_multiples
      #compairs web price with inventory price
      check_price
      if $needs_fix == true
        #makes any needed corrections
        change_price
        change_price_message
        message
      end
    end
    end
  end
  report
  # write_changes(web) if $items_changed != 0
  # write_no_match(web) if $no_match.length > 0
end

def part_number_match(web_item,qb)
  $item_found = false
  #Only Searches for Enabled items and items that do not have variations
  if web_item[45] != "False" && web_item[50] == nil
    $items_checked += 1
    $webPN = web_item[4]
    if $webPN == nil
      $nilPN += 1
    end
    qb.each do |qb_item|
      $qb_item = qb_item
      #removes categories from PN from quickbooks
      qbPN = qb_item[1].split(':')[-1]
      if qbPN != nil && $webPN != nil && qbPN == $webPN
        $item_found = true
        $matches_found += 1

        break
      end
    end
    #Takes all web items that were not matched and moves them to $no_match
    if $item_found == false && $webPN != nil && web_item[0] != "ProductID"
      $no_match << web_item
    end
  end
end

def check_multiples()
  $multiples = false
  # Checks to make sure there is a price message
  if $web_item[47] != nil
    $msg_break = $web_item[47].split(" ")
    $pack_size = $msg_break[$msg_break.length - 3].to_i
    #Flags for multiples if it finds an int. where the quantities should be
    if $pack_size != 0
      $multiples = true
    end
  end
end

def check_price
  $needs_fix = false
  #Compares packsize price to QB
  if $multiples == true
    $packsize_price = $qbCP * $pack_size
    if $web_item[47].split(" ") != []
      if $webCP != $packsize_price
        $needs_fix = true
      end
    end
  else
    #Compares price of a non-varible item
    if $webCP != $qbCP
      $needs_fix = true
    end
  end
end

def change_price
  if $multiples == true
    #Converts new sell with packsize
    $new_price = '%.2f' % ($packsize_price / 100.00)
  elsif $multiples == false
    #Converts new sell solo item
    $new_price = '%.2f' % ($qbCP / 100.00)
  end
  $web_item[13] = $new_price
  $items_changed += 1
end

def change_price_message
  #changes the price in the price message
  if $web_item[47] != nil
    $msg_break[$msg_break.length - 1] = "$" + $new_price.to_s
    $web_item[47] = $msg_break.join(' ')
  end
end

def message
  puts "\n"
  puts "\n"
  puts "****************"
  puts "Discrepancy Found"
  puts "-----------------"
  puts "#{$webPN}"
  puts "-----------------"
  puts "Web Cost = $#{'%.2f' % ($webCP.to_i / 100.00)}"
  if $multiples == true
    puts "QB Cost = $#{'%.2f' % ($packsize_price / 100.00)}"
  elsif $multiples == false
    puts "QB Cost = $#{'%.2f' % ($qbCP / 100.00)}"
  end
  if $web_item[47] != nil
    puts "---------------------"
    puts "Price Message Changed"
    puts "---------------------"
    puts "#{$web_item[47]}"
  end
    puts "****************"
end

def report
  puts "\n"
  puts "\n"
  puts "---------------------"
  puts "Items Checked = #{$items_checked}"
  puts "Total Matches = #{$matches_found}"
  puts "Total nil PN = #{$nilPN}"
  puts "Total non-Match = #{$no_match.length}"
  puts "Total Items Changed = #{$items_changed}"
  puts "---------------------"
end

def write_changes(web)
  CSV.open("../csv/#{$new_file_name}", "wb") do |csv|
    web.each do |web_item|
      csv << web_item
    end
  end
  puts "***************************"
  puts "Changes Found"
  puts "Export File Saved As :: #{$new_file_name}"
  puts "***************************"
end

def write_no_match(web)
  CSV.open("../csv/Non-Matched-#{$date}.csv", 'wb') do |csv|
    csv << web[0]
    $no_match.each do |web_item|
      csv << web_item
    end
  end
  puts "***************************"
  puts "Items Not Found"
  puts "CSV File Saved As :: Non-Matched-#{$date}.csv"
  puts "***************************"
end

checker(web,qb)
