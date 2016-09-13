require 'uber/arguments'
require 'uber/api_request'
require 'uber/models/reminder'

module Uber
  module API
    module Reminders

      def reminder(reminder_id)
        perform_with_object(:get, "/v1/reminders/#{reminder_id}", {}, Reminder)
      end

      def add_reminder(*args)
        arguments = sanitize_time(Uber::Arguments.new(args))
        perform_with_object(:post, "/v1/reminders", arguments.options, Reminder)
      end

      def update_reminder(reminder_id, *args)
        arguments = sanitize_time(Uber::Arguments.new(args))
        perform_with_object(:patch, "/v1/reminders/#{reminder_id}", arguments.options, Reminder)
      end

      def delete_reminder(reminder_id)
        perform_with_object(:delete, "/v1/reminders/#{reminder_id}", {}, Reminder)
      end

      alias_method :reminder_detail, :reminder

      private
      def sanitize_time(arguments)
        options = arguments.options
        options[:reminder_time] = to_unix_time(options[:reminder_time])
        options[:event][:time] = to_unix_time(options[:event][:time]) if options[:event]
        arguments
      end

      def to_unix_time(attr)
        attr && attr.instance_of?(::Time) ? attr.to_i : attr
      end

    end
  end
end
