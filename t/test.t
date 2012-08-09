#!/usr/bin/perl

use lib 'lib';

use IO::All::LWP;
use Test::LWP::UserAgent;
use Test::Most;

# patch the monkey, punch the duck

#{
#	no warnings 'redefine';
#
#	my $ua = Test::LWP::UserAgent->new;
#	   $ua->map_response( qr//, HTTP::Response->new( 200, 'OK', [ Content_Type => 'application/xml' ], do { local $/; <DATA> } ) );
#
#	*IO::All::LWP::ua = sub { $ua };
#}

# run the tests

my %data = ( Group => 'valve',
              User => 'jraspass' );

use_ok 'WebService::Steam';

for ( qw/Group User/ )
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

__DATA__
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<profile>
	<steamID64>76561198005755687</steamID64>
	<steamID><![CDATA[JRaspass]]></steamID>
	<onlineState>offline</onlineState>
	<stateMessage><![CDATA[Last Online: 2 hrs, 26 mins ago]]></stateMessage>
	<privacyState>public</privacyState>
	<visibilityState>3</visibilityState>
	<avatarIcon><![CDATA[http://media.steampowered.com/steamcommunity/public/images/avatars/88/886d8cb19a1054fdd7fcd6f4dba0a562e6516e70.jpg]]></avatarIcon>
	<avatarMedium><![CDATA[http://media.steampowered.com/steamcommunity/public/images/avatars/88/886d8cb19a1054fdd7fcd6f4dba0a562e6516e70_medium.jpg]]></avatarMedium>
	<avatarFull><![CDATA[http://media.steampowered.com/steamcommunity/public/images/avatars/88/886d8cb19a1054fdd7fcd6f4dba0a562e6516e70_full.jpg]]></avatarFull>
	<vacBanned>0</vacBanned>
	<tradeBanState>None</tradeBanState>
	<isLimitedAccount>0</isLimitedAccount>
	<customURL><![CDATA[jraspass]]></customURL>
	<memberSince>January 31, 2009</memberSince>
	<steamRating>0.2</steamRating>
	<hoursPlayed2Wk>0.6</hoursPlayed2Wk>
	<headline><![CDATA[foo]]></headline>
	<location><![CDATA[Southampton, Southampton, United Kingdom (Great Britain)]]></location>
	<realname><![CDATA[James Raspass]]></realname>
	<summary><![CDATA[No information given.]]></summary>
 	<mostPlayedGames>
		<mostPlayedGame>
			<gameName><![CDATA[Batman: Arkham Asylum GOTY Edition]]></gameName>
			<gameLink><![CDATA[http://store.steampowered.com//app/35140]]></gameLink>
			<gameIcon><![CDATA[http://media.steampowered.com/steamcommunity/public/images/apps/35140/e52f91ecb0d3f20263e96fe188de1bcc8c91643e.jpg]]></gameIcon>
			<gameLogo><![CDATA[http://media.steampowered.com/steamcommunity/public/images/apps/35140/172e0928b845c18491f1a8fee0dafe7a146ac129.jpg]]></gameLogo>
			<gameLogoSmall><![CDATA[http://media.steampowered.com/steamcommunity/public/images/apps/35140/172e0928b845c18491f1a8fee0dafe7a146ac129_thumb.jpg]]></gameLogoSmall>
			<hoursPlayed>0.6</hoursPlayed>
			<hoursOnRecord>1.6</hoursOnRecord>
		</mostPlayedGame>
	</mostPlayedGames>
	<groups>
		<group isPrimary="0">
			<groupID64>103582791430884334</groupID64>
		</group>
		<group isPrimary="0">
			<groupID64>103582791432188903</groupID64>
		</group>
		<group isPrimary="0">
			<groupID64>103582791432570414</groupID64>
		</group>
		<group isPrimary="0">
			<groupID64>103582791432706584</groupID64>
		</group>
	</groups>
</profile>