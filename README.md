# BSON MiniHash

Compacts cryptographic hashes and other strings of limited charsets into blobs of BSON binary data, to reduce MongoDB storage and index size. Supports the vanilla Mongo driver, MongoMapper and Mongoid.

## Installation

Add this line to your application's Gemfile:

    gem 'bson_minihash'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install bson_minihash

## Usage

You need to require either the 'bson' (Mongo driver/MongoMapper) or 'moped' (Mongoid) libraries before using MiniHash, so it knows which library's binary object type to give you. If you're using MongoMapper or Mongoid, one of those libraries has already been loaded for you.

### Digestion

If you've got some data you want to digest, then pack into a minihash, `BSONMiniHash#digest(data, hash_type)` provides a shortcut to do so.

    require 'mongo'
    require 'bson_minihash'
    
    BSONMiniHash.digest("Geddy Lee", :md5)
    #=> <BSON::Binary:70301078819340>

`hash_type` can be either `:md5` or `:sha1`

### Packing pre-existing hashes

If you've already got a hash as a string (e.g. passed as a parameter to your web app), you can pack it into a minihash that's suitable for a `#find` operation by using `BSONMiniHash.pack(string, hash_type)`.

    require 'mongo'
    require 'bson_minihash'
    
    BSONMiniHash.pack('99f815bab7703b220c97feeca3ff9769', :md5)
    #=> <BSON::Binary:70301087948100>

`hash_type` can be `:md5`, `:sha1` or `:hex`

It's best to pass the kind of hash you're using, minihash will do a little validation on the hash to make sure it fits the right character set and length. `:hex` just checks for the hex character range, without a length check, see the Caveats section below before using it.

### Examples

For examples of using minihashes in MongoDB, please see the `examples` direcotry.

## How does it work?

Have you ever wondered what the difference between `Digest::SHA1.digest` and `Digest::SHA1.hexdigest` is?

    str = "Geddy Lee"

    Digest::SHA1.digest(str).length
    #=> 20
    
    Digest::SHA1.hexdigest(str).length
    #=> 40

They both contain the same information, except `#digest` uses only the space that it needs to represent the hash. SHA1 and MD5 both use different length combinations of only sixteen characters (hex) to represent their hashes. A nibble (half a byte, four bits), is enough room to store one of those character.

`#hexdigest` gives a UTF-8 string, which uses a byte per character when relegated to the ASCII range, double the amount needed.

So we convert each character in the hash to its actual hex value:

    Digest::SHA1.hexdigest(str).split('').collect(&:hex)
    #=> [3, 14, 10, 10, 12, 14, 9, 0, 14, 5, 5, 2, 6, 14, 5, 10, 12, 12, 9, 6, 15, 1, 13, 6, 13, 11, 1, 4, 6, 11, 0, 14, 13, 4, 0, 1, 12, 2, 15, 14]

Then pack them together into a new string, treating each number as a nibble:

    Digest::SHA1.hexdigest(str).split('').collect(&:hex).in_groups_of(2).collect{|n| (n.first << 4) + n.last }.pack("C*")
    #=> ">\xAA\xCE\x90\xE5RnZ\xCC\x96\xF1\xD6\xDB\x14k\x0E\xD4\x01\xC2\xFE"
    
That's a roundabout way of emulating `#digest` :)

    Digest::SHA1.digest(str)
    #=> ">\xAA\xCE\x90\xE5RnZ\xCC\x96\xF1\xD6\xDB\x14k\x0E\xD4\x01\xC2\xFE"

Or, we could use the handy "hex" format of `Array#pack`, which is what minihash does.

    [Digest::SHA1.hexdigest(str)].pack('H*')
    # => ">\xAA\xCE\x90\xE5RnZ\xCC\x96\xF1\xD6\xDB\x14k\x0E\xD4\x01\xC2\xFE"

## Efficiency

In MongoDB, you should see about a factor of two space saving for the minihash fields. Of course, you're spending some CPU power to pack the fields, but it's not much.

## Caveats
In MongoDB, it's not a great idea to use hashes as unique indexes, since there's always the possiblity of collisions.

If you choose to `#pack` a string with the `:hex` type, beware that an odd-length string will have an extra nibble at the end, since a byte is the smallest unit of allocation.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
