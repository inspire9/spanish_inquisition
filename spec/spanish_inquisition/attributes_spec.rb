module SpanishInquisition
end

require './lib/spanish_inquisition/attributes'

describe SpanishInquisition::Attributes do
  describe '#[]' do
    it "returns provided attribute values" do
      SpanishInquisition::Attributes.new(
        {:foo => 'bar'}, {:foo => :string}
      )[:foo].should == 'bar'
    end

    it "returns dates for date params" do
      SpanishInquisition::Attributes.new({
        :"created_on(1i)" => '2013',
        :"created_on(2i)" => '6',
        :"created_on(3i)" => '11'
      }, {:created_on => :date})[:created_on].should == Date.new(2013, 6, 11)
    end

    it "ignores date params if any are blank" do
      SpanishInquisition::Attributes.new({
        :"created_on(1i)" => '2013',
        :"created_on(2i)" => '6',
        :"created_on(3i)" => ''
      }, {:created_on => :date})[:created_on].should be_nil

      SpanishInquisition::Attributes.new({
        :"created_on(1i)" => '2013',
        :"created_on(2i)" => '',
        :"created_on(3i)" => '11'
      }, {:created_on => :date})[:created_on].should be_nil

      SpanishInquisition::Attributes.new({
        :"created_on(1i)" => '',
        :"created_on(2i)" => '6',
        :"created_on(3i)" => '11'
      }, {:created_on => :date})[:created_on].should be_nil
    end
  end
end
