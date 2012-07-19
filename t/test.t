#!/usr/bin/perl

use lib 't';

use Test::User;

$_->runtests for map "Test::$_", qw( User );