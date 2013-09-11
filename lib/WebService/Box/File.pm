package WebService::Box::File;

use strict;
use warnings;

use Moo;
use Types::Standard qw(Str Int);
use WebService::Box::Types::Library qw(BoxPerson);

has [qw/type id sequence_id etag sha1 name description item_status version_number structure/] => (
    is  => 'ro',
    isa => Str,
);

has [qw/size comment_count/] => (
    is  => 'ro',
    isa => Int,
);

has [qw/created_by modified_by owned_by/] => (
    is     => 'ro',
    isa    => BoxPerson,
    coerce => BoxPerson()->coercion,
);

has [qw/created_at modified_at trashed_at purged_at content_created_at content_modified_at/] => (
    is     => 'ro',
    isa    => Timestamp,
    coerce => Timestamp()->coercion,
);

sub BUILDARGS {
   my ( $class, @args ) = @_;

   unshift @args, "id" if @args % 2 == 1;

   return { @args };
}

1;
