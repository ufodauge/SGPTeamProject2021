return {
    {
        -- ステージのインデックス
        level = 0, -- プレイヤー
        player = {
            x = 440, -- x座標（左上の頂点）
            y = 520 -- y座標（左上の頂点）
        }, -- 地形
        grounds = {
            -- 一つ目の地形
            {
                x = 0, -- x座標（左上の頂点）
                y = 560, -- y座標（左上の頂点）
                w = 800, -- 横幅
                h = 40, -- 縦幅
                rot = 0 -- 回転
            }, -- 二つ目以降の地形も同様に記述
            {x = 720, y = 480, w = 80, h = 80},
            {x = 720, y = 320, w = 80, h = 100},
            {x = 720, y = 320, w = 80, h = 100, rot = math.pi / 3}
        }, -- 回収できるオブジェクト
        collectables = {
            {
                x = 0, -- x座標（左上の頂点）
                y = 580, -- y座標（左上の頂点）
                type = 'square' -- 形状
            }
        }, -- ゴール
        goal = {
            x = 0, -- x座標（左上の頂点）
            y = 580 -- y座標（左上の頂点）
        }
    }
}