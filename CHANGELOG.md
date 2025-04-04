# Change Log

## 3.0.1 / 2025-03-28

* The `number` option now accepts an optional starting value.
  This option can still be used as a keyword option.


## 3.0.0 / 2025-03-06

* Numbered as v3.0.0 to match the `jekyll_plugin_support` version number.
* Now requires [Jekyll 4.4.1](https://jekyllrb.com/news/2025/01/29/jekyll-4-4-1-released/) or later,
  and Ruby 3.2.0 or later


## 1.4.9 / 2025-02-07

* Added CSS for jekyll_emoji_tag in `demo/assets/css/jekyll_pre.css`.
* Added a space after `prompt`, when specified like this: `{% noselect prompt %}`.


## 1.4.8

* `id` option added.


## 1.4.7

* `dark` and `bg_yellow` css tags now have black text.
* `exec` works again.


## 1.4.6

* Made compatible with `jekyll_plugin_support` v1.0.0


## 1.4.5

* Restored implicit labels


## 1.4.4

* Fixed the empty response problem introduced by v1.4.3.


## 1.4.3

* Added the `no_stderr` option, which discards any STDERR output.


## 1.4.2

* Added missing `require` in `pre_tag_block.rb`.


## 1.4.1

* Fixed problem that caused exec tag to no produce output.


## 1.4.0

* Added `dedent` option and config setting.
* No longer dies when exec is passed an empty string, or a string with just whitespace.


## 1.3.2

* No longer strips leading spaces from exec result lines.


## 1.3.1

* Generates outer `div` with `jekyll_pre` class, like this:

  ```html
  <div class="jekyll_pre">
    ... HTML generated by previous versions of `pre` tag here
  </div>
  ```

* Added `wrapper_class` and `wrapper_style` name/value options.


## 1.3.0

* Updated to `jekyll_plugin_support` v0.6.0 for attribution support.


## 1.2.5

* Empty exec commands are detected and reported.


## 1.2.4

* The `exec` tag now evaluates environment variables in the command before execution.


## 1.2.3

* Added `cd` option to `exec` tag.


## 1.2.2

* Added `exec` tag.
* Demarked CSS for the `exec`, `noselect`, and `pre` tags in `demo/assets/css/style.css`
  within `/* Start of pre tag css */` and `/* End of pre tag css */`.


## 1.2.1

* Updated to `jekyll_plugin_support` v0.5.1 so the `noselect` tag is more efficient.


## 1.2.0

* Updated to `jekyll_plugin_support` v0.5.0.


## 1.1.7

* Fixed `noselect` tag content handling.


## 1.1.6

* Added `jekyll_plugin_support` as a dependency.


## 1.1.5

* Added `class` and `style` options to allow for specifying additional CSS classes and inline CSS
* Added `clear` option to ensure no images overlap the pre output


## 1.1.4

* Added `highlight` regex option
* Now using `lib/jekyll_tag_helper.rb` to parse markup


## 1.1.3

* Documented the `data-lt-active="false"` attribute.
* Added the `dark` option, and [provided CSS](https://www.mslinn.com/blog/2020/10/03/jekyll-plugins.html#pre_css).


## 1.1.2 / 2022-04-05

* Updated to `jekyll_plugin_logger` v2.1.0


## 1.1.1 / 2022-03-31

* Added `numbered_line` CSS class for unselectable line numbers


## 1.1.0 / 2022-03-31

* Added `number` option, which generates unselectable line numbers for contents


## 1.0.0 / 2022-03-13

* Made into a Ruby gem and published on RubyGems.org as [jekyll_pre](https://rubygems.org/gems/jekyll_pre).
* `bin/attach` script added for debugging
* Rubocop standards added
* Proper versioning and CHANGELOG.md added


## 2020-12-29

* Initial version published
