require 'spec_helper'

describe SimpleCsvParser do
  it 'has a version number' do
    expect(SimpleCsvParser::VERSION).not_to be nil
  end

  describe SimpleCsvPaser::Token do
    describe '#self.create' do
      it 'should create eof token' do
        token1 = SimpleCsvPaser::Token.create("\n")
        expect(token1.type).to eq(:eof)
        expect(token1.text).to eq('')

        token2 = SimpleCsvPaser::Token.create('')
        expect(token2.type).to eq(:eof)
        expect(token2.text).to eq('')
      end

      it 'should create comma token' do
        token = SimpleCsvPaser::Token.create(",,\r\n")
        expect(token.type).to eq(:comma)
        expect(token.text).to eq(',')
      end

      it 'should create crlf token' do
        token = SimpleCsvPaser::Token.create("\r\n\n\n\n")
        expect(token.type).to eq(:crlf)
        expect(token.text).to eq("\r\n")
      end

      it 'should create cr token' do
        token = SimpleCsvPaser::Token.create("\raaa\n\n\n\n\n")
        expect(token.type).to eq(:cr)
        expect(token.text).to eq("\r")
      end

      it 'should create lf token' do
        token = SimpleCsvPaser::Token.create("\n\n\n\n\n")
        expect(token.type).to eq(:lf)
        expect(token.text).to eq("\n")
      end

      it 'should create twodquote token' do
        token = SimpleCsvPaser::Token.create(%Q(""""""))
        expect(token.type).to eq(:twodquote)
        expect(token.text).to eq(%Q(""))
      end

      it 'should create dquote token' do
        token = SimpleCsvPaser::Token.create(%Q(","""""))
        expect(token.type).to eq(:dquote)
        expect(token.text).to eq(%Q("))
      end

      it 'should create textdata token' do
        token = SimpleCsvPaser::Token.create(%Q(a0B!-\#",\r\n))
        expect(token.type).to eq(:textdata)
        expect(token.text).to eq(%Q(a0B!-\#))
      end
    end
  end
end
