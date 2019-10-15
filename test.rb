require 'csv'
original_products = CSV.read('../csv/edit.csv')

@item_name = 'CS Unitec 10 Series Once-Touch TCT Annular Cutter'
@itemV = {'Cutter Size' => [],'Depth' => []}
@item_short_desc = 'Various Cutter Sizes & Depths Available'
@item_catagory = 'Power Tools and Accessories ~ Portable Magnetic Drills, Annular Cutters & Step Drill Kits ~ CS Unitec Annular Cutters'
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
  item['Name'] = item['Name'].gsub('  ', " ")
  item['Name'] = item['Name'].gsub('2-3/4 -', '2-3/4" x ')
  item['Name'] = item['Name'].gsub('2-5/8 -', '2-5/8" x ')
  item['Name'] = item['Name'].gsub('2-1/2 -', '2-1/2" x ')
  item['Name'] = item['Name'].gsub('2-7/16 -', '2-7/16" x ')
  item['Name'] = item['Name'].gsub('2-3/8 -', '2-3/8" x ')
  item['Name'] = item['Name'].gsub('2-3/8 -', '2-3/8" x ')
  item['Name'] = item['Name'].gsub('2-5/16 -', '2-5/16" x ')
  item['Name'] = item['Name'].gsub('2-1/4 -', '2-1/4" x ')
  item['Name'] = item['Name'].gsub('2-3/16 -', '2-3/16" x ')
  item['Name'] = item['Name'].gsub('2-1/8 -', '2-1/8" x ')
  item['Name'] = item['Name'].gsub('2-1-3/8"', '2" x 1-3/8"')
  item['Name'] = item['Name'].gsub('2-2-3/8"', '2" x 2-3/8"')
  item['Name'] = item['Name'].gsub('2-1/16 -', '2-1/16" x ')
  item['Name'] = item['Name'].gsub('2-2-3/8"', '2" x 3/8"')
  item['Name'] = item['Name'].gsub('1-15/16-', '1-15/16" x ')
  item['Name'] = item['Name'].gsub('1-7/8-', '1-7/8" x ')
  item['Name'] = item['Name'].gsub('1-13/16-', '1-13/16" x ')
  itemV['Cutter Size'] = item['Name'].split(' ')[-4]
  if itemV['Cutter Size'] == 'Cutter'
    p item['Name']
  end
  @itemV['Cutter Size'] << itemV['Cutter Size'] unless @itemV['Cutter Size'].include?(itemV['Cutter Size'])
  item['vars']['Depth'] = item['Name'].split(' ')[-2]
  @itemV['Depth'] << itemV['Depth'] unless @itemV['Depth'].include?(itemV['Depth'])
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

