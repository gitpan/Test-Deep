use strict;
use warnings;

package Test::Deep::Blessed;
use Carp qw( confess );

use Test::Deep::Cmp;

use vars qw( @ISA );
@ISA = qw( Test::Deep::Cmp );

use Data::Dumper qw(Dumper);

use Scalar::Util qw( blessed );

sub init
{
	my $self = shift;

	my $val = shift;

	$self->{val} = $val;
}

sub descend
{
	my $self = shift;
	my $d1 = shift;

	my $exp = $self->{val};
	my $blessed = blessed($d1);

	$self->push($blessed);

	my $cmp = Test::Deep::shallow($exp);
	return Test::Deep::descend($blessed, $cmp);
}

sub render_stack
{
	my $self = shift;
	my $var = shift;

	return "blessed($var)"
}

sub compare
{
	my $self = shift;

	my $other = shift;

	return 0 if $self->{snobby} != $other->{snobby};

	local $Test::Deep::Snobby = $self->{snobby};

	return Test::Deep::descend($self->{val}, $other->{val});
}

1;
