package KiokuX::Debug::Leaks;
use strict;
use warnings;

use Context::Preserve qw/preserve_context/;

our $VERSION = '0.01';

use Sub::Exporter -setup => {
    exports => ['do_with_scope'],
};

sub do_with_scope(&$){
    my ($code, $kiokudb) = @_;

    my $scope = $kiokudb->new_scope;

    # i want to use a guard, but that dies at the wrong time
    return preserve_context { $code->($scope) }
      after => sub {
          my $l = $scope->live_objects;
          undef $scope;
          my @live_objects = $l->live_objects;
          die $l if @live_objects;
      };
}

1;
