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

WebService::Steam - An OO Perl interface to the Steam community data

=head1 EXPORTED METHODS

=head2 steam_group

Returns one or more instances of WebService::Steam::Group

=head2 steam_user

Returns one or more instances of WebService::Steam::User