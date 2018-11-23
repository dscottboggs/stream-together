class StreamTogether::Config
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
end
