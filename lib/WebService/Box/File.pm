package WebService::Box::File;

use strict;
use warnings;

use Moo;
use Types::Standard qw(Str Int InstanceOf);
use WebService::Box::Types::Library qw(BoxPerson Timestamp BoxFolderHash OptionalStr);
use WebService::Box::Request;

has session => (is => 'ro', isa => InstanceOf["WebService::Box::Session"], required => 1);

has [qw/type id name description structure/] => (
    is  => 'ro',
    isa => Str,
);

has [qw/etag sequence_id sha1 item_status version_number/] => (
    is  => 'ro',
    isa => OptionalStr,
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

has parent_data => (is => 'ro', isa => BoxFolderHash);

has request => (
    is      => 'ro',
    isa     => InstanceOf["WebService::Box::Request"], 
    lazy    => 1,
    default => sub {
        my $self = shift;
        WebService::Box::Request->new( session => $self->session )
    },
);

has _parent_object => (is => 'rwp', isa => InstanceOf["WebService::Box::Folder"]);

sub parent {
    my ($self) = @_;

    my $data = $self->parent_data;

    if ( !$data ) {
        if ( !$self->id ) {
            $self->session->box->error( 'no id for parent found and no file id exists' );
            return;
        }

        my %file_data = $self->request(
            ressource => 'files',
            id        => $self->id,
        );

        $_[0] = WebService::Box::File->new( %file_data, session => $self->session );
    }

    if ( !$self->_parent_object ) {
        my %parent_data_result = $self->request(
            ressource => 'folders',
            id        => $data->{id},
        ); 
        
        $self->__set_parent_object(
            WebService::Box::Folder->new( %{$data}, session => $self->session )
        );
    }

    return $self->_parent_object;
}

sub upload {
    my ($self, $path, $parent) = @_;

    my $parent_id = ref $parent ? $parent->id : $parent;

    my %upload_data = $self->request(
        ressource => 'upload',
        filename  => $path,
        parent_id => $parent_id, 
    );

    my $uploaded_file = WebService::Box::File->new( %upload_data, session => $self->session );
    return $uploaded_file;
}

sub download {
}

sub comment {
}

sub comments {
}

sub BUILDARGS {
   my ( $class, @args ) = @_;

   unshift @args, "id" if @args % 2 == 1;

   return { @args };
}

1;
