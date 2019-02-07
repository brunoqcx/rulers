module Rulers
  class Application
    def get_controller_and_action(env)
      _, cont, action, after = env['PATH_INFO'].split('/', 4)
      cont = cont.capitalize
      cont += 'Controller'

      p "xibs env path_info: #{env['PATH_INFO']}"

      [Object.const_get(cont), action]
    end
  end
end