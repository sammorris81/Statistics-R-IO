package Statistics::R::REXP::Integer;
# ABSTRACT: an R integer vector

use 5.010;

use Scalar::Util qw(looks_like_number);

use Moose;
use namespace::clean;

with 'Statistics::R::REXP::Vector';
use overload;


use constant sexptype => 'INTSXP';

has '+elements' => (
    isa => 'IntegerElements',
);

sub _type { 'integer'; }


__PACKAGE__->meta->make_immutable;

1; # End of Statistics::R::REXP::Integer

__END__


=head1 SYNOPSIS

    use Statistics::R::REXP::Integer
    
    my $vec = Statistics::R::REXP::Integer->new([
        1, 4, 'foo', 42
    ]);
    print $vec->elements;


=head1 DESCRIPTION

An object of this class represents an R integer vector (C<INTSXP>).


=head1 METHODS

C<Statistics::R::REXP:Integer> inherits from
L<Statistics::R::REXP::Vector>, with the added restriction that its
elements are truncated to integer values. Elements that are not
numbers have value C<undef>, as do elements with R value C<NA>.


=over

=item sexptype

SEXPTYPE of integer vectors is C<INTSXP>.

=back


=head1 BUGS AND LIMITATIONS

Classes in the C<REXP> hierarchy are intended to be immutable. Please
do not try to change their value or attributes.

There are no known bugs in this module. Please see
L<Statistics::R::IO> for bug reporting.


=head1 SUPPORT

See L<Statistics::R::IO> for support and contact information.

=cut
