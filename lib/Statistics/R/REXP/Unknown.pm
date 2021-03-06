package Statistics::R::REXP::Unknown;
# ABSTRACT: R object not representable in Rserve

use 5.010;

use Scalar::Util qw(looks_like_number);

use Moose;
use Statistics::R::REXP::Types;
use namespace::clean;

with 'Statistics::R::REXP';

has _sexptype => (
    is => 'ro',
    isa => 'SexpType',
    required => 1,
);

use overload
    '""' => sub { 'Unknown' };

sub sexptype {
    my $self = shift;

    $self->_sexptype
}

sub to_pl {
    undef
}


__PACKAGE__->meta->make_immutable;

1; # End of Statistics::R::REXP::Unknown

__END__


=head1 SYNOPSIS

    use Statistics::R::REXP::Unknown;
    
    my $unknown = Statistics::R::REXP::Unknown->new(4);
    say $unknown->sexptype;
    say $unknown->to_pl;


=head1 DESCRIPTION

An object of this class represents an R object that's currently not
representable by the Rserve protocol.

=head1 METHODS

C<Statistics::R::REXP::Unknown> inherits from L<Statistics::R::REXP> and
adds no methods of its own.

=head2 ACCESSORS

=over

=item sexptype

The R L<SEXPTYPE|http://cran.r-project.org/doc/manuals/r-release/R-ints.html#SEXPTYPEs> of the object.

=item to_pl

The Perl value of the unknown type is C<undef>.

=back


=head1 BUGS AND LIMITATIONS

Classes in the C<REXP> hierarchy are intended to be immutable. Please
do not try to change their value or attributes.

There are no known bugs in this module. Please see
L<Statistics::R::IO> for bug reporting.


=head1 SUPPORT

See L<Statistics::R::IO> for support and contact information.

=cut
