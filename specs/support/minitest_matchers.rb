require 'minitest/spec'

module MiniTest::Expectations
  infect_an_assertion :assert_equal, :must_be
end
