require 'artoo/drivers/driver'

module Artoo
  module Drivers
    class BaseSensor < Driver
      COMMANDS = [:read, :lower, :upper, :previous_read, :unit].freeze

      attr_reader :lower, :upper, :previous_read, :unit

      def read
        connection.analog_read(pin)
      end

      def start_driver
        @previous_read = 0
        @upper = additional_params[:upper].nil? ? 1023 : additional_params[:upper]
        @lower = additional_params[:lower].nil? ? 0 : additional_params[:lower]
        @precision = additional_params[:precision].nil? ? 2 : additional_params[:precision]
        @unit = additional_params[:unit].nil? ? :C : additional_params[:unit].upcase

        every(interval) do
          new_value = read
          update(new_value) unless new_value.nil?
        end if !interval.nil? and interval > 0

        super
      end

      private
      
      def update(new_val)
        @previous_read = new_val
        if new_val >= @upper
          publish(event_topic_name("update"), "upper", new_val)
          publish(event_topic_name("upper"), new_val)
        elsif new_val <= @lower
          publish(event_topic_name("update"), "lower", new_val)
          publish(event_topic_name("lower"), new_val)
        end
      end
  
    end
  end
end
