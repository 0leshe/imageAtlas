local atlas = require('imageAtlas')
local gui = require('gui')
local atlas = atlas.init(49,5)
local wk = gui.workspace()
local path = '/MineOS/Icons/'
local BG = wk:addChild(gui.panel(1,1,160,50,0xBBBBBB))
atlas:setImage(1,1,path..'HDD.pic','HDD')
atlas:setImage(9,1,path..'Folder.pic','Folder')
atlas:setImage(17,1,path..'Floppy.pic','Floppy')
atlas:setImage(25,1,path..'Archive.pic','Archive')
atlas:setImage(33,1,path..'Trash.pic','Trash')
atlas:setImage(41,1,path..'Script.pic','Script')
local image = wk:addChild(gui.image(75,20,atlas:getImage('HDD')))
require('filesystem').makeDirectory('/ImageAtlasExample')
atlas:save('/ImageAtlasExample')
local function update()
  wk:draw()
end

wk.eventHandler = function(_,_,e1,_,_,key)
  if e1 == 'key_up' then
    if key == 2 then
      image.image = atlas:getImage('HDD')
      update()
    elseif key == 3 then
      image.image = atlas:getImage('Folder')
      update()
    elseif key == 4 then
      image.image = atlas:getImage('Floppy')
      update()
    elseif key == 5 then
      image.image = atlas:getImage('Archive')
      update()
    elseif key == 6 then
      image.image = atlas:getImage('Trash')
      update()
    elseif key == 7 then
      image.image = atlas:getImage('Script')
      update()
    elseif key == 31 then
      wk:stop()
    elseif key == 30 then
      image.localX = image.localX - 1
      update()
    elseif key == 32 then
      image.localX = image.localX + 1
      update()
    end
  end
end

wk:draw()
wk:start()
