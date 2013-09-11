package WebService::Box::Types::Library;

use strict;
use warnings;

use Type::Library
    -base,
    -declare => qw(BoxPerson PersonHash);

use Type::Utils -all;
use Types::Standard -types;


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
        from Str => via {
            my ($day,$month,$year,$hour,$minute,$second) = split /[:T-]/, $_;
            DateTime->new(
                second => $second,
                minute => $minute,
                hour   => $hour,
                day    => $day,
                month  => $month,
                year   => $year,
            );
        };
}

1;
