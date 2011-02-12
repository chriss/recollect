package Recollect::Trial;
use Moose;
use Recollect::Reminder;
use Recollect::Notifier;
use namespace::clean -except => 'meta';

has 'zone'   => (is => 'ro', isa => 'Recollect::Zone', required => 1);
has 'target' => (is => 'ro', isa => 'Str', required => 1);

with 'Recollect::Roles::Config';
with 'Recollect::Roles::SQL';
with 'Recollect::Roles::Log';

sub Is_valid_target {
    my $class = shift;
    my $target = shift;

    return 0 unless Recollect::Reminder->Is_valid_target($target);
    return 1 if $target =~ m/^(voice|sms):/;
    return 0;
}

sub Create {
    my $class = shift;
    my %opts  = @_;

    # Limit to 2 per target per month.
    my $count = $class->sql_singlevalue(
        "SELECT COUNT(*) FROM trials
          WHERE target = ?
            AND at > 'now'::timestamptz - '1month'::interval",
        [$opts{target}],
    );
    if ($count > 1) {
        $class->log("TRIAL DENIED for $opts{target}");
        return undef;
    }

    return $class->new(%opts);
};

sub fire {
    my $self = shift;

    my $n = Recollect::Notifier->new;
    $n->send_notification(zone => $self->zone, target => $self->target);

    $self->run_sql(
        "INSERT INTO trials VALUES ('now'::timestamptz, ?)",
        [$self->target],
    );
    $self->log("Sent trial reminder to '" . $self->target . "'");
}

__PACKAGE__->meta->make_immutable;
1;
