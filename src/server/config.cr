module StreamTogether
  class Config
    enum Environment
      Development
      Testing
      Production
      def development?
        self === Development
      end
      def testing?
        self === Testing
      end
      def production?
        self === Production
      end
    end
    TIMEOUT_PERIOD = 15.seconds
    PWD = "/home/scott/Documents/code/stream_together"
    ENVIRONMENT = Environment::Development
  end
end
