use strict;
use warnings;

package Test::Deep::Array;
use Carp qw( confess );

use Test::Deep::Ref;

use vars qw( @ISA );
@ISA = qw( Test::Deep::Ref );

use Data::Dumper qw(Dumper);

sub init
{
	my $self = shift;

	my $val = shift;

	$self->{val} = $val;
}

sub descend
{
	my $self = shift;
	my $a1 = shift;

	my $a2 = $self->{val};

	return 0 unless Test::Deep::descend($a1, Test::Deep::arraylength(scalar @$a2));

	return 0 unless $self->test_class($a1);

	my $data = $self->push;

	for my $i (0..$#{$a2})
	{
		$data->{index} = $i;

		my $got = $a1->[$i];
		my $expected = $a2->[$i];

		if (Test::Deep::descend($got, $expected))
		{
			next;
		}
		return 0;
	}

	return 1;
}

sub render_stack
{
	my $self = shift;
	my ($var, $data) = @_;
	$var .= "->" unless $Test::Deep::Stack->incArrow;
	$var .= "[$data->{index}]";

	return $var;
}

sub reset_arrow
{
	return 0;
}

sub compare
{
	my $self = shift;

	my $other = shift;

	return Test::Deep::descend($self->{val}, $other->{val});
}

1;
