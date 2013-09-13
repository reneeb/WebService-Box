package WebService::Box::Types::By;

use strict;
use warnings;

use Moo;
use Types::Standard qw(Str Int);

our $VERSION = 0.01;

has [qw/type name login/] => (is => 'ro', isa => Str, required => 1);
has id => (is => 'ro', isa => Int, required => 1);

1;
