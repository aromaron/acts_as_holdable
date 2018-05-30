# frozen_string_literal: true

module ActsAsHoldable
  module DBUtils
    class << self
      def connection
        ActsAsHoldable::Holding.connection
      end

      def using_postgresql?
        connection && connection.adapter_name == 'PostgreSQL'
      end

      def using_mysql?
        connection && connection.adapter_name == 'Mysql2'
      end

      def using_sqlite?
        connection && connection.adapter_name == 'SQLite'
      end

      def like_operator
        using_postgresql? ? 'ILIKE' : 'LIKE'
      end

      # escape _ and % characters in strings, since these are wildcards in SQL.
      def escape_like(str)
        str.gsub(/[!%_]/) { |x| '!' + x }
      end
    end
  end
end
