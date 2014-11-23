require 'open-uri'
require 'hpricot'
require 'watir-webdriver'

#
# Instagram Downloader Script 
#
# Salvatore Criscione - Karma Project 
#
# 2014
#

# debug var
DEBUG = true

if ARGV.size < 1
	puts "Use: #{$0} username"
end

prefix  = "storage/"
profile = "http://instagram.com/" + ARGV.shift
name = profile.split('/').last

# Creo la directory
Dir.mkdir( prefix + name ) rescue "Cartella già esistente"
puts "[!] Creo la cartella" if DEBUG

# Apro il browser per poter elaborare il JS
browser = Watir::Browser.new("chrome")
browser.goto profile
puts "[!] Apro il browser sul profilo" if DEBUG

puts "Scorri fino in fondo l'elenco tutte le foto ( premi invio per finire, scaricherà solo le foto che vedi nella lista )"
gets


# Ricevo i link
puts "[!] Cerco i link " if DEBUG

doc = Hpricot(browser.body.html)
array_link = []

board = doc.search("//ul[@class='photo-feed']")
(board/"a").each do |x|
	array_link << x['href']
end

array_link.each do |x|
	browser.goto x
	doc = Hpricot(browser.body.html)
	image = doc.search("//div[@class='iMedia LikeableFrame']")
	foto = (image/"div").first
	foto = (foto['src']).to_s
	puts "[!] Download #{foto}" if DEBUG
	resp = open(foto)
	
	if not(File.exist? prefix + name + "/" + foto.split('/').last + "")		
		File.open prefix + name + "/" + foto.split('/').last + "" , "w" do |f|
			f.write(resp.read)
		end
	end
end

puts "FINITO."