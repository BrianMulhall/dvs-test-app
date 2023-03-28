#!/usr/bin/perl
use warnings;
use strict;
use LWP::UserAgent;
use Data::Dumper;
use MIME::Base64;


my $filename = 'C:\Users\brian\source\repos\perl-projects\dvs-test-app\test-data\Base64Images.txt';

my $front_image_filepath = 'C:\Users\brian\source\repos\perl-projects\dvs-test-app\test-data\front.jpg';
my $back_image_filepath = 'C:\Users\brian\source\repos\perl-projects\dvs-test-app\test-data\back.jpg';
my $face_image_filepath = 'C:\Users\brian\source\repos\perl-projects\dvs-test-app\test-data\face.jpg';

open my $front_image_handle, '<', $front_image_filepath;
my $front_image = <$front_image_handle>;

open my $back_image_handle, '<', $back_image_filepath;
my $back_image = <$back_image_handle>;

open my $face_image_handle, '<', $face_image_filepath;
my $face_image = <$face_image_handle>;

close $front_image_handle;
close $back_image_handle;
close $face_image_handle;

my $ua = LWP::UserAgent->new;


#print $front_image;


my $v4_verify_url = 'https://stage.dvs2.idware.net/api/v4/Verify'; 

#my $verify_path = 'Verify';

my $json = '{ 
    "frontImageBase64": \"' . encode_base64($front_image) .
  '\" , "backOrSecondImageBase64":' . encode_base64($back_image) .
  ' , "faceImageBase64": ' . encode_base64($face_image) .
  ' , "ssn": \"\"
   ,"trackString": 
    {
      "trackString": null 
    },
  "documentType": 1,
  "overriddenSettings": null,
  "metadata": null 
}';


my $req = HTTP::Request->new( 'POST', $v4_verify_url );
$req->header( 'Content-Type' => 'application/json' );
$req->header( 'Authorization' => 'Bearer sk_edbe2987-eb2c-4c20-843b-e663d583c7a3' );
$req->content( $json );

my $resp = $ua->request($req);
if ($resp->is_success) {
    my $message = $resp->decoded_content;
    print "Received reply: $message\n";
}
else {
    print "HTTP POST error code: ", $resp->code, "\n";
    print Dumper($resp);
}