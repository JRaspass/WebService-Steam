package WebService::Steam::User;

use DateTime;
use Moose;
use Moose::Util::TypeConstraints;
use MooseX::Aliases;
use namespace::autoclean;
use XML::Bare;

subtype 'SteamBool' => as   'Bool';
coerce  'SteamBool' => from 'Str' => via { $_ eq 'online' || 0 };

has  banned     => ( is => 'ro', isa => 'Bool'     , alias      => 'vacBanned'                );
has  headline   => ( is => 'ro', isa => 'Str'                                                 );
has  id         => ( is => 'ro', isa => 'Int'      , alias      => 'steamID64'                );
has  name       => ( is => 'ro', isa => 'Str'      , alias      => 'realname'                 );
has  nick       => ( is => 'ro', isa => 'Str'      , alias      => 'steamID'                  );
has  online     => ( is => 'ro', isa => 'SteamBool', alias      => 'onlineState', coerce => 1 );
has  rating     => ( is => 'ro', isa => 'Num'      , alias      => 'steamRating'              );
has _registered => ( is => 'ro', isa => 'Str'      , alias      => 'memberSince'              );
has  registered => ( is => 'ro', isa => 'DateTime' , lazy_build => 1                          );
has  summary    => ( is => 'ro', isa => 'Str'                                                 );

sub get
{
	my ( $class, $user ) = $#_ ? @_ : return;

	my $url  = 'http://steamcommunity.com/' . ( $user =~ /^\d{17}$/ ? 'profiles' : 'id' ) . "/$user/?xml=1";

	my $xml  = `wget -q -O - $url`;

	my $hash = XML::Bare->new( text => $xml )->simple->{ profile };

	$class->new( $hash );
}

sub _build_registered
{
	my ( $month, $day, $year ) = split /,? /, $_[0]->_registered;

	my %months;
	   @months{ qw( January Febuary March April May June July August September October November December ) } = ( 1..12 );
	
	DateTime->new( year => $year, month => $months{ $month }, day => $day );
}

1;