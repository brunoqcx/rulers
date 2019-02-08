require 'erubis'
require_relative 'file_model'
require 'rack/request'

module Rulers
  class Controller
    attr_reader :env
    include Rulers::Model

    def initialize(env)
      @env = env
    end

    def render(locals = {})
      file_name = File.join 'app', 'views', controller_name, "#{action_name}.html.erb"
      template = File.read file_name
      eruby = Erubis::Eruby.new(template)
      eruby.result locals.merge(instance_variable_hash)
    end

    def response(text, status = 200, headers = {})
      raise 'Already responded!' if @response
      a = [text].flatten
      @response =Rack::Response.new(a, status, headers)
    end

    def get_response
      @response
    end

    def render_response(*args)
      response(render(*args))
    end
    
    def controller_name
      klass = self.class
      klass = klass.to_s.gsub /Controller$/, ""
      Rulers.to_underscore klass
    end

    def action_name
      Rulers.action_name_from_env(env)
    end

    def instance_variable_hash
      instance_variables.each_with_object({}) { |k, v| v[k] = instance_variable_get(k) }
    end

    def request
      @request ||= Rack::Request.new(@env)
    end

    def params
      request.params
    end
  end
end