-- Generations Interpreter

-- Use this function to perform your initial setup
function setup()
    print("Hello World!")
    lg = LifeGenerations({3,4,5},{2},4,100,20)
    parameter.action("Start", function() lg.started = true end)
    parameter.action("Stop",function() lg.started = false end)
    parameter.action("One Step", function() lg:oneStep() end)
    parameter.watch("1/DeltaTime")
    parameter.integer("num", 1,120,20,function() lg.num = num end)
    parameter.integer("randompercent", 0,100,50)
    parameter.action("Randomize", function() lg:randomize(randompercent) end)
    parameter.number("noiseThreshold", -1,1,0)
    parameter.action("Apply Noise", function() lg:noise(noiseThreshold) end)
end

-- This function gets called once every frame
function draw()
    -- This sets a dark background color 
    background(40, 40, 50)

    -- This sets the line thickness
    strokeWidth(5)

    -- Do your drawing here
    lg:draw()
end

function touched(touch)
    lg:touched(touch)
end

function blankTable(dim)
    local tab = {}
    for i = 1, dim do
        tab[i] = {}
        for v = 1, dim do
            tab[i][v] = 0
        end
    end
    return tab
end

function copy(tab)
    local newTab = {}
    for i,v in pairs(tab) do
        newTab[i] = {}
        for x,y in pairs(v) do
            newTab[i][x] = y
        end
    end
    return newTab
end

function inside(val,tab)
    for i,v in pairs(tab) do
        if v==val then
            return true
        end
    end
    return false
end
