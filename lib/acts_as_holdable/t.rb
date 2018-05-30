module ActsAsHoldable
  module T
    def self.t(message, opts={})
      I18n.t('.acts_as_holdable.' + message, opts)
    end

    def self.er(message, opts={})
      self.t('errors.messages.' + message, opts)
    end
  end
end