require 'spec_helper'

class Widget < ActiveRecord::Base
  include BelongsToHstore::Association

  serialize :properties, Hash

  belongs_to_hstore :properties, :item
  belongs_to_hstore :properties, :poly_item, :polymorphic => true
end

class ExtendedWidget < Widget
  belongs_to_hstore :properties, :additonal_item, :class_name => 'Item'
end

class Item < ActiveRecord::Base
end

describe BelongsToHstore do
  let(:item) { Item.create }
  let(:extra_item) { Item.create(:name=>'extra') }
  let(:widget) { Widget.new }
  let(:extended_widget) { ExtendedWidget.new }

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

  context 'subclasses' do
    it 'sets/gets properties from base class' do
      extended_widget.item = item
      extended_widget.poly_item = item
      extended_widget.properties['item_id'].should == item.id.to_s
      extended_widget.properties['poly_item_id'].should == item.id.to_s
      extended_widget.properties['poly_item_type'].should == item.class.to_s
    end

    it 'sets/gets properties from subclass' do
      extended_widget.additonal_item = item
      extended_widget.properties['additonal_item_id'].should == item.id.to_s
      extended_widget.additonal_item.should == item
    end

    it 'does not add subclass properties to base class' do
      expect{widget.additonal_item = item}.to raise_error(NameError)
      expect{widget.additonal_item}.to raise_error(NameError)
      Widget.belongs_to_hstore_attributes.should include('item_id')
      Widget.belongs_to_hstore_attributes.should_not include('additional_item_id')
    end
  end

  context 'preload associations' do
    it 'works with includes' do
      5.times { ExtendedWidget.create(:name => 'preload', :item => item, :additonal_item => extra_item) }
      widgets = ExtendedWidget.where(:name => 'preload').includes(:item, :additonal_item).to_a
      expect(widgets.size).to eq(5)
      expect(widgets[0].item).to eq(widgets[1].item)
    end
  end

end
