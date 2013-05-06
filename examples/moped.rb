require 'moped'
require 'bson_minihash'

session = Moped::Session.new([ "127.0.0.1:27017" ])
session.use "test"

# Digestion
mini_hash = BSONMiniHash.digest("Syd Vicious", :md5)
session[:artists].insert(name: "Syd Vicious", hash: mini_hash)
doc = session[:artists].find(hash: mini_hash).first
p doc

# Packing a hash you already have
mini_hash = BSONMiniHash.pack("3eaace90e5526e5acc96f1d6db146b0ed401c2fe", :sha1)
session[:artists].insert(name: "Geddy Lee", hash: mini_hash)
doc = session[:artists].find(hash: mini_hash).first
p doc


# Unpacking a mini hash
p BSONMiniHash.unpack(doc['hash'])
