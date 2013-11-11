require 'rspec'
require 'rr'
require 'active_model'
require 'active_support/core_ext/object'
require_relative '../../app/models/order_delivery_date_validator'

describe OrderDeliveryDateValidator do
  let(:validator) do
    described_class.new({})
  end

  let(:order_errors) { Object.new }
  let(:order) do
    Object.new.tap do |order|
      stub(order).errors { order_errors }
      stub(order).expected_date { 2.days.since.to_date }
      stub(order).delivery_date { 1.days.since.to_date }
    end
  end

  describe "#validate" do
    context "when delivery_date is not set yet" do
      it 'bypass validation' do
        stub(order).delivery_date { nil }
        dont_allow(order_errors).add(:delivery_date, :must_be_less_than_expected_date)
        validator.validate(order)
      end
    end

    context "when delivery_date is valid" do
      it 'adds no errors to order' do
        dont_allow(order_errors).add(:delivery_date, :must_be_less_than_expected_date)
        validator.validate(order)
      end
    end

    context "when delivery_date is greater than expected_date" do
      it 'adds errors to order' do
        stub(order).delivery_date { 3.days.since.to_date }
        mock(order_errors).add(:delivery_date, :must_be_less_than_expected_date)
        validator.validate(order)
      end
    end
  end
end
