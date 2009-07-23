use strict;
use warnings;
use Test::More tests => 5;
use Test::Exception;

use KiokuDB;
use KiokuX::Debug::Leaks qw(do_with_scope);

my $db = KiokuDB->connect( 'hash' );
ok 'connected ok';

lives_ok {
    do_with_scope {
        my $obj = { foo => 'bar' };
        my $id = $db->store($obj);
        undef $obj;
        $obj = $db->lookup($id);
        ok $obj, 'reloaded ok';
    } $db;
} 'leakless lives';

my $drain;

dies_ok {
    do_with_scope {
        my $faucet = { key => 'value' };
        my $id = $db->store($faucet);
        undef $faucet;
        $faucet = $db->lookup($id);
        ok $faucet, 'reloaded ok';
        $drain = $faucet; # get it? leaky faucet!!! HAHAHAHAHAHAHA
    } $db;
} 'dies when we leak something';
