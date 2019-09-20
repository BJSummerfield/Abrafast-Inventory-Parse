require 'csv'
require "date"
file_name = "BlindBolt"

date = DateTime.now
date = "#{date.month}-#{date.day}-#{date.year}"
$new_file_name = "#{file_name}-#{date}.csv"
qb = CSV.read('../csv/quickbooks.csv', :encoding => 'windows-1251:utf-8')
web = CSV.read("../csv/pearl.csv")

$items_checked = 0
$items_changed = 0
$qbPN = 0
$qbCP = 0
$webPN = 0
$webCP = 0
$msg = ""
$needs_fix = false
$msg_needs_fix = false

def runner_code(web, qb)
  web.each do |web_item|
    part_number_match(web_item, qb)
    $items_checked += 1
  end
  report
  if $items_changed > 0
    # write_file(web)
  end
end

def part_number_match(web_item, qb)
  qb.each do |qb_item|
    enabled = web_item[45]
    $qbPN = qb_item[1].split(/:/)[1]
    $webPN = web_item[4]
    if $qbPN == $webPN
      price_check(web_item, qb_item)
    end
  end
end

def price_check(web_item, qb_item)
  $msg = web_item[47]
  $webCP = web_item[13].delete('.').to_i
  $webCP = $webCP / 10000.00
  $qbCP = qb_item[4].to_f
  if $webCP != $qbCP
    $needs_fix = true
    check_multiples(web_item, qb_item)
  end
  if $needs_fix == true
    $items_changed += 1
    #check multiples
    puts "*********************"
    puts "Discrepancy Found ::"
    puts "#{$webPN}"
    puts "Web = $#{$webCP} -> QB = $#{$qbCP}"
    price_change(web_item, qb_item)
    check_message(web_item)
    $needs_fix = false
  end
end

def check_multiples(web_item, qb_item)
  msg_break = $msg.split(' ')

  if msg_break != []
    if $webCP.to_f == $qbCP.to_f * msg_break[4].to_i
      $needs_fix = false
    end
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
  $msg_needs_fix = false
  $msg = web_item[47]
  msg_break = $msg.split(' ')
  if $msg != "" && $qbCP.to_f * msg_break[4].to_i == msg_break.last.split('$').last.to_f
    multiple_msg(web_item, msg_break)
  elsif $msg != "" && msg_break.last.split('$').last.to_f != $qbCP
    # p msg_break.last.split('$').last.to_f
    # puts "#{$qbCP}"
    basic_msg(web_item, msg_break)
  end
  if $msg_needs_fix == true
    puts "Fixing Price Message"
    puts "#{web_item[47]} -> #{$msg}"
    puts "*********************"
    web_item[47] = $msg
    puts "\n"
    puts "\n"
  end
end

def multiple_msg(web_item, msg_break)
  msg_break.pop
  msg_break << "$#{'%.2f' % ($qbCP * msg_break[4].to_f)}"
  $msg = msg_break.join(" ")
  $msg_needs_fix = true
end

def basic_msg(web_item, msg_break)
  msg_break.pop
  msg_break << "$#{'%.2f' % $qbCP}"
  $msg = msg_break.join(" ")
  $msg_needs_fix = true
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
