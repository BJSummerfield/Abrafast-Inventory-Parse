require 'csv'
wp = CSV.read('../csv/wp101719.csv')
cp = CSV.read('../csv/cp01.csv')

def runner(cp, wp)
  cp = convert_to_hash(cp)
  wp = convert_to_hash(wp)
  # convert_categories(cp)
  convert_products(wp)
end

def convert_categories(cp)
  convertUrl(cp)
  convert_c_title(cp)
  write_file(cp,'newCata')
end

def convert_products(wp)
  prod_convert_url(wp)
  convert_p_title(wp)
  write_file(wp,'newProd')
end

def prod_convert_url(wp)
  i = 0
  wp.each do |prod|
    if i != 0 && prod['Name'] != nil && prod['Categories'] != nil && prod['Enabled'] != 'False'
      edit = []
      prod['Categories'].gsub('~',"/").gsub(',','').gsub('"','').split(' ').each { |word| edit << word.capitalize}
      edit << '/'
      prod['Name'].gsub('  ',' ').gsub('(','').gsub(')','').gsub(',','').gsub('"','').split(' ').each { |word| edit << word.capitalize}
      a = prod['ProductUrl'].split('.COM/')
      a[1] = edit.join('')
      prod['ProductUrl'] = a.join('.COM/')
    end
    i += 1
  end
end


def convert_to_hash(cp)
  original = []
  cp.each do |product|
    original << Hash[cp[0].zip(product.map)]
  end
  return original
end

def convert_c_title(cp)
  i = 0
  cp.each do |cata|
    if i != 0 && cata['Name'] != nil && cata['Hidden'] != 'True'
      edit = []
      cata['Name'].split(' ').each { |word| edit << word}
      edit = edit.join(' ') + " | Abrafast"
      cata['PageTitle'] = edit
    end
    i += 1
  end
end

def convert_p_title(wp)
  i = 0
  wp.each do |prod|
    if i != 0 && prod['Name'] != nil && prod['Categories'] != nil && prod['Enabled'] != 'False'
      edit = []
      prod['Name'].split(' ').each { |word| edit << word}
      edit = edit.join(' ') + " | " + prod['Categories'].split(' ~ ').last
      prod['MetaTitle'] = edit
    end
    i += 1
  end
end

def convertUrl(cp)
  i = 0
  cp.each do |cata|
    if i != 0 && cata['Name'] != nil && cata['Hidden'] != 'True'
      edit = []
      cata['CategoryPath'].gsub('~',"/").split(' ').each { |word| edit << word.capitalize}
      cata['FriendlyURL'] = edit.join("")
    end
    i += 1
  end
end

def write_file(cp, filename)
  CSV.open("../csv/#{filename}.csv", "wb") do |csv|
    cp.each do |item|
      input = []
      item.each do |key , value|
        input << value
      end
      csv << input
    end
  end
end



runner(cp, wp)
  # cp.each do |cata|
  #   p cata


  # CSV.open("../csv/test.CSV", "wb") do |csv|
  #   edit.each do |item|
  #       csv << item
  #   end
  # end
