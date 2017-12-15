package Embedded;

use strict;
use Carp;


########################################################################


sub new ($;$) {
    my ($proto, $parent) = @_;
    my $class = ref($proto) || $proto;

    my $self = { parent => $parent,
		 name => "(anonymous $class)" };

    bless $self, $class;
    return $self;
}


sub name ($) {
    my $self = shift;
    if ($self->{parent}) {
	return $self->{parent}->name . '::' . $self->{name};
    } else {
	return $self->{name};
    }
}


sub malformed ($$$) {
    my ($self, $context) = @_;
    confess $self->name . ": malformed $context: $_\n";
}


sub warn ($$) {
    my ($self, $message) = @_;
    warn $self->name . ": $message\n";
}


########################################################################


1;
