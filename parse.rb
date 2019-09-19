require 'csv'
require "date"
file_name = "BlindBolt"

date = DateTime.now
date = "#{date.month}-#{date.day}-#{date.year}"
$new_file_name = "#{file_name}-#{date}.csv"
qb = CSV.read('../csv/quickbooks.csv', :encoding => 'windows-1251:utf-8')
web = CSV.read("../csv/bb.csv")

$items_checked = 0
$items_changed = 0
$qbPN = 0
$qbCP = 0
$webPN = 0
$webCP = 0

def runner_code(web, qb)
  web.each do |web_item|
    part_number_match(web_item, qb)
    $items_checked += 1
  end
  report
  if $items_changed > 0
    write_file(web)
  end
end

def part_number_match(web_item, qb)
  qb.each do |qb_item|
    enabled = web_item[45]
    $qbPN = qb_item[1].split(/:/)[1]
    $webPN = web_item[4]
    if $qbPN == $webPN && enabled == "True"
      price_check(web_item, qb_item)
    end
  end
end

def price_check(web_item, qb_item)
  $webCP = web_item[13].delete('.').to_i
  $webCP = $webCP / 10000.00
  $qbCP = qb_item[4].to_f
  if $webCP != $qbCP
    $items_changed += 1
    #check multiples
    puts "*********************"
    puts "Discrepancy Found ::"
    puts "#{$webPN}"
    puts "Web = $#{$webCP} -> QB = $#{$qbCP}"
    price_change(web_item, qb_item)
    check_message(web_item)
  end
end

def price_change(web_item, qb_item)
  puts "------------------"
  puts "Fixing Discrepancy"
  web_item[13] = '%.2f' % $qbCP.to_s
  puts "Web = $#{web_item[13]} <- QB = $#{$qbCP}"
  puts "------------------"
end

def check_message(web_item)
  if web_item[47] != ""
    puts "Fixing Price Message"
    msg = web_item[47]
    msg = msg.split(" ")
    msg.pop
    msg << "$#{'%.2f' % $qbCP}"
    msg = msg.join(" ")
    puts "#{web_item[47]} -> #{msg}"
    puts "*********************"
    web_item[47] = msg
    puts "\n"
    puts "\n"
  end
end

def report
  puts "Total Items Checked :: #{$items_checked}"
  puts "Total Items Changed :: #{$items_changed}"
  puts "\n"
end

def write_file(web)
  CSV.open("../csv/#{$new_file_name}", "wb") do |csv|
    web.each do |web_item|
      csv << web_item
    end
  end
  puts "***************************"
  puts "File Saved As :: #{$new_file_name}"
  puts "***************************"
end

runner_code(web, qb)
