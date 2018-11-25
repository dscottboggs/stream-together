require "spec"
require "../src/stream_together"
StreamTogether::Config.environment = StreamTogether::Config::Environment::Testing

class ::String
  def includes!(other : String)
    includes?(other) || fail %<"#{self}" didn't contain "#{other}">
  end
end

struct ::Nil
  def includes!(other : String)
    fail %<tried checking if a String? contained "#{other}", but that string was nil.>
  end
end

# describe "an intentional failure" do
#   it "fails with a string" do
#     "something".includes! "else"
#   end
#   it "fails with nil" { nil.includes! "something"}
# end
