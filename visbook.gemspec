require_relative "lib/visbook/version"

Gem::Specification.new do |spec|
  spec.name = "visbook"
  spec.version = Visbook::VERSION
  spec.authors = ["SERVOS"]
  spec.email = ["a@asgerbehnckejacobsen.dk"]

  spec.summary = "Ruby client for the VisBook v8 booking API"
  spec.description = "A client for the VisBook v8 booking API (ws.visbook.com). Plain Ruby, no runtime dependencies."
  spec.homepage = "https://github.com/servos-app/visbook"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.4"

  spec.files = Dir["lib/**/*.rb"]
  spec.require_paths = ["lib"]
end
