# encoding: UTF-8

require 'open-uri'
require 'geocoder'
require 'active_support/core_ext'

Geocoder.configure do |config|
  config.lookup = :bing
  config.api_key = "AjiRFAOxAb5Z01PMW3EwdUrCjDhN88QKPA3OfFmUuheW4ByTUZ9XPySvAv50RUpR"
  config.timeout = 30
end

rolls = Hash.from_xml open('http://www.rolls.fi/ravintolat.xml').read

rolls.each do |lol|

	lol.each do |lal|
		if lal.is_a? Hash
			lal.each do |trolol|
				trolol.each do |asdf|
					if asdf.is_a? Array
						asdf.each do |ravintolat|
							ravintolat["rolls"].each_with_index do |ravintola, index|
								address = ravintola["osoite"]
								post_office = ravintola["toimipaikka"]
								coordinates = Geocoder.search("#{address}, #{post_office}")
								if coordinates and not coordinates[0].nil?
									puts "#{coordinates[0].latitude},#{coordinates[0].longitude},#{ravintola["kunta"]}"
								else
									puts "0,0,#{ravintola["kunta"]}"
								end
							end
						end
					end
				end
			end
		end
	end

end