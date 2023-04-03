use strict;
use v5.20;
use warnings;
use feature qw(signatures);
no warnings qw(experimental::signatures);
use Mojo::Base -strict;
use Mojo::UserAgent;
use Mojo::Util qw(dumper);
use JSON::Validator;

use Test::Simple tests => 2;

my $secret_key = 'sk_edbe2987-eb2c-4c20-843b-e663d583c7a3';


TESTCASEONE: {
my $jv = JSON::Validator->new;
$jv = $jv->schema('file:///home/brian/source/repos/dvs-test-app/v4-tests/json-schemas/health-check-schema.json');


my $staging_health_check_url = 'https://stage.dvs2.idware.net/api/hc';

my $ua = Mojo::UserAgent->new;

my $tx = $ua->get(
    $staging_health_check_url => {
        'content-type'  => '*/*',
        'Authorization' => "Bearer $secret_key"
    }
);

my $res = $tx->result;
say do {
    if ( $res->is_success ) {
        # 2xx series
        'Health Check Request worked!';
    }
    elsif ( $res->is_redirect ) {
        # 3xx series
        'Need to look over there: ' . $res->headers->location;
    }
    elsif ( $res->is_client_error ) {    # 4xx series
        'Problem with the request';
    }
    elsif ( $res->is_server_error ) {    # 5xx series
        'Problem with the response (server fault)';
    }
};

if ( $res->is_success ) {
    my @errors = $jv->validate($res->json);
    print (@errors);
    ok( $res->json->{"status"} =~ m/Healthy/ );

}
else {
    print "HTTP GET error code: ",    $res->code,    "\n";
    print "HTTP GET error message: ", $res->message, "\n";
}

}

TESTCASETWO:{
my $staging_liveness_url     = 'https://stage.dvs2.idware.net/api/liveness';

my $ua = Mojo::UserAgent->new;

my $tx = $ua->get(
    $staging_liveness_url => {
        'content-type'  => '*/*',
        'Authorization' => "Bearer $secret_key"
    }
);

my $res = $tx->result;
say do {
    if ( $res->is_success ) {

        # 2xx series
        'Liveness Request worked!';
    }
    elsif ( $res->is_redirect ) {

        # 3xx series
        'Need to look over there: ' . $res->headers->location;
    }
    elsif ( $res->is_client_error ) {    # 4xx series
        'Problem with the request';
    }
    elsif ( $res->is_server_error ) {    # 5xx series
        'Problem with the response (server fault)';
    }
};

if ( $res->is_success ) {
    ok( $res->body =~ m/Healthy/ );
}
else {
    print "HTTP GET error code: ",    $res->code,    "\n";
}

}