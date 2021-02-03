use strict;
use warnings;
use utf8;
use Test::More;
use File::Spec;
use open IO => ':utf8';
use Data::Dumper;
$Data::Dumper::Sortkeys = 1;

my $lib = File::Spec->rel2abs('lib');

sub greple {
    Greple->new(@_)->run;
}

my $greple_path = sub {
    use App::Greple;
    my $install =
	($INC{"App/Greple.pm"} =~ m{(^.*) /lib (?:/[^/]+){0,2} /App/Greple\.pm$}x)[0]
	    or die;
    for my $dir (qw(bin script)) {
	my $file = "$install/$dir/greple";
	return $file if -f $file;
    }
}->() or die Dumper \%INC;

package Greple {
    use strict;
    use warnings;
    use utf8;
    use Data::Dumper;
    $Data::Dumper::Sortkeys = 1;

    sub new {
	my $class = shift;
	my $obj = bless {}, $class;
	$obj->{OPTION} = do {
	    if (@_ == 1) {
		my $command = shift;
		if (ref $command eq 'ARRAY') {
		    $_[0];
		} else {
		    use Text::ParseWords;
		    [ shellwords $command ];
		}
	    } else {
		[ @_ ];
	    }
	};
	$obj;
    }
    sub run {
	my $obj = shift;
	use IO::File;
	my $pid = (my $fh = new IO::File)->open('-|') // die "open: $@\n";
	if ($pid == 0) {
	    open STDERR, ">&STDOUT";
	    greple(@{$obj->{OPTION}});
	    exit 1;
	}
	binmode $fh, ':encoding(utf8)';
	$obj->{RESULT} = do { local $/; <$fh> };
	my $child = wait;
	$child != $pid and die "child = $child, pid = $pid";
	$obj->{STATUS} = $?;
	$obj;
    }
    sub status {
	my $obj = shift;
	$obj->{STATUS} >> 8;
    }
    sub result {
	my $obj = shift;
	$obj->{RESULT};
    }
    sub greple {
	exec $^X, "-I$lib", $greple_path, @_;
    }
}

1;
