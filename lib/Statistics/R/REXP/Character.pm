package Statistics::R::REXP::Character;
# ABSTRACT: an R character vector

use 5.010;

use Scalar::Util qw(looks_like_number);

use Moose;
use namespace::clean;

with 'Statistics::R::REXP::Vector';
use overload;


use constant sexptype => 'STRSXP';

has '+elements' => (
    isa => 'CharacterElements',
);

sub _type { 'character'; }


__PACKAGE__->meta->make_immutable;

1; # End of Statistics::R::REXP::Character

__END__


=head1 SYNOPSIS

    use Statistics::R::REXP::Character
    
    my $vec = Statistics::R::REXP::Character->new([
        1, '', 'foo', []
    ]);
    print $vec->elements;


=head1 DESCRIPTION

An object of this class represents an R character vector
(C<STRSXP>).


=head1 METHODS

C<Statistics::R::REXP:Character> inherits from
L<Statistics::R::REXP::Vector>, with the added restriction that its
elements are scalar values. Elements that are not scalars (i.e.,
numbers or strings) have value C<undef>, as do elements with R value
C<NA>.

=over

=item sexptype

SEXPTYPE of character vectors is C<STRSXP>.

=back


=head1 BUGS AND LIMITATIONS

Classes in the C<REXP> hierarchy are intended to be immutable. Please
do not try to change their value or attributes.

There are no known bugs in this module. Please see
L<Statistics::R::IO> for bug reporting.


=head1 SUPPORT

See L<Statistics::R::IO> for support and contact information.

=cut
