#!/usr/bin/env perl
use Mojolicious::Lite;
use FindBin qw($Bin);
use Digest::MD5 qw/md5_hex/;
use Path::Tiny;
use Time::Piece;


app->static->paths->[0] = $Bin . '/static';

get '/static/*file' => sub {
  my $self = shift;
  $self->reply->static($self->param('file'))
};

get '/' => sub {
    my $c = shift;
    $c->stash('mermaid', '');
    $c->render(template => 'index');
};

get '/new' => sub {
    my $c = shift;
    my $md5 = md5_hex(localtime . rand(10000));
    $c->redirect_to('/' . $md5);
};

post '/:md5' => sub {
    my $c = shift;

    unless ($c->param('mermaid')) {
	$c->res->code(400);
	return $c->render(json => { status => 'error', message => "missing mermaid content" });
    }
    
    my $p = path($Bin . '/data/' . $c->param('md5') . '.txt' );
    if ($p->is_file) {
	# app->log->info($p->stat->mtime);
	# app->log->info("$p");
	my $t = Time::Piece->new($p->stat->mtime);
	$t->strptime($p->stat->mtime, '%s' );
	$t = $t->strftime('%Y%m%d%H%M');
	my $n = "$p" =~ s/(\.)/-$t$1/r;
	# app->log->info($n)	    
	$p->copy($n);
    }
    if ($c->param('mermaid')) {
	$p->spew_utf8($c->param('mermaid'));
    }
    $c->render(json => { status => 'done' });
};

get '/:md5' => sub {
    my $c = shift;
    my $p = path($Bin . '/data/' . $c->param('md5') . '.txt' );
    $c->stash('mermaid', $p->is_file ? $p->slurp_utf8 : '');
    $c->render(template => 'index');
};

get '/:md5/:version' => sub {

};

get '/api';

app->start;
__DATA__

@@ layouts/default.html.ep
