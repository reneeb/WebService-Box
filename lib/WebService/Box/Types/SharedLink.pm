package WebService::Box::Types::SharedLink;

use strict;
use warnings;

use Moo;
use Types::Standard qw(Int Str Dict);

use WebService::Box::Types::Library qw(
    OptionalTimestamp OptionalStr SharedLinkPermissionHash
);

our $VERSION = 0.01;

has [qw/url download_url access/]        => (is => 'ro', isa => Str);
has [qw/download_count preview_count/]   => (is => 'ro', isa => Int);
has [qw/vanity_url is_password_enabled/] => (is => 'ro', isa => OptionalStr);

has unshared_at => (is => 'ro', isa => OptionalTimestamp);
has permission  => (is => 'ro', isa => SharedLinkPermissionHash);

1;
