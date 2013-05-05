module BSONMiniHash

  def self.bson_lib
    case
      when Kernel.const_defined?(:Moped) # Mongoid
        :moped
      when Kernel.const_defined?(:BSON) # Mongo driver (incliding MongoMapper)
        :bson
      else 
        raise "In order to use BSONMiniHash, you need to have either the 'bson' or 'moped' gem loaded"
    end
  end

  #
  # Beware, if you're not using SHA1, MD5 or any other hash with a length divisible by two,
  # you'll get a zero padded string when doing a round trip as the packed string will have
  # an extra nibble of space at the end.
  #
  def self.pack(str, type = :hex)
    str = str.downcase.strip

    packed_str = \
      case
        when Hex::TYPES.include?(type)
          Hex.pack(str, type)
        else
          raise ArgumentError, "type #{type} not supported"
      end

    bson_obj(packed_str)
  end

  def self.digest(data, type)
    packed_str = \
      case
        when Hex::TYPES.include?(type)
          Hex.digest(data, type)
        else
          raise ArgumentError, "type #{type} not supported"
      end

    bson_obj(packed_str)
  end

  def self.unpack(packed_obj, type = :hex)
    #
    # Both BSON and Moped give the right thing for to_s
    #
    packed_str = packed_obj.to_s

    case
      when Hex::TYPES.include?(type)
        Hex.unpack(packed_str)
      else
        raise ArgumentError, "type #{type} not supported"
    end
  end

  private

    def self.bson_obj(packed_str)
      case self.bson_lib
        when :bson
          BSON::Binary.new(packed_str, :user)
        when :moped
          Moped::BSON::Binary.new(:user, packed_str)
      end
    end

end

require "bson_minihash/version"
require "bson_minihash/hex"
