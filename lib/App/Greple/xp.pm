=head1 NAME

App::Greple::xp - Greple module: extended patterns

=head1 VERSION

Version 0.01

=head1 SYNOPSIS

greple -Mxp

=head1 DESCRIPTION

This module provides functions can be used by B<greple> pattern and
regions options.

=head1 SEE ALSO

L<https://github.com/kaz-utashiro/greple>

L<https://github.com/kaz-utashiro/greple-xp>

=head1 AUTHOR

Kazumasa Utashiro

=head1 LICENSE

Copyright (C) 2019 Kazumasa Utashiro.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut


package App::Greple::xp;

use v5.14;
use strict;
use warnings;

our $VERSION = "0.01";

use Exporter 'import';
our @EXPORT      = ();
our %EXPORT_TAGS = ();
our @EXPORT_OK   = qw();

use open IO => ':utf8';
use App::Greple::Common;
use App::Greple::Regions qw(match_regions merge_regions);
use Data::Dumper;

our $opt_hash_comment = 1;
our $opt_slash_comment = 1;

sub pattern_file {
    my %arg = @_;
    my $target = delete $arg{&FILELABEL} or die;
    my @files = grep { $arg{$_} == 1 } keys %arg;
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
	    push @r, match_regions pattern => qr/$p/;
	}
    }
    merge_regions @r;
}
*P = \&pattern_file;
push @EXPORT, qw(&P &pattern_file);

1;

__DATA__

option      --le-file      --le &pattern_file($<shift>)
option  --inside-file  --inside &pattern_file($<shift>)
option --outside-file --outside &pattern_file($<shift>)
option --include-file --include &pattern_file($<shift>)
option --exclude-file --exclude &pattern_file($<shift>)
