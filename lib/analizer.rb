require 'open-uri'
require 'hpricot'
require 'watir-webdriver'


class Analizer
	# Contiene il testo html della pagina
	@url = ""
	
	# E' un profilo o una foto?
	@profile = false
	
	@doc

	def initialize( httpUrl , isProfile )
		@url = httpUrl
		
		if isProfile == true
			@profile = true
		else
			@profile = false
		end

		self.parseDocument
	end
	
	def parseDocument
		browser = Watir::Browser.new("chrome")
		browser.goto @url
		@doc = Hpricot(browser.body.html)
		browser.close
	end		

	def profileImage
		if @profile == true
			profile = @doc.search("//span[@class='img img-inset user-avatar']")
			puts profile.at("img")['src']
		end
	end
	
	def getAllPhotoLinks
		if @profile == true
			board = @doc.search("//ul[@class='photo-feed']")
			(board/"a").each do |x|
				puts x['href']
			end
		end
	end 
end


a = Analizer.new("http://instagram.com/Salvatoree0123", true)
a.profileImage
a.getAllPhotoLinks
