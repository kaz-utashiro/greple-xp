[![Build Status](https://travis-ci.com/kaz-utashiro/greple-xp.svg?branch=master)](https://travis-ci.com/kaz-utashiro/greple-xp)
# NAME

App::Greple::xp - extended pattern module

# VERSION

Version 0.01

# SYNOPSIS

greple -Mxp

# DESCRIPTION

This module provides functions can be used by **greple** pattern and
region options.

# OPTIONS

- **--le-file** _file_
- **--inside-file** _file_
- **--outside-file** _file_
- **--include-file** _file_
- **--exclude-file** _file_

    Read file contents and use each lines as a pattern for options.

    Lines start with hash mark (`#`) is ignored as a comment line.

    String after double slash (`//`) is also ignored.

    Because file name is globbed, you can use wild card to give multiple
    files.

        $ greple -Mxp --exclude-file '*.exclude' ...

# SEE ALSO

[https://github.com/kaz-utashiro/greple](https://github.com/kaz-utashiro/greple)

[https://github.com/kaz-utashiro/greple-xp](https://github.com/kaz-utashiro/greple-xp)

# AUTHOR

Kazumasa Utashiro

# LICENSE

Copyright 2019- Kazumasa Utashiro.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.
