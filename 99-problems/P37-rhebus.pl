use v6;

# Specification:
#   P37 (**) Calculate Euler's totient function phi(m) (improved).
#       See problem P34 for the definition of Euler's totient function. If the
#       list of the prime factors of a number m is known in the form of
#       problem P36 then the function phi(m) can be efficiently calculated as
#       follows: Let ((p1 m1) (p2 m2) (p3 m3) ...) be the list of prime
#       factors (and their multiplicities) of a given number m. Then phi(m)
#       can be calculated with the following formula:
#
#   phi(m) = (p1-1) * p1 ** (m1-1) * (p2-1) * p2 ** (m2-1)
#          * (p3-1) * p3 ** (m3-1) * ...


# Straight from P36-rhebus.pl
sub prime_factors_mult (Int $n) {
    my $residue = $n;
    gather for (2,3,*+2 ... $n) -> $k {
        my $mult=0;
        while $residue %% $k {
            $mult++;
            $residue div= $k;
        }
        take [$k, $mult] if $mult;
        last if $residue == 1;
        if $k > sqrt $residue {
            take [$residue,1];
            last;
        }
    }
}


# 1. One-liner version
say "phi($_): ", [*] prime_factors_mult($_).map({ ($_[0]-1) * $_[0] ** ($_[1]-1) })
    for 1..20;
say [*] prime_factors_mult(315).map: { ($_[0]-1) * $_[0] ** ($_[1]-1) };
    

# 2. sub version
# note that when prime_factors_mult returns an empty list, [*] returns the
# multiplicative identity 1. This means we don't need to special-case
# totient(1) like in P34-rhebus.pl
sub totient (Int $n) {
    my @factors = prime_factors_mult($n);
    return [*] @factors.map: {
        ($_[0]-1) * $_[0] ** ($_[1]-1)
    }
}

say "phi2($_): ",  totient($_) for 1..20;
say "phi2(315): ", totient(315);

# vim:ft=perl6
