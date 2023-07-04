local image = require('image')
local gui = require('gui')
local fs = require('filesystem')
local imageAtlas = {}
function imageAtlas.init(path, configPath)
  local tmpx, tmpy
  if type(path) == 'number' then
    tmpx = path
  end
  if type(configPath) == 'number' then
    tmpy = configPath
  end
  local result = {config={}}
  if type(configPath) == 'string' then
    result.config = fs.readTable(configPath)
  end
  result.atlas = {}
  if type(path) == 'string' then
    result.atlas.image = image.load(path)
  else
    result.atlas.image = image.create(tmpx or 160, tmpy or 50)
  end
  tmpx, tmpy = nil, nil
  result.config.w=image.getWidth(result.atlas.image)
  result.config.h=image.getHeight(result.atlas.image)
  result.getImage = function(atlasFull, setImage)
    local atlas = atlasFull.atlas
    local config = atlasFull.config
    if not config[setImage] then return false end
    local resultImage = image.create(config[setImage].w, config[setImage].h)
    local imageConfig = config[setImage]
    for x = 1, imageConfig.w do
      for y = 1, imageConfig.h do
        image.set(resultImage, x, y, image.get(atlas.image, x+imageConfig.x, y+imageConfig.y))
      end
    end
    return resultImage
  end
  result.setImage = function(atlasFull, x, y, setImage, name)
    local atlas = atlasFull.atlas
    local config = atlasFull.config
    if type(setImage) == 'string' then
      setImage = image.load(setImage)
    end
    local w, h = image.getWidth(setImage), image.getHeight(setImage)
    config[name] = {x=x, y=y, w=w, h=h}
    for xx = 1, w do
      for yy = 1, h do
        image.set(atlas.image, x+xx, y+yy, image.get(setImage, xx, yy))
      end
    end
  end
  result.increase = function(fullAtlas, w, h)
    local atlas = fullAtlas.atlas
    local config = fullAtlas.config
    local newImage = image.create(w, h)
    for x = 1, image.getWidth(atlas.image) do
      for y = 1, image.getHeight(atlas.image) do
        image.set(newImage, x, y, image.get(atlas.image, x, y))
      end
    end
    config.w, config.h = w, h
    atlas.image = newImage
    return true
  end
  result.load = function(fullAtlas, pathOfAtlas)
    fullAtlas.atlas.image = image.load(pathOfAtlas)
    fullAtlas.config = fs.readTable(string.gsub(string.gsub(pathOfAtlas,'Atlas.pic','Config.cfg'),'atlas.pic','config.cfg'))
  end
  function result.save(fullAtlas, path)
    image.save(path..'/Atlas.pic', fullAtlas.atlas.image)
    fs.writeTable(path..'/Config.cfg', fullAtlas.config)
  end
  return result
end
return imageAtlas
