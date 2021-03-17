return {
    {
        level = 1,
        player = {x = 200, y = 440},
        grounds = {
            {x = 0, y = 480, w = 800, h = 120},
            {x = 600, y = 400, w = 200, h = 80},
            {x = 600, y = 260, w = 200, h = 100},
            {x = 0, y = 260, w = 40, h = 220},
            {x = 681, y = 361, w = 120, h = 40}

        },
        respawns = {{x = 400, y = 600, w = 120, h = 10}},
        collectables = {
            {x = 300, y = 440, type = 'square'},
            {x = 340, y = 440, type = 'square'},
            {x = 380, y = 440, type = 'square'},
            {x = 360, y = 400, type = 'triangle', rot = math.pi / 4}
        },
        goal = {
            x = 175,
            y = 460,
            w = 40,
            h = 40 -- ブラックホール出現時のみ
        },
        switches = {{x = 650, y = 380, w = 40, h = 20}},
        doors = {{x = 180, y = 400, w = 60, h = 80}}
    },
    {
        level = 2,
        player = {x = 694, y = 202},
        grounds = {
            {x = 0, y = 0, w = 40, h = 600, rot = 0},
            {x = 0, y = 540, w = 320, h = 60, rot = 0},
            {x = 180, y = 250, w = 100, h = 80, rot = 0},
            {x = 341, y = 250, w = 430, h = 80, rot = 0},
            {x = 500, y = 230, w = 80, h = 20, rot = 0},
            {x = 140, y = 500, w = 100, h = 40, rot = 0},
            {x = 410, y = 540, w = 10, h = 60, rot = 0},
            {x = 480, y = 540, w = 10, h = 60, rot = 0},
            {x = 540, y = 540, w = 250, h = 60, rot = 0},
            {x = 760, y = 0, w = 40, h = 600, rot = 0}
        },
        collectables = {{x = 210, y = 210, type = 'square'}, {x = 210, y = 169, type = 'square'}, {x = 50, y = 499, type = 'circle'}},
        respawns = {{x = 320, y = 605, w = 90, h = 10}, {x = 420, y = 605, w = 60, h = 10}, {x = 490, y = 605, w = 50, h = 10}},
        goal = {x = 620, y = 490},
        switches = {{x = 650, y = 380, w = 40, h = 20}},
        doors = {{x = 180, y = 400, w = 60, h = 80}}
    },
    {
        level = 3,
        player = {x = 30, y = 189},
        grounds = {
            {x = 0, y = 0, w = 10, h = 600, rot = 0},
            {x = 10, y = 230, w = 100, h = 370, rot = 0},
            {x = 110, y = 500, w = 290, h = 100, rot = 0},
            {x = 180, y = 0, w = 220, h = 220, rot = 0},
            {x = 320, y = 220, w = 80, h = 75, rot = 0},
            {x = 160, y = 295, w = 240, h = 85, rot = 0},
            {x = 520, y = 500, w = 220, h = 100, rot = 0},
            {x = 740, y = 0, w = 60, h = 600, rot = 0}
        },
        respawns = {},
        collectables = {{x = 180, y = 254, type = 'square'}, {x = 221, y = 254, type = 'square'}, {x = 262, y = 254, type = 'square'}},
        goal = {x = 650, y = 450},
        switches = {{x = 650, y = 380, w = 40, h = 20}},
        doors = {{x = 180, y = 400, w = 60, h = 80}}
    },
    {
        level = 4,
        player = {x = 120, y = 509},
        grounds = {
            {x = 0, y = 0, w = 40, h = 600, rot = 0},
            {x = 0, y = 0, w = 800, h = 40, rot = 0},
            {x = 760, y = 0, w = 40, h = 600, rot = 0},
            {x = 0, y = 550, w = 800, h = 50, rot = 0},
            {x = 500, y = 469, w = 40, h = 80, rot = 0}
        },
        respawns = {},
        collectables = {{x = 300, y = 509, type = 'square'}, {x = 340, y = 509, type = 'square'}, {x = 380, y = 509, type = 'square'}},
        goal = {x = 650, y = 510},
        switches = {{x = 650, y = 380, w = 40, h = 20}},
        doors = {{x = 180, y = 400, w = 60, h = 80}}
    }
}
