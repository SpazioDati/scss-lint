require 'spec_helper'

describe SCSSLint::Linter::SingleLinePerSelector do
  let(:engine) { SCSSLint::Engine.new(css) }
  subject { SCSSLint::Linter::SingleLinePerSelector.run(engine) }

  context 'when rule has one selector' do
    let(:css) { <<-EOS }
      p {
      }
    EOS

    it 'returns no lints' do
      subject.count.should == 0
    end
  end

  context 'when rule has one selector on each line' do
    let(:css) { <<-EOS }
      p,
      a {
      }
    EOS

    it 'returns no lints' do
      subject.count.should == 0
    end
  end

  context 'when rule contains multiple selectors on the same line' do
    let(:css) { <<-EOS }
      .first,
      .second,
      .third, .fourth,
      .fifth {
      }
    EOS

    it 'returns a lint' do
      subject.count.should == 1
    end

    it 'reports the first line of the multi-selector declaration for the lint' do
      subject.first.line.should == 4
    end
  end

  context 'when nested rule contains multiple selectors on the same line' do
    let(:css) { <<-EOS }
      #foo {
        .first,
        .second,
        .third, .fourth,
        .fifth {
        }
      }
    EOS

    it 'returns a lint' do
      subject.count.should == 1
    end

    it 'reports the last line of the multi-selector declaration for the lint' do
      subject.first.line.should == 5
    end
  end
end
