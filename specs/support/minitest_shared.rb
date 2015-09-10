require 'minitest/spec'

MiniTest::Spec.class_eval do
  def self.shared_examples
    @shared_examples ||= {}
  end
end

module MiniTest::Spec::SharedExamples
  def shared_examples_for(desc, &block)
    MiniTest::Spec.shared_examples[desc] = block
  end

  def it_behaves_like(desc, *args)
    examples = MiniTest::Spec.shared_examples[desc]
    instance_exec(*args, &examples)
  end
end

Object.class_eval { include(MiniTest::Spec::SharedExamples) }
