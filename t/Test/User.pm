package Test::User;

use base 'Test::Class';
use       Test::Most;

sub class { 'WebService::Steam::User' }

sub startup :Tests( startup => 1 )
{
	use_ok $_[0]->class;
}

sub constructor :Tests( 3 )
{
	my $class = $_[0]->class;

	can_ok    $class, 'new';
       ok my $user = $class->new, 'new() is ok';
	isa_ok    $user , $class;
}

1;