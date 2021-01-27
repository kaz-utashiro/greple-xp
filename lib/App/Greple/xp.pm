=head1 NAME

App::Greple::xp - extended pattern module

=head1 VERSION

Version 0.01

=head1 SYNOPSIS

greple -Mxp

=head1 DESCRIPTION

This module provides functions can be used by B<greple> pattern and
region options.

=head1 OPTIONS

=over 7

=item B<--le-file> I<file>

=item B<--inside-file> I<file>

=item B<--outside-file> I<file>

=item B<--include-file> I<file>

=item B<--exclude-file> I<file>

Read file contents and use each lines as a pattern for options.

Lines start with hash mark (C<#>) is ignored as a comment line.

String after double slash (C<//>) is also ignored.

Because file name is globbed, you can use wild card to give multiple
files.

    $ greple -Mxp --exclude-file '*.exclude' ...

=back

=head1 SEE ALSO

L<https://github.com/kaz-utashiro/greple>

L<https://github.com/kaz-utashiro/greple-xp>

=head1 AUTHOR

Kazumasa Utashiro

=head1 LICENSE

Copyright 2019- Kazumasa Utashiro.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut


package App::Greple::xp;

use v5.14;
use strict;
use warnings;

our $VERSION = "0.01";

use Exporter 'import';
our @EXPORT = qw(&xp_pattern_file);

use open IO => ':utf8';
use App::Greple::Common;
use App::Greple::Regions qw(match_regions merge_regions);
use Data::Dumper;

our $opt_hash_comment = 1;
our $opt_slash_comment = 0;
our $opt_glob = 1;

sub xp_pattern_file {
    my %arg = @_;
    my $target = delete $arg{&FILELABEL} or die;
    my $file = $arg{file};
    my @files = $opt_glob ? glob $file : ($file);
    my @r;
    for my $file (@files) {
	open my $fh, $file or die "$file: $!";
	while (my $p = <$fh>) {
	    chomp $p;
	    if ($opt_hash_comment) {
		next if $p =~ /^\s*#/;
	    }
	    if ($opt_slash_comment) {
		$p =~ s{//.*}{};
	    }
	    next unless $p =~ /\S/;
	    push @r, match_regions pattern => qr/$p/m;
	}
    }
    merge_regions @r;
}

1;

__DATA__

builtin xp-hash-comment!  $opt_hash_comment
builtin xp-slash-comment! $opt_slash_comment
builtin xp-glob!          $opt_glob

option      --le-file      --le &xp_pattern_file(file="$<shift>")
option  --inside-file  --inside &xp_pattern_file(file="$<shift>")
option --outside-file --outside &xp_pattern_file(file="$<shift>")
option --include-file --include &xp_pattern_file(file="$<shift>")
option --exclude-file --exclude &xp_pattern_file(file="$<shift>")
