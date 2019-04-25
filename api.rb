require 'uri'
require 'net/http'
require 'json'

def request(address,key)

  url = URI(address+key)
  http = Net::HTTP.new(url.host, url.port)
  http.use_ssl = true
  http.verify_mode = OpenSSL::SSL::VERIFY_NONE
  request = Net::HTTP::Get.new(url)
  request["cache-control"] = 'no-cache'
  request["postman-token"] = 'c1144cce-d324-d879-0889-c3947ad163d2'
  response = http.request(request)
  JSON response.read_body

end

address ="https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos?sol=1000"
key="&api_key=M1REUtc9ZqdjuJAOZVK1tfwpJeYzHkd8URtVUN0H"

# guarda en una variable el metodo request
connection = request(address,key)

connection = connection["photos"][0..20]

photos = connection.map{|x| x['img_src']}

def buid_web_page(photos)
html= " <html>
  <head>
  </head>
  <body>
  <ul>"
  # ciclo para recorre las imagen en el hashes
  photos.each do |photo|
  html += "<img src=\"#{photo}\">\n"
  end
  html+="</ul>
  </body>
  </html>"
  File.write('output.html', html)
end


def photos_count(connection)
  nuevo_has={}
  connection.map{|x| nuevo_has[x['camera']['name']] = 1 + nuevo_has[x['camera']['name']].to_i }
  print nuevo_has
end

buid_web_page(photos)

photos_count(connection)
