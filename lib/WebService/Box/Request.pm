package WebService::Box::Request;

use strict;
use warnings;

use Moo;
use Types::Standard qw(InstanceOf Dict Str);
use HTTP::Tiny;
use JSON;

use WebService::Box::Types::Library qw(OptionalStr);

has session     => (is => 'ro',  isa => InstanceOf["WebService::Box::Session"], required => 1);
has agent       => (is => 'ro',  isa => InstanceOf["HTTP::Tiny"], lazy => 1, builder => sub { HTTP::Tiny->new } );
has error       => (is => 'rwp', isa => OptionalStr );
has jsonp       => (is => 'ro',  isa => InstanceOf["JSON"], lazy => 1, builder => sub { JSON->new->allow_nonref } );
has auth_header => (
    is      => 'ro',
    isa     => Dict[
        Authorization => Str,
    ],
    lazy    => 1,
    builder => sub {
        { Authorization => 'Bearer ' . $self->session->auth_token };
    },
);

sub do {
    my $self   = shift;
    my %params = @_;

    $self->_check_token;
    my $method = sprintf "_%s_%s", delete $params{qw/ressource action/};
    return $self->$method( %params );
}

sub _check_token {
    my $self = shift;

    if ( $self->session->expires < time ) {
        $self->session->refresh;
    }
}

sub _files_get {
    my ($self, %params) = @_;

    $self->_set_error( undef );

    if ( !$params{id} ) {
        $self->session->box->error( 'Need id for request' );
        $self->_set_error( 'Need id for request' );
        return;
    }

    my $url = sprintf "%sfiles/%s/",
        $self->session->box->api_url,
        $params{id};

    my %result = $self->agent->get( $url );

    if ( !$result->{success} ) {
        $self->_set_error( $result->{content} );
        return;
    }

    my %data = %{ $self->jsonp->decode( $result->{content} || "{}" ) || {} };
    return %data;
}



1;

