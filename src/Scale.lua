--[[
	Creator: saSlol2436
	Date: 12/26/2019 (mm/dd/yyyy)
	Version: 1

	Description:
		A ModuleScript that returns a class named Scale.
	The Scale class manages GuiObjects becoming bigger and 
	smaller. Instead of tweening the size of the GuiObject, 
	we can insert a UIScale inside a GuiObject and change its 
	Scale property to make it bigger and smaller.  
	This is better because it is easier to code (which really 
	isn't that important in the big picture) and it doesn't 
	make the GuiObject loose pixels. Crazyman32 was the first 
	person to (publicly) propose the idea of using UIScales to 
	make objects bigger and smaller for tweens (not sure).
	
	Todo:
		1. For Scale:SmoothScale, create an alternative method
		called Scale:SmoothScaleAsync which is identical to
		Scale:SmoothScale to functionality, except it uses 
		Promises.
		
		2. Create a Roact component of Scale.
--]]

local function isValidScaleSize(scaleSize)
	if not scaleSize then
		error("Invalid value for ScaleSize argument.  ScaleSize cannot be nil", 2)
	end
	
	if not typeof(scaleSize) == "number" then
		error("Invalid value for ScaleSize argument. ScaleSize must be a number.  Got " .. typeof(scaleSize) .. ".", 2)
	end
	
	return true
end

local Scale do
	Scale = {}
	Scale.ClassName = "Scale"
	Scale.__index = Scale
	
	--[[**
		The constructor for the Scale class.
		
		@param [t:GuiObject] guiObject The GuiObject being Scaled
		@returns [t:Scale] Returns a table with GuiObject property and its methods (using metatable magic)
	**--]]
	function Scale.new(guiObject)
		if not guiObject then
			error("Invalid value for GuiObject argument. GuiObject cannot be nil", 2)
		end
		
		if not typeof(guiObject) == "Instance" then
			error("Invalid value for GuiObject argument. GuiObject must be an Instance", 2)
		end
		
		if not guiObject:IsA("GuiObject") then
			error("Invalid value for GuiObject argument.  GuiObject must be a GuiObject (Frame, TextButton, TextLabel, etc.).", 2)
		end
		
		local this = {}
		this.GuiObject = guiObject
		
		setmetatable(this, Scale)
		return this
	end
	
	--[[**
		Creates a UIScale object call SizeScale inside the GuiObject passed in the constructor
		
		@param [t:number] scaleSize What the scale property of the UIScale (called SizeScale) will be (how much bigger it will get)
		@returns [t:UIScale] The UIScale object created with its name being SizeScale
	**--]]
	function Scale:_CreateSizeScale(scaleSize)
		if scaleSize then
			if type(scaleSize) ~= "number" then
				error("Invalid value for ScaleSize argument, got type " .. type(scaleSize) .. ".  Expected number", 2)
			end
		end
		
		local sizeScale = Instance.new("UIScale")
		sizeScale.Name = "SizeScale"
		sizeScale.Scale = scaleSize or 1
		sizeScale.Parent = self.GuiObject
		
		return sizeScale
	end
	
	--[[** 
		A method that retrieves the SizeScale
		
		@returns [t:UIScale] The SizeScale created by self:_CreateSizeScale()
	**--]]
	function Scale:GetSizeScale()
		local sizeScale = self.GuiObject:FindFirstChild("SizeScale")
		if not sizeScale then
			return
		end
		
		if not sizeScale:IsA("UIScale") then
			return
		end
		
		return sizeScale
	end
	
	--[[**
		Automatically scales the GuiObject (without any animations)
		
		@param [t:number] scaleSize How big the GuiObject should be
	**--]]	
	function Scale:AutoScale(scaleSize)
		isValidScaleSize(scaleSize)
		self:_CreateSizeScale(scaleSize)
	end
	
	--[[**
		Smoothly scales the GuiObject (with animations)
		
		@param [t:number] scaleSize How big the GuiObject should be
		@param [t:TweenInfo] tweenInfo A TweenInfo that you can use to edit how it animates the scaling
		@returns [t:Tween] A tween that you can utilize
	**--]]	
	function Scale:SmoothScale(scaleSize, tweenInfo)
		isValidScaleSize(scaleSize)
		if tweenInfo then
			if not typeof(tweenInfo) == "TweenInfo" then
				error("Invalid value for TweenInfo argument.  TweenInfo must be a tweenInfo. Got " .. typeof(tweenInfo) .. ".", 2)
			end
		end
		
		local TweenService = game:GetService("TweenService")
		local sizeScale = self:_CreateSizeScale()
		
		tweenInfo = tweenInfo or TweenInfo.new()
		local tween = TweenService:Create(
			sizeScale,
			tweenInfo,
			{ Scale = scaleSize }
		)
		
		tween:Play()
		return tween
	end
	
	--[[**
		The deconstructor for the Scale class.  Destroys the
		SizeScale if there is any.  Sets the GuiObject property
		to nil (doesn't destroy it, just removes it from the
		table)
		
		@returns [t:nil]
	**--]]
	function Scale:Destroy()
		local sizeScale = self:GetSizeScale()
		if sizeScale then
			sizeScale:Destroy()
		end
		
		self.GuiObject = nil
	end
end

return Scale
