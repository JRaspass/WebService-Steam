#!/usr/bin/perl

use lib 'lib';

use IO::All;
use IO::All::LWP;
use Test::LWP::UserAgent;
use Test::Most;

# patch the monkey, punch the duck

{
	no warnings 'redefine';

	Test::LWP::UserAgent->map_response( qr/./, sub
	{
		HTTP::Response->new( 200, 'OK', [], $_[0]->uri =~ m!/(?:gid|groups)/!  ? io( 't/group.xml' )->all
		                                  : $_[0]->uri =~ m!/(?:profiles|id)/! ? io( 't/user.xml'  )->all
		                                  :                                      '' )
	} );

	*IO::All::LWP::ua = sub { Test::LWP::UserAgent->new };
}

# run the tests

my %data = ( Group => 'valve',
              User => 'jraspass' );

use_ok 'WebService::Steam';

for ( keys %data )
{
	my $class = "WebService::Steam::$_";
	my $sub   = "steam_\L$_";

	use_ok    $class;
	can_ok    $class, 'new';
	    ok my $object = $class->new, "$class->new()";
	isa_ok    $object , $class;
	    ok    $object = __PACKAGE__->can( $sub )->( $data{ $_ } ), "$sub( '$data{ $_ }' )";
	isa_ok    $object , $class;
}

done_testing;