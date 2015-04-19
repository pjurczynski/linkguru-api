module Parsers
  describe Link do
    let(:body) { 'add link <http://something.co> some description #tag <#tag2>' }
    subject { described_class.new(body) }

    it { expect(subject.url).to eq 'http://something.co' }
    it { expect(subject.description).to eq 'some description' }
    it { expect(subject.tag_list).to match_array [['tag'], ['<#tag2>']] }

    context 'no description has been passed' do
      let(:body) { 'add link <http://something.co> #tag <#tag2>' }

      it { expect(subject.url).to eq 'http://something.co' }
      it { expect(subject.description).to eq '** no description appended **' }
      it { expect(subject.tag_list).to match_array [['tag'], ['<#tag2>']] }
    end
  end
end
