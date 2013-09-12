package WebService::Box::Types::Library;

use strict;
use warnings;

use Type::Library
    -base,
    -declare => qw(
        BoxPerson PersonHash Timestamp BoxFolderHash BoxFileHash
        OptionalStr OptionalInt
    );

use Type::Utils -all;
use Types::Standard -types;

# create some basic types
{
    declare OptionalStr => as union[ Undef, Str ];
    declare OptionalInt => as union[ Undef, Int ];
}

# create types regarding users
{
    class_type BoxPerson => { class => "WebService::Box::Types::By" };

    declare PersonHash =>
        as Dict[
            type  => Str,
            id    => Int,
            name  => Str,
            login => Str,
        ];

    coerce BoxPerson => 
        from PersonHash => via { WebService::Box::Types::By->new( %{$_} ) };
}


# create types regarding times
{
    class_type Timestamp => { class => "DateTime" };

    coerce Timestamp =>
        from Str() => via {
            my ($timezone) = $_ =~ m{([+-][0-9]{2}:?[0-9]{2})\z};
            $timezone =~ s{:}{};

            my ($year,$month,$day,$hour,$minute,$second) = split /[:T-]/, $_;
            DateTime->new(
                second    => $second,
                minute    => $minute,
                hour      => $hour,
                day       => $day,
                month     => $month,
                year      => $year,
                time_zone => $timezone,
            );
        };
}

{
    declare BoxFolderHash => 
        as Dict[
            type        => sub{ $_ eq 'folder' },
            id          => Str,
            sequence_id => OptionalStr,
            etag        => OptionalStr,
            name        => Str,
        ];

    declare BoxFileHash => 
        as Dict[
            type        => sub{ $_ eq 'file' },
            id          => Str,
            sequence_id => OptionalStr,
            etag        => OptionalStr,
            name        => Str,
        ];
}

1;
