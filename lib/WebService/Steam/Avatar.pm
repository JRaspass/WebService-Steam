package WebService::Steam::Avatar;

use Moose;

has _images => ( is => 'rw',
                isa => 'ArrayRef[URI]',
             traits => [ 'Array' ],
            handles => { images => 'elements' } );

__PACKAGE__->meta->make_immutable;

1;