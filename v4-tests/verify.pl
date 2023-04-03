#!/usr/bin/perl
use warnings;
use strict;
use LWP::UserAgent;
use Data::Dumper;
use MIME::Base64;
use File::Slurp;
use Mojo::Base -strict;
use Mojo::JSON;
use Mojo::UserAgent;
use Mojo::Util qw(dumper);


# my $filename = 'C:\Users\brian\source\repos\perl-projects\dvs-test-app\test-data\Base64Images.txt';

my $front_image_filepath = '/home/brian/source/repos/dvs-test-app/test-data/07-05-2022_7ec25bf0-e9fd-4774-addd-d395b3aad0b1_FrontImage.jpg';
my $back_image_filepath = '/home/brian/source/repos/dvs-test-app/test-data/07-05-2022_7ec25bf0-e9fd-4774-addd-d395b3aad0b1_BackOrSecondImage.jpg';
my $face_image_filepath = '/home/brian/source/repos/dvs-test-app/test-data/07-05-2022_7ec25bf0-e9fd-4774-addd-d395b3aad0b1_FrontImage.jpg';

open my $front_image_handle, '<', $front_image_filepath or die $!;
my $front_image = <$front_image_handle>;

open my $back_image_handle, '<', $back_image_filepath or die $!;
my $back_image = <$back_image_handle>;

# open my $face_image_handle, '<', $face_image_filepath;
# my $face_image = <$face_image_handle>;

close $front_image_handle;
close $back_image_handle;
# close $face_image_handle;

# my $ua = LWP::UserAgent->new;


# #print $front_image;


# my $v4_verify_url = 'https://stage.dvs2.idware.net/api/v4/Verify'; 

# #my $verify_path = 'Verify';


# my $input_filename = 'C:\Users\brian\source\repos\perl-projects\dvs-test-app\input.txt';

# my $json = read_file($input_filename);

# my $output_filename = 'C:\Users\brian\source\repos\perl-projects\dvs-test-app\output.txt';
# open(my $fh, '>', $output_filename) or die "Could not open file '$output_filename' $!";


# my $req = HTTP::Request->new( 'POST', $v4_verify_url );
# $req->header( 'Content-Type' => 'application/json' );
# $req->header( 'Authorization' => 'Bearer sk_edbe2987-eb2c-4c20-843b-e663d583c7a3' );
# $req->content( $json );

# my $resp = $ua->request($req);
# if ($resp->is_success) {
#     my $message = $resp->decoded_content;
#     print $fh Dumper($message);
      
# }
# else {
#     print "HTTP POST error code: ", $resp->code, "\n";
#     print $fh Dumper($resp);
        
# }

# close $fh;


my $encoded_front_image = MIME::Base64::encode_base64($front_image,'');
my $encoded_back_image = MIME::Base64::encode_base64($back_image,'');


use Mojo::UserAgent;
my $ua = Mojo::UserAgent->new;

my $output_filename = 'output.txt';
open(my $fh, '>', $output_filename) or die "Could not open file '$output_filename' $!";

open my $handle, '<', '/home/brian/source/repos/dvs-test-app/test-data/Base64Images.txt';
chomp(my @lines = <$handle>);
close $handle;

my %body = (
    frontImageBase64        =>  $encoded_front_image,
    backOrSecondImageBase64 => $encoded_back_image,
    faceImageBase64         => undef,
    ssn => '5308',
    trackString => {
        trackString   => 'QAoeDUFOU0kgNjM2MDAzMDgwMDAyREwwMDQxMDI1NVpNMDI5NjAwMDhETERBUUctNDIwLTEzNS00MjktMjk4CkRDU0dMT1dBQ0sKRERFTgpEQUNEQU5JRUwKRERGTgpEQURKT0hOCkRER04KRENBQ00KRENCTk9ORQpEQ0ROT05FCkRCRDA0MTUyMDE3CkRCQjA0MTcxOTkxCkRCQTA0MTcyMDI0CkRCQzEKREFVMDczIGluCkRBWVVOSwpEQUcxMDUgT0FLSFVSU1QgQVZFCkRBSUVTU0VYCkRBSk1ECkRBSzIxMjIxMDAwMCAgCkRDRjI1MDBGQUQ5OQpEQ0dVU0EKRENLMTAwMDg5MzEwMApEREFGCkREQjA2MjAyMDE2CkRBVzE5Nw1aTVpNQTAxDQ==',
        barcodeParams => undef
    },
    documentType => 1,
    overriddenSettings => {
        isOCREnabled => Mojo::JSON->false,
        isAddressCheckEnabled => Mojo::JSON->true,
        isDMVEnabled => Mojo::JSON->false,
        isDMVPartialEnabled => Mojo::JSON->false,
        isIdentiFraudEnabled => Mojo::JSON->false,
        isIdentiFraudFullCaseEnabled => Mojo::JSON->false,
        isDmvOrIdentiFraudEnabled => Mojo::JSON->false,
        isDmvAndIdentiFraudEnabled => Mojo::JSON->false,
        isDmvOrIdentiFraudPartialEnabled => Mojo::JSON->false,
        isDmvAndIdentiFraudPartialEnabled => Mojo::JSON->false,
        isFaceRequiredOnDocument => Mojo::JSON->true,
        isGenderCheckEnabled => Mojo::JSON->true,
        isAgeCheckEnabled => Mojo::JSON->true,
        isShuftiEnabled => Mojo::JSON->true,
        isBackOrSecondImageProcessing => Mojo::JSON->true,
        isFaceMatchEnabled => Mojo::JSON->false
    },
    metadata => {
        captureMethod => '111',
        userAgent => '',
        frontEndMetadata => '',
        otherMetadata => ''
  }
);




my $staging_verfy_url = 'https://stage.dvs2.idware.net/api/v4/Verify';

my $tx = $ua->post($staging_verfy_url => {Accept => 'application/json', Authorization => 'Bearer sk_edbe2987-eb2c-4c20-843b-e663d583c7a3'} => json => \%body );
print $fh dumper $tx->req;

my $res = $tx->result->content;

print dumper $res;

close $fh;

