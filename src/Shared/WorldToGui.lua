local WorldToGui = {
}

-- This is used to get three vertices at each face
local DirectionLookup = {
	[Enum.NormalId.Right] = {
		Vector3.new(0.5,  0.5,  0.5),
		Vector3.new(0.5,  0.5, -0.5),
		Vector3.new(0.5, -0.5, -0.5),
	},
	[Enum.NormalId.Left] = {
		Vector3.new(-0.5,  0.5, -0.5),
		Vector3.new(-0.5,  0.5,  0.5),
		Vector3.new(-0.5, -0.5,  0.5),
	},
	[Enum.NormalId.Front] = {
		Vector3.new( 0.5,  0.5, -0.5),
		Vector3.new(-0.5,  0.5, -0.5),
		Vector3.new(-0.5, -0.5, -0.5),
	},
	[Enum.NormalId.Back] = {
		Vector3.new(-0.5,  0.5, 0.5),
		Vector3.new( 0.5,  0.5, 0.5),
		Vector3.new( 0.5, -0.5, 0.5),
	},
	[Enum.NormalId.Top] = {
		Vector3.new(-0.5,  0.5,  0.5),
		Vector3.new(-0.5,  0.5, -0.5),
		Vector3.new( 0.5,  0.5, -0.5),
	},
	[Enum.NormalId.Bottom] = {
		Vector3.new( 0.5, -0.5,  0.5),
		Vector3.new( 0.5, -0.5, -0.5),
		Vector3.new(-0.5, -0.5, -0.5),
	},
}

-- Get the nearest face to a point
function GetSurfaceClosestToPoint(Part, WorldPosition)
	local rel = Part.CFrame:pointToObjectSpace(WorldPosition) / Part.Size;
	local relX = rel.X;
	local relY = rel.Y;
	local relZ = rel.Z;
	local absX = math.abs(relX);
	local absY = math.abs(relY);
	local absZ = math.abs(relZ);
	
	if (absZ > absY) and (absZ > absX) then
		if (relZ > 0) then
			return Enum.NormalId.Back;
		else
			return Enum.NormalId.Front;
		end
	elseif (absY > absZ) and (absY > absX) then
		if (relY > 0) then
			return Enum.NormalId.Top;
		else
			return Enum.NormalId.Bottom;
		end    
	elseif (absX > absZ and absX > absY) then
		if (relX > 0) then
			return Enum.NormalId.Right;
		else
			return Enum.NormalId.Left;
		end    
	end
	
	return nil;
end

-- Get the nearest point on a line
function NearestPointOnLine( Origin, Direction, TestPoint )
	local testDir = Direction.unit;
	local v = TestPoint - Origin;
	local d = v:Dot(testDir);
	return Origin + (testDir * d);
end

-- Convert world position to Surface Gui Data
function WorldToGui.WorldPositionToGuiPosition( Part, WorldPosition )
	local Surface = GetSurfaceClosestToPoint( Part, WorldPosition );
	if ( Surface == nil ) then
		return nil, nil, nil, nil, nil;
	end
	
	local TriangleData = DirectionLookup[Surface];
	if ( TriangleData == nil ) then
		return nil, nil, nil, nil, nil;
	end
	
	local P1 = (Part.CFrame * CFrame.new(TriangleData[1]*Part.Size)).p;
	local P2 = (Part.CFrame * CFrame.new(TriangleData[2]*Part.Size)).p;
	local P3 = (Part.CFrame * CFrame.new(TriangleData[3]*Part.Size)).p;
	local P4 = NearestPointOnLine(P1, P2-P1, WorldPosition);
	local P5 = NearestPointOnLine(P2, P3-P2, WorldPosition);
	
	local LocalWidth = (P2-P1).Magnitude;
	local LocalHeight = (P3-P2).Magnitude;
	local RelativeWidth = ((P4-P1).Magnitude)/LocalWidth;
	local RelativeHeight = ((P5-P2).Magnitude)/LocalHeight;
	
	return Surface, LocalWidth, LocalHeight, RelativeWidth, RelativeHeight;
end

return WorldToGui;