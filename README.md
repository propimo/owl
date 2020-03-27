# owl

## Developing
Use `bundle config local.GEM_NAME /path/to/local/git/repository` to load the latest gem source from your file system.

To remove the changes, you need to run `bundle config --delete local.GEM_NAME`

## GemResolver Usage
1. Run installer `rails generate webpack_with_gems:install`
2. Add gems name and paths to their assets, inside `webpacker.yml`

Example: 
```
resolved_gems:
    owl:
      - 'app/assets/'
```

## Description

TODO: Description

## Features

## Examples

    require 'owl'

## Requirements

## Install

    $ gem install owl

## Copyright

Copyright (c) 2017 vladislav

See {file:LICENSE.txt} for details.
