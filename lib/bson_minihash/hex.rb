require 'digest'

module BSONMiniHash
  module Hex
    FORMAT = 'H*'.freeze
    TYPES = [:md5, :sha1, :hex].freeze

    def self.pack(str, type = :hex)
      Hex.validate(str, type)
      [str].pack(FORMAT)
    end

    def self.unpack(packed_str)
      packed_str.unpack(FORMAT).first
    end

    def self.validate(str, type)
      raise ArgumentError, "Hex strings must comprise of characters between a-f and 0-9" unless str.match /^[a-f0-9]+$/i

      case type
        when :md5
          raise ArgumentError, "MD5 strings must be 32 characters in length" unless str.length == 32
        when :sha1
          raise ArgumentError, "SHA1 strings must be 40 characters in length" unless str.length == 40
      end
      true
    end

    def self.digest(data, type)
      case type
        when :md5
          Digest::MD5.digest(data)
        when :sha1
          Digest::SHA1.digest(data)
        else
          raise ArgumentError, "type #{type} not supported"
      end
    end
  end
end
