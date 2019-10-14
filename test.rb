require 'csv'
original_products = CSV.read('../csv/edit.csv')

@item_name = 'BOA Abrasive Grinding Belt'
@itemV = {'Width' => [], 'Grit' => []}
@item_short_desc = 'Various Widths & Grits Available <br> 30" Long - 10 Per Pack'
@item_catagory = 'Finishing and Polishing Belts & Discs ~ BOA Pipe Sander Abrasive Grinding Belts'

@original = []

def runner(original_products)
  convert_to_hash(original_products)
  delete_originals
  save_file('original')
  product_fix
  save_file('copy')
  parent_fix(create_parent)
  save_file('parent')
  merge_files
  delete_files
end

def special_case(item)
  item['vars'] = {}
  itemV = item['vars']
  itemV['Width'] = item['Name'].split(' ')[-3]
  @itemV['Width'] << itemV['Width'] unless @itemV['Width'].include?(itemV['Width'])
  item['vars']['Grit'] = item['Name'].split(' ')[4]
  item['vars']['Grit'] = item['Name'].split(' ')[4] + " Aluminum Oxide" if item['Name'].include?('Aluminum')
  @itemV['Grit'] << itemV['Grit'] unless @itemV['Grit'].include?(itemV['Grit'])
end

def parent_fix(parent)
  np = parent[1]
  np['Name'] = @item_name
  np['ShortDescription'] = @item_short_desc
  np['Catagories'] = @item_catagory
  np['Variations'] = variations
  np['ManufacturerPartNumber'] = nil
  np['ManufacturerName'] = nil
  np['PriceMessage'] = nil
  return parent
end

def variations
  var = ""
  i = @itemV.length
  @itemV.each do |key, value|
    var += "#{key} |" if i == @itemV.length
    var += "~#{key}|" if i != @itemV.length
    value.each do |v|
      var += "#{v};"
    end
    i -= 1
  end
  return var
end

def create_parent
  parent = []
  i = 0
  2.times do
    parent << @original[i]
    i += 1
  end
  return parent
end

def convert_to_hash(original_products)
  original_products.each do |product|
    @original << Hash[original_products[0].zip(product.map)]
  end
end

def delete_originals
  i = 0
  @original.each do |item|
    item['Delete'] = 'True' if i != 0
    i += 1
  end
end

def product_fix
  i = 0
  @original.each do |item|
    if i != 0
      special_case(item)
      nameloop(item)
      attribute_fix(item)
    end
    i += 1
  end
end

def attribute_fix(item)
  item['ProductID'] = nil
  item['Delete'] = 'False'
  item['StoreCost'] = '0'
end

def nameloop(item)
  i = (@itemV.length)
  item['Name'] = "#{@item_name}| "
  item['vars'].each do |key, value|
    i -= 1
    item['Name'] += "#{key}| #{value};" if i != 0
    item['Name'] += "#{key}| #{value}" if i == 0
  end
  item.delete('vars')
end

def save_file(filename)
  CSV.open("../csv/#{filename}.csv", "wb") do |csv|
    if filename != 'parent'
      @original.each do |item|
        input = []
        item.each do |key , value|
          input << value
        end
        csv << input
      end
    else i = 0
      2.times do
        input = []
        @original[i].each do |key, value|
          input << value
        end
        csv << input
        i += 1
      end
    end
  end
end

def merge_files
  system('csvstack ../csv/original.csv ../csv/parent.csv ../csv/copy.csv > ../csv/Fix.csv')
end

def delete_files
  system('rm ../csv/original.csv ../csv/parent.csv ../csv/copy.csv')
end

runner(original_products)
