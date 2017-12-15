package SymbolTable;

use strict;


########################################################################


sub new ($) {
    my $proto = shift;
    my $class = ref($proto) || $proto;
    my $self = {};
    bless $self, $class;
    return $self;
}


sub add ($$$) {
    my ($self, $function) = @_;
    my $name = $function->{name};
    if (exists $self->{$name}) {
	$function->warn("duplicate function symbol: $name");
    } else {
	$self->{$name} = $function;
    }
}


sub sort ($) {
    my ($self) = @_;
    return sort { $a->{name} cmp $b->{name} } (values %{$self});
}


########################################################################


1;
