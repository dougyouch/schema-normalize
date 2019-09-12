require 'spec_helper'

describe Schema::ModelNormalizer do
  let(:model_class) {
    Class.new do
      attr_accessor :name
    end
  }
  let(:name) { ' Name ' + SecureRandom.hex(8) + '  ' }
  let(:model) { model_class.new.tap { |m| m.name = name } }

  let(:method) { :strip }
  let(:if_option) { nil }
  let(:unless_option) { nil }
  let(:with_option) { nil }
  let(:class_option) { nil }
  let(:class_name_option) { nil }
  let(:args_option) { nil }
  let(:normalization_options) do
    {
      args: args_option,
      if: if_option,
      unless: unless_option,
      with: with_option,
      class: class_option,
      class_name: class_name_option
    }
  end
    
  let(:normalizer) do
    Schema::ModelNormalizer.new.tap do |normalizer|
      normalizer.add(:name, method, normalization_options)
    end
  end

  context '#normalize' do
    subject { normalizer.normalize(model) }

    it 'removes whitespace' do
      expect(subject.name).to eq(name.strip)
    end
  end
end
