package WebService::Steam::Group;

use IO::All;
use Moose;
#use MooseX::MarkAsMethods autoclean => 1;
use XML::Bare;

#use overload '""' => sub { $_[0]->name };

has    name => ( is => 'ro', isa => 'Str' );
has summary => ( is => 'ro', isa => 'Str' );

sub new_from_xml_hash
{
	my $hash = $_[1];

	$_[0]->new( { name => $hash->{ groupDetails }{ groupName },
	           summary => $hash->{ groupDetails }{ summary   } } )
}

sub path { "http://steamcommunity.com/@{[ $_[1] =~ /^\d+$/ ? 'gid' : 'groups' ]}/$_[1]/memberslistxml" }

__PACKAGE__->meta->make_immutable;

1;

__END__
 
=head1 NAME

WebService::Steam::User

=head1 ATTRIBUTES