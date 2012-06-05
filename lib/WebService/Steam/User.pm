package WebService::Steam::User;

use DateTime;
use Moose;
use namespace::autoclean;
use XML::Bare;

has  banned     => ( is => 'ro', isa => 'Bool'                                                );
has  headline   => ( is => 'ro', isa => 'Str'                                                 );
has  id         => ( is => 'ro', isa => 'Int'                                                 );
has  name       => ( is => 'ro', isa => 'Str'                                                 );
has  nick       => ( is => 'ro', isa => 'Str'                                                 );
has  online     => ( is => 'ro', isa => 'Bool'                                                );
has  rating     => ( is => 'ro', isa => 'Num'                                                 );
has _registered => ( is => 'ro', isa => 'Str'                                                 );
has  registered => ( is => 'ro', isa => 'DateTime', lazy => 1, builder => '_build_registered' );
has  summary    => ( is => 'ro', isa => 'Str'                                                 );

our %map = ( banned     => 'vacBanned',
             headline   => 'headline',
             id         => 'steamID64',
             name       => 'realname',
             nick       => 'steamID',
             rating     => 'steamRating',
            _registered => 'memberSince',
             summary    => 'summary' );

sub get
{
	my ( $class, %args ) = @_;

	$args{ id } || $args{ nick } || return;

	my $url  = 'http://steamcommunity.com/' . ( $args{ id } ? "profiles/$args{ id }" : "id/$args{ nick }" ) . '/?xml=1';
	my $xml  = `wget -q -O - $url`;
	my $hash = XML::Bare->new( text => $xml )->parse->{ profile };
	my $new;

	while ( my ( $key, $value ) = each %map )
	{
		$new->{ $key } = $hash->{ $value }->{ value } if $hash->{ $value }->{ value };
	}

	$new->{ online } = $hash->{ onlineState }->{ value } eq 'offline' ? 0 : 1;

	$class->new( $new );
}

sub _build_registered
{
	my ( $month, $day, $year ) = split /,? /, shift->_registered;

	my %months;
		@months{ qw( January Febuary March April May June July August September October November December ) } = ( 1..12 );
	
	DateTime->new( year => $year, month => $months{ $month }, day => $day );
}

1;