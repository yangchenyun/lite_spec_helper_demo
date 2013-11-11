class OrderDeliveryDateValidator < ActiveModel::Validator
  def validate(order)
    return if order.delivery_date.blank? || order.expected_date.blank?

    if order.delivery_date > order.expected_date
      order.errors.add(:delivery_date, :must_be_less_than_expected_date)
    end
  end
end
