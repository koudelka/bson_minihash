require 'spec_helper'

describe BSONMiniHash do

  #
  # These test only pass becauseof the order in which they're writting. It sucks.
  #
  # I don't see another way to do this, since there's no way to remove a module
  # from the global namespace once it's been added.
  #

  context "No BSON Library" do
    it "should throw an error" do
      expect {
        BSONMiniHash.pack('a')
      }.to raise_error(RuntimeError)
    end
  end

  context "BSON" do
    it "should detect when the BSON library (mongo driver / mongomapper) is in use" do
      require 'bson'
      BSONMiniHash.bson_lib.should == :bson
    end

    context "packing" do
      it "should create a binary object of the right class" do
        BSONMiniHash.pack('a').class.should == BSON::Binary
      end
    end

    it "should have the same value through a pack/unpack roundtrip" do
      str = "abcdef1234567890"
      BSONMiniHash.unpack(BSONMiniHash.pack(str)).should == str
    end

    context "digestion" do
      it "should create a binary object of the right class" do
        BSONMiniHash.digest('a', :md5).class.should == BSON::Binary
      end

      it "should properly digest" do
        str = 'abcdefghijklmnop1235'
        BSONMiniHash.digest(str, :md5).to_s.should == Digest::MD5.digest(str)
      end

      it "should have the right value through a digest/unpack roundtrip" do
        str = "abcdef1234567890"
        BSONMiniHash.unpack(BSONMiniHash.digest(str, :sha1)).should == Digest::SHA1.hexdigest(str)
      end
    end
  end

  context "Moped" do
    it "should detect when the Moped library (mongoid) is in use" do
      require 'moped'
      BSONMiniHash.bson_lib.should == :moped
    end

    context "packing" do
      it "should create a binary object of the right class" do
        BSONMiniHash.pack('a').class.should == Moped::BSON::Binary
      end
    end

    it "should have the same value through a pack/unpack roundtrip" do
      str = "abcdef1234567890"
      BSONMiniHash.unpack(BSONMiniHash.pack(str)).should == str
    end

    context "digestion" do
      it "should create a binary object of the right class" do
        BSONMiniHash.digest('a', :md5).class.should == Moped::BSON::Binary
      end

      it "should properly digest" do
        str = 'abcdefghijklmnop1235'
        BSONMiniHash.digest(str, :md5).to_s.should == Digest::MD5.digest(str)
      end

      it "should have the right value through a digest/unpack roundtrip" do
        str = "abcdef1234567890"
        BSONMiniHash.unpack(BSONMiniHash.digest(str, :sha1)).should == Digest::SHA1.hexdigest(str)
      end
    end
  end

end
