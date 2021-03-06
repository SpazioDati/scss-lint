require 'spec_helper'

describe SCSSLint::Linter::DebugLinter do
  let(:engine) { SCSSLint::Engine.new(css) }
  subject { SCSSLint::Linter::DebugLinter.run(engine) }

  context 'when no debug statements are present' do
    let(:css) { <<-EOS }
      p {
        color: #fff;
      }
    EOS

    it 'returns no lints' do
      subject.should be_empty
    end
  end

  context 'when a debug statement is present' do
    let(:css) { <<-EOS }
      @debug 'This is a debug statement';
    EOS

    it 'returns a lint' do
      subject.count.should == 1
    end

    it 'reports the line of the debug statement for the lint' do
      subject.first.line.should == 1
    end
  end
end
