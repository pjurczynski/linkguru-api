require 'rails_helper'
module Parsers
  describe TriggerWord do

    describe '#keyword?' do
      context 'multiple valid keywords' do
        let(:valid_keywords) { %i[simple world] }

        context 'valid trigger word' do
          it 'says that either word is valid' do
            simple = described_class.new(:simple)
            expect(simple.send(:keyword?, valid_keywords)).to be_truthy

            world = described_class.new(:world)
            expect(world.send(:keyword?, valid_keywords)).to be_truthy
          end
        end

        context 'invalid trigger word' do
          it 'is invalid' do
            non_existent = described_class.new(:non_existent)
            expect(non_existent.send(:keyword?, valid_keywords)).to be_falsey
          end
        end
      end
    end
  end
end
