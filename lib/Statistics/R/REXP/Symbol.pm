package Statistics::R::REXP::Symbol;
# ABSTRACT: an R symbol

use 5.010;

use Scalar::Util qw(blessed);

use Moose;
use Statistics::R::REXP::Types;
use namespace::clean;

with 'Statistics::R::REXP';


use constant sexptype => 'SYMSXP';

has name => (
    is => 'ro',
    isa => 'SymbolName',
    default => '',
    coerce => 1,
);

use overload
    '""' => sub { 'symbol `'. shift->name .'`' };

sub BUILDARGS {
    my $class = shift;
    if ( scalar @_ == 1) {
        if ( ref $_[0] eq 'HASH' ) {
            return $_[0]
        }
        else {
            return { name => $_[0] }
        }
    }
    elsif ( @_ % 2 ) {
        die "The new() method for $class expects a hash reference or a key/value list."
                . " You passed an odd number of arguments\n";
    }
    else {
        return { @_ };
    }
}


around _eq => sub {
    my $orig = shift;
    $orig->(@_) and ($_[0]->name eq $_[1]->name);
};


sub to_pl {
    my $self = shift;
    $self->name
}


__PACKAGE__->meta->make_immutable;

1; # End of Statistics::R::REXP::Symbol

__END__


=head1 SYNOPSIS

    use Statistics::R::REXP::Symbol;
    
    my $sym = Statistics::R::REXP::Symbol->new('some name');
    print $sym->name;


=head1 DESCRIPTION

An object of this class represents an R symbol/name object (C<SYMSXP>).


=head1 METHODS

C<Statistics::R::REXP::Symbol> inherits from L<Statistics::R::REXP>.

=head2 ACCESSORS

=over

=item name

String value of the symbol.

=item sexptype

SEXPTYPE of symbols is C<SYMSXP>.

=item to_pl

Perl value of the symbol is just its C<name>.

=back

=for Pod::Coverage BUILDARGS


=head1 BUGS AND LIMITATIONS

Classes in the C<REXP> hierarchy are intended to be immutable. Please
do not try to change their value or attributes.

There are no known bugs in this module. Please see
L<Statistics::R::IO> for bug reporting.


=head1 SUPPORT

See L<Statistics::R::IO> for support and contact information.

=cut
