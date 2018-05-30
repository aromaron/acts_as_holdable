class Holdable < ActiveRecord::Base
  acts_as_holdable on_hand_type: :open, preset: :ticket
end
