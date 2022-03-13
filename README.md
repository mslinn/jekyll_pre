Jekyll_pre
[![Gem Version](https://badge.fury.io/rb/jekyll_pre.svg)](https://badge.fury.io/rb/jekyll_pre)
===========

This is a Jekyll plugin that provides two Liquid tags: `pre` and `noselect` that frequently work together:

 * A `pre` block tag that can optionally display a copy button.
 * A `noselect` tag that can renders HTML content passed to it unselectable.


## Installation

Add this line to your application's Gemfile, within the `jekyll_plugins` group:

```ruby
group :jekyll_plugins do
  gem 'jekyll_pre'
end
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install jekyll_pre


## Usage

Unfortunately markdown does not support CSS styles, so the HTML rendering of the examples is compromised.

### Syntax

<pre data-lt-active="false" class="maxOneScreenHigh copyContainer" id="id7478d3e758a5"><button class="copyBtn" data-clipboard-target="#id7478d3e758a5" title="Copy to clipboard"><img src="images/clippy.svg" alt="Copy to clipboard" style="width: 13px"></button>{% pre [copyButton] [shell] [headline words] %}
Contents of pre tag
{% endpre %}</pre>

<pre data-lt-active="false" class="maxOneScreenHigh copyContainer" id="idbb1564f70e84">{% pre [copyButton] %}
{% noselect [text string]%}Contents of pre tag
{% endpre %}</pre>

### Usage Example 1
This example does not generate a copy button and does not demonstrate `noselect`.
<pre data-lt-active="false" class="maxOneScreenHigh copyContainer" id="id110c50d624b4">{% pre %}
Contents of pre tag
{% endpre %}</pre>

Generates:
<pre data-lt-active="false" class="maxOneScreenHigh copyContainer" id="idddd87a0eb77d">&lt;pre data-lt-active='false' class='maxOneScreenHigh copyContainer' id='id377433c30186'&gt;Contents of pre tag&lt;/pre&gt;</pre>

Which renders as:

<pre data-lt-active="false" class="maxOneScreenHigh copyContainer" id="id377433c30186">Contents of pre tag</pre>

### Usage Example 2
This example generates a copy button and does not demonstrate `noselect`.

<pre data-lt-active="false" class="maxOneScreenHigh copyContainer" id="idb92b40eba687">{% pre copyButton %}Contents of pre tag
{% endpre %}</pre>

Generates:
<pre data-lt-active="false" class="maxOneScreenHigh copyContainer" id="id08a5d26db177">&lt;pre data-lt-active='false' class='maxOneScreenHigh copyContainer' id='id6a831a3e8992'&gt;&lt;button class='copyBtn' data-clipboard-target='#id6a831a3e8992' title='Copy to clipboard'&gt;&lt;img src='images/clippy.svg' alt='Copy to clipboard' style='width: 13px'&gt;&lt;/button&gt;Contents of pre tag&lt;/pre&gt;</pre>

Which renders as:
<pre data-lt-active="false" class="maxOneScreenHigh copyContainer" id="id6a831a3e8992"><button class="copyBtn" data-clipboard-target="#id6a831a3e8992" title="Copy to clipboard"><img src="images/clippy.svg" alt="Copy to clipboard" style="width: 13px"></button>Contents of pre tag</pre>

### Usage Example 3
This example generates a copy button and does demonstrates the default usage of `noselect`, which renders an unselectable dollar sign followed by a space.
<pre data-lt-active="false" class="maxOneScreenHigh copyContainer" id="id59feb02aa3b9">{% pre copyButton %}
{% noselect %}Contents of pre tag
{% endpre %}</pre>

Generates:

<pre data-lt-active="false" class="maxOneScreenHigh copyContainer" id="id7935a9ec84be">&lt;pre data-lt-active='false' class='maxOneScreenHigh copyContainer' id='id8103adbe3dc2'&gt;&lt;button class='copyBtn' data-clipboard-target='#id8103adbe3dc2' title='Copy to clipboard'&gt;&lt;img src='images/clippy.svg' alt='Copy to clipboard' style='width: 13px'&gt;&lt;/button&gt;&lt;span class='unselectable'&gt;$ &lt;/span&gt;Contents of pre tag&lt;/pre&gt;</pre>

Which renders as:

<pre data-lt-active="false" class="maxOneScreenHigh copyContainer" id="id8103adbe3dc2"><button class="copyBtn" data-clipboard-target="#id8103adbe3dc2" title="Copy to clipboard"><img src="images/clippy.svg" alt="Copy to clipboard" style="width: 13px"></button><span class="unselectable">$ </span>Contents of pre tag</pre>

### Usage Example 4
This example generates a copy button and does demonstrates the `noselect` being used twice:
the first time to render an unselectable custom prompt,
and the second time to render unselectable output.

<pre data-lt-active="false" class="maxOneScreenHigh copyContainer" id="id0f0a8de5ecc5">{% pre copyButton %}{% noselect &gt;&gt;&gt; %}Contents of pre tag
{% noselect How now brown cow%}
{% endpre %}</pre>

Generates:
<pre data-lt-active="false" class="maxOneScreenHigh copyContainer" id="id3095048e2ec2">&lt;pre data-lt-active='false' class='maxOneScreenHigh copyContainer' id='idcb8035dc3766'&gt;&lt;button class='copyBtn' data-clipboard-target='#idcb8035dc3766' title='Copy to clipboard'&gt;&lt;img src='images/clippy.svg' alt='Copy to clipboard' style='width: 13px'&gt;&lt;/button&gt;&lt;span class='unselectable'&gt;&gt;&gt;&gt; &lt;/span&gt;contents of pre tag
&lt;span class='unselectable'&gt;How now brown cow&lt;/span&gt;&lt;/pre&gt;</pre>

Which renders as:

<pre data-lt-active="false" class="maxOneScreenHigh copyContainer" id="idcb8035dc3766"><button class="copyBtn" data-clipboard-target="#idcb8035dc3766" title="Copy to clipboard"><img src="images/clippy.svg" alt="Copy to clipboard" style="width: 13px"></button><span class="unselectable">&gt;&gt;&gt; </span>contents of pre tag
<span class="unselectable">How now brown cow</span></pre>

### CSS
Here are the CSS declarations that I defined pertaining to the `pre` and `noselect` tags:

<pre data-lt-active="false" class="maxOneScreenHigh copyContainer" id="id68ec1ab4d04c"><button class="copyBtn" data-clipboard-target="#id68ec1ab4d04c" title="Copy to clipboard"><img src="images/clippy.svg" alt="Copy to clipboard" style="width: 13px"></button>.maxOneScreenHigh {
  max-height: 500px;
}

.unselectable {
  color: #7922f9;
  -moz-user-select: none;
  -khtml-user-select: none;
  user-select: none;
}</pre>

### Comprehensive Example
The code I wrote to generate the above CSS was a good example of how the plugins work together with
the `from` and `to` tags from my `from_to_until` plugin:

<pre data-lt-active="false" class="maxOneScreenHigh copyContainer" id="id1ad3df5c4a2f">
{% capture css %}{% flexible_include '_sass/mystyle.scss' %}{% endcapture %}
{% pre copyButton %}{{ css | from: '.copyBtn' | to: '^$' | strip }}

{{ css | from: '.copyContainer' | to: '^$' | strip }}

{{ css | from: '.maxOneScreenHigh' | to: '^$' | strip }}

{{ css | from: '.unselectable' | to: '^$' | strip }}
{% endpre %}</pre>


## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/jekyll_pre.


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
