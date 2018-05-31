# frozen_string_literal: false

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

        # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/MethodLength
        def validate_holding_options!(options)
          unpermitted_params = []
          required_params = {}

          case holding_opts[:on_hand_type]
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
                        .select { |k, v| options.key?(k) && v.select { |type| options[k].is_a?(type) }.length.zero? }
                        .map { |k, v| "'#{k}' must be a '#{v.join(' or ')}' but '#{options[k].class}' found" }

          required_params = required_params.reject { |k, _v| options.key?(k) }
                                           .map { |k, _v| "'#{k}'" }

          # Raise OptionsInvalid if some invalid parameters were found
          if (unpermitted_params.length + required_params.length + wrong_types.length).positive?
            message = ''
            message << " unpermitted parameters: #{unpermitted_params.join(',')}." unless unpermitted_params.empty?
            message << " missing parameters: #{required_params.join(',')}." unless required_params.empty?
            message << " parameters type mismatch: #{wrong_types.join(',')}" unless wrong_types.empty?
            raise ActsAsHoldable::OptionsInvalid.new(self, message)
          end
          true
        end
        # rubocop:enable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/MethodLength

        private

        # rubocop:disable Metrics/MethodLength
        def set_options
          holding_opts[:preset] = :ticket

          # Validates options
          permitted_options = {
            on_hand_type: %i[open closed none],
            preset: [:ticket]
          }

          holding_opts.each_pair do |key, val|
            # rubocop:disable Style/GuardClause
            if !permitted_options.key? key
              raise ActsAsHoldable::InitializationError.new(self, "#{key} is not a valid option")
            elsif !permitted_options[key].include? val
              raise ActsAsHoldable::InitializationError.new(self, "#{val} is not a valid value for #{key}. Allowed values: #{permitted_options[key]}")
            end
            # rubocop:enable Style/GuardClause
          end

          defaults = case holding_opts[:preset]
                     when :ticket
                       {
                         on_hand_type: :open
                       }
                     else
                       {
                         on_hand_type: :none
                       }
                     end

          # Merge options with defaults
          holding_opts.reverse_merge!(defaults)
        end
        # rubocop:enable Metrics/MethodLength
      end

      module InstanceMethods
        def check_availability!(opts)
          # validates options
          validate_holding_options!(opts)

          if holding_opts[:on_hand_type] != :none
            # Amount > on_hand
            if opts[:amount] > on_hand
              raise ActsAsHoldable::AvailabilityError,
                    ActsAsHoldable::T.er('.availability.amount_gt_on_hand', model: self.class.to_s)
            end
          end
          true
        end

        def check_availability(opts)
          check_availability!(opts)
        rescue ActsAsHoldable::AvailabilityError
          false
        end

        def hold!(holder, opts)
          holder.hold(self, opts)
        end

        def validate_holding_options!(opts)
          self.class.validate_holding_options!(opts)
        end

        def holder?
          self.class.holder?
        end
      end
    end
  end
end
