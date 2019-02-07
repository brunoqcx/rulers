require 'erubis'

module Rulers
  class Controller
    attr_reader :env

    def initialize(env)
      @env = env

      render
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
      instance_variable_hash = {}

      self.instance_variables.each do |instance_variable|
        p instance_variable
        p self.instance_variable_get(instance_variable)
        instance_variable_hash[instance_variable] = self.instance_variable_get(instance_variable)
      end

      instance_variable_hash
    end
  end
end