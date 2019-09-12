require 'spec_helper'

describe Schema::AttributeNormalizer do
  let(:model_class) {
    Class.new do
      attr_accessor :name,
                    :name_changed

      def name_changed?
        !! @name_changed
      end

      def normalize_name(name)
        name.upcase
      end
    end
  }
  let(:model) { model_class.new }
  let(:name) { ' Name ' + SecureRandom.hex(8) + '  ' }

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
    Schema::AttributeNormalizer.new.tap do |normalizer|
      normalizer.add(method, normalization_options)
    end
  end

  let(:normalization_class_name) { 'Normalization' + SecureRandom.hex(8) }
  let(:normalization_class) do
    kls = Class.new do
      def self.trim(str)
        str.rstrip
      end
    end
    Object.const_set(normalization_class_name, kls)
  end

  context 'normalize' do
    subject { normalizer.normalize(model, name) }

    it 'removes whitespace' do
      expect(subject).to eq(name.strip)
    end

    describe 'chain normalization methods' do
      it 'removes whitespace and upcases the name' do
        normalizer.add(:upcase)
        expect(subject).to eq(name.strip.upcase)
      end
    end

    describe 'if option' do
      let(:if_option) { :name_changed? }

      it 'skips the normalization' do
        expect(subject).to eq(name)
      end

      it 'removes white space' do
        model.name_changed = true
        expect(subject).to eq(name.strip)
      end

      describe 'if option as proc' do
        let(:if_option) { Proc.new { name_changed? } }

        it 'removes white space' do
          model.name_changed = true
          expect(subject).to eq(name.strip)
        end
      end
    end

    describe 'unless option' do
      let(:unless_option) { :name_changed? }

      it 'removes white space' do
        expect(subject).to eq(name.strip)
      end

      it 'skips the normalization' do
        model.name_changed = true
        expect(subject).to eq(name)
      end
    end

    describe 'method as a proc' do
      let(:method) { Proc.new { |v| v.strip.upcase } }

      it 'removes white space' do
        expect(subject).to eq(name.strip.upcase)
      end
    end

    describe 'method name as a string or unhandled type' do
      let(:method) { 'string' }

      it 'raises an exception' do
        expect { subject }.to raise_exception(RuntimeError)
      end
    end

    describe 'with option' do
      let(:method) { nil }
      let(:with_option) { :normalize_name }

      it 'uses the model method to normalize the attribute' do
        expect(subject).to eq(name.upcase)
      end

      describe 'class option' do
        let(:with_option) { :trim }
        let(:class_option) { normalization_class }

        it 'removes trainling whitespace' do
          expect(subject).to eq(name.rstrip)
        end
      end

      describe 'class_name option' do
        let(:with_option) { :trim }
        let(:class_name_option) { normalization_class.name }

        it 'removes trainling whitespace' do
          expect(subject).to eq(name.rstrip)
        end
      end
    end
  end

  context 'normalize_model_attribute' do
    let(:model) { model_class.new.tap { |m| m.name = name } }

    subject { normalizer.normalize_model_attribute(model, :name); model.name }

    it 'removes whitespace' do
      expect(subject).to eq(name.strip)
    end
  end
end
