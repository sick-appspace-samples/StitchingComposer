--[[

  Application name: StitchingComposer

  Summary:
  Demonstrating image stitching in a scene with known geometry and motion.

  Description:
  This sample shows how the views from three cameras and 13 exposures can be used to create one combined image.
  This method is recommended for cases where the geometry and placement of all cameras are known with good precision.
  Also the object surface should be possible to estimate by means of an external method as it is needed to stitch the image correctly.

  How To Run:
  Starting this sample is possible either by running the App (F5) or debugging (F7+F10).
  Setting breakpoint on the first row inside the 'main' function allows debugging step-by-step after 'Engine.OnStarted' event.
  Results can be seen in the image viewer on the DevicePage. Restarting the Sample may be necessary to show images after loading the web-page.
  To run this Sample a device with SICK Algorithm API and AppEngine >= V2.8.0 is required. For example SIM4000 with latest firmware.
  Alternatively the Emulator in AppStudio 2.4 or higher can be used.

--]]


--Start of Global Scope---------------------------------------------------------

print('AppEngine Version: ' .. Engine.getVersion())

-- Create a viewer
local viewer = View.create('viewer2D1')

--End of Global Scope-----------------------------------------------------------

--Start of Function and Event Scope---------------------------------------------

local function main()
  ------------------------------------------------------------
  -- Configure
  ------------------------------------------------------------
  -- Placed in private/public/ram/resources or other location
  local dataPath = 'resources/'

  -- For composer the direction of movement must be provided
  local direction = {0.99818713673244, 0.06014000366606, 0.0023706583345014}

  -- Specify the travel distance between each exposure
  local positions = {0.00, 13.20, 26.40, 39.60, 52.80, 66.00, 79.20, 92.40, 105.60, 118.80, 132.00, 145.20, 158.40}

  -- The plane to stitch in must also be provided
  local stitchingPlane = Shape3D.createPlane(0, 0, 1, 35)
  ------------------------------------------------------------

  -- Create the stitcher object
  local composer = Image.Stitching.Composer.create()
  composer:setPlane(stitchingPlane)

  -- Configure stitching
  composer:setUndistort(true)
  composer:setOutputScaling(0.8)
  --composer:setBlendOverlap(24)
  --composer:setFusionMethod("BLEND")
  --composer:setInterpolationMethod("LINEAR")

  -- Function that handles adding images from one camera
  local function addOneCamera(stitcher, cameraName, id, offsets)

    -- Load the the base camera model
    local cameraModel = Object.load(dataPath .. cameraName .. '.json')
    if not cameraModel then
      error('Failed to load camera model')
      return
    end

    -- Precomputing the lens correction increases performance while adding images
    local success = stitcher:initUndistort(cameraModel, id)
    if not success then
      print('WARNING: Failed to create lens correction LUT for camera: ' .. cameraName)
    end

    -- Calculate camera positions at increments along the direction
    local cameraModelsTranslated = cameraModel:translate(direction, offsets)
    if (#cameraModelsTranslated ~= #offsets) then
      print('Failed to translate camera models')
    end

    -- Add each image with the corresponding translated camera model
    for i = 1, #cameraModelsTranslated do
      local img = Image.load(dataPath .. cameraName .. '/' .. tostring(i - 1) .. '.png')
      stitcher:addImage(img, cameraModelsTranslated[i], id)
    end

    collectgarbage()
  end

  -- Add each camera
  addOneCamera(composer, 'cam_14135893', 0, positions)
  addOneCamera(composer, 'cam_14425986', 1, positions)
  addOneCamera(composer, 'cam_14340525', 2, positions)

  -- Perform actual stitching
  local stitched = composer:stitch()
  if (stitched ~= nil) then
    viewer:clear()
    viewer:addImage(stitched)
    viewer:present()
    print('Stitching successful')
  else
    print('Stitching failed')
  end

  print('App finished.')
end
--The following registration is part of the global scope which runs once after startup
--Registration of the 'main' function to the 'Engine.OnStarted' event
Script.register('Engine.OnStarted', main)

--End of Function and Event Scope--------------------------------------------------
