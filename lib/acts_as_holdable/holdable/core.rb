module ActsAsHoldable
  module Holdable
    module Core
      def self.included(base)
        base.extend ActsAsHoldable::Holdable::Core::ClassMethods
        base.include ActsAsHoldable::Holdable::Core::InstanceMethods

        base.initialize_acts_as_holdable_core
      end

      module ClassMethods
        def initialize_acts_as_holdable_core
          set_options
        end

        def validate_holding_options!(options)
          unpermitted_params = []
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
          unpermitted_params = unpermitted_params.select{ |p| options.has_key?(p) }
                                                 .map{ |p| "'#{p}'"}

          wrong_types = required_params
                        .select { |k, v| options.has_key?(k) && v.select{|type| options[k].is_a?(type)}.length.zero? }
                        .map { |k, v| "'#{k}' must be a '#{v.join(' or ') }' but '#{options[k].class}' found" }

        required_params = required_params.select { |k, v| !options.has_key?(k) }
                                         .map { |k, v| "'#{k}'" }

          # Raise OptionsInvalid if some invalid parameters were found
          if unpermitted_params.length + required_params.length + wrong_types.length > 0
            message = ''
            message << " unpermitted parameters: #{unpermitted_params.join(',')}." if unpermitted_params.length > 0
            message << " missing parameters: #{required_params.join(',')}." if required_params.length > 0
            message << " parameters type mismatch: #{wrong_types.join(',')}" if wrong_types.length > 0
            raise ActsAsHoldable::OptionsInvalid.new(self, message)
          end
          true
        end

        private

        def set_options
          self.holding_opts[:preset] = :ticket

          defaults = nil

          # Validates options
          permitted_options = {
            on_hand_type: [:open, :closed, :none],
            preset: [:ticket]
          }

          self.holding_opts.each_pair do |key, val|
            if !permitted_options.key? key
              raise ActsAsHoldable::InitializationError.new(self, "#{key} is not a valid option")
            elsif !permitted_options[key].include? val
              raise ActsAsHoldable::InitializationError.new(self, "#{val} is not a valid value for #{key}. Allowed values are: #{permitted_options[key]}")
            end
          end
          
          case self.holding_opts[:preset]
          when :ticket
            defaults = {
              on_hand_type: :open
            }
          else
            defaults = {
              on_hand_type: :none
            }
          end

          # Merge options with defaults
          self.holding_opts.reverse_merge!(defaults)
        end
      end

      module InstanceMethods
        def check_availability!(opts)
          if self.holding_opts[:on_hand_type] != :none
            # Amount > on_hand
            if opts[:amount] > self.on_hand
              raise ActsAsHoldable::AvailabilityError.new ActsAsHoldable::T.er('.availability.amount_gt_on_hand', model: self.class.to_s)
            end
          end
          true
        end

        def check_availability(opts)
          begin
            check_availability!(opts)
          rescue ActsAsHoldable::AvailabilityError
            false
          end
        end

        def hold!(holder, opts)
          holder.hold(self, opts)
        end

        def validate_holding_options!(opts)
          self.validate_holding_options!(opts)
        end

        def holder?
          self.class.holder?
        end
      end
    end
  end
end