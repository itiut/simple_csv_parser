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

  describe Lexer do
    describe '#read, #peek' do
      it 'should tokenize definition 1' do
        lexer = Lexer.new "aaa,bbb,ccc\r\nzzz,yyy,xxx\r\n"
        expect(lexer.peek(100).type).to eq(:eof)

        expect(lexer.read.text).to eq('aaa')
        expect(lexer.read.type).to eq(:comma)
        expect(lexer.read.text).to eq('bbb')
        expect(lexer.read.type).to eq(:comma)
        expect(lexer.read.text).to eq('ccc')
        expect(lexer.read.type).to eq(:crlf)
        expect(lexer.read.text).to eq('zzz')
        expect(lexer.read.type).to eq(:comma)
        expect(lexer.read.text).to eq('yyy')
        expect(lexer.read.type).to eq(:comma)
        expect(lexer.read.text).to eq('xxx')

        # Lexer chomps input data_string
        expect(lexer.read.type).to eq(:eof)
        expect(lexer.read.type).to eq(:eof)
        expect(lexer.peek(0).type).to eq(:eof)
      end

      it 'should tokenize definition 2' do
        lexer = Lexer.new "aaa,bbb,ccc\r\nzzz,yyy,xxx"
        expect(lexer.read.text).to eq('aaa')
        expect(lexer.read.type).to eq(:comma)
        expect(lexer.read.text).to eq('bbb')
        expect(lexer.read.type).to eq(:comma)
        expect(lexer.read.text).to eq('ccc')
        expect(lexer.read.type).to eq(:crlf)
        expect(lexer.read.text).to eq('zzz')
        expect(lexer.read.type).to eq(:comma)
        expect(lexer.read.text).to eq('yyy')
        expect(lexer.read.type).to eq(:comma)
        expect(lexer.read.text).to eq('xxx')
        expect(lexer.read.type).to eq(:eof)
      end

      it 'should tokenize definition 5' do
        lexer = Lexer.new %Q("aaa","bbb","ccc"\r\nzzz,yyy,xxx)
        expect(lexer.read.type).to eq(:dquote)
        expect(lexer.read.text).to eq('aaa')
        expect(lexer.read.type).to eq(:dquote)
        expect(lexer.read.type).to eq(:comma)
        expect(lexer.read.type).to eq(:dquote)
        expect(lexer.read.text).to eq('bbb')
        expect(lexer.read.type).to eq(:dquote)
        expect(lexer.read.type).to eq(:comma)
        expect(lexer.read.type).to eq(:dquote)
        expect(lexer.read.text).to eq('ccc')
        expect(lexer.read.type).to eq(:dquote)
        expect(lexer.read.type).to eq(:crlf)
        expect(lexer.read.text).to eq('zzz')
        expect(lexer.read.type).to eq(:comma)
        expect(lexer.read.text).to eq('yyy')
        expect(lexer.read.type).to eq(:comma)
        expect(lexer.read.text).to eq('xxx')
        expect(lexer.read.type).to eq(:eof)
      end

      it 'should tokenize definition 6' do
        lexer = Lexer.new %Q("aaa","b\r\nbb","ccc"\r\nzzz,yyy,xxx)
        expect(lexer.read.type).to eq(:dquote)
        expect(lexer.read.text).to eq('aaa')
        expect(lexer.read.type).to eq(:dquote)
        expect(lexer.read.type).to eq(:comma)
        expect(lexer.read.type).to eq(:dquote)
        expect(lexer.read.text).to eq('b')
        expect(lexer.read.type).to eq(:crlf)
        expect(lexer.read.text).to eq('bb')
        expect(lexer.read.type).to eq(:dquote)
        expect(lexer.read.type).to eq(:comma)
        expect(lexer.read.type).to eq(:dquote)
        expect(lexer.read.text).to eq('ccc')
        expect(lexer.read.type).to eq(:dquote)
        expect(lexer.read.type).to eq(:crlf)
        expect(lexer.read.text).to eq('zzz')
        expect(lexer.read.type).to eq(:comma)
        expect(lexer.read.text).to eq('yyy')
        expect(lexer.read.type).to eq(:comma)
        expect(lexer.read.text).to eq('xxx')
        expect(lexer.read.type).to eq(:eof)
      end

      it 'should tokenize definition 7' do
        lexer = Lexer.new %Q("aaa","b""bb","ccc")
        expect(lexer.read.type).to eq(:dquote)
        expect(lexer.read.text).to eq('aaa')
        expect(lexer.read.type).to eq(:dquote)
        expect(lexer.read.type).to eq(:comma)
        expect(lexer.read.type).to eq(:dquote)
        expect(lexer.read.text).to eq('b')
        expect(lexer.read.type).to eq(:twodquote)
        expect(lexer.read.text).to eq('bb')
        expect(lexer.read.type).to eq(:dquote)
        expect(lexer.read.type).to eq(:comma)
        expect(lexer.read.type).to eq(:dquote)
        expect(lexer.read.text).to eq('ccc')
        expect(lexer.read.type).to eq(:dquote)
        expect(lexer.read.type).to eq(:eof)
      end
    end
  end

  describe Runner do
    describe '#run' do
      it 'should parse spec/def{1..7}.csv successfully' do
        (1..7).map { |i| "#{__dir__}/def#{i}.csv" }.each do |csvfile|
          Runner.new([csvfile]).run
        end
      end

      it 'should raise error when parsing spec/ndef{1..3}.csv' do
        (1..3).map { |i| "#{__dir__}/ndef#{i}.csv" }.each do |csvfile|
          runner = Runner.new([csvfile])
          expect(-> () { runner.run }).to raise_error
        end
      end
    end
  end
end
