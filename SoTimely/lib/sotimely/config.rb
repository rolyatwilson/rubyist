module SoTimely
  class Config
    attr_reader :domain, :token
    def initialize
      path = File.expand_path(File.join(__dir__, '..', '..', 'config', 'secrets.yml'))
      raise 'Secrets Path Not Found!' unless File.exist?(path)
      secrets = YAML.load_file(path).deep_symbolize_keys!
      @domain = secrets[:domain]
      @token = secrets[:token]
    end
  end
end
