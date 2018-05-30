module ActsAsHoldable
  module Holdable
    module Core
      def self.included(base)
        base.extend ActsAsHoldable::Holdable::Core::ClassMethods
        base.initialize_acts_as_holdable_core
      end

      module ClassMethods
        def initialize_acts_as_holdable_core
          set_options
        end

        def validate_holding_options!(options)
          unpermitted_params = {}
          required_params = {}

          case self.holding_opts[:on_hand_type]
          when :closed
            required_params[:amount] = [Integer]
          when :open
            required_params[:amount] = [Integer]
          when :none
            unpermitted_params << :amount
          end

          # Actual validation
          unpermitted_params = unpermitted_params.select { |p| options.key?(p) }
                                                 .map { |p| "'#{p}'" }

          wrong_types = required_params
                        .select { |k, v| options.key?(k) && !options[k].is_a?(v) }
                        .map { |k, v| "'#{k}' must be a '#{v.to_s}' but '#{options[k].class.to_s}' found" }

          required_params = required_params.select{ |k, v| !options.key?(k) }
                                            .map{ |k, v| "'#{k}'" }

          # Raise OptionsInvalid if some invalid parameters were found
          if unpermitted_params.length + required_params.length + wrong_types.length > 0
            message = ''
            message << " unpermitted parameters: #{unpermitted_params.join(',')}." unless unpermitted_params.length.empty?
            message << " missing parameters: #{required_params.join(',')}." unless required_params.length.empty?
            message << " parameters type mismatch: #{wrong_types.join(',')}" unless wrong_types.length.empty?
            raise ActsAsBookable::OptionsInvalid.new(self, message)
          end
          true
        end

        private

        def set_options
          defaults = nil
          # self.holding_opts.reverse_merge!(defaults)
        end
      end
    end
  end
end