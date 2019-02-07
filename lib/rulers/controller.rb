require 'erubis'
require_relative 'file_model'

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
  end
end