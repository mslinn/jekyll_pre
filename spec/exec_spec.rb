require_relative '../lib/jekyll_pre'

module ExecTagSpec
  RSpec.describe(JekyllPreModule) do
    it 'strips properly' do
      content = <<~END_CONTENT
        Line 1
          Line 2
            Line 3
            Line 4
          Line 5
        Line 6
        Line 7
          Line 8
          Line 9
        Line 10
      END_CONTENT
      actual = described_class.compress content, false
      expected = <<~END_CONTENT
        Line 1
          Line 2
            Line 3
            Line 4
          Line 5
        Line 6
        Line 7
          Line 8
          Line 9
        Line 10
      END_CONTENT
      expect(expected.strip).to eq(actual)
    end
  end
end
