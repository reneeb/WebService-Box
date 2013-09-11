package WebService::Box::Folder;

use strict;
use warnings;

use Moo;
use Types::Standard qw(Str Int);

sub BUILDARGS {
   my ( $class, @args ) = @_;

   unshift @args, "id" if @args % 2 == 1;

   return { @args };
}

1;
