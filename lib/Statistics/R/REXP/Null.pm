package Statistics::R::REXP::Null;
# ABSTRACT: the R null object

use 5.010;

use Moose;
use namespace::clean;

with 'Statistics::R::REXP';


has '+sexptype' => (
    default => 'NILSXP'
);


sub BUILDARGS {
    my $class = shift;
    die 'Null cannot have attributes' if scalar @_;

    return {@_}
}

sub is_null {
    return 1;
}

use overload
    '""' => sub { 'NULL' };

sub to_pl {
    undef
}


__PACKAGE__->meta->make_immutable;

1; # End of Statistics::R::REXP::Null

__END__


=head1 SYNOPSIS

    use Statistics::R::REXP;
    
    my $null = Statistics::R::REXP::Null->new();
    say $rexp->is_null;
    print $rexp->to_pl;


=head1 DESCRIPTION

An object of this class represents the null R object (C<NILSXP>). The
null object does not have a value or attributes, and trying to set
them will cause an exception.


=head1 METHODS

C<Statistics::R::REXP::Null> inherits from L<Statistics::R::REXP> and
adds no methods of its own.

=head2 ACCESSORS

=over

=item to_pl

The Perl value of C<NULL> is C<undef>.

=item attributes

Null objects have no attributes, so the attributes accessor always
returns C<undef>.

=back

=for Pod::Coverage is_null


=head1 BUGS AND LIMITATIONS

Classes in the C<REXP> hierarchy are intended to be immutable. Please
do not try to change their value or attributes.

There are no known bugs in this module. Please see
L<Statistics::R::IO> for bug reporting.


=head1 SUPPORT

See L<Statistics::R::IO> for support and contact information.

=cut
