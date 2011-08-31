package Recollect::ProController;
use Moose;
use Recollect::User;
use JSON qw/encode_json/;
use namespace::clean -except => 'meta';

with 'Recollect::ControllerBase';
with 'Recollect::Roles::SQL';

sub run {
    my $self = shift;
    my $req = $self->request;

    my $path = $req->path;
    my %pro_map = (
        GET => [
            [ qr{^/$}                   => \&home_screen ],
        ],
    );

    my $method = $req->method;
    my $resp;
    my $matcher = sub {
        for my $match (@_) {
            my ($regex, $todo) = @$match;
            if ($path =~ $regex) {
                $resp ||= $todo->($self, $1, $2, $3, $4);
                last;
            }
        }
    };
    $matcher->( @{ $pro_map{$method} } );
    return $resp if $resp;

    $self->message("Unknown path - $path");
    return $self->home_screen;
}

sub home_screen {
    my $self = shift;

    my $params = {
    };
    return $self->process_template("pro/home.tt2", $params)->finalize;
}

__PACKAGE__->meta->make_immutable;
1;
