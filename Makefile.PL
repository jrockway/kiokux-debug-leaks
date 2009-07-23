use inc::Module::Install;
use strict;

requires 'Context::Preserve';
requires 'KiokuDB'; # technically not required... but...

build_requires 'Test::More';
build_requires 'Test::Exception';
build_requires 'ok';

WriteAll();
