package WebService::Steam::User;

use DateTime;
use IO::All;
use Moose;
use namespace::autoclean;
use URI;
use WebService::Steam;

has       banned => ( is => 'ro', isa => 'Bool'          );
has   custom_url => ( is => 'ro', isa => 'Str'           );
has     __groups => ( is => 'ro', isa => 'ArrayRef'      );
has      _groups => ( is => 'ro',
                     isa => 'ArrayRef[WebService::Steam::Group]',
                 handles => { groups => 'elements' },
              lazy_build => 1,
                  traits => [ 'Array' ]                  );
has     headline => ( is => 'ro', isa => 'Str'           );
has       _icons => ( is => 'ro',
                     isa => 'ArrayRef[URI]',
                 handles => { avatars => 'elements' },
                  traits => [ 'Array' ]                  );
has           id => ( is => 'ro', isa => 'Int'           );
has      limited => ( is => 'ro', isa => 'Bool'          );
has     location => ( is => 'ro', isa => 'Str'           );
has         name => ( is => 'ro', isa => 'Str'           );
has         nick => ( is => 'ro', isa => 'Str'           );
has       online => ( is => 'ro', isa => 'Bool'          );
has       rating => ( is => 'ro', isa => 'Num'           );
has  _registered => ( is => 'ro', isa => 'Str'           );
has   registered => ( is => 'ro',
                     isa => 'DateTime',
              lazy_build => 1                            );
has      summary => ( is => 'ro', isa => 'Str'           );

sub new_from_xml_hash
{
	my $hash = $_[1];

	$_[0]->new( { banned =>   $hash->{ vacBanned        },
	          custom_url =>   $hash->{ customURL        },
	            __groups => [ map $_->{ groupID64 }, @{ $hash->{ groups }{ group } } ],
	            headline =>   $hash->{ headline         },
	              _icons => [ map URI->new( $hash->{ "avatar$_" } ), qw/Icon Medium Full/ ],
	                  id =>   $hash->{ steamID64        },
	             limited =>   $hash->{ isLimitedAccount },
	            location =>   $hash->{ location         },
	                name =>   $hash->{ realname         },
	                nick =>   $hash->{ steamID          },
	              online =>   $hash->{ onlineState      } eq 'online',
	              rating =>   $hash->{ steamRating      },
	         _registered =>   $hash->{ memberSince      },
	             summary =>   $hash->{ summary          } } )
}

sub path { "http://steamcommunity.com/@{[ $_[1] =~ /^\d+$/ ? 'profiles' : 'id' ]}/$_[1]/?xml=1" }

sub _build__groups { [ WebService::Steam::steam_group( $_[0]->__groups ) ] }

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

WebService::Steam::User

=head1 ATTRIBUTES

=head2 banned

A boolean indicating whether or not the user has received a VAC ban.

=head2 custom_url

=head2 headline

=head2 icons

An array of L<URI>s of the user's icon in various sizes. From smallest to largest.

=head2 id

=head2 limited

=head2 location

=head2 name

A string of the user's real life name.

=head2 nick

A string of the user's chosen nick name.

=head2 online

A boolean indicating whether or not the user is currently online.

=head2 rating

=head2 registered

A L<DateTime> of when the user registered their Steam account.

=head2 summary

=head2 groups