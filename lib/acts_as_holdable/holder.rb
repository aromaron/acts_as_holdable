# frozen_string_literal: true

require 'jobs/unhold_job'
module ActsAsHoldable
  module Holder
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def acts_as_holder(_opts = {})
        class_eval do
          has_many :holdings, as: :holder, dependent: :destroy, class_name: '::ActsAsHoldable::Holding'
        end

        include ActsAsHoldable::Holder::InstanceMethods
        extend ActsAsHoldable::Holder::SingletonMethods
      end

      def holder?
        false
      end
    end

    module InstanceMethods
      def hold!(holdable, opts = {})
        # validates availability
        holdable.check_availability!(opts) if holdable.class.holdable?

        holding_params = opts.merge(holder: self, holdable: holdable)
        holding = ActsAsHoldable::Holding.create!(holding_params)

        holdable.reload
        holding
      end

      def unhold!(holding)
        # deletes current holding
        ActsAsHoldable::Holding.destroy(holding.id)
        holding.update_on_hold
        reload
        true
      end

      def hold_for(holdable, opts = {})
        # Clean params for Bookings
        holding_opts = opts.except(:duration)

        # Creates the Booking
        holding = hold!(holdable, holding_opts)

        # Sets a Job to delete the Booking
        job = UnholdJob.set(wait: opts[:duration]).perform_later(holding.id)
        holding.update(job_pid: job.provider_job_id)
        holding
      end

      def confirm_holding!(holding)
        return false unless holding.job_pid
        Sidekiq::Status.unschedule(holding.job_pid)
        holding.update(job_pid: nil)
        holding
      end

      def holder?
        self.class.holder?
      end
    end

    module SingletonMethods
      def holder?
        true
      end
    end
  end
end
