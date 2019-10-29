require 'csv'

products = CSV.read('../csv/wp102819.csv')
path = '../images/products/detail'


product_images = []
products.each do |product|
  array = []
  product_name = nil
  file = nil
  if product[45] == 'True'
    file = product[40].split('/').last if product[40]
    product_name = product[1].split(" ").join("")
    product_name = product_name.split('|')[0] if product_name.include?('|')
    product_name = product_name.gsub(' ','')
    product_name = product_name.gsub('(','')
    product_name = product_name.gsub(')','')
    product_name = product_name.gsub('/','')
    product_name = product_name.gsub('&','')
    product_name = product_name.gsub('','')
    product_name = product_name.gsub('.','')
    product_name = product_name.gsub('"','')
    product_name = product_name.gsub("'",'')
    product_name = product_name.gsub(",",'')
    product_name = product_name.gsub("#",'')
    product_name = product_name.gsub("Â°",'')
    # p file
    # p product_name
    array << product_name if product_name && file
    array << file if file && product_name
    product_images << array unless product_images.include?(array)
  end
end

  product_images.each do | pn, f |
    if f != nil
    # p pn
    origin = path+'/'+f
    destination = '../new_images/'+pn+'.'+f.split('.').last
       p destination
       # p destination.gsub(f.split('.').last,'jpg')
       system("cp #{origin} #{destination}")
       if f.split('.').last == 'JPG'
        system("mv #{destination} #{destination.gsub('JPG','jpg')}")
       elsif f.split('.').last != 'jpg'
        system("sips -s format jpeg #{destination} --out #{destination.gsub(f.split('.').last,'jpg')}")
        system("rm #{destination}")
      end
    end
  end

    # if file
    #    origin = path+'/'+file
    #    destination = '../new_images/'+product_name+'.'+file.split('.').last
    #    # p destination
    #    system("cp #{origin} #{destination}")
    # end
# puts product_images.length
# p product_images[0]


