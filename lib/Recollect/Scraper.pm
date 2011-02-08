package Recollect::Scraper;
use URI;
use Moose;
use FindBin;
use Web::Scraper;
use YAML qw/LoadFile/;
use namespace::clean -except => 'meta';

has 'zone'  => (is => 'ro', isa => 'Str');
has 'area'  => (is => 'ro', isa => 'Object', required => 1);

sub scrape {
    my $self = shift;
    my $area = $self->area;
    my $only_zone = $self->zone;

    my $zones = $area->zones;
    die "Sorry, '" . $area->name . "' has no zones defined!" unless @$zones;

    for my $zone (@$zones) {
        next if $only_zone and $zone->{name} ne $only_zone;
        print "Scraping " . $zone->name . "\n";
        my $pickups = $self->scrape_zone($zone);

        $zone->add_pickups($pickups);
    }
}

sub scrape_zone {
    my $self = shift;
    my $zone = shift;
    my $debug = $ENV{RECOLLECT_DEBUG} = 1;

    my $row_scraper = scraper {
        process 'td.headings', 'months[]' => 'TEXT';
        process 'td:nth-child(2)', 'month1day' => 'TEXT';
        process 'td:nth-child(3) > img', 'month1yard' => '@alt';
        process 'td:nth-child(5)', 'month2day' => 'TEXT';
        process 'td:nth-child(6) > img', 'month2yard' => '@alt';
        process 'td:nth-child(8)', 'month3day' => 'TEXT';
        process 'td:nth-child(9) > img', 'month3yard' => '@alt';
    };

    my $zone_scraper = scraper {
        process 'tr', "rows[]" => $row_scraper;
    };

    my $uri = uri_for_zone($zone);
    my $res = $zone_scraper->scrape( URI->new( $uri ) );

    my @days;
    my @current_months;
    for my $row (@{ $res->{rows} }) {
        if ($row->{months}) {
            @current_months = @{ $row->{months} };
        }
        else {
            for my $i (1 .. 3) {
                my $day = $row->{"month${i}day"};
                next unless $day;
                next if $day =~ m/^\s*$/ or $day =~ m/Set out by 7/;
                unless ($day and $day =~ m/^\s*(\d+)\s*$/) {
                    warn "Couldn't recognize: '$day'\n" if $day =~ m/\w+/;
                    next;
                }
                $day = $1;
                my $year = 2010;
                my $month = $current_months[$i - 1];
                if ($month =~ s/^(\w+) (\d+)/$1/) {
                    $year = $2;
                }
                $month =~ s/\s+$//;

                my $month_num = _month_to_num($month);
                my $date = sprintf '%4d-%02d-%02d 07:00-08', $year,$month_num,$day;

                my $flags = 'GR';
                if ($row->{"month${i}yard"}) {
                    $flags .= 'Y';
                }

                push @days, {
                    day => $date,
                    flags => $flags,
                };
            }
        }

    }

    return [ sort {$a->{day} cmp $b->{day}} @days ];
}


sub _month_to_num {
    my $name = shift;
    return {
        january => 1,
        february => 2,
        march => 3,
        april => 4,
        may => 5,
        june => 6,
        july => 7,
        august => 8,
        september => 9,
        october => 10,
        november => 11,
        december => 12,
    }->{lc $name} || die "No month for '$name'";
}

sub uri_for_zone {
    my $zone = shift;
    die "Do not know how to scrape for area " . $zone->area->name
        unless $zone->area->name eq 'Vancouver';

    # http://vancouver.ca/ENGSVCS/solidwaste/garbage/north-purple.htm
    my $uri_base = 'http://vancouver.ca/ENGSVCS/solidwaste/garbage';
    $zone->name =~ m/^vancouver-(\w+)-(\w+)$/;
    return "$uri_base/$1-$2.htm";
}

__PACKAGE__->meta->make_immutable;
1;

