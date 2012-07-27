require 'helper/spec_helper'

describe Service do
  before(:each) do
    json_hash = {id: 42, name: "Varadha", email: "varadha@thoughtworks.com" }
    @expected_hash = json_hash.stringify_keys
    @expected_hash.delete("id")

    array_with_symbols_block = Proc.new { 
      status 200
      json [json_hash], :ignore=>[:id]
    }
    array_with_strings_block = Proc.new { 
      status 200
      json [json_hash.stringify_keys], :ignore=>[:id]
    }
    object_with_symbols_block = Proc.new { 
      status 200
      json json_hash, :ignore=>[:id]
    }
    object_with_strings_block = Proc.new { 
      status 200
      json json_hash.stringify_keys, :ignore=>[:id]
    }

    @array_symbols_contract = Contract.new({block: array_with_symbols_block})
    @array_strings_contract = Contract.new({block: array_with_strings_block})
    @object_symbols_contract = Contract.new({block: object_with_symbols_block})
    @object_strings_contract = Contract.new({block: object_with_strings_block})
  end

  it "json_spec should delete ignored attributes" do
    @array_symbols_contract.json_for_spec.should == [@expected_hash]
    @array_strings_contract.json_for_spec.should == [@expected_hash]
    @object_symbols_contract.json_for_spec.should == @expected_hash
    @object_strings_contract.json_for_spec.should == @expected_hash
  end
end
