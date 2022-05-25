# frozen_string_literal: true
require 'spec_helper'

describe Schema::Normalize do
  let(:model_class) {
    Class.new do
      include Schema::Normalize
      attr_accessor :name,
                    :other_name
      normalize :name, :strip
    end
  }
  let(:name) { ' Name ' + SecureRandom.hex(8) + '  ' }
  let(:other_name) { ' Other Name ' + SecureRandom.hex(8) + '  ' }
  let(:model) { model_class.new.tap { |m| m.name = name; m.other_name = other_name } }

  context '#normalize' do
    subject { model.normalize }

    it 'removes whitespace' do
      expect(subject.name).to eq(name.strip)
      expect(subject.other_name).to eq(other_name)
    end

    describe 'inheritance' do
      let(:model_class_other) do
        Class.new(model_class) do
          normalize(:other_name, &:lstrip)
        end
      end

      let(:other_model) { model_class_other.new.tap { |m| m.name = name; m.other_name = other_name } }

      it 'original clas' do
        other_model.normalize
        model.normalize
        expect(model.name).to eq(name.strip)
        expect(model.other_name).to eq(other_name)
        expect(other_model.name).to eq(name.strip)
        expect(other_model.other_name).to eq(other_name.lstrip)
      end
    end
  end
end

