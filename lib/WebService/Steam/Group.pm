package WebService::Steam::Group;

use DateTime;
use IO::All;   # IO::All::LWP also needed
use Moose;
use namespace::autoclean;
use XML::Bare;

has name    => ( is => 'ro', isa => 'Str' );
has summary => ( is => 'ro', isa => 'Str' );

sub get
{
	$#_ || return;

	my $class = shift;

	my @groups = map {

		my $xml < io 'http://steamcommunity.com/' . ( /^\d+$/ ? 'gid' : '' ) . "/$_/memberslistxml";

		my $hash = XML::Bare->new( text => $xml )->simple->{ memberList };

		$class->new( name    => $hash->{ groupDetails }{ groupName },
		             summary => $hash->{ groupDetails }{ summary   } );

	} $#_       ?    @_
	: ref $_[0] ? @{ $_[0] }
	:              ( $_[0] );

	wantarray ? @groups : $groups[0];
}

__PACKAGE__->meta->make_immutable;

1;