#!/usr/bin/env perl
use strict;
use warnings;
use lib 'lib';
use Recollect::Subscription;
use Recollect::Notifier;
use FindBin;

$ENV{RECOLLECT_BASE_PATH} = "$FindBin::Bin/..";
my $n = Recollect::Notifier->new;
$n->send_email(
    to => 'team@recollect.net',
    subject => "This Week in Recollect",
    content_type => 'text/html',
    template => 'twir.html',
    template_args => {
        subs => recent_subscriptions(),
        need_data => zones_needing_moar_datas(),
        sent => notifications_sent(),
        icals => icals_fetched(),
        place_interest => place_interest(),
    },
);
print "Sent\n";

exit;


sub recent_subscriptions {
    my $sth = Recollect::Subscription->run_sql(
        q{SELECT * FROM subscriptions
            WHERE created_at > 'now'::timestamptz - '1week'::interval
        }
    );
    my $subs = Recollect::Subscription->_all_as_obj($sth);
    return [ sort { $a->free <=> $b->free } @$subs ];
}


sub zones_needing_moar_datas {
    my $cols = Recollect::Zone->Columns;
    my $sth = Recollect::Zone->run_sql(
        qq{SELECT $cols from zones
            WHERE id NOT IN (
                SELECT zone_id FROM pickups
                  WHERE day > 'now'::timestamptz + '2weeks'::interval
                  GROUP BY zone_id)
        }
    );
    return Recollect::Zone->_all_as_obj($sth);
}

sub notifications_sent {
    return Recollect::Reminder->sql_singlevalue(
        q{SELECT COUNT(*) FROM reminders WHERE last_notified > 'now'::timestamptz - '1week'::interval},
    );
}

sub icals_fetched {
    return Recollect::Reminder->sql_singlevalue(
        q{select count(distinct(ical_id)) FROM ical_users where last_get > 'now'::timestamptz - '1week'::interval;},
    );
}

sub place_interest {
    return Recollect::Reminder->sql_singlevalue(
        q{select count(*) from place_interest where at > 'now'::timestamptz - '1week'::interval;}
    );
}
