require 'open-uri'
require 'hpricot'
require 'watir-webdriver'

class Downloader
	def initialize ( url, profile, locationPath )
		@url = url.to_s
		@profile = profile.to_s
		@locationPath = locationPath.to_s
		self.download
	end
	
	def download
		puts "[!] Download #{@url}"
		resp = open(@url)
		Dir.mkdir(@locationPath + @profile) rescue "Cartella già esistente" 
		File.open @locationPath + @profile + "/" + @url.split('/').last + "" , "w" do |f|
			f.write(resp.read)
		end
	end
end

class Analizer
	# Contiene il testo html della pagina
	@url = ""
	
	# E' un profilo o una foto?
	@profile = false
	
	@doc

	def initialize( httpUrl )
		@url = httpUrl
		
		if httpUrl.include? "http://instagram.com/p"
			@profile = false
		else
			@profile = true
		end

		self.parseDocument
	end
	
	def parseDocument
		browser = Watir::Browser.new("chrome")
		browser.goto @url
		if @profile
			puts "Scorri fino in fondo l'elenco tutte le foto"
			gets
			# TODO TRY WORKAROUND
		end
		@doc = Hpricot(browser.body.html)
		browser.close
	end		

	def profileImage
		if @profile == true
			profile = @doc.search("//span[@class='img img-inset user-avatar']")
			(profile.at("img")['src']).to_s
		end
	end
	
	def getAllPhotoLinks
		if @profile == true
			array = []
			board = @doc.search("//ul[@class='photo-feed']")
			(board/"a").each do |x|
				array << x['href']
			end
			array
		end
	end
	
	def getPhoto
		if @profile == false
			image = @doc.search("//div[@class='iMedia LikeableFrame']")
			foto = (image/"div").first
			(foto['src']).to_s	
		end
	end
end

def download(x)
  Downloader.new(x, "http://instagram.com/salvatoree0123".split('/').last ,"storage/")
end

main = Analizer.new("http://instagram.com/salvatoree0123")
download(main.profileImage)

main.getAllPhotoLinks.each do |x|
  buff = Analizer.new(x)
  download(buff.getPhoto)
end