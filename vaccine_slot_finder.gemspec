# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "vaccine_slot_finder/version"

Gem::Specification.new do |spec|
  spec.name          = "vaccine_slot_finder"
  spec.version       = VaccineSlotFinder::VERSION
  spec.authors       = ["drg-dhyan"]
  spec.email         = ["dhyanbaba@gmail.com"]

  spec.summary       = %q{Gem to check console output of vaccine availability}
  spec.description   = %q{Uses COWIN api to find vaccine centres based on pincode and date}
  spec.homepage      = ""
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  # if spec.respond_to?(:metadata)
  #   spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  # else
  #   raise "RubyGems 2.0 or newer is required to protect against " \
  #     "public gem pushes."
  # end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "bin"
  #spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.executables   = ["vaccine_slot_finder"]
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.15"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "httparty", "~> 0.18.1"
  spec.add_development_dependency "twilio-ruby", "4.13.0"
  spec.add_development_dependency "whenever", "1.0.0"
end
