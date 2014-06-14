require File.dirname(__FILE__) + '/fake_british_toponym'

MANY = 10e3.to_i

describe FakeBritishToponym do

  it 'should be a string' do
    expect(subject).to be_a String
  end


  describe 'options' do

    describe 'modifier' do
      describe 'when set to false' do
        it 'should never include antefix or postfix' do
          MANY.times do
            toponym = FakeBritishToponym.new(modifier: false)
            expect(toponym).to_not include ' '
            expect(toponym).to_not include '-'
            expect(toponym).to_not include "'"
          end
        end
      end

      it 'should not contain obvious errors' do
        MANY.times do
          toponym = FakeBritishToponym.new(modifier: true)
          [' -', '- ', " '", "' "].each do |bad_char_sequence|
            expect(toponym).not_to include bad_char_sequence
          end
        end
      end
    end

    describe 'min_syllables' do
      it 'should return words of roughly appropriate length' do
        MANY.times do
          length = rand(10)
          toponym = FakeBritishToponym.new(min_syllables: length)
          expect(toponym.length).to be >= length * 2
        end
      end
    end

  end

end
