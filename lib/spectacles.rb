# (The MIT License)
#
# Copyright (c) 2012 Adam Hutchison, http://github.com/liveh2o
# Copyright (c) 2012 Brandon Dewitt, http://abrandoned.com
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the 'Software'),
# to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense,
# and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
# IN THE SOFTWARE.

require 'active_record'
require 'active_support/core_ext'
require 'spectacles/schema_statements'
require 'spectacles/schema_dumper'
require 'spectacles/view'
require 'spectacles/version'

ActiveRecord::ConnectionAdapters::AbstractAdapter.class_eval do
  alias_method(:_spectacles_orig_inherited, :inherited) if method_defined?(:inherited)

  def self.inherited(klass)
    ::Spectacles::load_adapters
    _spectacles_orig_inherited if method_defined?(:_spectacles_orig_inherited)
  end
end

ActiveRecord::SchemaDumper.class_eval do
  alias_method(:_spectacles_orig_trailer, :trailer)

  def trailer(stream)
    ::Spectacles::SchemaDumper.dump_views(stream, @connection)
    _spectacles_orig_trailer(stream)
  end
end

Spectacles::load_adapters
