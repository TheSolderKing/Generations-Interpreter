LifeGenerations = class()

function LifeGenerations:init(s,b,c,dim,num,cols)
    -- you can accept and set parameters here
    self.survive = s
    if cols then self.cols = cols end
    self.born = b
    self.states = c
    self.cur = blankTable(dim)
    self.new = blankTable(dim)
    self.dim = dim
    self.started = false
    self.mesh = mesh()
    for x=1,dim do
        for y=1,dim do
            local i = self.mesh:addRect((x-1)*WIDTH/dim + WIDTH/(dim * 2),(y-1)*HEIGHT/dim + HEIGHT/(dim * 2),WIDTH/dim,HEIGHT/dim)
            self.mesh:setRectColor(i,0,0,0)
        end
    end
    self.frame = 1
    self.num = num
    print(num)
end

function LifeGenerations:oneStep()
    for x=1,self.dim do
        for y=1,self.dim do
            self:process(x,y)
            self:updateMesh(x,y)
        end
    end
    self.cur = copy(self.new)
end

function LifeGenerations:draw()
    self.mesh:draw()
    if self.started and self.frame % self.num == 0 then
        self:oneStep()
        self.frame = self.frame + 1
    elseif self.started then
        self.frame = self.frame + 1
    end
end

function LifeGenerations:process(x,y)
    neighbors = self:getAdjCount(x,y)
    if self.cur[x][y] == 0 then
        if inside(neighbors,self.born) then
            self.new[x][y] = 1
        end
    else
        if (self.cur[x][y] == 1 and not inside(neighbors,self.survive)) or self.cur[x][y] ~=1 then
            local n = self.cur[x][y] + 1
            self.new[x][y] = n%self.states
        end
        
    end
end

function LifeGenerations:updateMesh(x,y)
    if self.new[x][y] ~= self.cur[x][y] then
        if self.cols then
            self.mesh:setRectColor(self:getMeshIndex(x,y),self.cols[self.new[x][y] + 1])
        else
            if self.new[x][y] == 0 then
                self.mesh:setRectColor(self:getMeshIndex(x,y),0,0,0)
            else
                self.mesh:setRectColor(self:getMeshIndex(x,y),255,255/(self.states-2) * (self.new[x][y]-1),0)
            end
        end
    end
end

function LifeGenerations:getAdjCount(x,y)
    local total = 0
    for dx=-1,1 do
        for dy=-1,1 do
            if x+dx > 0 and x+dx <= self.dim and y+dy > 0 and y+dy <= self.dim then
                if self.cur[x+dx][y+dy] == 1 then
                    total = total + 1
                end
            else
                local nx,ny = x+dx,y+dy
                if x+dx<1 then
                    nx=self.dim
                elseif x+dx>self.dim then
                    nx=1
                end
                if y+dy<1 then
                    ny=self.dim
                elseif y+dy>self.dim then
                    ny=1
                end
                if self.cur[nx][ny] == 1 then
                    total = total + 1
                end
            end
        end
    end
    if self.cur[x][y] == 1 then
        total = total - 1
    end
    return total
end

function LifeGenerations:touched(t)
    local x,y = math.floor(t.x / (WIDTH/self.dim))+1,math.floor(t.y / (HEIGHT/self.dim))+1
    if not self.started and t.state == BEGAN then
        self.new[x][y] = 1 - self.new[x][y]
        if self.cols then
            self.mesh:setRectColor(self:getMeshIndex(x,y), self.cols[self.new[x][y]+1])
        else
            if self.new[x][y] == 0 then
                self.mesh:setRectColor(self:getMeshIndex(x,y),0,0,0)
            else
                self.mesh:setRectColor(self:getMeshIndex(x,y),255,0,0)
            end
        end
    end
end

function LifeGenerations:getMeshIndex(x,y)
    return (x-1)*self.dim+y
end

function LifeGenerations:randomize(percent)
    for x = 1, self.dim do
        for y=1, self.dim do
            if math.random(0,100) < percent then
                self.new[x][y] = 1
                if self.cols then
                    self.mesh:setRectColor(self:getMeshIndex(x,y),self.cols[2])
                else
                    self.mesh:setRectColor(self:getMeshIndex(x,y),255,0,0)
                end
            end
        end
    end
end

function LifeGenerations:noise(thresh)
    local seed = math.random(1000)/1000
    for x = 1, self.dim do
        for y=1, self.dim do
            if noise(x/5,y/5,seed) > thresh then
                self.new[x][y] = 1
                if self.cols then
                    self.mesh:setRectColor(self:getMeshIndex(x,y),self.cols[2])
                else
                    self.mesh:setRectColor(self:getMeshIndex(x,y),255,0,0)
                end
            end
        end
    end
end
