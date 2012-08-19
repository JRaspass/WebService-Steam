package WebService::Steam;

use strict;
use warnings;

use Exporter;
use IO::All;
use WebService::Steam::Group;
use WebService::Steam::User;
use XML::Bare;

our $AUTOLOAD;
our @EXPORT  = qw/steam_group steam_user/;
our @ISA     = 'Exporter';
our $VERSION = .3;

sub AUTOLOAD
{
	$AUTOLOAD =~ s/steam_(\w)/\u$1/;

	my @objects = map
	{
		my $path = $AUTOLOAD->path( $_ );

		my $xml < io $path;

		$xml =~ /^<\?xml/ ? $AUTOLOAD->new_from_xml_hash( XML::Bare->new( text => $xml )->simple ) : ()

	} ref $_[0] ? @{ $_[0] } : @_;

	wantarray ? @objects : $objects[0];
}

1;

__END__
 
=head1 NAME

WebService::Steam - A Perl interface to the Steam community data

=head1 SYNOPSIS

	use WebService::Steam;

	my $user = steam_user 'jraspass';

	print $user->name,
	      ' joined steam in ',
	      $user->registered,
	      ', has a rating of ',
	      $user->rating,
	      ', is from ',
	      $user->location,
	      ', and belongs to the following ',
	      $user->group_count,
	      ' groups: ',
	      join ', ', $user->groups;

=head1 EXPORTED METHODS

=head2 steam_group

Returns one or more instances of WebService::Steam::Group

=head2 steam_user

Returns an instance of a Steam user, can take any combination of Steam usernames and IDs.

In scalar context returns the first element of the array.
 
	my $user  = steam_user(   'jraspass'                      );
	my $user  = steam_user(               76561198005755687   );
	my @users = steam_user(   'jraspass', 76561198005755687   );
	my @users = steam_user( [ 'jraspass', 76561198005755687 ] );