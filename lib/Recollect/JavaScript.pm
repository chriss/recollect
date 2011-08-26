package Recollect::JavaScript;
use Moose;
use methods;
use Recollect::Util qw/base_path is_dev_env/;
use File::Slurp qw(slurp write_file);
use Jemplate;
use JavaScript::Minifier::XS qw(minify);
use Compress::Zlib;
use namespace::clean -except => 'meta';

has 'target' => ( is => 'ro', isa => 'Str', required => 1 );

has 'compile_dir' => ( is => 'ro', isa => 'Str', lazy_build => 1 );
method _build_compile_dir {
    my $dir = 'root/javascript/compiled';
    mkdir $dir unless -d $dir;
    return $dir;
}

has 'compressed_file' => ( is => 'ro', isa => 'Str', lazy_build => 1 );
method _build_compressed_file {
    return join('/', $self->compile_dir, $self->target . '.jgz');
}
has 'uncompressed_file' => ( is => 'ro', isa => 'Str', lazy_build => 1 );
method _build_uncompressed_file {
    return join('/', $self->compile_dir, $self->target . '.js');
}

has 'parts' => ( is => 'ro', isa => 'ArrayRef', lazy_build => 1 );
method _build_parts {
    my $targets = {
        'recollect' => [
            'libs/jquery-1.4.2.min.js',
            'libs/jquery-ui-1.8.6.custom.min.js',
            'libs/jquery.scrollTo-1.4.2-min.js',
            'libs/jquery.cookie.js',
            'libs/json2.js',
        ],
        'recollect-wizard' => [
             'libs/jquery.timePicker.min.js',
             'libs/jquery-maskedinput-1.2.2.min.js',
             'libs/jquery.validate.js',
             'libs/jquery.client.js',
             'libs/geoxml3.js',
             'libs/google.polygon.js',
             'recollect/base.js',
             'recollect/wizard.js',
             'recollect/feedback.js',
             { jemplate_runtime => 1 },
             { jemplate => 'template/wizard.tt2' },
             { jemplate => 'template/feedback.tt2' },
         ],
         'recollect-radmin' => [
             'libs/jquery.timePicker.min.js',
             'libs/jquery-maskedinput-1.2.2.min.js',
             'libs/jquery.validate.js',
             'libs/geoxml3.js',
             'libs/google.polygon.js',
             'libs/history.adapter.jquery.js',
             'libs/history.js',
             'libs/history.html4.js',
             'recollect/base.js',
             'recollect/radmin.js',
             { jemplate_runtime => 1 },
             { jemplate => 'template/radmin.tt2' },
         ]
    };
    my $parts = $targets->{$self->target};
    for my $part (@$parts) {
        unless (ref $part) {
            $part = { file => "root/javascript/$part" };
        }

        if ($part->{jemplate}) {
            $part->{file} = "root/javascript/$part->{jemplate}";
        }
    }
    return $parts;
};

method part_files {
    return grep { $_ } map { $_->{file} } @{$self->parts};
}

method needs_update($target) {
    return $self->most_recent() > $self->modified($self->uncompressed_file);
}

method build($target) {
    my $parts = $self->parts || return;

    if ($self->needs_update) {
        # Build away
        my $content = '';
        for my $part (@$parts) {
            if ($part->{jemplate_runtime}) {
                $content .= Jemplate->runtime_source_code('jquery');
            }
            elsif ($part->{jemplate}) {
                $content .= Jemplate->compile_template_files($part->{file});
            }
            else {
                $content .= slurp($part->{file});
            }
            $content .= "\n;\n";
        }
        write_file($self->uncompressed_file, $content);

        # Minify
        my $minified = minify($content);

        # Compress
        my $gzipped = Compress::Zlib::memGzip($minified);

        write_file($self->compressed_file, $gzipped);
    }
}

method modified($file) {
    return (stat $file)[9] || 0;
}

method most_recent() {
    my @mods = sort { $a <=> $b }
                map { $self->modified($_->{file}) }
               grep { $_->{file} }
                    @{$self->parts};
    return $mods[-1];
}

__PACKAGE__->meta->make_immutable;
