require 'spec_helper'

module SimpleCsvPaser
  describe Token do
    describe '#self.create' do
      it 'should create comma token' do
        token = Token.create(",,\r\n")
        expect(token.type).to eq(:comma)
        expect(token.text).to eq(',')
      end

      it 'should create crlf token' do
        token = Token.create("\r\n\n\n\n")
        expect(token.type).to eq(:crlf)
        expect(token.text).to eq("\r\n")
      end

      it 'should create cr token' do
        token = Token.create("\raaa\n\n\n\n\n")
        expect(token.type).to eq(:cr)
        expect(token.text).to eq("\r")
      end

      it 'should create lf token' do
        token = Token.create("\n\n\n\n\n")
        expect(token.type).to eq(:lf)
        expect(token.text).to eq("\n")
      end

      it 'should create twodquote token' do
        token = Token.create(%Q(""""""))
        expect(token.type).to eq(:twodquote)
        expect(token.text).to eq(%Q(""))
      end

      it 'should create dquote token' do
        token = Token.create(%Q(","""""))
        expect(token.type).to eq(:dquote)
        expect(token.text).to eq(%Q("))
      end

      it 'should create textdata token' do
        token = Token.create(%Q(a0B!-\#",\r\n))
        expect(token.type).to eq(:textdata)
        expect(token.text).to eq(%Q(a0B!-\#))
      end
    end
  end
end
