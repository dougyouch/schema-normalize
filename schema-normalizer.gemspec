# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name        = 'schema-normalize'
  s.version     = '0.1.0'
  s.licenses    = ['MIT']
  s.summary     = 'Schema Normalize'
  s.description = 'Easy way to normalize attributes'
  s.authors     = ['Doug Youch']
  s.email       = 'dougyouch@gmail.com'
  s.homepage    = 'https://github.com/dougyouch/schema-normalize'
  s.files       = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }

  s.add_runtime_dependency 'inheritance-helper'
end
