# frozen_string_literal: true

require "fileutils"
require "jekyll"
require "key_value_parser"
require "shellwords"
require_relative "../lib/jekyll_pre"

RSpec.describe(PreTagBlock) do
  it "parses arguments" do
    argv = Shellwords.split "number copyButton shell"
    options = KeyValueParser.new.parse(argv)
    # puts options.map { |k, v| "#{k} = #{v}" }.join("\n")

    expect(options[:copyButton]).to be true
    expect(options[:number]).to be true
    expect(options[:shell]).to be true
  end

  it "numbers content lines" do
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
    numbered_content = PreTagBlock.number_content(content)
    expected_content = <<~END_CONTENT
      <span class='unselectable'>  1: </span>Line 1
      <span class='unselectable'>  2: </span>  Line 2
      <span class='unselectable'>  3: </span>    Line 3
      <span class='unselectable'>  4: </span>    Line 4
      <span class='unselectable'>  5: </span>  Line 5
      <span class='unselectable'>  6: </span>Line 6
      <span class='unselectable'>  7: </span>Line 7
      <span class='unselectable'>  8: </span>  Line 8
      <span class='unselectable'>  9: </span>  Line 9
      <span class='unselectable'> 10: </span>Line 10
    END_CONTENT
    expect(numbered_content).to eq(expected_content)
  end
end
