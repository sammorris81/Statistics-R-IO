package Statistics::R::REXP::Complex;
# ABSTRACT: an R numeric vector

use 5.010;

use Moose;
use namespace::clean;

with 'Statistics::R::REXP::Vector';
use overload;


use constant sexptype => 'CPLXSXP';

has '+elements' => (
    isa => 'ComplexElements',
    );


around _eq => sub {
    my $orig = shift;

    return unless Statistics::R::REXP::_eq(@_);
    
    my ($self, $obj) = (shift, shift);

    my $a = $self->elements;
    my $b = $obj->elements;
    return undef unless scalar(@$a) == scalar(@$b);
    for (my $i = 0; $i < scalar(@{$a}); $i++) {
        my $x = $a->[$i];
        my $y = $b->[$i];
        if (defined($x) && defined($y)) {
            return undef unless
                $x == $y;
        } else {
            return undef if defined($x) or defined($y);
        }
    }
    
    1
};


sub _type { 'complex'; }


__PACKAGE__->meta->make_immutable;

1; # End of Statistics::R::REXP::Complex

__END__


=head1 SYNOPSIS

    use Statistics::R::REXP::Complex;
    use Math::Complex ();
    
    my $vec = Statistics::R::REXP::Complex->new([
        1, cplx(4, 2), 'foo', 42
    ]);
    print $vec->elements;


=head1 DESCRIPTION

An object of this class represents an R complex vector
(C<CPLXSXP>).


=head1 METHODS

C<Statistics::R::REXP:Complex> inherits from
L<Statistics::R::REXP::Vector>, with the added restriction that its
elements are complex numbers. Elements that are not numbers have value
C<undef>, as do elements with R value C<NA>.

=over

=item sexptype

SEXPTYPE of complex vectors is C<CPLXSXP>.

=back


=head1 BUGS AND LIMITATIONS

Classes in the C<REXP> hierarchy are intended to be immutable. Please
do not try to change their value or attributes.

There are no known bugs in this module. Please see
L<Statistics::R::IO> for bug reporting.


=head1 SUPPORT

See L<Statistics::R::IO> for support and contact information.

=cut
