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
                     handles    => {     groups => 'elements',
                                     num_groups => 'count' },
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

	}     $#_   ?    @_
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

__END__
 
=head1 NAME

WebService::Steam - An OO Perl interface to the Steam community data

=head1 SYNOPSIS

	use WebService::Steam::User;

	my $user = WebService::Steam::User->get( 'jraspass' );

	print $user->name,
	      ' joined steam in ',
	      $user->registered,
	      ', has a rating of ',
	      $user->rating,
	      ', is from ',
	      $user->location,
	      ', and belongs to the following ',
	      $user->num_groups,
	      ' groups: ',
	      join ', ', $user->groups;

=head1 METHODS
 
=head2 Class Methods

=head3 get

Returns an instance of a Steam user, can take any combination of Steam usernames and IDs. In scalar context returns the first user.
 
	my $user  = WebService::Steam::User->get( 'jraspass' );
	my $user  = WebService::Steam::User->get( 76561198005755687 )
	my @users = WebService::Steam::User->get(   'jraspass', 76561198005755687   );
	my @users = WebService::Steam::User->get( [ 'jraspass', 76561198005755687 ] );

=head2 Instance Methods

=head3 banned

Returns a boolean indicating whether or not the user has received a VAC ban.

=head3 custom_url

=head3 headline

=head3 id

=head3 limited

=head3 location

=head3 name

=head3 nick

=head3 online

Returns a boolean indicating whether or not the user is currently online.

=head3 rating

=head3 registered

A L<DateTime> representing when the user registered their Steam account.

=head3 summary

=head3 groups

=head3 num_groups
