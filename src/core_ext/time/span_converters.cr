module Time::Span::SecondConverter
  extend self

  def from_json(pull)
    Span.new seconds: pull.read_int, nanoseconds: 0
  end

  def to_json(span, builder)
    builder.number(span.total_seconds)
  end
end

module Time::Span::NanosecondConverter
  extend self

  def from_json(pull)
    Span.new nanoseconds: pull.read_int
  end

  def to_json(span, builder)
    builder.number(span.total_nanoseconds)
  end
end
