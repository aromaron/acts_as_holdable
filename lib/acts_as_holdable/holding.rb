module ActsAsHoldable
  # Holding model. Store in host database holdings made by holders on holdables
  class Holding < ::ActiveRecord::Base
    belongs_to :holdable, polymorphic: true
    belongs_to :holder, polymorphic: true

    validates_presence_of :holdable
    validates_presence_of :holder
    validate :holdable_is_holdable, :holder_is_holder

    private

    # Validation method. Check if the holded model is actually holdable
    def holdable_is_holdable
      return unless holdable.present? && !holdable.class.holdable?
      errors.add(:holdable, T.er('holding.must_be_holdable',
                                 model: holdable.class.to_s))
    end

    # Validation method. Check if the holder model is actually a holder
    def holder_is_holder
      return unless holder.present? && !holder.class.holder?
      errors.add(:holder, T.er('holder.must_be_holder',
                                model: holder.class.to_s))
    end
  end
end