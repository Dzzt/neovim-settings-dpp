--configuration for mr.vim

    local g = vim.g
    local fn = vim.fn

    -- 1. 変数の設定
    g["mr#delay"] = 60000

    -- 2. ファイルパスの設定
    -- NeovimのLua環境でVim scriptのexpand()関数を使います
    g["mr#mru#filename"] = fn.expand("~/.cache/mr/mru")
    g["mr#mrw#filename"] = fn.expand("~/.cache/mr/mrw")
    g["mr#mrr#filename"] = fn.expand("~/.cache/mr/mrr")

    -- 3. リポジトリの記録を無効化
    g.mr_mrr_disabled = 1

    -- 4. 述語(Predicates)の設定 (正規表現チェックをLua関数として定義)
    -- 注意: vim.fn.match()はマッチしない場合に -1 を返すため、それを活用します。
    g["mr#mru#predicates"] = {
      function(filename)
        -- *.txt ファイルを記録しない: filename !~? '\v.+\.txt'
        return fn.match(filename, [[\v.+\.txt]]) == -1
      end
    }

    g["mr#mrw#predicates"] = {
      function(filename)
        -- *.txt または *.sql ファイルを記録しない: filename !~? '\v.+\.(txt|sql)'
        return fn.match(filename, [[\v.+\.(txt|sql)]]) == -1
      end
    }
