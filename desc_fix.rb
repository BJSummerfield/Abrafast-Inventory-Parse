require 'csv'

wp = CSV.read('../csv/wordpress.csv')
ns = CSV.read('../csv/wp102819.csv')

@import_array = []

@import_array << wp[0]

def runner (wp, ns)
  wp.each do |wp_item|
    matched_items = find_match(wp_item, ns)
    qty = get_qty(matched_items[1][47])
    if matched_items[0][1] == 'variation'
      p "#{qty} - #{matched_items[0][3]}"
      matched_items[0][8] = "<p>#{qty}</p>"
      @import_array << matched_items[0]
    end
  end
  writefile(@import_array)
end

def writefile(array)
  CSV.open("../csv/desc_fix.CSV", "wb") do |csv|
    array.each do |item|
      csv << item
    end
  end
end

def get_qty(pm)
  if pm != nil
    split = pm.split(' ')
    if split[0].to_i != 0
      return "#{pm.split(' = ')[0]}"
    elsif split[-3].to_i == 0
      return 'Sold Individually'
    elsif split[-3].to_i != 0
      return "Sold In Quantities of #{split[-3]}" if split[-3].to_i != 1
      return "Sold Individually" if split[-3].to_i == 1
    end
  end
end

def find_match(wp_item, ns)
  ns.each do|ns_item|
    if wp_item[2] == ns_item[4]
      return [wp_item, ns_item]
    end
  end
end

runner(wp, ns)

