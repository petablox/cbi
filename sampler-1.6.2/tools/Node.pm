package Node;

use strict;

use Embedded;

our @ISA = ('Embedded');


########################################################################


sub new ($$) {
    my ($proto, $parent) = @_;
    my $class = ref($proto) || $proto;
    my $self = $class->SUPER::new(@_);
    bless $self, $class;

    my $handle = $parent->{handle};
    local $_ = <$handle>;
    chomp;
    return if $_ eq '';

    /^(.+)\t(\d+)$/ or $self->malformed('node header');
    ($self->{filename}, $self->{line}) = ($1, $2);
    
    $_ = <$handle>;
    chomp;
    /^(\d+\t)*$/ or $self->malformed('successors list');
    my @successors = split /\t/;
    $self->{successors} = \@successors;

    $_ = <$handle>;
    chomp;
    my @callees;
    if ($_ ne '???') {
	/^([\w\$]+\t)*$/ or self->malformed('callees list');
	@callees = split /\t/;
	$self->{callees} = \@callees;
    }

    return $self;
}


sub resolveSuccessors ($$) {
    my ($self, $peers) = @_;
    $peers->[$self->{name}] == $self or die "inconsistent node ordering";

    $_ = $peers->[$_] foreach @{$self->{successors}};
}


sub resolveCallees ($$$) {
    my ($self, $unit, $exports) = @_;

    return unless exists $self->{callees};

    foreach (@{$self->{callees}}) {
	my $old = $_;
	if (exists $unit->{$_}) {
	    $_ = $unit->{$_};
	} elsif (exists $exports->{$_}) {
	    $_ = $exports->{$_};
	}
    }
}


sub dump ($) {
    my $self = shift;

    print "\t\t\tnode $self->{name} at $self->{filename}:$self->{line}\n";

    if (@{$self->{successors}}) {
	print "\t\t\t\tsuccessors:";
	print " $_->{name}" foreach @{$self->{successors}};
	print "\n";
    }

    if (exists $self->{callees}) {
	if (@{$self->{callees}}) {
	    print "\t\t\t\tcallees:";
	    foreach (@{$self->{callees}}) {
		if (ref) {
		    print " $_->{name}";
		} else {
		    print " ($_)";
		}
	    }
	    print "\n";
	}
    } else {
	print "\t\t\t\tcallees: ???\n";
    }
}


########################################################################


sub dot ($) {
    my $self = shift;

    print "\t\t\t\t\"$self\" [label=$self->{name}];\n";

    if (@{$self->{successors}}) {
	print "\t\t\t\t\"$self\" -> { ";
	print "\"$_\"; " foreach @{$self->{successors}};
	print "}\n";
    }

    if (exists $self->{callees} && @{$self->{callees}}) {
	print "\t\t\t\t\"$self\" -> { ";
	foreach (@{$self->{callees}}) {
	    if (ref $_) {
		print "\"$_->{nodes}[0]\"; ";
	    } else {
		print "\"$_\"; ";
	    }
	}
	print "} [style=dotted]\n";
    }
}


sub count_callees ($$) {
    my ($self, $count) = @_;

    ++$count->{$_} foreach @{$self->{callees}};
}


########################################################################


1;
