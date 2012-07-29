package Test::User;

use Test::Class::Most;

sub tests :Tests
{
	my $class = 'WebService::Steam::User';

	use_ok    $class;
	can_ok    $class, 'new';
	    ok my $user = $class->new, 'new() is ok';
	isa_ok    $user , $class;
	    ok    $user = $class->get( 'jraspass' ), 'get() is ok';
	isa_ok    $user , $class;
}

1;