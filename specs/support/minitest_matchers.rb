require 'minitest/spec'

module Minitest::Expectations
  infect_an_assertion :assert_equal, :must_be
end
