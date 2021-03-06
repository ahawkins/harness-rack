require "harness/rack/version"

require 'harness'

module Harness
  class RackInstrumenter
    include Instrumentation

    def initialize(app, namespace = nil)
      @app, @namespace = app, namespace
    end

    def call(env)
      status, headers, body = time stat_name('rack.request', 'all') do
        @app.call env
      end

      increment "#{stat_name("rack.request")}.#{status}"

      [status, headers, body]
    end

    def stat_name(name, type = nil)
      [name, @namespace, type].compact.join('.')
    end
  end
end
