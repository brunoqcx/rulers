module Rulers
  def self.to_underscore(string)
    string.gsub(/::/, '/').
    gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2').
    gsub(/([a-z\d])([A-Z])/,'\1_\2').
    tr('-', '_').
    downcase
  end

  def self.action_name_from_env(env)
    _, _, action, _ = env['PATH_INFO'].split('/', 4)[2]
  end
end