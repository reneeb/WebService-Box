#!/usr/bin/perl

use strict;
use warnings;

use Test::More;
use Test::Exception;

use WebService::Box;
use WebService::Box::Session;

use_ok 'WebService::Box::File';

my $session = WebService::Box::Session->new(
    client_id     => 123,
    client_secret => 'abcdef123',
    refresh_token => 'hefe0815',
    redirect_uri  => 'http://localhost',
    box           => WebService::Box->new,
);

{
    # a plain file object without any data
    my $file = WebService::Box::File( session => $session );

    isa_ok $file, 'WebService::Box::File';
    can_ok $file, qw(
        upload download comment parent comments delete copy 
        share thumbnail recover delete_permanent tasks
    );
}

{
    # a basic file object with little data
    my $file = WebService::Box::File(
        id      => 123,
        session => $session,
        etag    => undef,
    );
}

done_testing();
