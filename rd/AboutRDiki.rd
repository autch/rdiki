
= RDiki

RDoc で書く Wiki もどき。Wiki じゃないので RdWiki! にはしない。

== もどきなところ

* ブラウザから更新できない
  * ブラウザからは見るだけ。
* 都度 rd.rb を走らせないといけない
  * めんどくさ
* 履歴を残さない
* ロックとか何にもしない
* HTML が汚い
* テンプレとかスタイルとか何にもなし
* ついさっきまで循環参照したら無限ループしてた
* 遅い
  * だからバッチ処理

== 設計？

* 表紙は FrontPage.
* WikiName! は勝手に追いかけてコンパイルしてリンクする。

== 記法

ほぼ RDoc の SimpleMarkup! そのまま。

*boldface* _emphasize_ +code+

<b>ボールド</b> <em>強調</em> <tt>コード</tt>

WikiName は勝手にリンクされる。WikiName.rd がないとコンパイル時に文句を言う。
[!wiki:NONWIKINAME] とすれば無理やりリンクしようとする。
bracket によるリンクにはキャプションをつけられる。[wiki:FrontPage 表紙]

勝手にコンパイル＆リンクされたくなければ WikiName!! と書く。

http://www.autch.net/ぬるぽ mailto:autch@autch.net ftp://ftp.riken.jp/

リンクの張り方：[http://www.autch.net], [!http://www.autch.net/ Autch.net]

[!wiki:FrontPage] 行頭の bracket link と definition list がかぶるんだけ
どどうしよう？

[a word]  definition
[wiki:foo] definition of foo
[!wiki:foo] To forcibly link to some non-wikiword page, write one like this
[[wiki:foo]] foo
