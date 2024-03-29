require 'csv'

ns_db = CSV.read('../csv/wp102819.csv')
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
      export_name(product)
      export_sku(product)
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
      export_mpn(product)
      export_parent_product(product)
      export_attributes(product)

      @wp_db_hash << @export_array
    end
  end
  write_export
  fix_export
  write_sort
end

def write_sort
  CSV.open("../csv/sorted_import.csv", "wb") do |csv|
    @wp_db_hash.each do |item|
      input_array = []
      item.each do |k,v|
        input_array << v
      end
     csv << input_array
    end
  end
end

def export_mpn(product)
  @export_array['Meta: _wpm_gtin_code'] = product['ManufacturerPartNumber']
end

def fix_export
  export = CSV.read('../csv/test_import.csv')
  @wp_db_hash = []
  create_import_hash(export)
  @wp_db_hash.each do |product|
    @matchfound = false
    if product['Type'] == 'variation'
      x = pull_variations(product)
      if @matchfound == true
        attributes = sort_variations(x)
        write_attributes(product, attributes)
      end
    end
  end
end

def write_attributes(product, attributes)
  i = 0
  j = 1
  3.times do
    product["Attribute #{j} name"] = attributes[i][0]
    product["Attribute #{j} value(s)"] = attributes[i][1]
    i += 1
    j += 1
  end
end

def sort_variations(x)
  key = []
  value = []
  i = 0
  3.times do
    key << x[1][i][0]
    i += 1
  end
  key.each do |k|
    i = 0
    j = 1
    3.times do
      value << x[0][i] if x[0][i].include?(k)
      i +=1
    end
  end
  return value
end

def pull_variations(product)
  @wp_db_hash.each do |pparent|
    if product['Parent'] == pparent['SKU']
      @matchfound = true
      j = [product,pparent]
      x = []
      j.each do |unit|
        y = []
        i = 1
        3.times do
          h = []
          h << unit["Attribute #{i} name"]
          h << unit["Attribute #{i} value(s)"]
          y << h
          i += 1
        end
        x << y
      end
      return x
    end
  end
end

def write_export
  CSV.open("../csv/test_import1.csv", "wb") do |csv|
    @wp_db_hash.each do |item|
      input_array = []
      item.each do |k,v|
        input_array << v
      end
      csv << input_array
    end
  end
  system('csvsort -c 2 ../csv/test_import1.csv -I > ../csv/test_import.csv')
  system('rm ../csv/test_import1.csv')
end

def export_parent_product(product)
  if @export_array['Type'] == 'variation'
    @export_array['Parent'] = @export_array['Name'].split(' - ')[0]
  elsif @export_array['Type'] == 'variable'
    @export_array['Parent'] = nil
  elsif @export_array['Type'] == 'simple'
    @export_array['Parent'] = nil
  end
end

def export_attributes(product)
  if @export_array['Type'] == 'variable'
    extract_parent(product)
  elsif @export_array['Type'] == 'variation'
    extract_child(product)
  else
    @export_array['Attribute 1 name'] = nil
    @export_array['Attribute 1 value(s)'] = nil
    @export_array['Attribute 1 visible'] = nil
    @export_array['Attribute 1 global'] = nil
    @export_array['Attribute 2 name'] = nil
    @export_array['Attribute 2 value(s)'] = nil
    @export_array['Attribute 2 visible'] = nil
    @export_array['Attribute 2 global'] = nil
    @export_array['Attribute 3 name'] = nil
    @export_array['Attribute 3 value(s)'] = nil
    @export_array['Attribute 3 visible'] = nil
    @export_array['Attribute 3 global'] = nil
  end
end

def extract_child(product)
  var_array = extract_child_variations(product)
  i = 1
  (var_array.length/2).times do
    @export_array["Attribute #{i} name"] = var_array.shift
    @export_array["Attribute #{i} value(s)"] = var_array.shift
    @export_array["Attribute #{i} visible"] = 1
    @export_array["Attribute #{i} global"] = 0
    i += 1
  end
end

def extract_child_variations(product)
  variations = product['Name'].gsub(';','| ').split('| ')
  variations.shift
  return variations
end

def extract_parent(product)
  var_array = extract_variations(product)
  i = 1
  var_array.each do |variation|
    variation.each do |k , v|
      @export_array["Attribute #{i} name"] = k
      value_string = ""
      v.each do | value|
        if value == v.last
          value_string += value
        else
          value_string += value+", "
        end
      end
      @export_array["Attribute #{i} value(s)"] = value_string
      @export_array["Attribute #{i} visible"] = 1
      @export_array["Attribute #{i} global"] = 0
      i += 1
    end
  end
end

def extract_variations(product)
  variations = product['Variations'].split('; ~')
  var_array =[]
  variations.each do |var|
    var_hash = {}
    var = var.gsub('|  ', '| ')
    var = var.split('| ')
    values = var[1].split(';')
    values.pop if values.last == " "
    var_hash["#{var[0]}"] = values
    var_array << var_hash
  end
  return var_array
end


def export_extras3(product)
  @export_array['Download limit'] = nil
  @export_array['Download expiry days'] = nil
  @export_array['Grouped products'] = nil
  @export_array['Upsells'] = nil
  @export_array['Cross-sells'] = nil
  @export_array['External URL'] = nil
  @export_array['Button text'] = nil
  @export_array['Position'] = 0
end


def export_images(product)
  filepath = product["Name"].split(" ").join("").split('|')[0]
  filepath = filepath.gsub(' ','')
  filepath = filepath.gsub('(','')
  filepath = filepath.gsub(')','')
  filepath = filepath.gsub('/','')
  filepath = filepath.gsub('&','')
  filepath = filepath.gsub('','')
  filepath = filepath.gsub('.','')
  filepath = filepath.gsub('"','')
  filepath = filepath.gsub("'",'')
  filepath = filepath.gsub(",",'')
  filepath = filepath.gsub("#",'')
  filepath = filepath.gsub("Â°",'')

  @export_array['Images'] = "http://localhost:8000/wp-content/uploads/2019/10/#{filepath}.jpg"
end

def export_extras2(product)
  @export_array['Tags'] = nil
  @export_array['Shipping class'] = nil
end

def export_categories(product)
  if product['Categories']
    @export_array["Categories"] = product['Categories'].gsub('~',">")
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
  mfg = product['ManufacturerName']
  write_short_desc(qty, mfg)
end

def write_short_desc(qty, mfg)
  msg = ""
  msg += "<p>Manufacturer: #{mfg}</p>" if mfg != nil
  msg += "<p>Quantity: #{qty}</p>" if qty != nil
  @export_array['Short description'] = msg
  p "#{@export_array['Short description']} - #{@export_array['Name']}"
end

def price_message(pm)
  if @export_array['Type'] == 'simple'
    return nil
  end
  if @export_array['Type'] == 'variable'
    return nil
  end
  if pm != nil
    split = pm.split(' ')
    if split[0].to_i != 0
      return "#{pm.split(' = ')[0]}"
    elsif split[-3].to_i == 0
      return '1'
    elsif split[-3].to_i != 0
      return "#{split[-3]}"
    end
  end
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
  product['Name'] = product['Name'].gsub("Â°",'')
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
  @export_array['Name'] = @export_array['Name'].gsub('&','and')
end

def export_sku(product)
  if @export_array['Type'] == 'variable'
    @export_array["SKU"] = @export_array['Name']
  else
    @export_array['SKU'] = product['PartNumber']
  end
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
