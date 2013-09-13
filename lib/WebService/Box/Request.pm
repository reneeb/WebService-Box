package WebService::Box::Request;

use strict;
use warnings;

use Moo;
use Types::Standard qw(InstanceOf);

has session => (is => 'ro', isa => InstanceOf["WebService::Box::Session"], required => 1);

sub do {
    print STDERR "original";
}

1;
