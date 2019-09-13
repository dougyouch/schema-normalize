# frozen_string_literal: true
require 'spec_helper'

describe Schema::Normalize do
  let(:model_class) {
    Class.new do
      include Schema::Normalize
      attr_accessor :name
      normalize :name, :strip
    end
  }
  let(:name) { ' Name ' + SecureRandom.hex(8) + '  ' }
  let(:model) { model_class.new.tap { |m| m.name = name } }

  context '#normalize' do
    subject { model.normalize }

    it 'removes whitespace' do
      expect(subject.name).to eq(name.strip)
    end
  end
end

