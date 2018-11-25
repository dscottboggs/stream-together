require "./config/*"

module StreamTogether
  class Config
    TIMEOUT_PERIOD = 15.seconds
    PWD            = "/home/scott/Documents/code/stream_together"
    @@environment = Environment::Development

    def self.environment=(env : Environment)
      ENV["KEMAL_ENV"] = "test" if env === Environment::Testing
      @@environment = env
    end

    def self.environment
      @@environment
    end
  end
end
