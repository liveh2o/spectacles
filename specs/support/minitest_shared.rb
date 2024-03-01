require 'Minitest/spec'

Minitest::Spec.class_eval do
  def self.shared_examples
    @shared_examples ||= {}
  end
end

module Minitest::Spec::SharedExamples
  def shared_examples_for(desc, &block)
    Minitest::Spec.shared_examples[desc] = block
  end

  def it_behaves_like(desc, *args)
    examples = Minitest::Spec.shared_examples[desc]
    instance_exec(*args, &examples)
  end
end

Object.class_eval { include(Minitest::Spec::SharedExamples) }
