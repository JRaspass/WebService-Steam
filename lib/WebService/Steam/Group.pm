package WebService::Steam::Group;

use IO::All;   # IO::All::LWP also needed
use Moose;
use MooseX::MarkAsMethods autoclean => 1;
use XML::Bare;

use overload '""' => sub { $_[0]->name };

has name    => ( is => 'ro', isa => 'Str' );
has summary => ( is => 'ro', isa => 'Str' );

sub get
{
	$#_ || return;

	my @groups = map {

		my $xml < io 'http://steamcommunity.com/' . ( /^\d+$/ ? 'gid' : '' ) . "/$_/memberslistxml";

		my $hash = XML::Bare->new( text => $xml )->simple->{ memberList };

		$_[0]->new( name    => $hash->{ groupDetails }{ groupName },
		            summary => $hash->{ groupDetails }{ summary   } );

	} ref $_[1] ? @{ $_[1] } : @_[ 1..$#_ ];

	wantarray ? @groups : $groups[0];
}

__PACKAGE__->meta->make_immutable;

1;
