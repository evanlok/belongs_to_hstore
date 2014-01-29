require 'spec_helper'

class Widget < ActiveRecord::Base
  include BelongsToHstore::Association

  serialize :properties, Hash

  belongs_to_hstore :properties, :item
  belongs_to_hstore :properties, :poly_item, :polymorphic => true
end

class Item < ActiveRecord::Base
end

describe BelongsToHstore do
  let(:item) { Item.create }
  let(:widget) { Widget.new }

  it 'sets properties from object' do
    widget.item = item
    widget.item_id.should == item.id.to_s
    widget.properties['item_id'].should == item.id.to_s
  end

  it 'returns associated object' do
    widget = Widget.create(:item => item)
    widget.reload.item.should == item
  end

  it 'sets properties from setter method' do
    widget.item_id = item.id
    widget.properties['item_id'].should == item.id
    widget.item.should == item
  end

  context 'polymorphic' do
    it 'sets type and id from object' do
      widget.poly_item = item
      widget.properties['poly_item_id'].should == item.id.to_s
      widget.properties['poly_item_type'].should == item.class.to_s
    end

    it 'returns correct type' do
      widget = Widget.create(:poly_item => item)
      widget.reload.poly_item.class.should == item.class
    end
  end
end
