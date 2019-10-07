require 'csv'
require "date"
file_name = "Web_Products"

date = DateTime.now
date = "#{date.month}-#{date.day}-#{date.year}"
$new_file_name = "#{file_name}-#{date}.csv"
qb = CSV.read('../csv/qb100419.csv', :encoding => 'windows-1251:utf-8')
web = CSV.read("../csv/wp100719a.csv")

$items_checked = 0
$items_changed = 0
$qbPN = 0
$qbCP = 0
$webPN = 0
$webCP = 0
$packsize_price = 0
$pack_size = 0
$needs_fix = false
$msg = ""
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
    if $qbPN != nil && $webPN != nil && $qbPN == $webPN
      price_check(web_item, qb_item)
    end
  end
end

def price_check(web_item, qb_item)
  $msg = web_item[47]
  $webCP = ('%.2f' % web_item[13]).delete('.').to_i
  $qbCP = ('%.2f' % qb_item[4]).delete('.').to_i
  if $webCP != $qbCP
    $needs_fix = true
    if $msg != "" && $msg != nil
      check_multiples(web_item, qb_item)
    end
  end
  if $needs_fix == true
    $items_changed += 1
    if $items_changed != 0
      puts "\n"
      puts "\n"
    end
    puts "*********************"
    puts "Discrepancy Found ::"
    puts "#{$webPN}"
    puts "Web = $#{'%.2f' % ($webCP / 100.00)} -> QB = $#{'%.2f' % ($qbCP / 100.00)}"
    price_change(web_item, qb_item)
    if $msg != "" && $msg != nil
      check_message(web_item)
    end
    $needs_fix = false
  end
end

def check_multiples(web_item, qb_item)
  $pack_size = 0
  msg_break = $msg.split(' ')
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


def price_change(web_item, qb_item)
  multiple_msg_addition = ""
  puts "------------------"
  puts "Fixing Discrepancy"
  if $pack_size == 0
    new_price = ($qbCP / 100.00).to_s
  end
  if $pack_size != 0
    new_price = ($packsize_price / 100.00).to_s
    multiple_msg_addition = " x #{$pack_size} pack"
  end
  web_item[13] = new_price
  puts "Web = $#{'%.2f' % web_item[13]} <- QB = $#{'%.2f' % ($qbCP / 100.00)}#{multiple_msg_addition}"
  puts "------------------"
end

def check_message(web_item)
  $msg_needs_fix = false
  $msg = web_item[47]
  msg_break = $msg.split(' ')
  if msg_break.last.split('$').last.delete('.').to_i != 0
    msg_price = ('%.2f' % msg_break.last.split('$').last).delete('.').to_i
    if $msg != "" && msg_price != $qbCP
      basic_msg(web_item, msg_break)
    end
  end
  if $msg_needs_fix == true
    puts "Fixing Price Message"
    puts "#{web_item[47]} -> #{$msg}"
    puts "*********************"
    web_item[47] = $msg
  end
end

def basic_msg(web_item, msg_break)
  msg_break.pop
  new_price = '%.2f' % ($qbCP / 100.00) if $pack_size == 0
  new_price = '%.2f' % (($pack_size * $qbCP) / 100.00) if $pack_size != 0
  msg_break << "$#{new_price}"
  $msg = msg_break.join(" ")
  $msg_needs_fix = true
end

def report
  puts "\n"
  puts "\n"
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
