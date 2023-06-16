# Requerimientos:
# 1. Crear el método request que reciba una url y retorne el hash con los resultados.
  
# 2. Crear un método llamado buid_web_page que reciba el hash de respuesta con todos los datos y construya una página web. Se evaluará la página creada con el formato dado. 

# 3. Crear un método photos_count que reciba el hash de respuesta y devuelva un nuevo hash con el nombre de la cámara y la cantidad de fotos.

require "uri"
require "json"
require "net/http"

url = URI("https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos?sol=10&api_key=xlUfk2zABb3OavcpVWR5grNc478VtNRWi9Zutzvu")

def request(url)
  url = URI(url)

  http = Net::HTTP.new(url.host, url.port)
  http.use_ssl = true
  http.verify_mode = OpenSSL::SSL::VERIFY_PEER

  request = Net::HTTP::Get.new(url)
  request["cache-control"] = "no-cache"
  request["Content-Type"] = "application/json"
  request["postman-token"] = "5f4b1b36-5bcd-4c49-f578-75a752af8fd5"

  response = http.request(request)
  return JSON.parse(response.body)
end
# La variable data está recibiendo la asignacion de los datos solicitados de la API
data = request("https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos?sol=10&api_key=xlUfk2zABb3OavcpVWR5grNc478VtNRWi9Zutzvu")
# Declaracion del método build_web_page que reciba el hash de respuesta con todos los datos y construya una página web
def build_web_page(photos)
  html = "<html>\n<head>\n</head>\n<body>\n"
  html += "<ul>\n"
  photos.each do |photo|
    html += "<li>\n"
    html += "<img src='#{photo["img_src"]}' alt='#{photo['full_name']}'/>\n"
    html += "</li>\n"
  end
  html += "</ul>\n"
  html += "</body>\n</html>"
  File.write("nasa_photos.html", html)
end
# Declaracion del método photos_count que reciba y devuelva un Hash con con el nombre de la cámara y la cantidad de fotos
def photos_count(photos)
  photos_count = Hash.new(0)
  photos.each do |photo|
    camera_name = photo["camera"]["name"]
    photos_count[camera_name] += 1
  end 
  photos_count.each do |photos, count|
    puts "#{photos}: #{count}"
  end
end
# Asignacion a la variable photo, el contenido en la variable data en formato de arreglo
photos = data["photos"]
# Llamado al método build_web_page entregando como parametro el contenido de la variable photo
build_web_page(photos)
# Llamado al método photos_count entregando como parametro el contenido de la variable photo
photos_count(photos)