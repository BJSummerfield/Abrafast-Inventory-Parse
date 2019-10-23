require 'csv'

ns_db = CSV.read('../csv/wp102319.csv')
wp_db = CSV.read('../csv/wordscheema.csv')


@ns_db_hash = []
@wp_db_hash = []

def runner(ns_db, wp_db)
  convert_to_hash(ns_db)
  create_import_hash(wp_db)
  export_products
end

def export_products
  @ns_db_hash.each do |product|
    if product['Enable'] == 'True'
      @export_array = {}
      export_id(product)
      export_type(product)
      export_sku(product)
      export_name(product)
      export_published(product)
      export_featured(product)
      export_visibility(product)
      export_short_description(product)
      export_description(product)
      export_extras(product)
      export_weight(product)
      export_extras1(product)
      export_categories(product)
      export_extras2(product)
      export_images(product)
      export_extras3(product)
      export_attributes(product)

      @wp_db_hash << @export_array
    end
  end
end

def export_attributes(product)
end

def export_extras3(product)
  @export_array['Download limit'] = nil
  @export_array['Download expiry days'] = nil
  @export_array['Parent'] = nil
  @export_array['Grouped products'] = nil
  @export_array['Upsells'] = nil
  @export_array['Cross-sells'] = nil
  @export_array['External URL'] = nil
  @export_array['Button text'] = nil
  @export_array['Position'] = 0
end


def export_images(product)
  @export_array['Images'] = nil
end

def export_extras2(product)
  @export_array['Tags'] = nil
  @export_array['Shipping class'] = nil
end

def export_categories(product)
  if product['Categories']
    @export_array["Categories"] = product['Categories'].gsub('~',">") + ', Uncategorized'
  else
    @export_array['Categories'] = nil
  end
end

def export_extras1(product)
@export_array['Length (in)'] = nil
@export_array['Width (in)'] = nil
@export_array['Height (in)'] = nil
@export_array['Allow customer reviews?'] = 1
@export_array['Purchase note'] = nil
@export_array['Sale price'] = nil
@export_array['Regular price'] = product['CustomerPrice']
end

def export_weight(product)
  major = product['WeightMajor']
  minor = product['WeightMinor']
  @export_array['Weight (lbs)'] = major.to_f + minor.to_f / 16
end

def export_extras(product)
  @export_array['Date sale price starts'] = nil
  @export_array['Date sale price ends'] = nil
  @export_array['Tax status'] = 'taxable'
  @export_array['Tax class'] = nil
  @export_array['In stock?'] = 1
  @export_array['Stock'] = nil
  @export_array['Low stock amount'] = nil
  @export_array['Backorders allowed?'] = 0
  @export_array['Sold individually?'] = 0
end


def export_description(product)
  @export_array['Description'] = product["LongDescription"]
end

def export_short_description(product)
  qty = price_message(product['PriceMessage'])
  mfg = product['ManufacturerName'] if product['ManufacturerName'] != nil
  mfgpn = product['ManufacturerPartNumber'] if product['ManufacturerPartNumber'] != nil
  write_short_desc(qty, mfg, mfgpn)
end

def write_short_desc(qty, mfg, mfgpn)
  msg = ""
  msg += "<p>Manufacturer: #{mfg}</p>" if mfg
  msg += "<p>Manufacturer Part Number: #{mfgpn}</p>" if mfgpn
  msg += "<p>Quantity: #{qty}</p>" if qty
  @export_array['Short description'] = msg
end

def price_message(pm)
  return '1' if pm == nil
  split = pm.split(' ')
  return "#{pm.split(' = ')[0]}" if split[0].to_i != 0
  return '1' if split[-3].to_i == 0
  return "#{split[-3]}" if split[-3].to_i != 0
end

def export_visibility(product)
  @export_array['Visibility in catalog'] = 'visible'
end

def export_featured(product)
  @export_array['Is featured?'] = 0
end

def export_published(product)
  @export_array['Published'] = 1
end

def export_name(product)
  product['Name'] = product['Name'].gsub(' - ', '-')
  if @export_array['Type'] == 'simple' || @export_array['Type'] == 'variable'
    @export_array['Name'] = product['Name']
  else
    variable = product['Name'].count('|') - 1
    i = 2
    new_name = product['Name'].gsub(';','| ').split('| ')
    @export_array['Name'] = new_name[0] +' - '
    variable.times do
      @export_array['Name'] = @export_array['Name'] + new_name[i] if i == 2
      @export_array['Name'] = @export_array['Name'] + ", " + new_name[i] if i != 2
      i += 2
    end
  end
end

def export_sku(product)
  @export_array['SKU'] = product['PartNumber']
end

def export_type(product)
  if product['Name'].include?('|')
    @export_array['Type'] = 'variation'
  elsif product['Variations'] != nil
    @export_array['Type'] = 'variable'
  else
    @export_array['Type'] = 'simple'
  end
end

def export_id(product)
  @export_array['ID'] = nil
end

def create_import_hash(db)
  db.each do |product|
    product
    @wp_db_hash << Hash[db[0].zip(product.map)]
  end
end

def convert_to_hash(db)
  db.each do |product|
    product
    @ns_db_hash << Hash[db[0].zip(product.map)]
  end
end

runner(ns_db, wp_db)
# p @wp_db_hash[5]
#  @wp_db_hash.each do |product|
#   p "#{product["Type"]} - #{product['Name']}"
# end




 # ['Download limit']
 # ['Download expiry days']
 # ['Parent']
 # ['Grouped products']
 # ['Upsells']
 # ['Cross-sells']
 # ['External URL']
 # ['Button text']
 # ['Position']
 # ['Attribute 1 name']
 # ['Attribute 1 value(s)']
 # ['Attribute 1 visible']
 # ['Attribute 1 global']
 # ['Attribute 2 name']
 # ['Attribute 2 value(s)']
 # ['Attribute 2 visible']
 # ['Attribute 2 global']
 # ['Attribute 3 name']
 # ['Attribute 3 value(s)']
 # ['Attribute 3 visible']
 # ['Attribute 3 global']
