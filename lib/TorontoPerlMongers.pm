package TorontoPerlMongers;
use Dancer ':syntax';
use Dancer::Plugin::Feed;

our $VERSION = '0.1';

use TorontoPerlMongers::Model::Meetings;

my $meetings = TorontoPerlMongers::Model::Meetings->new();
$meetings->load("data/meetings");

get qr{/feed/?} => sub {
    # template('meeting', { meeting => $_ }, { layout  => undef } )
    # title, link, summary, content, author, issued and modified
    my @x = map { +{
                      link    => uri_for( '/meetings/' . $_->id() ),
                      issued  => $_->details()->datetime ? $_->details()->datetime : '',
                      title   => $_->label(),
                      content => template('meeting', { meeting => $_, layout => undef }),
                  } } @{ $meetings->meetings() };

    my $feed = create_feed(
         entries => \@x,

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
    template 'index', { meetings => $meetings };
};

true;
