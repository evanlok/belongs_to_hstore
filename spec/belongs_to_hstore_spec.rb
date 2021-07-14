require 'spec_helper'

class Widget < ActiveRecord::Base
  include BelongsToHstore::Association

  serialize :properties, Hash

  belongs_to_hstore :properties, :item
  belongs_to_hstore :properties, :poly_item, :polymorphic => true
end

class ExtendedWidget < Widget
  belongs_to_hstore :properties, :additional_item, :class_name => 'Item'
end

class Item < ActiveRecord::Base
end

describe BelongsToHstore do
  let(:item) { Item.create }
  let(:extra_item) { Item.create(:name => 'extra') }
  let(:widget) { Widget.new }
  let(:extended_widget) { ExtendedWidget.new }

  it 'sets properties from object' do
    widget.item = item
    expect(widget.item_id).to eq item.id.to_s
    expect(widget.properties['item_id']).to eq item.id.to_s
  end

  it 'returns associated object' do
    widget = Widget.create(:item => item)
    expect(widget.reload.item).to eq item
  end

  it 'sets properties from setter method' do
    widget.item_id = item.id
    expect(widget.properties['item_id']).to eq(item.id)
    expect(widget.item).to eq item
  end

  context 'polymorphic' do
    it 'sets type and id from object' do
      widget.poly_item = item
      expect(widget.properties['poly_item_id']).to eq item.id.to_s
      expect(widget.properties['poly_item_type']).to eq item.class.to_s
    end

    it 'returns correct type' do
      widget = Widget.create(:poly_item => item)
      expect(widget.reload.poly_item.class).to eq item.class
    end
  end

  context 'subclasses' do
    it 'sets/gets properties from base class' do
      extended_widget.item = item
      extended_widget.poly_item = item
      expect(extended_widget.properties['item_id']).to eq item.id.to_s
      expect(extended_widget.properties['poly_item_id']).to eq item.id.to_s
      expect(extended_widget.properties['poly_item_type']).to eq item.class.to_s
    end

    it 'sets/gets properties from subclass' do
      extended_widget.additional_item = item
      expect(extended_widget.properties['additional_item_id']).to eq item.id.to_s
      expect(extended_widget.additional_item).to eq item
    end

    it 'does not add subclass properties to base class' do
      expect{widget.additional_item = item}.to raise_error(NameError)
      expect{widget.additional_item}.to raise_error(NameError)
      expect(Widget.belongs_to_hstore_attributes).to include('item_id')
      expect(Widget.belongs_to_hstore_attributes).not_to include('additional_item_id')
    end
  end

  context 'preload associations' do
    it 'works with includes' do
      5.times { ExtendedWidget.create(:name => 'preload', :item => item, :additional_item => extra_item) }
      widgets = ExtendedWidget.where(:name => 'preload').includes(:item, :additional_item).to_a
      expect(widgets.size).to eq(5)
      expect(widgets[0].item).to eq(widgets[1].item)
    end
  end

end
