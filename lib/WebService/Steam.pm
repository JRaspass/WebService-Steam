package WebService::Steam;

use strict;
use warnings;

use Data::Dumper;

use Exporter;
use IO::All;
use WebService::Steam::Group;
use WebService::Steam::User;
use XML::Bare;

our @EXPORT  = qw/steam_group steam_user/;
our @ISA     = 'Exporter';
our $VERSION = .3;

sub steam_group { _steam( 'WebService::Steam::Group', @_ ) }
sub steam_user  { _steam( 'WebService::Steam::User' , @_ ) }

sub _steam
{
	$#_ == 1 || return;

	my @objects = map
	{
		my $xml < io $_[0]->path( $_ );

		   $xml =~ /^<\?xml.*<\/profile>$/s || next;

		my $hash = XML::Bare->new( text => $xml )->simple->{ profile };

		$_[0]->new( $hash )

	} ref $_[1] ? @{ $_[1] } : @_[ 1..$#_ ];

	wantarray ? @objects : $objects[0];
}

1;

__END__
 
=head1 NAME

WebService::Steam - An OO Perl interface to the Steam community data

=head1 MODULES AND UTILITIES

=head2 WebService::Steam::Group

=head2 WebService::Steam::User