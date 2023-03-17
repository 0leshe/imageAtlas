local image = require('image')
local gui = require('gui')
local fs = require('filesystem')
local imageAtlas = {}
function imageAtlas.init(path, configPath)
  if type(path) == 'number' then
    local tmpx = path
  end
  if type(configPath) == 'number' then
    local tmpy = configPath
  end
  local result = {}
  if configPath and type(configPath) == 'string' then
    result.config = fs.readTable(configPath)
  else
    result.config = {w=50, h=50}
  end
  result.atlas = {}
  if type(path) == 'string' then
    result.atlas.image = image.load(path)
  else
    result.atlas.image = image.create(tmpx or 160, tmpy or 50)
    tmpx, tmpy = nil, nil
  end
  result.getImage = function(atlasFull, setImage)
    local atlas = atlasFull.atlas
    local config = atlasFull.config
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
  function result.save(fullAtlas, path)
    image.save(path..'/atlas.pic', fullAtlas.atlas.image)
    fs.writeTable(path..'/config.cfg', fullAtlas.config)
  end
  return result
end
return imageAtlas
