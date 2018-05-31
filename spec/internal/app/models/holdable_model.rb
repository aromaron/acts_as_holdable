class Holdable < ActiveRecord::Base
  acts_as_holdable preset: :ticket
end
