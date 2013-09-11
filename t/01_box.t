#!/usr/bin/perl

use strict;
use warnings;

use Test::More;
use Test::Exception;

use_ok 'WebService::Box';

{
    my $box = WebService::Box->new;
    isa_ok $box, 'WebService::Box';

    can_ok $box, qw/create_session error/;

    # standard api_url
    is $box->api_url, "", 'standard api_url';

    # standard upload_url
    is $box->upload_url, "", 'standard upload_url';
}

{
    # set an invalid value for on_error
    throws_ok
        { WebService::Box->new( on_error => 'test' ) }
        qr/invalid value for 'on_error'/,
        'invalid value for on_error (string)';

    throws_ok
        { WebService::Box->new( on_error => {} ) }
        qr/invalid value for 'on_error'/,
        'invalid value for on_error (hashref)';
}

{
    # set new values for urls
    my $box = WebService::Box->new(
        api_url => 'http://localhost/',
        upload_url => 'http://localhost/upload',
    );

    is $box->api_url, 'http://localhost/', 'new api_url';
    is $box->upload_url, 'http://localhost/upload', 'new upload_url';
}

done_testing();

