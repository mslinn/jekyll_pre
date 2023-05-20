require 'fileutils'
require 'jekyll'
require 'key_value_parser'
require 'shellwords'
require_relative '../lib/jekyll_pre'

RSpec.describe(JekyllPreModule::PreTagBlock) do
  it 'dedents content lines' do
    content = <<-END_CONTENT
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
    actual = content.dedent
    expect(actual).to eq(expected)
  end

  it 'removes surrounding whitespace' do
    text = <<-END_CONTENT


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
    actual = described_class.remove_surrounding(text)

    expected = <<-END_CONTENT
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

    expect(actual).to eq(expected.rstrip)
  end

  it 'parses arguments' do
    argv = Shellwords.split 'number copyButton shell'
    options = KeyValueParser.new.parse(argv)
    # puts options.map { |k, v| "#{k} = #{v}" }.join("\n")

    expect(options[:copyButton]).to be true
    expect(options[:number]).to be true
    expect(options[:shell]).to be true
  end

  it 'numbers content lines' do
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
    numbered_content = described_class.number_content(content)
    expected_content = <<~END_CONTENT
      <span class='unselectable numbered_line'>  1: </span>Line 1
      <span class='unselectable numbered_line'>  2: </span>  Line 2
      <span class='unselectable numbered_line'>  3: </span>    Line 3
      <span class='unselectable numbered_line'>  4: </span>    Line 4
      <span class='unselectable numbered_line'>  5: </span>  Line 5
      <span class='unselectable numbered_line'>  6: </span>Line 6
      <span class='unselectable numbered_line'>  7: </span>Line 7
      <span class='unselectable numbered_line'>  8: </span>  Line 8
      <span class='unselectable numbered_line'>  9: </span>  Line 9
      <span class='unselectable numbered_line'> 10: </span>Line 10
    END_CONTENT
    expect(numbered_content).to eq(expected_content)
  end

  it 'highlights regex patterns' do
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
    highlighted = described_class.highlight(content, '.*2').split("\n")[1]
    expect(highlighted).to eq("<span class='bg_yellow'>  Line 2</span>")
  end
end
