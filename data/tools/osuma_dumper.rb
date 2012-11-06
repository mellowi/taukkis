#encoding: UTF-8
require 'open-uri'
require 'json'

# Finlandz boundaries from http://isithackday.com/geoplanet-explorer/index.php?woeid=23424812
min_latitude = 59.764881
max_latitude = 70.092308
min_longitude = 20.548571
max_longitude = 31.586201

if ARGV.size == 0
  puts "Usage: ruby osuma_dumper.rb <osuma_category_id> e.g ruby osuma_dumper.rb 1D0050"
  puts "Categories:"
  puts "1D0050 - gas_station (Huoltoasema)"
  puts "1D1480 - cafe (Kahvila)"
  puts "1D1490 - kiosk (Kioski)"
  puts "1D1220 - sights (Nähtävyydet)"
  puts "1D1520 - fast_food (Pikaruoka)"
  puts "1D1530 - restaurant (Ravintola)"
  exit
end

lob_code = ARGV[0]

query_string = "http://developer.fonecta.net/osuma/resource/search/osuma/companies/boundingbox?minLatitude=#{min_latitude}&maxLatitude=#{max_latitude}&minLongitude=#{min_longitude}&maxLongitude=#{max_longitude}&lobCode=#{lob_code}"
companies = nil
has_next_page = true
page = 1

while has_next_page
  query = JSON.parse(open("#{query_string}&page=#{page}").read)
  if companies.nil?
    companies = query["results"]
  else
    # merge two arrays, lolcode from http://stackoverflow.com/questions/7312713/merge-two-arrays-in-ruby
    companies = companies.zip(query["results"]).flatten.compact
  end
  has_next_page = query["query"]["hasNextPage"]
  page += 1
end

companies.each do |company|
  puts "#{company["coordinate"]["latitude"]},#{company["coordinate"]["longitude"]},\"#{company["name"]}\""
end