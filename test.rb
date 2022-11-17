# webrickを呼び出している
require 'webrick'

# WEB Brick::HTTPServer.newでWebrickのインスタンスを作成して、serverという名前のローカル変数に入れる。
# その際の初期値として、
server = WEBrick::HTTPServer.new({
  
  # DocumentRootの後にこのWebアプリケーションのドメインの設定
  # （ここに書き込まれた記述が、作成するWebアプリケーションのドメインになる）
  :DocumentRoot => '.',
  
  # CGIInterpreterがこのプログラムを実行（翻訳）できるプログラム（Rubyのこと）本体の居場所を指定する記述。
  :CGIInterpreter => WEBrick::HTTPServlet::CGIHandler::Ruby,

  # Port：このWebアプリケーションの情報の出入り口を表す設定。
  :Port => '3000',
})
['INT', 'TERM'].each {|signal|
  Signal.trap(signal){ server.shutdown }
}

# というコードを記述することで、Webサーバを起動した状態で、（DocumentRootの値）/testというURLを送信すると、
# 同じディレクトリ階層にあるtest.html.erbファイルを表示するという機能が付与されます。
# 今回のDocumentRootは’.’ですから、”./test”というURLが送信されることになります
server.mount('/test', WEBrick::HTTPServlet::ERBHandler, 'test.html.erb')

# この行を追加することで、<form action='indicate.cgi'> 〜 </form>(test.html.erbの中のコード)
# の内部にある値を、indicate.rbに送信することができるようになります。
server.mount('/indicate.cgi', WEBrick::HTTPServlet::CGIHandler, 'indicate.rb')

server.mount('/goya.cgi', WEBrick::HTTPServlet::CGIHandler, 'goya.rb')

server.mount('/', WEBrick::HTTPServlet::ERBHandler, 'kadai.html.erb')

server.mount('/givefor.cgi', WEBrick::HTTPServlet::CGIHandler, 'give_for.rb')

server.mount('/quality.cgi', WEBrick::HTTPServlet::CGIHandler, 'quality.rb')


# Webrickのサーバを起動させる
server.start