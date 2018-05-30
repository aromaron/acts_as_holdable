# frozen_string_literal: true

class UnholdJob < ActiveJob::Base
  discard_on ActiveRecord::RecordNotFound
  queue_as :default

  def perform(holding_id)
    ActsAsHoldable::Holding.destroy(holding_id) if booking_exists?(holding_id)
  end

  private

  def booking_exists?(holding_id)
    ActsAsHoldable::Holding.find_by(id: holding_id)
  end
end
