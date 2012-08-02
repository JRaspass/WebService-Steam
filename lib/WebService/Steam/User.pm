package WebService::Steam::User;

use Data::Dumper;

use DateTime;
use IO::All;   # IO::All::LWP also needed
use Moose;
use Moose::Util::TypeConstraints;
use namespace::autoclean;
use WebService::Steam::Group;
use XML::Bare;

subtype 'SteamBool' =>   as 'Bool';
coerce  'SteamBool' => from 'Str' => via { /online/ };

has   banned     => ( is => 'ro', isa => 'Bool'     , init_arg   => 'vacBanned'        );
has   custom_url => ( is => 'ro', isa => 'Str'      , init_arg   => 'customURL'        );
has __groups     => ( is => 'ro', isa => 'HashRef'  , init_arg   => 'groups'           );
has  _groups     => ( is => 'ro',
                     isa => 'ArrayRef[WebService::Steam::Group]',
                  traits => [ 'Array' ],
              lazy_build => 1,
                 handles => {  groups => 'elements', group_count => 'count' }          );
has   headline   => ( is => 'ro', isa => 'Str'                                         );
has   id         => ( is => 'ro', isa => 'Int'      , init_arg   => 'steamID64'        );
has   limited    => ( is => 'ro', isa => 'Bool'     , init_arg   => 'isLimitedAccount' );
has   location   => ( is => 'ro', isa => 'Str'                                         );
has   name       => ( is => 'ro', isa => 'Str'      , init_arg   => 'realname'         );
has   nick       => ( is => 'ro', isa => 'Str'      , init_arg   => 'steamID'          );
has   online     => ( is => 'ro', isa => 'SteamBool', init_arg   => 'onlineState', coerce => 1 );
has   rating     => ( is => 'ro', isa => 'Num'      , init_arg   => 'steamRating'      );
has  _registered => ( is => 'ro', isa => 'Str'      , init_arg   => 'memberSince'      );
has   registered => ( is => 'ro', isa => 'DateTime' , lazy_build => 1                  );
has   summary    => ( is => 'ro', isa => 'Str'                                         );

sub path { "http://steamcommunity.com/@{[ $_[1] =~ /^\d+$/ ? 'profiles' : 'id' ]}/$_[1]/?xml=1" }

sub _build__groups { [ WebService::Steam::Group->get( map { $_->{ groupID64 } } @{ $_[0]->__groups->{ groups }{ group } } ) ] }

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

	use WebService::Steam;

	my $user = steam user => 'jraspass';

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

=head1 METHODS
 
=head2 Class Methods

=head3 get

Returns an instance of a Steam user, can take any combination of Steam usernames and IDs.

In scalar context returns the first element of the array.
 
	my $user  = WebService::Steam::User->get(   'jraspass'                      );
	my $user  = WebService::Steam::User->get(               76561198005755687   );
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

=head3 group_count