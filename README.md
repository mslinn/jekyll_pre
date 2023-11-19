# Jekyll_pre [![Gem Version](https://badge.fury.io/rb/jekyll_pre.svg)](https://badge.fury.io/rb/jekyll_pre)

This Jekyll plugin provides 3 new Liquid tags that work together:

* A `pre` block tag that can be displayed various ways.

  ```html
  {% pre [Options] [free text label] %}
  Contents of pre tag
  {% endpre %}
  ```

  `Options` are:

    - `class="class1 class2"` &ndash; Apply CSS classes
    - `clear` &ndash; Line break after floating HTML elements
    - `copyButton` &ndash; Generate a copy button
    - `dark` &ndash; Dark mode
    - `dedent` &ndash; Remove leading spaces common to all lines, like Ruby's <<~ squiggly heredoc (default is false)
    - `label='This is a label'` &ndash; Apply text above `pre` tag.
      The `label` parameter value can also be specified in free text.
      For example, the following produce the same results:

      - {% pre label="This is a label" %}<br>Contents of pre tag<br>{% endpre %}

      - {% pre This is a label %}<br>Contents of pre tag<br>{% endpre %}
    - `number` &ndash; Number the lines
    - `shell` &ndash; Equivalent to `label='Shell'`
    - `style` &ndash; Apply inline CSS styles

  The generated &lt;pre>&lt;/pre> tag has an `data-lt-active="false"` attribute, so
  [LanguageTool](https://forum.languagetool.org/t/avoid-spell-check-on-certain-html-inputs-manually/3944)
  does not check the spelling or grammar of the contents.

* A `noselect` tag that can renders HTML content passed to it unselectable,
  and generates a <code>$</code> prompt if no content is provided.

  ```html
  {% pre %}
  {% noselect [optional text string, defaults to $]%}Command
  {% noselect unselectable output goes here %}
  {% endpre %}
  ```

* An `exec` tag that executes shell commands and incorporates the command and its output into the content of the `pre` tag.
  Environment variables are evaluated,
  output data is escaped, whitespace is condensed, and wrapped in the same `unselectable` class as does `unselectable`.

  ```html
  {% exec [Options] [shell command] %}
  ```

  `Options` are:

    - `cd="relative/or/absolute/directory"` - Change to specified directory before executing shell command.
      Environment variables in the directory path will be expanded.
    - `die_if_nonzero` – Set `false` to treat non-zero return codes as non-fatal.
      Instead of terminating Jekyll with an error message,
      the message will be displayed as an error by the Jekyll logger,
      and a red message will appear in place of the result on the web page.
    - `die_if_error` – Set `false` to treat exceptions generated by this plugin as non-fatal.
      Instead of terminating Jekyll with an error message, the message will be displayed as an error by the Jekyll logger.
    - `no_escape` – Do not HTML escape the result of running the shell command.
    - `no_strip` – Do not remove leading and trailing whitespace from the result.
    - `wrapper_class` class applied to outer `div`.
    - `wrapper_style` style applied to outer `div`.


## Keyword Options

For all keyword options, including keyword options for the `pre` and `exec` tags:

 - Option values specified in the document *may* be provided.
   If a value is not provided, the value `true` is assumed.
   Otherwise, if a value is provided, it *must* be wrapped in single or double quotes.

 - Option values specified in `_config.yml` *must* be provided, and the value `true` cannot be implied.
   Values that do not contain special characters *may* be wrapped in single or double quotes.

### Examples

#### Specifying Tag Option Values

The following sets `die_if_error` `true`:

```html
{% pre die_if_error %} ... {% endpre %}
```

The above is the same as writing:

```html
{% pre die_if_error='true' %} ... {% endpre %}
```

Or writing:

```html
{% pre die_if_error="true" %} ... {% endpre %}
```

Neglecting to provide surrounding quotes around the provided value causes the parser to not recognize the option.
Instead, what you had intended to be the keyword/value pair will be parsed as part of the command.
For the `pre` tag, this means the erroneous string becomes part of the `label` value, unless `label` is explicitly specified.
For the `exec` tag, this means the erroneous string becomes part of the command to execute.
The following demonstrates the error.

```html
{% pre die_if_error=false %} ... {% endpre %}
```

The above causes the label to be `die_if_error=false`.

```html
{% exec die_if_error=false ls %} ... {% endpre %}
```

The above causes the command to be executed to be `die_if_error=false ls` instead of `ls`.


## CSS

See [`demo/assets/css/style.css`](demo/assets/css/style.css) for the CSS declarations,
between `/* Start of pre tag css */` and `/* End of pre tag css */`.


## Configuration

Default options can be set for the `pre` tag by entries in `_config.yml`.
The following demonstrates setting a default value for every possible option:

```yml
pre:
  class: bg_yellow
  clear: true
  dark: true
  dedent: true
  highlight: 'Error:.*'
  label: Shell
  copyButton: true
  number: true
  style: 'font-face: courier'
  wrapper_class: rounded shadow
  wrapper_style: 'padding: 2em; border: thin green dashed;'
```

The default values used on [`mslinn.com`](https://www.mslinn.com) are:

```yml
pre:
  dedent: true
  label: Shell
  copyButton: true
```


### Specifying Default Option Values

Specifying a default value for `die_if_error` in `_config.yml` could be done as follows:

```yaml
pre:
  die_if_error: true
```

```yaml
pre:
  die_if_error: "true"
```

```yaml
pre:
  die_if_error: 'true'
```


## Additional Information

More information is available on
[Mike Slinn&rsquo;s website](https://www.mslinn.com/jekyll_plugins/jekyll_pre.html).


## Installation

Add this line to your application's Gemfile, within the `jekyll_plugins` group:

```ruby
group :jekyll_plugins do
  gem 'jekyll_pre'
end
```

And then execute:

```shell
$ bundle
```


## Usage

The following examples are rendered on
[Mike Slinn&rsquo;s website](https://www.mslinn.com/jekyll_plugins/jekyll_pre.html).

### Example 0

<pre data-lt-active="false" class="maxOneScreenHigh copyContainer" id="id110c50d624b4">{% pre dedent %}
    This line was indented 4 spaces
      This line was indented 6 spaces
    This line was indented 4 spaces
{% endpre %}</pre>

Which renders as:

<pre data-lt-active="false" class="maxOneScreenHigh copyContainer" id="id377433c30186">This line was indented 4 spaces
  This line was indented 6 spaces
This line was indented 4 spaces</pre>


### Example 1

This example does not generate a copy button and does not demonstrate `noselect`.
<pre data-lt-active="false" class="maxOneScreenHigh copyContainer" id="id110c50d624b4">{% pre %}
Contents of pre tag
{% endpre %}</pre>

Generates:
<pre data-lt-active="false" class="maxOneScreenHigh copyContainer" id="idddd87a0eb77d">&lt;pre data-lt-active='false' class='maxOneScreenHigh copyContainer' id='id377433c30186'&gt;Contents of pre tag&lt;/pre&gt;</pre>

Which renders as:

<pre data-lt-active="false" class="maxOneScreenHigh copyContainer" id="id377433c30186">Contents of pre tag</pre>


### Example 2

This example generates a copy button and does not demonstrate `noselect`.

{% pre copyButton %}
Contents of pre tag
{% endpre %}

Generates:
<pre data-lt-active="false" class="maxOneScreenHigh copyContainer" id="id08a5d26db177">&lt;pre data-lt-active='false' class='maxOneScreenHigh copyContainer' id='id6a831a3e8992'&gt;&lt;button class='copyBtn' data-clipboard-target='#id6a831a3e8992' title='Copy to clipboard'&gt;&lt;img src='images/clippy.svg' alt='Copy to clipboard' style='width: 13px'&gt;&lt;/button&gt;Contents of pre tag&lt;/pre&gt;</pre>

Which renders as (note the clipboard icon at the far right):
![example 2](images/usage2example.png)


### Example 3

This example generates a copy button and does demonstrates the default usage of `noselect`, which renders an unselectable dollar sign followed by a space.

```html
{% pre copyButton %}
{% noselect %}Contents of pre tag
{% endpre %}
```

Generates:

```html
<pre data-lt-active='false' class='maxOneScreenHigh copyContainer' id='id1e4a8fe53480'><button class='copyBtn' data-clipboard-target='#id1e4a8fe53480' title='Copy to clipboard'><img src='/assets/images/clippy.svg' alt='Copy to clipboard' style='width: 13px'></button><span class='unselectable'>$ </span>Contents of pre tag</pre>
```

Which renders as:

![example 3](images/usage3example.png)


### Example 4

This example generates a copy button and does demonstrates the `noselect` being used twice:
the first time to render an unselectable custom prompt,
and the second time to render unselectable output.

```html
{% pre copyButton %}
{% noselect &gt;&gt;&gt; %}Contents of pre tag
{% noselect How now brown cow%}
{% endpre %}
```

Generates:

```html
<pre data-lt-active='false' class='maxOneScreenHigh copyContainer' id='idb58a6cf1761c'><button class='copyBtn' data-clipboard-target='#idb58a6cf1761c' title='Copy to clipboard'><img src='/assets/images/clippy.svg' alt='Copy to clipboard' style='width: 13px'></button><span class='unselectable'>>>> </span>contents of pre tag
<span class='unselectable'>How now brown cow</span></pre>
```

Which renders as:

![example 4](images/usage4example.png)


### Example 5

A regular expression can be passed to the `highlight` option.
This causes text that matches the regex pattern to be wrapped within a &lt;span class="bg_yellow">&lt;/span> tag.

The CSS stylesheet used for this page contains the following:

```css
.bg_yellow {
  background-color: yellow;
  padding: 2px;
}
```

This example demonstrates highlighting text that matches a regular expression.
Regular expressions match against lines,
which are delimited via newlines (\n).

```html
{% pre copyButton highlight="Line 2" %}
Line 1
  Line 2
    Line 3
      Line 4
    Line 5
  Line 6
Line 7
{% endpre %}
```


### Example 6

Regular expressions match against lines, which are delimited via newlines (`\n`).
Thus to match an entire line that contains a phrase, specify the regex as `.*phrase.*`.
The following matches 3 possible phrases (`2`, `4` or `6`), then selects the entire line if matched.

```html
{% pre copyButton highlight=".*(2|4|6).*" %}
Line 1
  Line 2
    Line 3
      Line 4
    Line 5
  Line 6
Line 7
{% endpre %}
```


### Example 7

This example floats an image to the right.
The `jekyll_pre plugin`’s `clear` option moves the generated HTML below the image.

```html
&lt;img src="jekyll.webp" style="float: right; width: 100px; height: auto;">
{% pre clear copyButton label='Clear example' %}
Using clear, copyButton and label parameters
{% endpre %}
```

### Example 8

The following executes `ls -alF /` and displays the output.

```html
{% pre clear copyButton label='Exec without error' %}
{% noselect %}{% exec die_if_nonzero='false' ls -alF / %}
{% endpre %}
```

### Example 9

The following changes to the home directory (`$HOME`), then executes `pwd` and displays the output.

```html
{% pre clear copyButton label='Exec without error' %}
{% noselect %}{% exec cd="$HOME" die_if_nonzero='false' pwd %}
{% endpre %}
```

### Example 10

The following executes `echo $USER` and displays the output.

```html
{% pre clear copyButton label='Exec display &dollar;USER' %}
{% noselect %}{% exec die_if_nonzero='false' echo $USER %}
{% endpre %}
```


### Comprehensive Example

The code I wrote to generate the above CSS was a good example of how the plugins work together with
the `from` and `to` tags from my [`from_to_until`](https://github.com/mslinn/jekyll_from_to_until) plugin:

```html
{% capture css %}{% flexible_include '_sass/mystyle.scss' %}{% endcapture %}
{% pre copyButton %}{{ css | from: '.copyBtn' | to: '^$' | strip }}

{{ css | from: '.copyContainer' | to: '^$' | strip }}

{{ css | from: '.maxOneScreenHigh' | to: '^$' | strip }}

{{ css | from: '.unselectable' | to: '^$' | strip }}
{% endpre %}
```


## Development

After checking out the repo, run `bin/setup` to install dependencies.

You can also run `bin/console` for an interactive prompt that will allow you to experiment.


## Test

A test website is provided in the `demo` directory.

1. Set breakpoints.
2. Initiate a debug session from the command line:

   ```shell
   $ bin/attach demo
   ```

3. Once the `Fast Debugger` signon appears, launch the Visual Studio Code launch configuration called `Attach rdebug-ide`.
4. View the generated website at [`http://localhost:4444`](http://localhost:4444)


### Build and Install Locally

To build and install this gem onto your local machine, run:

```shell
$ bundle exec rake install
```

Examine the newly built gem:

```shell
$ gem info jekyll_pre

*** LOCAL GEMS ***

jekyll_pre (1.0.0)
    Author: Mike Slinn
    Homepage:
    https://github.com/mslinn/jekyll_pre
    License: MIT
    Installed at: /home/mslinn/.gems

    Generates Jekyll logger with colored output.
```


### Build and Push to RubyGems

To release a new version,

  1. Update the version number in `version.rb`.
  2. Commit all changes to git; if you don't the next step might fail with an unexplainable error message.
  3. Run the following:

     ```shell
     $ bundle exec rake release
     ```

     The above creates a git tag for the version, commits the created tag,
     and pushes the new `.gem` file to [RubyGems.org](https://rubygems.org).


## Contributing

1. Fork the project
2. Create a descriptively named feature branch
3. Add your feature
4. Submit a pull request


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
