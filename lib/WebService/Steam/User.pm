package WebService::Steam::User;

use DateTime;
use IO::All;   # IO::All::LWP also needed
use Moose;
use namespace::autoclean;
use WebService::Steam::Group;
use XML::Bare;

has  banned     => ( is => 'ro', isa => 'Bool'                       );
has  custom_url => ( is => 'ro', isa => 'Str'                        );
has  headline   => ( is => 'ro', isa => 'Str'                        );
has  id         => ( is => 'ro', isa => 'Int'                        );
has  limited    => ( is => 'ro', isa => 'Bool'                       );
has  location   => ( is => 'ro', isa => 'Str'                        );
has  name       => ( is => 'ro', isa => 'Str'                        );
has  nick       => ( is => 'ro', isa => 'Str'                        );
has  online     => ( is => 'ro', isa => 'Bool'                       );
has  rating     => ( is => 'ro', isa => 'Num'                        );
has _registered => ( is => 'ro', isa => 'Str'                        );
has  registered => ( is => 'ro', isa => 'DateTime' , lazy_build => 1 );
has  summary    => ( is => 'ro', isa => 'Str'                        );

has __groups    => ( is         => 'ro', isa => 'ArrayRef' );
has  _groups    => ( is         => 'ro',
                     isa        => 'ArrayRef[WebService::Steam::Group]',
                     traits     => [ 'Array' ],
                     handles    => { groups => 'elements' },
                     lazy_build => 1 );

sub get
{
	$#_ || return;

	my $class = shift;

	my @users = map {

		my $xml < io 'http://steamcommunity.com/' . ( /^\d+$/ ? 'profiles' : 'id' ) . "/$_/?xml=1";

		my $hash = XML::Bare->new( text => $xml )->simple->{ profile };

		$class->new( banned     => $hash->{ vacBanned        },
		             custom_url => $hash->{ customURL        },
		           __groups     => [ map { $_->{ groupID64 } } @{ $hash->{ groups }{ group } } ],
		             headline   => $hash->{ headline         },
		             id         => $hash->{ steamID64        },
		             limited    => $hash->{ isLimitedAccount },
		             location   => $hash->{ location         },
		             name       => $hash->{ realname         },
		             nick       => $hash->{ steamID          },
		             online     => $hash->{ onlineState      } eq 'online',
		             rating     => $hash->{ steamRating      },
		            _registered => $hash->{ memberSince      },
		             summary    => $hash->{ summary          } );

	} $#_       ?    @_
	: ref $_[0] ? @{ $_[0] }
	:              ( $_[0] );

	wantarray ? @users : $users[0];	
}

sub _build__groups
{
	[ WebService::Steam::Group->get( $_[0]->__groups ) ];
}

sub _build_registered
{
	my ( $month, $day, $year ) = split /,? /, $_[0]->_registered;

	my %months;
	   @months{ qw( January Febuary March April May June July August September October November December ) } = ( 1..12 );
	
	DateTime->new( year => $year, month => $months{ $month }, day => $day );
}

__PACKAGE__->meta->make_immutable;

1;