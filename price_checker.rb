require 'csv'
qb = CSV.read('../csv/quickbooks.csv', :encoding => 'windows-1251:utf-8')
web = CSV.read("../csv/pearl.csv")

$items_checked = 0
$changed_made = 0
$qbPN = 0
$qbCP = 0
$webPN = 0
$webCP = 0

def runner_code(web, qb)
  web.each do |web_item|
    part_number_match(web_item, qb)
    $items_checked += 1
  end
  puts "Items checked :: #{$items_checked}"
  puts "Issues found :: #{$changed_made}"
end

def part_number_match(web_item, qb)
  qb.each do |qb_item|
    enabled = web_item[45]
    $qbPN = qb_item[1].split(/:/)[1]
    $webPN = web_item[4]
    if $qbPN == $webPN && enabled == "True"
      price_check(web_item, qb_item)
      $changed_made += 1
    end
  end
end

def price_check(web_item, qb_item)
  $webCP = web_item[13].delete('.').to_i
  $webCP = $webCP / 10000.00
  $qbCP = qb_item[4].to_f
  if $webCP != $qbCP
    #check multiples
    puts "#{$webPN} :: W = $#{$webCP} :: Q = $#{$qbCP}"
  end
end

runner_code(web, qb)
