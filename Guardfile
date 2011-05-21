guard 'rspec', :cli => "--color --fail-fast", :version => 2 do
  watch(%r{^spec/(.+)_spec\.rb})
  watch(%r{^lib/(.+)\.rb})
  watch(%r{^spec/spec_helper\.rb})                       { "spec" }
end
