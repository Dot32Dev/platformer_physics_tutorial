local player = {
  x=400-20,
  y=300,
  xV=0,
  yV=0,

  width=40,
  height=40,

  previous=function(self) 
    -- Return a table compatible with our AABB functions
    return {
      x=self.x - self.xV,
      y=self.y - self.yV,
      width=self.width,
      height=self.height,
    }
  end,
}

local platforms = {
  {
    -- Floor
    x=0,
    y=450,
    width=800,
    height=150,
  },
  {
    -- Different platform
    x=0,
    y=350,
    width=300,
    height=100,
  },
  {
    -- Different platform
    x=400,
    y=350,
    width=200,
    height=30,
  },
  {
    -- Different platform
    x=500,
    y=250,
    width=100,
    height=60,
  }
}

function love.draw()
  love.graphics.setColor(1,1,1)
  love.graphics.rectangle(
    "fill", 
    player.x,
    player.y, 
    player.width, 
    player.height
  )

  love.graphics.setColor(0.4,0.4,0.4)
  for i, platform in ipairs(platforms) do
    love.graphics.rectangle(
      "fill",
      platform.x,
      platform.y,
      platform.width,
      platform.height
    )
  end
end

function love.update()
  if love.keyboard.isDown("right") then
    player.xV = player.xV + 0.5
  end
  if love.keyboard.isDown("left") then
    player.xV = player.xV - 0.5
  end
  player.xV = player.xV * 0.9

  -- Update the players position
  player.x = player.x + player.xV
  player.y = player.y + player.yV

  player.yV = player.yV + 0.2

  for i, platform in ipairs(platforms) do
    if aabb_x_check(player, platform) and aabb_y_check(player, platform) then
      -- player.y = platform.y - player.height
      -- player.yV = 0

      -- if love.keyboard.isDown("up") then
      --  player.yV = -7
      -- end
      if aabb_x_check(player:previous(), platform) then
        -- Resolve on the Y axis
        if player.yV > 0 then
          -- Player was falling downwards. Resolve upwards.
          player.y = platform.y - player.height
          player.yV = 0
          -- The Player is on the ground and can jump
          if love.keyboard.isDown("up") then
            player.yV = -7
          end
        else 
          -- Player was moving upwards. Resolve downwards
          player.y = platform.y + platform.height
          player.yV = 0
        end
      elseif aabb_y_check(player:previous(), platform) then
        -- Resolve on the X axis
        if player.xV > 0 then
          -- Player was traveling right. Resolve to the left
          player.x = platform.x - player.width
          player.xV = 0
        else
          -- Player was traveling left. Resolve to the right
          player.x = platform.x + platform.width
          player.xV = 0
        end
      end
    end
  end
end

function aabb_x_check(player, platform)
  return player.x + player.width > platform.x 
    and player.x < platform.x + platform.width
end

function aabb_y_check(player, platform)
  return player.y + player.height > platform.y 
    and player.y < platform.y + platform.height
end
