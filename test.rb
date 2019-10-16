require 'csv'
original_products = CSV.read('../csv/edit.csv')

@item_name = 'Blind Bolt A4 Stainless Steel'
@itemV = {'Finish' => [],'Bolt Diameter & Length' => []}
@item_short_desc = 'Available in 304 & 316 Stainless Steel'
@item_catagory = 'Blind Bolts ~ Blind Bolt'
@original = []

def runner(original_products)
  convert_to_hash(original_products)
  delete_originals
  save_file('original')
  product_fix
  save_file('copy')
  variation_sort
  parent_fix(create_parent)
  save_file('parent')
  merge_files
  delete_files
  p @original[1]['Variations']
end

def special_case(item)
  item['vars'] = {}
  itemV = item['vars']
  itemV['Bolt Diameter & Length'] = item['Name'].split('| ')[-1]
  @itemV['Bolt Diameter & Length'] << itemV['Bolt Diameter & Length'] unless @itemV['Bolt Diameter & Length'].include?(itemV['Cutter Size'])
  item['vars']['Finish'] = "316 Stainless Steel"
  item['vars']['Finish'] = "304 Stainless Steel" if item['Name'].include?('3/8')

  @itemV['Finish'] << itemV['Finish'] unless @itemV['Finish'].include?(itemV['Finish'])
end

def parent_fix(parent)
  np = parent[1]
  np['Name'] = @item_name
  np['ShortDescription'] = @item_short_desc
  np['Categories'] = @item_catagory
  np['Variations'] = variations
  np['ManufacturerPartNumber'] = nil
  np['ManufacturerName'] = nil
  np['PriceMessage'] = nil
  np['PartNumber'] = nil
  np['Delete'] = "False"
  np['ProductID'] = nil
  return parent
end

def variation_sort
  @itemV.sort_by do |k,v|
    @itemV[k] = v.sort_by {|s| s.split('-').map(&:to_r).inject(:+)}
  end
end

def variations
  var = ""
  i = @itemV.length
  @itemV.each do |key, value|
    var += "#{key} |" if i == @itemV.length
    var += " ~#{key}|" if i != @itemV.length
    value.each do |v|
      var += " #{v};"
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
    if i != 0 && item['Variations'] == nil
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
  system('csvstack ../csv/parent.csv ../csv/original.csv ../csv/copy.csv > ../csv/Fix.csv')
end

def delete_files
  system('rm ../csv/original.csv ../csv/parent.csv ../csv/copy.csv')
end

runner(original_products)

