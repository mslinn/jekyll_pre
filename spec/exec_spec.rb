require_relative '../lib/jekyll_pre'

module ExecTagSpec
  extend ExecTagModule

  RSpec.describe('misc') do
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
      actual = ExecTagSpec.compress content, false
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
      expect(expected).to eq(actual)
    end
  end
end
