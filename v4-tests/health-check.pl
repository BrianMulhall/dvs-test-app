use strict;
use v5.20;
use warnings;
use feature qw(signatures);
no warnings qw(experimental::signatures);
use Data::Dumper;
use JSON;
use LWP::UserAgent;
use Test::Simple tests => 2;

my $secret_key = 'sk_edbe2987-eb2c-4c20-843b-e663d583c7a3';

my $health_check_url = 'https://stage.dvs2.idware.net/api/hc';
my $liveness_url = 'https://stage.dvs2.idware.net/api/liveness';



my $ua = LWP::UserAgent->new;

# set custom HTTP request header fields
my $req = HTTP::Request->new(GET => $health_check_url);
$req->header('content-type' => '*/*');
$req->header('Authorization' => "Bearer $secret_key");

my $resp = $ua->request($req);
if ($resp->is_success) {
    my $message = $resp->decoded_content;
    my $text = JSON::decode_json($message);
    print Dumper($text->{'status'});
    ok($text->{"status"} =~ m/Healthy/);
    
}
else {
    print "HTTP GET error code: ", $resp->code, "\n";
    print "HTTP GET error message: ", $resp->message, "\n";
}



# set custom HTTP request header fields
$req = HTTP::Request->new(GET => $liveness_url);
$req->header('content-type' => '*/*');
$req->header('Authorization' => "Bearer $secret_key");

$resp = $ua->request($req);
if ($resp->is_success) {
    my $message = $resp->decoded_content;
    ok($message =~ m/Healthy/);
}
else {
    print "HTTP GET error code: ", $resp->code, "\n";
    print "HTTP GET error message: ", $resp->message, "\n";
}