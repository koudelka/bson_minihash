require 'spec_helper'

describe BSONMiniHash::Hex do

  context "Packing" do
    it "should correctly pack a hex string" do
      str = "7e240de74fb1ed08fa08d38063f6a6a91462a815"
      packed_str = "~$\r\xE7O\xB1\xED\b\xFA\b\xD3\x80c\xF6\xA6\xA9\x14b\xA8\x15"
      BSONMiniHash::Hex.pack(str).should == packed_str
    end

    it "should correctly unpack a hex string" do
      str = "7e240de74fb1ed08fa08d38063f6a6a91462a815"
      packed_str = "~$\r\xE7O\xB1\xED\b\xFA\b\xD3\x80c\xF6\xA6\xA9\x14b\xA8\x15"
      BSONMiniHash::Hex.unpack(packed_str).should == str
    end

    it "should correctly roundtrip a hex string" do
      unpacked_str = "7e240de74fb1ed08fa08d38063f6a6a91462a815"
      BSONMiniHash::Hex.unpack(BSONMiniHash::Hex.pack(unpacked_str)).should == unpacked_str

      packed_str = "~$\r\xE7O\xB1\xED\b\xFA\b\xD3\x80c\xF6\xA6\xA9\x14b\xA8\x15"
      BSONMiniHash::Hex.pack(BSONMiniHash::Hex.unpack(packed_str)).should == packed_str
    end
  end

  context "Validation" do
    it "should fail when the character set isn't in hex" do
      str = Digest::MD5.hexdigest("a")
      str[0] = 'g'
      expect { BSONMiniHash::Hex.validate(str, :md5) }.to raise_error(ArgumentError)
    end

    context "MD5" do
      it "should pass for a correctly formatted MD5" do
        BSONMiniHash::Hex.validate(Digest::MD5.hexdigest("a"), :md5).should be_true
      end

      it "should fail when the length is other than 32" do
        str = Digest::MD5.hexdigest("a")
        expect { BSONMiniHash::Hex.validate(str[1..-1], :md5) }.to raise_error(ArgumentError)
      end
    end

    context "SHA1" do
      it "should pass for a correctly formatted SHA1" do
        BSONMiniHash::Hex.validate(Digest::SHA1.hexdigest("a"), :sha1).should be_true
      end

      it "should fail when the length is other than 40" do
        str = Digest::SHA1.hexdigest("a")
        expect { BSONMiniHash::Hex.validate(str[1..-1], :sha1) }.to raise_error(ArgumentError)
      end
    end

  end
end
