-- sounds!
    -- water spray

-- make a few songs

function love.load()
    -- Setup the randomizer
    math.randomseed(os.time())
    -- need to pop a few... wierd thing
    math.random()
    math.random()
    math.random()

    -- hide mouse cursor!
    love.mouse.setVisible(false)

    -- graphics stuff
    love.graphics.setDefaultFilter("nearest", "nearest")

    -- camera
    camera = {scale=2, w=512, h=384, pos=0}

    -- game title graphic
    title = love.graphics.newImage("assets/title.png")
    titlepos = {x=0, y=0}

    -- movement speed (pixels / second)
    movespeed = 100

    -- health and water levels
    health = 100
    water = 100

    -- damage/water loss per second
    healthpersecond = 10
    waterpersecond = 10

    -- background colour
    background = {164,164,255,255}

    -- ROAD STUFF
    road = love.graphics.newImage("assets/road.png")
    -- number of roads to draw
    roadcount = camera.w / road:getWidth() + 2
    -- road position counter
    roadpos = 0

    -- BACKGROUND STUFF
    backgrounds = {
        love.graphics.newImage("assets/buildings.png"),
        love.graphics.newImage("assets/forest.png"),
        love.graphics.newImage("assets/hills.png")
    }
    -- number of backgrounds to draw (all backgrounds are the same width - so using buildings)
    backgroundcount = camera.w / backgrounds[1]:getWidth() + 2
    -- list of backgrounds to draw
    local b = math.random(#backgrounds)
    bgi = {}
    for i=1, backgroundcount, 1 do
        bgi[i] = b
    end
    -- building position counter
    backgroundpos = 0
    -- background counter
    backgroundcounter = 0
    backgroundcounterrange = {4,8}
    backgroundcountermax = math.random(backgroundcounterrange[1], backgroundcounterrange[2])

    -- CLOUD STUFF
    clouds = {
        love.graphics.newImage("assets/clouds1.png"),
        love.graphics.newImage("assets/clouds2.png"),
        love.graphics.newImage("assets/clouds3.png")
    }
    -- list of clouds (x, y, img index)
    cloudlist = {}
    -- cloud generation chance
    cloudchance = 25
    -- cloud generation timer
    cloudtimer = 0
    cloudtimermax = 1
    -- cloud speed
    cloudspeed = 25

    -- FIRETRUCK STUFF
    firetruckfront = love.graphics.newImage("assets/firetruckfront.png")
    firetruckback = love.graphics.newImage("assets/firetruckback.png")
    -- firetruck positions
    firetruckpos = {frontx=0, backx=0, centrex=camera.pos + camera.w/2, y=camera.h - road:getHeight() - firetruckfront:getHeight() - 24, ysin=0}
    -- if firetruck is jumping or not
    firetruckjump = false
    -- the direction of the player movement
    playermoved = 0
    -- the draw directino of the player
    drawdir = 1

    -- WHEEL STUFF
    wheel = love.graphics.newImage("assets/wheel.png")
    -- positions/angle of the wheels
    wheelpos = {backx=0, frontx=0, y=0, angle=0}
    -- speed the wheels turn
    wheelspeed = math.pi

    -- FIRE STUFF
    fire = love.graphics.newImage("assets/fire.png")
    fireeye = love.graphics.newImage("assets/eye.png")
    firewing = love.graphics.newImage("assets/wing.png")
    firefoot = love.graphics.newImage("assets/foot.png")
    -- list of fires - array of active flags, x,y positions
    fires = {}
    -- change that a fire should be active (0-100%)
    firechance = 25
    -- fire creation timer
    firetimer = 0
    firetimermax = 1
    -- counter for firesextinguished
    firesextinguished = 0
    -- speed that the fires travel
    firespeed = 50

    -- ARM STUFF
    arm = love.graphics.newImage("assets/arm.png")
    -- arm angle position
    armpos = {x=0, y=0, angle=0}
    -- angle movement speed
    armspeed = math.pi/2
    -- movement direction
    armdir = -1

    -- LEG STUFF
    leg = love.graphics.newImage("assets/leg.png")
    -- leg position
    legpos = {x=0, y=0, angle=0}
    -- movement speed
    legspeed = math.pi/2
    --movement direction
    legdir = -1

    -- HEAD STUFF
    head = love.graphics.newImage("assets/head.png")
    -- position of the head
    headpos = {x=0, y=0, angle=0}

    -- LIGHT STUFF
    light = love.graphics.newImage("assets/light.png")
    -- position
    lightpos = {backx=0, frontx=0, y=0}
    -- colour info
    colours = {
        {255,0,0,255},
        {0,0,255,255}
    }
    -- colour timer
    colourtimer = 0
    colourtimermax = 0.5
    -- tracks what colour each light is using (front/back)
    lightcolours = {1,2}
    -- siren flag
    siren = false

    -- FIRETRUCK MODE
    firetruckmode = false
    -- speed
    firetruckspeed = 200
    -- jump speed/velocity
    jumpvelocity = 0

    -- TRANSFORM STUFF
    -- transform flag
    transform = false
    -- how long in seconds the transform takes
    transformtimer = 0
    transformtimermax = 1
    -- angle change for head
    headchange = math.pi/2
    -- angle change for leg
    legchange = math.pi/2
    -- angle change for arm
    armchange = math.pi/2
    -- vertical shift for the truck
    verticalshift = 18
    -- shift for back of truck
    backshift = 16
    -- shift for front of truck
    frontshift = 8
    -- light shift
    lightshift = 8
    -- the lerp value
    transformlerp = 0
    -- transform direction
    transformdir = 1

    -- HITBOX STUFF
    hitbox = {x1=0, y1=0, x2=0, y2=0}
    firehit = false

    -- WATER STUFF
    -- water images (canon, line, end)
    watercanon = love.graphics.newImage("assets/canon.png")
    waterend = love.graphics.newImage("assets/waterend.png")
    waterline = love.graphics.newImage("assets/waterline.png")
    -- position of the water canon
    watercanonpos = {x=0, y=0, angle=0}
    -- world position of the water line
    waterlinepos = {x1=0, y1=0, x2=0, y2=0, length=0}
    -- flag if the water is on or not
    wateron = false

    -- PLANE STUFF
    plane = love.graphics.newImage("assets/plane.png")
    -- plane position
    planepos = {x=0, y=0, dropx=0}
    planespeed = 250
    -- plane timer, chance (chance will be based on how much water you have left)
    planetimer = 0
    planetimermax = 10
    planechance = 0
    -- active flag
    planeactive = false
    waterdropped = false

    -- WATER BARREL/PARACHUTE STUFF
    healthbarrel = love.graphics.newImage("assets/healthbarrel.png")
    waterbarrel = love.graphics.newImage("assets/waterbarrel.png")
    parachute = love.graphics.newImage("assets/parachute.png")

    -- position
    barrelpos = {x=0, y=0, angle=0}
    -- speed
    barrelspeed = 25
    swingspeed = 0.15
    swingdir = 1
    -- type of barrel -> water or health
    type = ""       
    -- active flag
    barrelactive = false
    parachuteactive = false

    -- PARTICLE EFFECTS
    pickupeffectimage = love.graphics.newImage("assets/pickupeffect.png")
    pickupeffect = love.graphics.newParticleSystem(pickupeffectimage, 16)
    pickupeffect:setSpread(math.pi*2)
    pickupeffect:setParticleLifetime(0.25, 0.5)
    pickupeffect:setSpeed(32,64)
    pickupeffect:setSpin(math.pi/2,math.pi*2)
    pickupeffect:setColors(255,128,128,255,128,255,128,255,128,128,255,255)

    fireeffect = love.graphics.newParticleSystem(pickupeffectimage, 16)
    fireeffect:setSpread(math.pi*2)
    fireeffect:setParticleLifetime(0.25, 0.5)
    fireeffect:setSpeed(32,64)
    fireeffect:setSpin(math.pi/2,math.pi*2)
    fireeffect:setColors(255,128,128,255,32,32,32,0)

    -- AUTO SHOOTING STUFF
    autoshooting = false
    shoottimer = 0
    shoottimermax = 2
    shotontimer = 0
    shotontimermax = 0.5
    closestindex = 1            

    -- UI STUFF
    crossout = love.graphics.newImage("assets/crossout.png")
    watericon = love.graphics.newImage("assets/waterdrop.png")
    healthicon = love.graphics.newImage("assets/health.png")
    wateroutline = love.graphics.newImage("assets/waterdropoutline.png")
    healthoutline = love.graphics.newImage("assets/healthoutline.png")
    reticle = love.graphics.newImage("assets/reticle.png")

    local t = {
        {255,255,255,255},
        [[
        Move: Arrow Keys
        Jump: Space
        Transform: Enter
        Siren: S
        Shoot: Left Mouse
        Aim: Move the Mouse
        Auto Shoot Toggle: TAB
        Window Size: W
        ]]
    }
    instructions = love.graphics.newText(love.graphics.newFont(12),nil)
    instructions:setf(t, 192, "center")

    -- set the font for gameplay
    love.graphics.setFont(love.graphics.newFont(28))

    -- SOUND STUFF!
    ouch = love.audio.newSource("assets/ouch1.wav")
    engine = love.audio.newSource("assets/engine.wav")
    engine:setLooping(true)
    engine:setVolume(0.25)
    jump = love.audio.newSource("assets/jump.wav")
    jump:setPitch(1.5)
    change = love.audio.newSource("assets/change.wav")
    letsrock = love.audio.newSource("assets/letsrock.wav")
    step = love.audio.newSource("assets/step2.wav")
    step:setPitch(0.75)
    pickup = love.audio.newSource("assets/pickup.wav")
    pickup:setVolume(2)
    sirensound = love.audio.newSource("assets/siren.wav")
    sirensound:setLooping(true)
    sirensound:setVolume(0.1)
    barrelland = love.audio.newSource("assets/barrelland.wav")
    poof = love.audio.newSource("assets/poof.wav")
    poof:setVolume(2)
    planesound = love.audio.newSource("assets/plane2.wav")
    planesound:setLooping(true)
end

function love.keypressed(key)
    if key == "return" and not(transform) then
        -- set the direction of the transform
        if firetruckmode then
            transformdir = -1
            letsrock:play()
            if siren then
                sirensound:stop()
            end
        else
            transformdir = 1
            change:play()
        end
        -- flip the hulk/firetruck state
        firetruckmode = not(firetruckmode)
        -- flag that we are in transform mode
        transform = true

        if not(firetruckmode) then
            engine:stop()
        end
    end

    -- window big/small toggle
    if key == "w" then
        local w, h = love.graphics.getDimensions()
        if w == 1024 then
            love.window.setMode(512, 384, {})
            camera.scale = 1
        else
            love.window.setMode(1024, 768, {})
            camera.scale = 2
        end

    end

    -- flips the siren flag
    if key == "s" then
        siren = not(siren)
        colourtimer = 0
        if siren then
            sirensound:play()
        else
            sirensound:stop()
        end
    end

    -- turns on autoshooting
    if key == "tab" then
        autoshooting = not(autoshooting)
        shoottimer = 0
        shoton = false
        shotontimer = 0
    end
end

function love.update(dt)
    -- update the particle effects
    pickupeffect:update(dt)
    fireeffect:update(dt)

    -- increment cloud and generate a new one
    cloudtimer = cloudtimer + dt
    if cloudtimer >= cloudtimermax then
        cloudtimer = cloudtimer - cloudtimermax
        if math.random(100) <= cloudchance then
            local c = {}
            c.index = math.random(3)
            c.x = camera.pos + camera.w + clouds[c.index]:getWidth()
            c.y = math.random(32,128)
            c.hflip = math.random(0,1)
            c.vflip = math.random(0,1)
            if c.hflip == 0 then c.hflip = -1 end
            if c.vflip == 0 then c.vflip = -1 end
            c.speed = math.random(0,15)
            table.insert(cloudlist, c)
        end
    end
    -- update the clouds
    local toremove = {}
    for i, v in ipairs(cloudlist) do
        -- push left
        v.x = v.x - (cloudspeed + v.speed) * dt
        -- see if it is off the screen & should be removed
        if v.x + clouds[v.index]:getWidth() < camera.pos then
            table.insert(toremove, i)
        end
    end
    -- remove any flagged
    for i=#toremove, 1, -1 do
        table.remove(cloudlist, toremove[i])
    end

    -- init
    local moved = false
    local speed = movespeed
    local firetruckoffset = 24
    local lightshiftoffset = 8

    if not(firetruckjump) then
        playermoved = 0
    end

    if not(transform) then
        if firetruckmode then
            firetruckoffset = 6
            if not(engine:isPlaying()) then
                engine:play()
            end
        end
    end

    local backshiftoffset = 16
    local frontshiftoffset = 8

    if firetruckmode then
        -- reset these
        lightshiftoffset = 0
        backshiftoffset = 0
        frontshiftoffset = 0
    end

    if transform then
        -- decrease the timer
        transformtimer = transformtimer + dt
        -- get the normalized lerp value
        transformlerp = transformtimer / transformtimermax
        -- transform from hulk to firetruck
        if transformdir == 1 then
            -- set head
            headpos.angle = transformlerp * headchange
            -- set leg
            legpos.angle = transformlerp * legchange
            -- set arm
            armpos.angle = transformlerp * armchange
            -- set firetruck vertical position
            firetruckoffset = firetruckoffset - transformlerp * verticalshift
            -- set back shift offset
            backshiftoffset = backshift - (transformlerp * backshift)
            -- set front shift offset
            frontshiftoffset = frontshift - (transformlerp * frontshift)
            -- light shift
            lightshiftoffset = lightshift - (transformlerp * lightshift)
        else
            -- transform from firetruck to hulk
            -- set head
            headpos.angle = headchange - (transformlerp * headchange)
            -- set leg
            legpos.angle = legchange - (transformlerp * legchange)
            -- set arm
            armpos.angle = armchange - (transformlerp * armchange)
            -- set firetruck vertical position
            firetruckoffset = firetruckoffset - verticalshift + (transformlerp * verticalshift)
            -- set back shift offset
            backshiftoffset = transformlerp * backshift
            -- set front shift offset
            frontshiftoffset = transformlerp * frontshift
            -- light shift
            lightshiftoffset = transformlerp * lightshift

        end

        -- reset if necessary
        if transformtimer >= transformtimermax then
            transformtimer = 0
            transformlerp = 0
            transform = false
            if firetruckmode then
                engine:play()            
                if siren then
                    sirensound:play()
                end
            end
        end

    else
        -- get input (if not jumping)
        if not(firetruckjump) then
            if love.keyboard.isDown("right") then
                playermoved = 1
                -- drawdir = 1
            elseif love.keyboard.isDown("left") then 
                playermoved = -1
                -- drawdir = -1
            end
        end

        if not(firetruckmode) and love.keyboard.isDown("space") then
            if not(firetruckjump) then
                jump:play()
                firetruckjump = true
                jumpvelocity = -0.5
            end
        end
    end

    -- update firetruck position
    if not(playermoved==0) then
        -- arrow keys were pressed...
        if firetruckmode then
            speed = firetruckspeed
            engine:setPitch(1)
        end

        if health == 0 then
            speed = 25
        end

        firetruckpos.centrex = firetruckpos.centrex + speed * dt * playermoved

        if firetruckpos.centrex <= camera.pos + 32 then
            firetruckpos.centrex = camera.pos + 32
        elseif firetruckpos.centrex >= camera.pos + camera.w/2 then
            -- firetruckpos.centrex = camera.pos + camera.w/2
            moved = true
        end

        -- rotate firetruck wheels
        wheelpos.angle = wheelpos.angle + wheelspeed * dt * playermoved

        if not(firetruckmode) then
            -- rotate the arm
            armpos.angle = armpos.angle + armspeed * dt * armdir
            if armpos.angle > math.pi/4 then
                armdir = -1
            elseif armpos.angle < -math.pi/4 then
                armdir = 1
            end

            -- rotate the leg
            legpos.angle = legpos.angle + legspeed * dt * legdir
            if legpos.angle > math.pi/4 then
                if not(step:isPlaying()) and not(firetruckjump) then
                    step:play()
                end
                legdir = -1
            elseif legpos.angle < -math.pi/4 then
                if not(step:isPlaying()) and not(firetruckjump) then
                    step:play()
                end
                legdir = 1
            end
        end
    else
        -- if the player hasn't moved - rotate arm/leg back to natural position
        if not(firetruckmode) then
            -- rotate the arm back to 0 if they aren't moving...
            if not(armpos.angle == 0) then
                armpos.angle = armpos.angle + armspeed * dt * armdir
                if armpos.angle > math.pi/4 then
                    armdir = -1
                elseif armpos.angle < -math.pi/4 then
                    armdir = 1
                end            
                if math.abs(armpos.angle) < 0.05 then
                    armpos.angle = 0
                end
            end
            -- rotate the leg back to 0 if they aren't moving...
            if not(legpos.angle == 0) then
                legpos.angle = legpos.angle + legspeed * dt * legdir
                if legpos.angle > math.pi/4 then
                    if not(step:isPlaying()) and not(firetruckjump) then
                        step:play()
                    end
                    legdir = -1
                elseif legpos.angle < -math.pi/4 then
                    if not(step:isPlaying()) and not(firetruckjump) then
                        step:play()
                    end
                    legdir = 1
                end            
                if math.abs(legpos.angle) < 0.05 then
                    legpos.angle = 0
                end
            end        
        else
            engine:setPitch(0.5)
        end
    end

    -- update the other positions regardless...
    firetruckpos.backx = firetruckpos.centrex - firetruckback:getWidth() + backshiftoffset
    firetruckpos.frontx = firetruckpos.centrex - frontshiftoffset

    -- move non player stuff - matches player
    if moved then
        -- move camera
        if firetruckpos.centrex >= camera.pos + camera.w/2 then
            camera.pos = camera.pos + speed * dt
            -- move road
            roadpos = roadpos - speed * dt
            -- reset roadpos tracker if necessary
            -- if roadpos <= -road:getWidth() or roadpos >= road:getWidth() then
            if roadpos <= -road:getWidth() then
                roadpos = 0
            end

            -- move buildings
            backgroundpos = backgroundpos - speed * dt
            -- reset boudingpos tracker if necessary (using building width as all backgrounds are the same width)
            if backgroundpos <= -backgrounds[1]:getWidth() then
                -- if backgroundpos <= -backgrounds[1]:getWidth() or backgroundpos >= backgrounds[1]:getWidth() then
                backgroundpos = 0

                -- move the bg indexes...
                local b = bgi[#bgi]
                -- check if we need to... first and last don't match...
                if not(bgi[#bgi] == bgi[1]) then
                    -- loop backwards, finding first that doesn't match last one
                    for i=#bgi-1, 1, -1 do
                        if not(bgi[i] == b) then
                            -- update and end for
                            bgi[i] = b
                            break
                        end
                    end
                end
                -- increment the number of backgrounds passed
                backgroundcounter = backgroundcounter + 1
                -- should we switch backgrounds?
                if backgroundcounter >= backgroundcountermax then
                    -- reset counter/max
                    backgroundcounter = 0
                    backgroundcountermax = math.random(backgroundcounterrange[1],backgroundcounterrange[2])

                    -- pick a random background and assign to end
                    bgi[#bgi] = math.random(#backgrounds)
                end
            end
        end
    end

    -- changes the colours of the lights
    if siren then
        -- increment
        colourtimer = colourtimer + dt
        -- check for switch
        if colourtimer >= colourtimermax then
            -- reset
            colourtimer = colourtimer - colourtimermax
            -- flip colours
            for i=1, 2, 1 do
                if lightcolours[i] == 1 then
                    lightcolours[i] = 2
                else
                    lightcolours[i] = 1
                end
            end
        end
    end
    
    -- increment fire creation timer
    firetimer = firetimer + dt
    if firetimer >= firetimermax then
        firetimer = firetimer - firetimermax
        -- determine if a fire should be activated or not
        if math.random(1,100) <= firechance then
            local f = {}
            -- 1=ground, 2=flying
            f.type = math.random(1,2)
            f.x = camera.pos + camera.w + fire:getWidth()
            if f.type == 1 then -- ground
                f.y = camera.h - road:getHeight() - fire:getHeight() - firefoot:getHeight()
            else -- flying
                f.y = math.random(32, camera.h - road:getHeight() - fire:getHeight()*2)
            end
            f.timer = 0
            f.timermax = 0.5
            f.animvalue = 1
            table.insert(fires, f)
        end
    end

    toremove = {}
    -- move/update the fires (right -> left)
    for i, v in ipairs(fires) do
        -- move it left
        v.x = v.x - firespeed * dt
        -- do other stuff here... like flying, animations...
        v.timer = v.timer + dt
        if v.timer >= v.timermax then
            -- flip the value
            v.animvalue = v.animvalue * -1
            -- reset timer
            v.timer = v.timer - v.timermax
        end

        -- look for any to remove but not if you have autoshooting on and is currently shooting... could cause an indexing issue
        if not(autoshooting) and not(wateron) then
            -- remove any that are too far left
            if v.x - camera.pos < -camera.w then
                table.insert(toremove, i)
            end
        end
    end

    for i=#toremove, 1, -1 do
        table.remove(fires, toremove[i])
    end


    -- jump! - this doesn't work properly... 
    if firetruckjump then
        -- adjust the y pos
        firetruckpos.y = firetruckpos.y + 700*dt*jumpvelocity        
        -- update the velocity
        jumpvelocity = jumpvelocity + dt
        -- reset if necessary
        if jumpvelocity >= 0.5  then
            firetruckjump = false
        end
    else
        -- if not jumping - just have a hard coded y position
        firetruckpos.y = camera.h - road:getHeight() - firetruckfront:getHeight() - firetruckoffset
    end

    -- give the player some bounce when walking
    if not(firetruckmode) and not(firetruckjump) then
        firetruckpos.y = firetruckpos.y + math.abs(math.sin(legpos.angle)*4)
    end

    -- update light position
    lightpos.backx = firetruckpos.backx + 4
    lightpos.frontx = firetruckpos.frontx + firetruckfront:getWidth() - light:getWidth() - 4
    lightpos.y = firetruckpos.y + - light:getHeight() + lightshiftoffset

    -- update water canon position
    if firetruckmode then
        watercanonpos.x = firetruckpos.centrex - 4
        watercanonpos.y = firetruckpos.y - watercanon:getHeight()/2
    else
        watercanonpos.x = firetruckpos.frontx + firetruckfront:getWidth() - 4
        watercanonpos.y = firetruckpos.y + firetruckfront:getHeight()/2 - watercanon:getHeight()/2        
    end
      
    -- update wheel positions (front, back)
    wheelpos.y = firetruckpos.y + firetruckfront:getHeight() - wheel:getHeight()/2 + 6
    wheelpos.backx = firetruckpos.backx + 8 + wheel:getWidth()/2
    wheelpos.frontx = firetruckpos.frontx + firetruckfront:getWidth() - 8 - wheel:getWidth()/2

    -- update arm positions
    armpos.x = firetruckpos.centrex
    armpos.y = firetruckpos.y + 4

    -- update leg position
    legpos.x = firetruckpos.centrex
    legpos.y = firetruckpos.y + 24    

    -- setup hitbox based on world coords
    hitbox.x1=firetruckpos.backx + 4
    hitbox.y1=firetruckpos.y + 4
    hitbox.x2=firetruckpos.frontx + firetruckfront:getWidth() - 4
    hitbox.y2=firetruckpos.y + firetruckfront:getHeight() - 4
    if not(firetruckmode) then
        hitbox.y1 = hitbox.y1 - head:getHeight()
        hitbox.y2 = hitbox.y2 + 24
    end

    -- test for fire/player collision
    firehit = false
    for i, v in ipairs(fires) do
        local fr = {x1=v.x + 8, y1=v.y + 8, x2=v.x + fire:getWidth() - 8, y2=v.y + fire:getHeight() - 8}
        -- test bounds (first x bounds, then y bounds)
        if (fr.x1 >= hitbox.x1 and fr.x1 <= hitbox.x2) or (fr.x2 >= hitbox.x1 and fr.x2 <= hitbox.x2) then
            if (fr.y1 >= hitbox.y1 and fr.y1 <= hitbox.y2) or (fr.y2 >= hitbox.y1 and fr.y2 <= hitbox.y2) then
                -- hit!
                firehit = true
                health = health - healthpersecond * dt
                if health <= 0 then 
                    health = 0
                end
                -- say ouch!
                if not(ouch:isPlaying()) then
                    ouch:play()
                end
            end
        end
    end

    if not(autoshooting) then
        -- update water canon angle
        local mx, my = love.mouse.getPosition()
        -- scale it to the world size
        mx = mx / camera.scale
        my = my / camera.scale
        -- translate to world position
        mx = mx + camera.pos
        -- get angle
        watercanonpos.angle = math.atan2(my - watercanonpos.y, mx - watercanonpos.x)
        -- calculate world position of the water line
        waterlinepos.x1 = watercanonpos.x + (watercanon:getWidth()-4) * math.cos(watercanonpos.angle)
        waterlinepos.y1 = watercanonpos.y + (watercanon:getHeight()+4) * math.sin(watercanonpos.angle)
        waterlinepos.x2 = mx
        waterlinepos.y2 = my
        local xl = waterlinepos.x2-waterlinepos.x1
        local yl = waterlinepos.y2-waterlinepos.y1
        waterlinepos.length = math.sqrt(xl * xl + yl * yl)

        -- turn water off (default)
        wateron = false
        if water > 0 and not(transform) then
            -- checks if the mouse button is pressed or not
            if love.mouse.isDown(1, 2) then
                -- turn it on!
                wateron = true
                water = water - waterpersecond * dt
            end
        end  

        -- reset toremove
        toremove = {}
        -- test for water/fire collision
        for i, v in ipairs(fires) do
            local fr = {x1=v.x + 4, y1=v.y + 4, x2=v.x + fire:getWidth() - 4, y2=v.y + fire:getHeight() - 4}

            if wateron then
                if waterlinepos.x2 >= fr.x1 and waterlinepos.x2 <= fr.x2 and waterlinepos.y2 >= fr.y1 and waterlinepos.y2 <= fr.y2 then
                    table.insert(toremove, i)
                    firesextinguished = firesextinguished + 1
                    poof:play()
                    fireeffect:setPosition(waterlinepos.x2, waterlinepos.y2)
                    fireeffect:emit(32)
                    break
                end
            end        
        end

        for i=#toremove, 1, -1 do
            table.remove(fires, toremove[i])
        end
    else
        if water > 0 then
            -- increment shooting timer
            if not(wateron) then
                shoottimer = shoottimer + dt
                if #fires > 0 then
                    if shoottimer >= shoottimermax then
                        -- reset
                        shoottimer = 0
                        -- find closest
                        local closest = camera.w
                        closestindex = 1     
                        local foundone = false       
                        for i, v in ipairs(fires) do
                            -- pythag to the max!!!!
                            local dx = math.abs(v.x - firetruckpos.centrex)
                            local dy = math.abs(v.y - firetruckpos.y)
                            local distance = math.sqrt(dx*dx + dy*dy)
                            -- see if it is closer than what we currently have
                            if distance < closest and v.x >= camera.pos and v.x < camera.pos + camera.w - fire:getWidth() then
                                foundone = true
                                closest = distance
                                closestindex = i
                            end
                        end
                        if foundone then
                            wateron = true                    
                        end
                    end
                end
            else
                -- set the water line
                local fx = fires[closestindex].x + fire:getWidth()/2
                local fy = fires[closestindex].y + fire:getHeight()/2

                watercanonpos.angle = math.atan2(fy - watercanonpos.y, fx - watercanonpos.x)
                -- calculate world position of the water line
                waterlinepos.x1 = watercanonpos.x + (watercanon:getWidth()-4) * math.cos(watercanonpos.angle)
                waterlinepos.y1 = watercanonpos.y + (watercanon:getHeight()+4) * math.sin(watercanonpos.angle)
                waterlinepos.x2 = fx
                waterlinepos.y2 = fy
                local xl = waterlinepos.x2-waterlinepos.x1
                local yl = waterlinepos.y2-waterlinepos.y1
                waterlinepos.length = math.sqrt(xl * xl + yl * yl)

                water = water - waterpersecond * dt

                shotontimer = shotontimer + dt
                if shotontimer >= shotontimermax then
                    wateron = false
                    shotontimer = 0
                    table.remove(fires, closestindex)
                    firesextinguished = firesextinguished + 1
                    poof:play()
                    fireeffect:setPosition(fx, fy)
                    fireeffect:emit(32)
                end
            end
        end
    end

    -- update / create plane
    if planeactive then
        -- increment the position
        planepos.x = planepos.x + planespeed * dt
        if not(barrelactive) and planepos.x >= camera.pos + planepos.dropx then
            -- drop the barrel
            barrelactive = true 
            parachuteactive = true
            barrelpos.x = planepos.x
            barrelpos.y = planepos.y + plane:getHeight()
            barrelpos.angle = 0
            swingdir = 1
        end
        -- normalize how close you are to centre
        local n = (planepos.x - camera.pos) / (camera.w/2)
        if n > 1 then
            n = 2 - n
        end
        -- set volume based on normalized position
        planesound:setVolume(n)
        -- remove plane if offscreen
        if planepos.x >= camera.pos + camera.w + plane:getWidth() + 16 then
            planeactive = false
            planesound:stop()
        end
    else
        -- increment timer
        planetimer = planetimer + dt
        -- check if we should create a plane
        if planetimer >= planetimermax and not(barrelactive) then
            -- reset timer
            planetimer = 0
            -- determine the type of barrel it should be
            if water == 100 or health < 25 then
                -- determine what the creation chance should be
                planechance = 100 - health
                type = "health"
            else
                -- determine what the creation chance should be
                planechance = 100 - water
                type = "water"
            end

            -- check if we should randomly create a plane
            if planechance > math.random(1,100) then
                planeactive = true
                planepos.x = camera.pos - plane:getWidth() - 16
                planepos.y = math.random(10,160)
                planepos.dropx = math.random(camera.w/2, camera.w)
                planesound:setVolume(0)
                planesound:play()
            end
        end
    end

    if parachuteactive then
        barrelpos.y = barrelpos.y + barrelspeed * dt
        if barrelpos.y + waterbarrel:getHeight() >= camera.h - road:getHeight() then
            barrelpos.y = camera.h - road:getHeight() - waterbarrel:getHeight()
            parachuteactive = false
            barrelpos.angle = 0
            barrelland:play()
        end
        barrelpos.angle = barrelpos.angle + swingspeed * dt * swingdir
        if barrelpos.angle > math.pi/16 then
            swingdir = -1
        elseif barrelpos.angle < -math.pi/16 then
            swingdir = 1
        end
    end

    if barrelactive then
        -- test for player/barrel collision
        local barrelhitbox = {x1=barrelpos.x, y1=barrelpos.y, x2=barrelpos.x + waterbarrel:getWidth(), y2=barrelpos.y + waterbarrel:getHeight()}
        -- test bounds (first x bounds, then y bounds)
        
        if (barrelhitbox.x1 >= hitbox.x1 and barrelhitbox.x1 <= hitbox.x2) or (barrelhitbox.x2 >= hitbox.x1 and barrelhitbox.x2 <= hitbox.x2) then
            if (barrelhitbox.y1 >= hitbox.y1 and barrelhitbox.y1 <= hitbox.y2) or (barrelhitbox.y2 >= hitbox.y1 and barrelhitbox.y2 <= hitbox.y2) then
                barrelactive = false
                parachuteactive = false     -- in case you hit it out of the air...
                if type == "water" then
                    water = water + 50
                    if water > 100 then
                        water = 100
                    end
                elseif type == "health" then
                    health = health + 50
                    if health > 100 then
                        health = 100
                    end
                end
                -- pickup sound
                pickup:play()
                -- emit effect
                pickupeffect:setPosition(barrelpos.x, barrelpos.y)
                pickupeffect:emit(32)
            end
        end
    end

    -- update the title position... 
    if camera.pos > camera.w then
        titlepos.x = camera.pos + camera.w/2 - title:getWidth()/2
        titlepos.y = 4
    else
        titlepos.x = camera.w/2 - title:getWidth()/2
        titlepos.y = camera.h/2 - title:getHeight()/2*8
    end
end

function love.draw()
    -- scale the camera
    love.graphics.push()
    love.graphics.scale(camera.scale)
    love.graphics.translate(-camera.pos, 0)

    -- clear the background (colours the sky)
    love.graphics.clear(background)

    love.graphics.setColor(255,255,255,255)

    -- draw the background tiles, the position is offset by the camera position and background position offset (so it looks like it moves)
    for i=0, backgroundcount-1, 1 do
        love.graphics.draw(backgrounds[bgi[i+1]], (i-1) * backgrounds[1]:getWidth() + camera.pos + backgroundpos, camera.h - road:getHeight() - backgrounds[1]:getHeight())
    end

    -- draw the road tiles, the position is offset by the camera position and road position offset (so it looks like it moves)
    for i=0, roadcount, 1 do
        love.graphics.draw(road, (i-1) * road:getWidth() + camera.pos + roadpos, camera.h - road:getHeight())
    end

    love.graphics.setColor(255,255,255,128)

    -- draw the clouds
    for i, v in ipairs(cloudlist) do
        love.graphics.draw(clouds[v.index], v.x, v.y, 0, v.hflip, v.vflip)
    end

    love.graphics.setColor(255,255,255,255)

    -- change colour if we are at 0 health
    if health == 0 then
        love.graphics.setColor(64,64,64,255)
    end

    -- change colour if we are touching a fire
    if firehit then
        love.graphics.setColor(255,128,128,255)
    end

    -- draw back leg
    if firetruckjump then
        if not(firetruckmode) then
            love.graphics.draw(leg, legpos.x, legpos.y, math.pi/4, drawdir, 1, leg:getWidth()/2, 0)
        end
    else
        if not(firetruckmode) then
            love.graphics.draw(leg, legpos.x, legpos.y, -legpos.angle, drawdir, 1, leg:getWidth()/2, 0)
        end
    end

    -- draw lights
    love.graphics.setColor(colours[lightcolours[1]])
    love.graphics.draw(light, lightpos.frontx, lightpos.y, 0, drawdir, 1)
    love.graphics.setColor(colours[lightcolours[2]])
    love.graphics.draw(light, lightpos.backx, lightpos.y, 0, drawdir, 1)
    love.graphics.setColor(255,255,255,255)

    -- change colour if we are at 0 health
    if health == 0 then
        love.graphics.setColor(64,64,64,255)
    end
    
    -- change colour if we are touching a fire
    if firehit then
        love.graphics.setColor(255,128,128,255)
    end

    -- draw head & water canon
    if firetruckmode and not(transform) then
    else
        love.graphics.draw(head, firetruckpos.centrex - head:getWidth()/2, firetruckpos.y, headpos.angle, drawdir, 1, 0, head:getHeight())
    end

    -- draw firetruck
    love.graphics.draw(firetruckback, firetruckpos.backx, firetruckpos.y, 0, drawdir, 1)
    love.graphics.draw(firetruckfront, firetruckpos.frontx, firetruckpos.y, 0, drawdir, 1)

    -- draw water canon
    if not(transform) then
        love.graphics.draw(watercanon, watercanonpos.x, watercanonpos.y, watercanonpos.angle, drawdir, 1, 4, watercanon:getHeight()/2)
    end

    -- draw wheels
    love.graphics.draw(wheel, wheelpos.backx, wheelpos.y, wheelpos.angle, drawdir, 1, wheel:getWidth()/2, wheel:getHeight()/2)
    love.graphics.draw(wheel, wheelpos.frontx, wheelpos.y, wheelpos.angle, drawdir, 1, wheel:getWidth()/2, wheel:getHeight()/2)
    
    -- draw arm/ front leg (jumping will have a 0 rotation and flipped y)
    if firetruckjump then
        if firetruckmode and not(transform)  then
        else
            love.graphics.draw(arm, armpos.x, armpos.y, 0, drawdir, -1, arm:getWidth()/2, 0)
            love.graphics.draw(leg, legpos.x, legpos.y, -math.pi/4, drawdir, 1, leg:getWidth()/2, 0)
        end
    else
        if firetruckmode and not(transform) then
        else
            love.graphics.draw(leg, legpos.x, legpos.y, legpos.angle, drawdir, 1, leg:getWidth()/2, 0)
            love.graphics.draw(arm, armpos.x, armpos.y, armpos.angle, drawdir, 1, arm:getWidth()/2, 0)
        end
    end

    love.graphics.setColor(255,255,255,255)

    -- draw fire   
    for i, v in ipairs(fires) do
        love.graphics.draw(fire, v.x, v.y)
        love.graphics.draw(fireeye, v.x + 6, v.y + 12)
        if v.type == 1 then
            love.graphics.setColor(128,128,128,255)
            love.graphics.draw(firefoot, v.x + fire:getWidth()/2-4, v.y + fire:getHeight(), 0.25 * v.animvalue, 1, 1, 4, 0)
            love.graphics.setColor(255,255,255,255)
            love.graphics.draw(firefoot, v.x + fire:getWidth()/2-4, v.y + fire:getHeight(), -0.25 * v.animvalue, 1, 1, 4, 0)
        else
            love.graphics.draw(firewing, v.x + fire:getWidth()/2, v.y + fire:getHeight()/2+4, 0, 1, v.animvalue, firewing:getWidth()/2, 0)
        end
    end

    -- draw plane
    if planeactive then
        love.graphics.draw(plane, planepos.x, planepos.y)
    end

    -- draw barrel/parachute
    if barrelactive then
        if type == "health" then
            love.graphics.draw(healthbarrel, barrelpos.x, barrelpos.y, barrelpos.angle, 1, 1, healthbarrel:getWidth()/2, 0)
        elseif type == "water" then
            love.graphics.draw(waterbarrel, barrelpos.x, barrelpos.y, barrelpos.angle, 1, 1, waterbarrel:getWidth()/2, 0)
        end
    end
    if parachuteactive then
        love.graphics.draw(parachute, barrelpos.x, barrelpos.y, barrelpos.angle, 1, 1, parachute:getWidth()/2, parachute:getHeight())
    end

    -- draw effects
    love.graphics.draw(pickupeffect, 0, 0)
    love.graphics.draw(fireeffect, 0, 0)

    -- draw water
    if wateron then
        love.graphics.draw(waterline, waterlinepos.x1, waterlinepos.y1, watercanonpos.angle, waterlinepos.length, 1, 0, waterline:getHeight()/2)
        love.graphics.draw(waterend, waterlinepos.x2, waterlinepos.y2, watercanonpos.angle, 1, 1, waterend:getWidth()/2, waterend:getHeight()/2)
    end

    -- draw UI
    love.graphics.stencil(waterstencil, "replace", 1) 
    love.graphics.setStencilTest("greater", 0)
    love.graphics.draw(watericon, camera.pos + camera.w - healthicon:getWidth() - watericon:getWidth() - 4, 4)
    love.graphics.stencil(healthstencil, "replace", 1) 
    love.graphics.setStencilTest("greater", 0)    
    love.graphics.draw(healthicon, camera.pos + camera.w - healthicon:getWidth() - 2, 4)
    love.graphics.setStencilTest()    
    love.graphics.draw(wateroutline, camera.pos + camera.w - healthicon:getWidth() - watericon:getWidth() - 4, 4)
    love.graphics.draw(healthoutline, camera.pos + camera.w - healthicon:getWidth() - 2, 4)
    love.graphics.draw(fire, camera.pos + 4, 4)
    -- love.graphics.draw(crossout, camera.pos + 4, 4) 
    love.graphics.draw(title, titlepos.x, titlepos.y)
    love.graphics.draw(instructions, camera.w/2 - instructions:getWidth()/2-16, camera.h/2 - instructions:getHeight()/2)

    --Reticle
    if not(autoshooting) then
        love.graphics.draw(reticle, waterlinepos.x2, waterlinepos.y2, 0, 1, 1, reticle:getWidth()/2, reticle:getHeight()/2)
    end

    love.graphics.setColor(0,0,0,255)
    love.graphics.print(firesextinguished, camera.pos + 40, 4)

    -- hitbox DEBUG
    -- local w = hitbox.x2 - hitbox.x1
    -- local h = hitbox.y2 - hitbox.y1
    -- love.graphics.rectangle("line",hitbox.x1, hitbox.y1, w, h)
    -- love.graphics.print("Fire Extinguished: " .. firesextinguished, camera.pos + 5, 5)

    -- remove scaling/translation
    love.graphics.pop()

    -- -- debug
    -- love.graphics.print("health: " .. health, 10, 10)
    -- love.graphics.print("water: " .. water, 10, 25)
    -- love.graphics.print("Plane in: " .. planetimermax - planetimer, 10, 40)
    -- love.graphics.print("auto shooting: " .. tostring(autoshooting), 10, 55)
    -- love.graphics.print("shooting timer: " .. shoottimer, 10, 70)
    -- love.graphics.print("Camera Position: " .. camera.pos, 10, 10)
    -- love.graphics.print("Firetruck Position: " .. firetruckpos.centrex .. "," .. firetruckpos.y, 10, 75)
    -- love.graphics.print("Armpos Angle: " .. math.abs(armpos.angle), 10, 40)
end

-- draws water indicator
function waterstencil()
    local h = math.abs(watericon:getHeight() * (water / 100))
    local y = 4 + watericon:getHeight() - h
    love.graphics.rectangle("fill", camera.pos + camera.w - healthicon:getWidth() - watericon:getWidth() - 4, y, watericon:getWidth(), h)
end

-- draws health indicator
function healthstencil()
    local h = math.abs(healthicon:getHeight() * (health / 100))
    local y = 4 + healthicon:getHeight() - h
    love.graphics.rectangle("fill", camera.pos + camera.w - healthicon:getWidth() - 2, y, healthicon:getWidth(), h)
end