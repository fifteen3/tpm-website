package TorontoPerlMongers;
use Dancer ':syntax';
use Dancer::Plugin::Feed;

our $VERSION = '0.1';

use TorontoPerlMongers::Model::Meetings;

my $meetings = TorontoPerlMongers::Model::Meetings->new();
$meetings->load("data/meetings");

get qr{/feed/?} => sub {
    my $feed = create_feed(	
        entries => [],
    );
    return $feed;	
};

get '/meetings/:meeting' => sub {
    my $id = params->{meeting};
    my ($meeting) = grep { $_->id() == $id } @{$meetings->meetings()} or die("Can't find meeting: $id");
	template 'meeting', { meeting => $meeting };
};

get qr{/meetings/?} => sub {
    template 'meetings', { meetings => $meetings };
};	

get '/' => sub {
    template 'index';
};

true;
