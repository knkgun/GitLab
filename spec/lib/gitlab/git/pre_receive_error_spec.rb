# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Gitlab::Git::PreReceiveError do
  Gitlab::Git::PreReceiveError::SAFE_MESSAGE_PREFIXES.each do |prefix|
    context "error messages prefixed with #{prefix}" do
      it 'accepts only errors lines with the prefix' do
        raw_message = "#{prefix} Hello,\nworld!"
        ex = described_class.new(raw_message)

        expect(ex.message).to eq('Hello,')
        expect(ex.raw_message).to eq(raw_message)
      end

      it 'makes its message HTML-friendly' do
        raw_message = "#{prefix} Hello,\n#{prefix} world!\n"
        ex = described_class.new(raw_message)

        expect(ex.message).to eq('Hello,<br>world!')
        expect(ex.raw_message).to eq(raw_message)
      end

      it 'sanitizes the user message' do
        raw_message = 'Raw message'
        ex = described_class.new(raw_message, "#{prefix} User message")

        expect(ex.raw_message).to eq(raw_message)
        expect(ex.message).to eq('User message')
      end
    end
  end
end
