package Statistics::R::IO::Base;
# ABSTRACT: Common object methods for processing R files

use 5.012;

use IO::File;
use IO::Handle;

use IO::Uncompress::Gunzip ();
use IO::Uncompress::Bunzip2 ();

use Carp;

use Moo::Role;

requires qw( read );

has fh => (
    is => 'ro',
    required => 1,
    isa => sub {
        die "'fh' must be a file handle"
            unless UNIVERSAL::isa($_[0], 'IO::Handle') ||
            UNIVERSAL::isa($_[0], 'GLOB')
    }
);


sub BUILDARGS {
    my $class = shift;
    if ( scalar @_ == 1 ) {
        if ( defined $_[0] ) {
            if ( ref $_[0] eq 'HASH' ) {
                return { %{ $_[0] } }
            } elsif (ref $_[0] eq '') {
                my $name = shift;
                die "No such file '$name'" unless -r $name;
                my $fh = IO::File->new($name);
                return { fh => $fh }
            }
        }
        die "Single parameters to new() must be a HASH ref or filename scalar"
    }
    elsif ( @_ % 2 ) {
        die "The new() method for $class expects a hash reference or a key/value list."
                . " You passed an odd number of arguments\n";
    }
    else {
        return {@_}
    }
}


sub _read_and_uncompress {
    my $self = shift;
    
    my $data;
    
    $self->fh->sysread($data, 1<<30);
    if (substr($data, 0, 2) eq "\x1f\x8b") {
        ## gzip-compressed file
        $self->fh->sysseek(0, 0);
        IO::Uncompress::Gunzip::gunzip $self->fh, \$data;
    }
    elsif (substr($data, 0, 3) eq 'BZh') {
        ## bzip2-compressed file
        $self->fh->sysseek(0, 0);
        IO::Uncompress::Bunzip2::bunzip2 $self->fh, \$data;
    }
    elsif (substr($data, 0, 6) eq "\xfd7zXZ\0") {
        croak "xz-compressed R files are not supported";
    }

    $data
}


sub close {
    my $self = shift;
    $self->fh->close
}


sub DEMOLISH {
    my $self = shift;
    ## TODO: should only close if given a filename (OR autoclose, if I
    ## choose to implement it)
    $self->close if $self->fh
}


# sub eof {
#     my $self = shift;
#     $self->position >= scalar @{$self->data};
# }

    
1;

__END__


=head1 SYNOPSIS

    use Statistics::R::IO::Base;
    
    # $f is an instance of Base
    $f->does('Statistics::R::IO::Base');
    my $var = $rds->read;
    $f->close;


=head1 DESCRIPTION

An object of this class represents a handle to an R-related file. This
class cannot be directly instantiated (it's a L<Moo::Role>), because
it is intended as a base abstract class with concrete subclasses to
parse specific types of files, such as RDS or RData.


=head1 METHODS

=head2 CONSTRUCTOR

=over

=item new $filename

The single-argument constructor can be invoked with a scalar
containing the name of the R file. This file will be immediately
opened for reading using L<IO::File>. The method will raise an
exception if the file is not readable.

=item new ATTRIBUTE_HASH_OR_HASH_REF

The constructor's arguments can also be given as a hash or hash
reference, specifying values of the object attributes (in this case,
'fh', for which any subclass of L<IO::Handle> can be used).

=back


=head2 ACCESSORS

=over

=item fh

A file handle (stored as a reference to the L<IO::Handle>) to the data
being parsed.

=back


=head2 METHODS

=over

=item read

Reads the contents of the filehandle and returns a
L<Statistics::R::REXP>.

=item close

Closes the object's filehandle. This method is automatically invoked
when the object is destroyed.

=back

=for Pod::Coverage BUILDARGS DEMOLISH


=head1 BUGS AND LIMITATIONS

Instances of this class are intended to be immutable. Please do not
try to change their value or attributes.

There are no known bugs in this module. Please see
L<Statistics::R::IO> for bug reporting.


=head1 SUPPORT

See L<Statistics::R::IO> for support and contact information.


=cut
