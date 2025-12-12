
if getgenv().LoadedFisch then
    return
end

getgenv().LoadedFisch = true

print("Fisch Script Loaded Version 22 - Enhanced")
local AutoAurora = false
local AutoKickSer = false
local AutoFish = false
local autoShake = false
local autoShake2 = false
local autoShake3 = false
local autoReel = false
local AutoCast = false
local Noclip = false
local AntiAfk = false
local AutoAppraiser = false
local AutoSell = false
local AutoZoneCast = false
local AutoFreeze = false
local WebhookLog = false
local autoShakeDelay = 0.3
local WebhookDelay = 30
local selectedZoneCast = ""
_G.Settings = {
    Farm = {
        Position = {},
        Mode = "Save Position",--"Trash","Level","Enchant Relic","Save Position","Freeze"
        SelectBoat = "",
        EnableBoat = false,
        Enable = false,

        Cast = {
            Mode = "Perfect", -- Perfect,Random
            Enable = true
        },

        Shake = {
            Delay = 0.1,
            Enable = true
        },

        Reel = {
            Bar = "Center", -- Center , Large
            Mode = "Fast[Risk]",-- Center, Large ,Safe 80,Fast[Risk]
            ReelBarprogress = 0.67,
            Enable = true
        },

        Rod = {
            Admin_Event = "Flimsy Rod",
            FarmRod = "Flimsy Rod",
            ScyllaRod = "Flimsy Rod",
            MossjawRod = "Flimsy Rod"
        },
    },

    Boss = {
        SelectBoss = {},
        Mode = "With Farm",--with Farm ,Re Day
        Enable = false
    },

    Fish = {
        SellAll = true
    },

    Daily_Shop = {
        SelectItem = {},
        Enable = true
    },
}

local teleportSpots = {
    altar = CFrame.new(1296.320068359375, -808.5519409179688, -298.93817138671875),
    arch = CFrame.new(998.966796875, 126.6849365234375, -1237.1434326171875),
    birch = CFrame.new(1742.3203125, 138.25787353515625, -2502.23779296875),
    brine = CFrame.new(-1794.10596, -145.849701, -3302.92358, -5.16176224e-05, 3.10316682e-06, 0.99999994, 0.119907647, 0.992785037, 3.10316682e-06, -0.992785037, 0.119907647, -5.16176224e-05),
    deep = CFrame.new(-1510.88672, -237.695053, -2852.90674, 0.573604643, 0.000580655003, 0.81913209, -0.000340352941, 0.999999762, -0.000470530824, -0.819132209, -8.89541116e-06, 0.573604763),
    deepshop = CFrame.new(-979.196411, -247.910156, -2699.87207, 0.587748766, 0, 0.809043527, 0, 1, 0, -0.809043527, 0, 0.587748766),
    enchant = CFrame.new(1296.320068359375, -808.5519409179688, -298.93817138671875),
    executive = CFrame.new(-29.836761474609375, -250.48486328125, 199.11614990234375),
    keepers = CFrame.new(1296.320068359375, -808.5519409179688, -298.93817138671875),
    mod_house = CFrame.new(-30.205902099609375, -249.40594482421875, 204.0529022216797),
    moosewood = CFrame.new(383.10113525390625, 131.2406005859375, 243.93385314941406),
    mushgrove = CFrame.new(2501.48583984375, 127.7583236694336, -720.699462890625),
    roslit = CFrame.new(-1476.511474609375, 130.16842651367188, 671.685302734375),
    snow = CFrame.new(2648.67578125, 139.06605529785156, 2521.29736328125),
    snowcap = CFrame.new(2648.67578125, 139.06605529785156, 2521.29736328125),
    spike = CFrame.new(-1254.800537109375, 133.88555908203125, 1554.2021484375),
    statue = CFrame.new(72.8836669921875, 138.6964874267578, -1028.4193115234375),
    sunstone = CFrame.new(-933.259705, 128.143951, -1119.52063, -0.342042685, 0, -0.939684391, 0, 1, 0, 0.939684391, 0, -0.342042685),
    swamp = CFrame.new(2501.48583984375, 127.7583236694336, -720.699462890625),
    terrapin = CFrame.new(-143.875244140625, 141.1676025390625, 1909.6070556640625),
    trident = CFrame.new(-1479.48987, -228.710632, -2391.39307, 0.0435845852, 0, 0.999049723, 0, 1, 0, -0.999049723, 0, 0.0435845852),
    vertigo = CFrame.new(-112.007278, -492.901093, 1040.32788, -1, 0, 0, 0, 1, 0, 0, 0, -1),
    volcano = CFrame.new(-1888.52319, 163.847565, 329.238281, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    wilson = CFrame.new(2938.80591, 277.474762, 2567.13379, 0.4648332, 0, 0.885398269, 0, 1, 0, -0.885398269, 0, 0.4648332),
    wilsons_rod = CFrame.new(2879.2085, 135.07663, 2723.64233, 0.970463336, -0.168695927, -0.172460333, 0.141582936, -0.180552125, 0.973321974, -0.195333466, -0.968990743, -0.151334763)
}

local FishAreas = {
    Roslit_Bay = CFrame.new(-1663.73889, 149.234116, 495.498016, 0.0380855016, 4.08820178e-08, -0.999274492, 5.74658472e-08, 1, 4.3101906e-08, 0.999274492, -5.90657123e-08, 0.0380855016),
    Ocean = CFrame.new(7665.104, 125.444443, 2601.59351, 0.999966085, -0.000609769544, -0.00821684115, 0.000612694537, 0.999999762, 0.000353460142, 0.00821662322, -0.000358482561, 0.999966204),
    Snowcap_Pond = CFrame.new(2778.09009, 283.283783, 2580.323, 1, 7.17688531e-09, -2.22843701e-05, -7.17796267e-09, 1, -4.83369114e-08, 2.22843701e-05, 4.83370712e-08, 1),
    Moosewood_Docks = CFrame.new(343.2359924316406, 133.61595153808594, 267.0580139160156),
    Deep_Ocean = CFrame.new(3569.07153, 125.480949, 6697.12695, 0.999980748, -0.00188910461, -0.00591362361, 0.00193980196, 0.999961317, 0.00857902411, 0.00589718809, -0.00859032944, 0.9999457),
    Vertigo = CFrame.new(-137.697098, -736.86377, 1233.15271, 1, -1.61821543e-08, -2.01375751e-05, 1.6184277e-08, 1, 1.05423091e-07, 2.01375751e-05, -1.0542341e-07, 1),
    Snowcap_Ocean = CFrame.new(3088.66699, 131.534332, 2587.11304, 1, 4.30694858e-09, -1.19097813e-14, -4.30694858e-09, 1, -2.80603398e-08, 1.17889275e-14, 2.80603398e-08, 1),
    Harvesters_Spike = CFrame.new(-1234.61523, 125.228767, 1748.57166, 0.999991536, -0.000663080777, -0.00405627443, 0.000725277001, 0.999881923, 0.0153511297, 0.00404561637, -0.0153539423, 0.999873936),
    SunStone = CFrame.new(-845.903992, 133.172211, -1163.57776, 1, -7.93465915e-09, -2.09446498e-05, 7.93544608e-09, 1, 3.75741536e-08, 2.09446498e-05, -3.75743205e-08, 1),
    Roslit_Bay_Ocean = CFrame.new(-1708.09302, 155.000015, 384.928009, 1, -9.84460868e-09, -3.24939563e-15, 9.84460868e-09, 1, 4.66220271e-08, 2.79042003e-15, -4.66220271e-08, 1),
    Moosewood_Pond = CFrame.new(509.735992, 152.000031, 302.173004, 1, -1.78487678e-08, -8.1329488e-14, 1.78487678e-08, 1, 8.45405168e-08, 7.98205428e-14, -8.45405168e-08, 1),
    Terrapin_Ocean = CFrame.new(58.6469994, 135.499985, 2147.41699, 1, 2.09643041e-08, -5.6023784e-15, -2.09643041e-08, 1, -9.92988376e-08, 3.52064755e-15, 9.92988376e-08, 1),
    Isonade = CFrame.new(-1060.99902, 121.164787, 953.996033, 0.999958456, 0.000633197487, -0.00909138657, -0.000568434712, 0.999974489, 0.00712434994, 0.00909566507, -0.00711888634, 0.999933302),
    Moosewood_Ocean = CFrame.new(-167.642715, 125.19548, 248.009521, 0.999997199, -0.000432743778, -0.0023210498, 0.000467110571, 0.99988997, 0.0148265222, 0.00231437827, -0.0148275653, 0.999887407),
    Roslit_Pond = CFrame.new(-1811.96997, 148.047089, 592.642517, 1, 1.12983072e-08, -2.16573972e-05, -1.12998171e-08, 1, -6.97014357e-08, 2.16573972e-05, 6.97016844e-08, 1),
    Moosewood_Ocean_Mythical = CFrame.new(252.802994, 135.849625, 36.8839989, 1, -1.98115071e-08, -4.50667564e-15, 1.98115071e-08, 1, 1.22230617e-07, 2.08510289e-15, -1.22230617e-07, 1),
    Terrapin_Olm = CFrame.new(22.0639992, 182.000015, 1944.36804, 1, 1.14953362e-08, -2.7011112e-15, -1.14953362e-08, 1, -7.09263972e-08, 1.88578841e-15, 7.09263972e-08, 1),
    The_Arch = CFrame.new(1283.30896, 130.923569, -1165.29602, 1, -5.89772364e-09, -3.3183043e-15, 5.89772364e-09, 1, 3.63913486e-08, 3.10367822e-15, -3.63913486e-08, 1),
    Scallop_Ocean = CFrame.new(23.2255898, 125.236847, 738.952271, 0.999990165, -0.00109633175, -0.00429760758, 0.00115595153, 0.999902785, 0.0138949333, 0.00428195624, -0.013899764, 0.999894202),
    SunStone_Hidden = CFrame.new(-1139.55701, 134.62204, -1076.94324, 1, 3.9719481e-09, -1.6278158e-05, -3.97231048e-09, 1, -2.22651142e-08, 1.6278158e-05, 2.22651781e-08, 1),
    Mushgrove_Stone = CFrame.new(2525.36011, 131.000015, -776.184021, 1, 1.90145943e-08, -3.24206519e-15, -1.90145943e-08, 1, -1.06596836e-07, 1.21516956e-15, 1.06596836e-07, 1),
    Keepers_Altar = CFrame.new(1307.13599, -805.292236, -161.363998, 1, 2.40881981e-10, -3.25609947e-15, -2.40881981e-10, 1, -1.35044154e-09, 3.255774e-15, 1.35044154e-09, 1),
    Lava = CFrame.new(-1959.86206, 193.144821, 271.960999, 1, -6.02453598e-09, -2.97388313e-15, 6.02453598e-09, 1, 3.37767716e-08, 2.77039384e-15, -3.37767716e-08, 1),
    Roslit_Pond_Seaweed = CFrame.new(-1785.2869873046875, 148.15780639648438, 639.9299926757812),    
}

local itemSpots = {
    Training_Rod = CFrame.new(457.693848, 148.357529, 230.414307, 1, -0, 0, 0, 0.975410998, 0.220393807, -0, -0.220393807, 0.975410998),
    Plastic_Rod = CFrame.new(454.425385, 148.169739, 229.172424, 0.951755166, 0.0709736273, -0.298537821, -3.42726707e-07, 0.972884834, 0.231290117, 0.306858391, -0.220131472, 0.925948203),
    Lucky_Rod = CFrame.new(446.085999, 148.253006, 222.160004, 0.974526405, -0.22305499, 0.0233404674, 0.196993902, 0.901088715, 0.386306256, -0.107199371, -0.371867687, 0.922075212),
    Kings_Rod = CFrame.new(1375.57642, -810.201721, -303.509247, -0.7490201, 0.662445903, -0.0116144121, -0.0837960541, -0.0773290396, 0.993478119, 0.657227278, 0.745108068, 0.113431036),
    Flimsy_Rod = CFrame.new(471.107697, 148.36171, 229.642441, 0.841614008, 0.0774728209, -0.534493923, 0.00678436086, 0.988063335, 0.153898612, 0.540036798, -0.13314943, 0.831042409),
    Nocturnal_Rod = CFrame.new(-141.874237, -515.313538, 1139.04529, 0.161644459, -0.98684907, 1.87754631e-05, 1.87754631e-05, 2.21133232e-05, 1, -0.98684907, -0.161644459, 2.21133232e-05),
    Fast_Rod = CFrame.new(447.183563, 148.225739, 220.187454, 0.981104493, 1.26492232e-05, 0.193478703, -0.0522461236, 0.962867677, 0.264870107, -0.186291039, -0.269973755, 0.944674432),
    Carbon_Rod = CFrame.new(454.083618, 150.590073, 225.328827, 0.985374212, -0.170404434, 1.41561031e-07, 1.41561031e-07, 1.7285347e-06, 1, -0.170404434, -0.985374212, 1.7285347e-06),
    Long_Rod = CFrame.new(485.695038, 171.656326, 145.746109, -0.630167365, -0.776459217, -5.33461571e-06, 5.33461571e-06, -1.12056732e-05, 1, -0.776459217, 0.630167365, 1.12056732e-05),
    Mythical_Rod = CFrame.new(389.716705, 132.588821, 314.042847, 0, 1, 0, 0, 0, -1, -1, 0, 0),
    Midas_Rod = CFrame.new(401.981659, 133.258316, 326.325745, 0.16456604, 0.986365497, 0.00103566051, 0.00017541647, 0.00102066994, -0.999999464, -0.986366034, 0.1645661, -5.00679016e-06),
    Trident_Rod = CFrame.new(-1484.34192, -222.325562, -2194.77002, -0.466092706, -0.536795318, 0.703284025, -0.319611132, 0.843386114, 0.43191275, -0.824988723, -0.0234660208, -0.56466186),
    Enchated_Altar = CFrame.new(1310.54651, -799.469604, -82.7303467, 0.999973059, 0, 0.00733732153, 0, 1, 0, -0.00733732153, 0, 0.999973059),
    Bait_Crate = CFrame.new(384.57513427734375, 135.3519287109375, 337.5340270996094),
    Quality_Bait_Crate = CFrame.new(-177.876, 144.472, 1932.844),
    Crab_Cage = CFrame.new(474.803589, 149.664566, 229.49469, -0.721874595, 0, 0.692023814, 0, 1, 0, -0.692023814, 0, -0.721874595),
    GPS = CFrame.new(517.896729, 149.217636, 284.856842, 7.39097595e-06, -0.719539165, -0.694451928, -1, -7.39097595e-06, -3.01003456e-06, -3.01003456e-06, 0.694451928, -0.719539165),
    Basic_Diving_Gear = CFrame.new(369.174774, 132.508835, 248.705368, 0.228398502, -0.158300221, -0.96061182, 1.58026814e-05, 0.986692965, -0.162594408, 0.973567724, 0.037121132, 0.225361705),
    Fish_Radar = CFrame.new(365.75177, 134.50499, 274.105804, 0.704499543, -0.111681774, -0.70086211, 1.32396817e-05, 0.987542748, -0.157350808, 0.709704578, 0.110844307, 0.695724905)
}

local racistPeople = {
    Witch = CFrame.new(409.638092, 134.451523, 311.403687, -0.74079144, 0, 0.671735108, 0, 1, 0, -0.671735108, 0, -0.74079144),
    Quiet_Synph = CFrame.new(566.263245, 152.000031, 353.872101, -0.753558397, 0, -0.657381535, 0, 1, 0, 0.657381535, 0, -0.753558397),
    Pierre = CFrame.new(391.38855, 135.348389, 196.712387, -1, 0, 0, 0, 1, 0, 0, 0, -1),
    Phineas = CFrame.new(469.912292, 150.69342, 277.954987, 0.886104584, -0, -0.46348536, 0, 1, -0, 0.46348536, 0, 0.886104584),
    Paul = CFrame.new(381.741882, 136.500031, 341.891022, -1, 0, 0, 0, 1, 0, 0, 0, -1),
    Shipwright = CFrame.new(357.972595, 133.615967, 258.154541, 0, 0, -1, 0, 1, 0, 1, 0, 0),
    Angler = CFrame.new(480.102478, 150.501053, 302.226898, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Marc = CFrame.new(466.160034, 151.00206, 224.497086, -0.996853352, 0, -0.0792675018, 0, 1, 0, 0.0792675018, 0, -0.996853352),
    Lucas = CFrame.new(449.33963, 181.999893, 180.689072, 0, 0, 1, 0, 1, -0, -1, 0, 0),
    Latern_Keeper = CFrame.new(-39.0456772, -246.599976, 195.644363, -1, 0, 0, 0, 1, 0, 0, 0, -1),
    Latern_Keeper2 = CFrame.new(-17.4230175, -304.970276, -14.529892, -1, 0, 0, 0, 1, 0, 0, 0, -1),
    Inn_Keeper = CFrame.new(487.458466, 150.800034, 231.498932, -0.564704418, 0, -0.825293183, 0, 1, 0, 0.825293183, 0, -0.564704418),
    Roslit_Keeper = CFrame.new(-1512.37891, 134.500031, 631.24353, 0.738236904, 0, -0.674541533, 0, 1, 0, 0.674541533, 0, 0.738236904),
    FishingNpc_1 = CFrame.new(-1429.04138, 134.371552, 686.034424, 0, 0.0168599077, -0.999857903, 0, 0.999857903, 0.0168599077, 1, 0, 0),
    FishingNpc_2 = CFrame.new(-1778.55408, 149.791779, 648.097107, 0.183140755, 0.0223737024, -0.982832015, 0, 0.999741018, 0.0227586292, 0.983086705, -0.00416803267, 0.183093324),
    FishingNpc_3 = CFrame.new(-1778.26807, 147.83165, 653.258606, -0.129575253, 0.501478612, 0.855411887, -2.44146213e-05, 0.862683058, -0.505744994, -0.991569638, -0.0655529201, -0.111770131),
    Henry = CFrame.new(483.539307, 152.383057, 236.296143, -0.789363742, 0, 0.613925934, 0, 1, 0, -0.613925934, 0, -0.789363742),
    Daisy = CFrame.new(581.550049, 165.490753, 213.499969, -0.964885235, 0, -0.262671858, 0, 1, 0, 0.262671858, 0, -0.964885235),
    Appraiser = CFrame.new(453.182373, 150.500031, 206.908783, 0, 0, 1, 0, 1, -0, -1, 0, 0),
    Merchant = CFrame.new(416.690521, 130.302628, 342.765289, -0.249025017, -0.0326484665, 0.967946589, -0.0040341015, 0.999457955, 0.0326734781, -0.968488574, 0.00423171744, -0.249021754),
    Mod_Keeper = CFrame.new(-39.0905838, -245.141144, 195.837891, -0.948549569, -0.0898146331, -0.303623199, -0.197293222, 0.91766715, 0.34490931, 0.247647122, 0.387066364, -0.888172567),
    Ashe = CFrame.new(-1709.94055, 149.862411, 729.399536, -0.92290163, 0.0273250472, -0.384064913, 0, 0.997478604, 0.0709675401, 0.385035753, 0.0654960647, -0.920574605),
    Alfredrickus = CFrame.new(-1520.60632, 142.923264, 764.522034, 0.301733732, 0.390740901, -0.869642735, 0.0273988936, 0.908225596, 0.417582989, 0.952998459, -0.149826124, 0.26333645),
}

function ClickMiddle()
    game:GetService("VirtualInputManager"):SendMouseButtonEvent(workspace.CurrentCamera.ViewportSize.X/2,workspace.CurrentCamera.ViewportSize.Y/2,0,true,a,1)
    game:GetService("VirtualInputManager"):SendMouseButtonEvent(workspace.CurrentCamera.ViewportSize.X/2,workspace.CurrentCamera.ViewportSize.Y/2,0,false,a,1)    
end 

function ClickCamera()
	game:GetService("VirtualUser"):CaptureController()
	game:GetService("VirtualUser"):ClickButton1(Vector2.new(851, 158), game:GetService("Workspace").Camera.CFrame)
end
function Click()
	game:GetService("VirtualUser"):CaptureController()
	game:GetService("VirtualUser"):Button1Down(Vector2.new(1280, 672))
end

print(game:GetService("Players").LocalPlayer.PlayerGui.loading.Enabled)




repeat wait() until game:IsLoaded()
repeat wait() until game.Players.LocalPlayer
local plr = game.Players.LocalPlayer
repeat wait() until plr.Character
repeat wait() until plr.Character:FindFirstChild("HumanoidRootPart")
repeat wait() until plr.Character:FindFirstChild("Humanoid")
repeat wait() ClickMiddle() until game:GetService("Players").LocalPlayer.PlayerGui.loading.Enabled == false 


task.wait(3)

getgenv().Load = function()
    print("Loaded!")
	if readfile and writefile and isfile and isfolder then
		if not isfolder("Hypexz V2") then
			makefolder("Hypexz V2")
		end
		if not isfolder("Hypexz V2/Fisch/") then
			makefolder("Hypexz V2/Fisch/")
		end
		if not isfile("Hypexz V2/Fisch/US_" .. game.Players.LocalPlayer.Name .. ".json") then
			writefile("Hypexz V2/Fisch/US_" .. game.Players.LocalPlayer.Name .. ".json", game:GetService("HttpService"):JSONEncode(_G.Settings))
		else
			local Decode = game:GetService("HttpService"):JSONDecode(readfile("Hypexz V2/Fisch/US_" .. game.Players.LocalPlayer.Name .. ".json"))
			for i,v in pairs(Decode) do
				_G.Settings[i] = v
			end
		end
	else
		return warn("Status : Undetected Executor")
	end
end

getgenv().SaveSetting = function()
    -- print("Save!")
	if readfile and writefile and isfile and isfolder then
		if not isfile("Hypexz V2/Fisch/US_" .. game.Players.LocalPlayer.Name .. ".json") then
			getgenv().Load()
		else
			local Decode = game:GetService("HttpService"):JSONDecode(readfile("Hypexz V2/Fisch/US_" .. game.Players.LocalPlayer.Name .. ".json"))
			local Array = {}
			for i,v in pairs(_G.Settings) do
				Array[i] = v
			end
			writefile("Hypexz V2/Fisch/US_" .. game.Players.LocalPlayer.Name .. ".json", game:GetService("HttpService"):JSONEncode(Array))
		end
	else
		return warn("Status : Undetected Executor")
	end
end

getgenv().Load()


local DeviceType = game:GetService("UserInputService").TouchEnabled and "Mobile" or "PC"
if DeviceType == "Mobile" then
    local ClickButton = Instance.new("ScreenGui")
    local MainFrame = Instance.new("Frame")
    local ImageLabel = Instance.new("ImageLabel")
    local TextButton = Instance.new("TextButton")
    local UICorner = Instance.new("UICorner")
    local UICorner_2 = Instance.new("UICorner")

    ClickButton.Name = "ClickButton"
    ClickButton.Parent = game.CoreGui
    ClickButton.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    MainFrame.Name = "MainFrame"
    MainFrame.Parent = ClickButton
    MainFrame.AnchorPoint = Vector2.new(1, 0)
    MainFrame.BackgroundTransparency = 0.8
    MainFrame.BackgroundColor3 = Color3.fromRGB(38, 38, 38) 
    MainFrame.BorderSizePixel = 0
    MainFrame.Position = UDim2.new(1, -60, 0, 10)
    MainFrame.Size = UDim2.new(0, 45, 0, 45)

    UICorner.CornerRadius = UDim.new(1, 0)
    UICorner.Parent = MainFrame

    UICorner_2.CornerRadius = UDim.new(0, 10)
    UICorner_2.Parent = ImageLabel

    ImageLabel.Parent = MainFrame
    ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
    ImageLabel.BackgroundColor3 = Color3.new(0, 0, 0)
    ImageLabel.BorderSizePixel = 0
    ImageLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
    ImageLabel.Size = UDim2.new(0, 45, 0, 45)
    ImageLabel.Image = "rbxassetid://"

    TextButton.Parent = MainFrame
    TextButton.BackgroundColor3 = Color3.new(1, 1, 1)
    TextButton.BackgroundTransparency = 1
    TextButton.BorderSizePixel = 0
    TextButton.Position = UDim2.new(0, 0, 0, 0)
    TextButton.Size = UDim2.new(0, 45, 0, 45)
    TextButton.AutoButtonColor = false
    TextButton.Font = Enum.Font.SourceSans
    TextButton.Text = "Open"
    TextButton.TextColor3 = Color3.new(220, 125, 255)
    TextButton.TextSize = 20

    TextButton.MouseButton1Click:Connect(function()
        game:GetService("VirtualInputManager"):SendKeyEvent(true, "LeftControl", false, game)
        game:GetService("VirtualInputManager"):SendKeyEvent(false, "LeftControl", false, game)
    end)
end


local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Offset 
if DeviceType == "Mobile" then
    Offset = UDim2.fromOffset(464, 368) -- 580 * 0.8 = 464, 460 * 0.8 = 368
elseif DeviceType == "PC" then
    Offset = UDim2.fromOffset(580, 460)
end

local Window = Fluent:CreateWindow({
    Title = "Hypexz V2 ",
    SubTitle = "by dawid",
    TabWidth = 120,
    Size = Offset,--UDim2.fromOffset(580, 460),
    Acrylic = false, -- The blur may be detectable, setting this to false disables blur entirely
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl -- Used when theres no MinimizeKeybind
})

-- local savedPosition = nil
-- if _G.Settings.Farm.Position then
-- 	local sp = _G.Settings.Farm.Position
-- 	if sp.X and sp.Y and sp.Z and sp.Yaw then
-- 		local pos = Vector3.new(sp.X, sp.Y, sp.Z)
-- 		local yawRad = math.rad(sp.Yaw)
-- 		savedPosition = CFrame.new(pos) * CFrame.Angles(0, yawRad, 0)
-- 	end
-- end

local savedPosition = nil
if _G.Settings.Farm.Position then
    local sp = _G.Settings.Farm.Position
    if sp.X and sp.Y and sp.Z and sp.Yaw then
        local pos = Vector3.new(sp.X, sp.Y, sp.Z)
        local yawRad = sp.Yaw
        savedPosition = CFrame.new(pos) * CFrame.Angles(0, yawRad, 0)
        print("Loaded saved position:", savedPosition)
    end
end


game:GetService("Players").LocalPlayer.Idled:connect(function()
	game:GetService("VirtualUser"):Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
	wait(1)
	game:GetService("VirtualUser"):Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
end)


spawn(function()
    while wait(1) do
        local args = {
            [1] = false
        }

        game:GetService("ReplicatedStorage"):WaitForChild("events"):WaitForChild("afk"):FireServer(unpack(args))
    end
end)


local PlaceID = game.PlaceId
local AllIDs = {}
local foundAnything = ""
local actualHour = os.date("!*t").hour
local Deleted = false
local File = pcall(function()
    AllIDs = game:GetService('HttpService'):JSONDecode(readfile("NotSameServers.json"))
end)
if not File then
    table.insert(AllIDs, actualHour)
    writefile("NotSameServers.json", game:GetService('HttpService'):JSONEncode(AllIDs))
end

local function TP(...)
    local args = {...}
    local targetPos = args[1]
    local RealTarget

    if typeof(targetPos) == "Vector3" then
        RealTarget = CFrame.new(targetPos)
    elseif typeof(targetPos) == "CFrame" then
        RealTarget = targetPos
    elseif typeof(targetPos) == "Instance" and targetPos:IsA("BasePart") then
        RealTarget = targetPos.CFrame
    elseif typeof(targetPos) == "number" then
        RealTarget = CFrame.new(unpack(args))
    else
        warn("TP: Invalid target type")
        return
    end

    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:WaitForChild("Humanoid")
    local root = character:WaitForChild("HumanoidRootPart")

    if humanoid.Health <= 0 then
        repeat task.wait() until humanoid.Health > 0
        task.wait(0.2)
        character = player.Character
        humanoid = character:WaitForChild("Humanoid")
        root = character:WaitForChild("HumanoidRootPart")
    end

    root.CFrame = RealTarget
end

function TPReturner()
    local Site;
    if foundAnything == "" then
        Site = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. PlaceID .. '/servers/Public?sortOrder=Asc&limit=100'))
    else
        Site = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. PlaceID .. '/servers/Public?sortOrder=Asc&limit=100&cursor=' .. foundAnything))
    end
    local ID = ""
    if Site.nextPageCursor and Site.nextPageCursor ~= "null" and Site.nextPageCursor ~= nil then
        foundAnything = Site.nextPageCursor
    end
    local num = 0;
    for i,v in pairs(Site.data) do
        local Possible = true
        ID = tostring(v.id)
        if tonumber(v.maxPlayers) > tonumber(v.playing) then
            for _,Existing in pairs(AllIDs) do
                if num ~= 0 then
                    if ID == tostring(Existing) then
                        Possible = false
                    end
                else
                    if tonumber(actualHour) ~= tonumber(Existing) then
                        local delFile = pcall(function()
                            delfile("NotSameServers.json")
                            AllIDs = {}
                            table.insert(AllIDs, actualHour)
                        end)
                    end
                end
                num = num + 1
            end
            if Possible == true then
                table.insert(AllIDs, ID)
                wait()
                pcall(function()
                    writefile("NotSameServers.json", game:GetService('HttpService'):JSONEncode(AllIDs))
                    wait()
                    game:GetService("TeleportService"):TeleportToPlaceInstance(PlaceID, ID, game.Players.LocalPlayer)
                end)
                wait(4)
            end
        end
    end
end

function Teleport()
    while wait() do
        pcall(function()
            TPReturner()
            if foundAnything ~= "" then
                TPReturner()
            end
        end)
    end
end


task.spawn(function()
    while wait() do
        game:GetService("CoreGui").RobloxPromptGui.promptOverlay.ChildAdded:Connect(function(child)
            if child.Name == 'ErrorPrompt' and child:FindFirstChild('MessageArea') and child.MessageArea:FindFirstChild("ErrorFrame") then
                Teleport()
            end
        end)
    end
end)



local Autokick = tick()
local TS = game:GetService("TeleportService")
local PL = game:GetService("Players")
spawn(function()
    while task.wait(1) do
        if AutoKickSer and (tick() - Autokick > 1800) then
            local ok, err = pcall(function()
               Teleport()
            end)
            if not ok then
                warn("TPReturner error:", err)
            else
                Autokick = tick()
            end
        end
    end
end)

local function AutoFish5()
    if autoShake3 then
        task.spawn(function()
            while AutoFish do
                local PlayerGUI = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
                local shakeUI = PlayerGUI:FindFirstChild("shakeui")
                if shakeUI and shakeUI.Enabled then
                    local safezone = shakeUI:FindFirstChild("safezone")
                    if safezone then
                        local button = safezone:FindFirstChild("button")
                        if button and button:IsA("ImageButton") and button.Visible then
                            if autoShake then
                                local pos = button.AbsolutePosition
                                local size = button.AbsoluteSize
                                VirtualInputManager:SendMouseButtonEvent(pos.X + size.X / 2, pos.Y + size.Y / 2, 0, true, game:GetService("Players").LocalPlayer, 0)
                                VirtualInputManager:SendMouseButtonEvent(pos.X + size.X / 2, pos.Y + size.Y / 2, 0, false, game:GetService("Players").LocalPlayer, 0)
                            elseif autoShake2 then
                                GuiService.SelectedObject = button
                                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
                                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
                            end
                        end
                    end
                end
                task.wait()
            end
        end)
    else
        task.spawn(function()
            while AutoFish do
                task.wait(autoShakeDelay)
                local PlayerGUI = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
                local shakeUI = PlayerGUI:FindFirstChild("shakeui")
                if shakeUI and shakeUI.Enabled then
                    local safezone = shakeUI:FindFirstChild("safezone")
                    if safezone then
                        local button = safezone:FindFirstChild("button")
                        if button and button:IsA("ImageButton") and button.Visible then
                            if autoShake then
                                local pos = button.AbsolutePosition
                                local size = button.AbsoluteSize
                                VirtualInputManager:SendMouseButtonEvent(pos.X + size.X / 2, pos.Y + size.Y / 2, 0, true, game:GetService("Players").LocalPlayer, 0)
                                VirtualInputManager:SendMouseButtonEvent(pos.X + size.X / 2, pos.Y + size.Y / 2, 0, false, game:GetService("Players").LocalPlayer, 0)
                            elseif autoShake2 then
                                GuiService.SelectedObject = button
                                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
                                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
                            end
                        end
                    end
                end
            end
        end)
    end
end

local function AntiAfkHandler()
    spawn(function()
        while AntiAfk do
            pcall(function()
                local Link = game:GetService("ReplicatedStorage"):FindFirstChild("Link") or game:GetService("ReplicatedStorage")
                Link:WaitForChild("events"):WaitForChild("afk"):FireServer(false)
            end)
            task.wait(60)
        end
    end)
end

local function AutoFreezeHandler()
    task.spawn(function()
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local rootPart = character:WaitForChild("HumanoidRootPart")
        local initialCFrame = rootPart.CFrame
        
        local bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bodyVelocity.Parent = rootPart
        
        local bodyGyro = Instance.new("BodyGyro")
        bodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        bodyGyro.D = 100
        bodyGyro.P = 10000
        bodyGyro.CFrame = initialCFrame
        bodyGyro.Parent = rootPart
        
        while AutoFreeze do
            rootPart.CFrame = initialCFrame
            task.wait(0.01)
        end
        
        if bodyVelocity then bodyVelocity:Destroy() end
        if bodyGyro then bodyGyro:Destroy() end
    end)
end

local NoclipConnection
local function EnableNoclip()
    NoclipConnection = game:GetService("RunService").Stepped:Connect(function()
        if Noclip and game.Players.LocalPlayer.Character then
            for _, v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
                if v:IsA("BasePart") and v.CanCollide then
                    v.CanCollide = false
                end
            end
        end
    end)
end

local function SellFishAndReturnAll()
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local rootPart = character:WaitForChild("HumanoidRootPart")
    local currentPosition = rootPart.CFrame
    local sellPosition = CFrame.new(464, 151, 232)
    local wasAutoFreezeActive = false
    
    if AutoFreeze then
        wasAutoFreezeActive = true
        AutoFreeze = false
    end
    
    rootPart.CFrame = sellPosition
    task.wait(0.5)
    
    pcall(function()
        game:GetService("Workspace"):WaitForChild("world"):WaitForChild("npcs"):WaitForChild("Marc Merchant"):WaitForChild("merchant"):WaitForChild("sellall"):InvokeServer()
    end)
    
    task.wait(3)
    rootPart.CFrame = currentPosition
    
    if wasAutoFreezeActive then
        AutoFreeze = true
    end
end

local function SellFishAndReturnOne()
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local rootPart = character:WaitForChild("HumanoidRootPart")
    local currentPosition = rootPart.CFrame
    local sellPosition = CFrame.new(464, 151, 232)
    local wasAutoFreezeActive = false
    
    if AutoFreeze then
        wasAutoFreezeActive = true
        AutoFreeze = false
    end
    
    rootPart.CFrame = sellPosition
    task.wait(0.5)
    
    pcall(function()
        game:GetService("Workspace"):WaitForChild("world"):WaitForChild("npcs"):WaitForChild("Marc Merchant"):WaitForChild("merchant"):WaitForChild("sell"):InvokeServer()
    end)
    
    task.wait(3)
    rootPart.CFrame = currentPosition
    
    if wasAutoFreezeActive then
        AutoFreeze = true
    end
end

local function Appraise()
    spawn(function()
        while AutoAppraiser do
            pcall(function()
                game:GetService("Workspace"):WaitForChild("world"):WaitForChild("npcs"):WaitForChild("Appraiser"):WaitForChild("appraiser"):WaitForChild("appraise"):InvokeServer()
            end)
            task.wait(0.1)
        end
    end)
end

local function OptimizePerformance()
    local Lighting = game:GetService("Lighting")
    
    Lighting.Brightness = 1
    Lighting.Ambient = Color3.fromRGB(200, 200, 200)
    Lighting.OutdoorAmbient = Color3.fromRGB(200, 200, 200)
    
    for _, obj in pairs(Lighting:GetDescendants()) do
        if obj:IsA("Atmosphere") then
            obj:Destroy()
        elseif obj:IsA("Bloom") then
            obj:Destroy()
        elseif obj:IsA("DepthOfField") then
            obj:Destroy()
        elseif obj:IsA("Sun") then
            obj.Brightness = 2
        end
    end
    
    for _, char in pairs(game.Players:GetPlayers()) do
        if char.Character then
            for _, part in pairs(char.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.Material = Enum.Material.Plastic
                end
            end
        end
    end
    
    print("✓ Performance optimized: Removed effects, simplified materials")
end

local function RestoreGraphics()
    print("Graphics restored to default")
end


local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")

local VirtualInputManager = game:GetService("VirtualInputManager")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")
local HttpService = game:GetService("HttpService")
local GuiService = game:GetService("GuiService")
local RunService = game:GetService("RunService")

getgenv().Ready = false

local PlayerName = LocalPlayer.Name

local Signals = {
    "Activated",
    "MouseButton1Down",
    "MouseButton2Down",
    "MouseButton1Click",
    "MouseButton2Click"
}
getgenv().rememberPosition = nil
print(getgenv().rememberPosition)


local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")

local function TPB(...)
    local args = {...}
    local target = args[1]
    local RealTarget

    -- === INPUT PARSING ===
    if typeof(target) == "Vector3" then
        RealTarget = CFrame.new(target)
    elseif typeof(target) == "CFrame" then
        RealTarget = target
    elseif typeof(target) == "Instance" and target:IsA("BasePart") then
        RealTarget = target.CFrame
    elseif typeof(target) == "number" and #args >= 3 then
        RealTarget = CFrame.new(args[1], args[2], args[3])
    end

end

local function TP(...)
    local args = {...}
    local targetPos = args[1]
    local RealTarget

    -- Handle different input types
    if typeof(targetPos) == "Vector3" then
        RealTarget = CFrame.new(targetPos)
    elseif typeof(targetPos) == "CFrame" then
        RealTarget = targetPos
    elseif typeof(targetPos) == "Instance" and targetPos:IsA("BasePart") then
        RealTarget = targetPos.CFrame
    elseif typeof(targetPos) == "number" then
        RealTarget = CFrame.new(unpack(args))  -- {x, y, z}
    else
        warn("TP: Invalid target type")
        return
    end

    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:WaitForChild("Humanoid")
    local root = character:WaitForChild("HumanoidRootPart")

    -- Death/respawn handler (no tween cancel needed)
    if humanoid.Health <= 0 then
        repeat task.wait() until humanoid.Health > 0
        task.wait(0.2)  -- Small buffer after respawn
        character = player.Character
        humanoid = character:WaitForChild("Humanoid")
        root = character:WaitForChild("HumanoidRootPart")
    end

    -- Instant player teleport
    root.CFrame = RealTarget
end

local autocast_running = false
local originalCastAsync = {}
local autoreel_running = false


local function GetProgressBarScale()
    local ok, result = pcall(function()
        local gui = PlayerGui
        if not gui then return nil end
        local reel = gui:FindFirstChild("reel")
        if not reel then return nil end
        local bar = reel:FindFirstChild("bar")
        if not bar then return nil end
        local progress = bar:FindFirstChild("progress")
        if not progress then return nil end
        local inner = progress:FindFirstChild("bar")
        if not inner then return nil end
        if inner.Size and inner.Size.X and type(inner.Size.X.Scale) == "number" then
            return inner.Size.X.Scale
        end
        return nil
    end)
    if ok then
        return result
    else
        return nil
    end
end


local Rellconnect

local function Reel()
    local RodState = workspace:WaitForChild("PlayerStats")[PlayerName].T[PlayerName].Stats.rod.Value
    local Mode = _G.Settings.Farm.Reel.Mode
    local Bar = _G.Settings.Farm.Reel.Bar
    local BareelProgress = _G.Settings.Farm.Reel.ReelBarprogress
    local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
    
    if playerGui then
        local reel = playerGui:FindFirstChild("reel")
        if reel then
            local bar = reel:FindFirstChild("bar")
            if bar then
                local fish = bar:FindFirstChild("fish")
                local playerbar = bar:FindFirstChild("playerbar")
                
                if fish and playerbar and fish:IsA("GuiObject") and playerbar:IsA("GuiObject") then
                    if _G.Settings.Farm.Reel.Enable then
                        if Bar == "Center" then
                            spawn(function()
                                Rellconnect = game:GetService("RunService").Heartbeat:Connect(function()
                                    pcall(function()
                                        playerbar.Position = UDim2.new(fish.Position.X.Scale, 0, playerbar.Position.Y.Scale, 0)
                                    end)
                                end)
                                if Mode == "Safe 80" then
                                    local prog = GetProgressBarScale()
                                    if prog and prog >= 0.80 then
                                        pcall(function()
                                            ReplicatedStorage.events.reelfinished:FireServer(100, true)
                                            task.wait(0.5)
                                            game:GetService("Players").LocalPlayer.Character:FindFirstChild(RodState).events.reset:FireServer()
                                        end)
                                    end
                                elseif Mode == "Fast[Risk]" then
                                    local prog = GetProgressBarScale()
                                    if prog and prog >= tonumber(BareelProgress) then
                                        pcall(function()
                                            ReplicatedStorage.events.reelfinished:FireServer(100, true)
                                            task.wait(0.5)
                                            game:GetService("Players").LocalPlayer.Character:FindFirstChild(RodState).events.reset:FireServer()
                                        end)
                                    end
                                end
                            end)
                        elseif Bar == "Large" then
                            spawn(function()
                                pcall(function()
                                    playerbar.Size = UDim2.fromScale(1,1)
                                end)
                            end)

                            if Mode == "Safe 80" then
                                local prog = GetProgressBarScale()
                                if prog and prog >= 0.80 then
                                    pcall(function()
                                        ReplicatedStorage.events.reelfinished:FireServer(100, true)
                                        task.wait(0.5)
                                        game:GetService("Players").LocalPlayer.Character:FindFirstChild(RodState).events.reset:FireServer()
                                    end)
                                end
                            elseif Mode == "Fast[Risk]" then
                                local prog = GetProgressBarScale()
                                if prog and prog > tonumber(BareelProgress) then
                                    pcall(function()
                                        ReplicatedStorage.events.reelfinished:FireServer(100, true)
                                        task.wait(0.5)
                                        game:GetService("Players").LocalPlayer.Character:FindFirstChild(RodState).events.reset:FireServer()
                                    end)
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end





task.spawn(function()
    game:GetService("RunService").Stepped:Connect(function()
        pcall(function()
            --[World 1]
            if _G.Settings.Farm.Enable
            then
                if game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    if not game:GetService("Players").LocalPlayer.Character.HumanoidRootPart:FindFirstChild("BodyVelocity1") then
                        local BodyVelocity = Instance.new("BodyVelocity")
                        BodyVelocity.Name = "BodyVelocity1"
                        BodyVelocity.Parent =  game:GetService("Players").LocalPlayer.Character.HumanoidRootPart
                        BodyVelocity.MaxForce = Vector3.new(10000, 10000, 10000)
                        BodyVelocity.Velocity = Vector3.new(0, 0, 0)
                    end
                    for _, v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
                        if v:IsA("BasePart") and v.Name ~= "bobber" and v.Name ~= "handle" then
                            v.CanCollide = false    
                        end
                    end
                    for _,v in pairs(workspace.active.boats[PlayerName][_G.Settings.Farm.SelectBoat]:GetDescendants()) do
                        if v:IsA("BasePart") then
                            v.CanCollide = false    
                            v.Anchored = false
                        end
                    end
                end
            else
                if game.Players.LocalPlayer.Character.HumanoidRootPart:FindFirstChild("BodyVelocity1") then
                    game.Players.LocalPlayer.Character.HumanoidRootPart:FindFirstChild("BodyVelocity1"):Destroy();
                end
            end
        end)
    end)
end)


local function CheckBoatSpawn()
    for i,v in pairs(workspace.active.boats:GetChildren()) do
        if v.Name == (game.Players.LocalPlayer.Name) then
            return true
        end
    end
    return false
end


if not workspace:FindFirstChild("Platform") then
    local part = Instance.new("MeshPart")
    part.Name = "Platform" -- Changed to a more appropriate name
    part.Parent = game.Workspace
    part.Anchored = true
    part.Transparency = 0
    part.Size = Vector3.new(10, 0.5, 10)
end


-- spawn(function()
--     while task.wait() do 
--         pcall(function()
--             workspace:FindFirstChild("Platform").CFrame = CFrame.new(game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.X,game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.Y -3.15,game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.Z)
--         end)
--     end
-- end)



local function rememberPosition()
    spawn(function()
        local initialCFrame = HumanoidRootPart.CFrame
 
        local bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bodyVelocity.Parent = HumanoidRootPart
 
        local bodyGyro = Instance.new("BodyGyro")
        bodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        bodyGyro.D = 100
        bodyGyro.P = 10000
        bodyGyro.CFrame = initialCFrame
        bodyGyro.Parent = HumanoidRootPart
 
        while AutoFreeze do
            HumanoidRootPart.CFrame = initialCFrame
            task.wait(0.01)
        end
        if bodyVelocity then
            bodyVelocity:Destroy()
        end
        if bodyGyro then
            bodyGyro:Destroy()
        end
    end)
end


--Hypexz provides Lucide Icons https://lucide.dev/icons/ for the tabs, icons are optional
local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "home" }),
    Rod = Window:AddTab({ Title = "Red Settings",Icon = "glass-water"}),
    Teleport = Window:AddTab{Title = "Teleport",Icon = "map"},
    Shop = Window:AddTab({Title = "Shop",Icon = "shopping-cart"}),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}



local FarmSection = Tabs.Main:AddSection("Status")


local tmme = Tabs.Main:AddParagraph({
    Title = ""
})


spawn(function()
    while wait() do
        pcall(function()
            local scripttime = game.Workspace.DistributedGameTime
            local seconds = scripttime%60
            local minutes = math.floor(scripttime/60%60)
            local hours = math.floor(scripttime/3600)
            local tempo = string.format("%.0f Hour , %.0f Minute , %.0f Second", hours ,minutes, seconds)
            tmme:SetTitle(tempo)
        end)
    end
end)

local Status = Tabs.Main:AddParagraph({
    Title = "Status : N/A"
})

local tmsme = Tabs.Main:AddParagraph({
    Title = "Status Ready : N/A"
})

spawn(function()
    while wait(1) do
        pcall(function()
            if getgenv().Ready then
                tmsme:SetTitle("Status Ready : True")
            else
                tmsme:SetTitle("Status Ready : False")
            end
        end)
    end
end)

local tmssme = Tabs.Main:AddParagraph({
    Title = "Status Farm : N/A"
})






local FarmSection = Tabs.Main:AddSection("Main")



Tabs.Main:AddButton({
    Title = "Set Position Farm",
    Callback = function()
        Window:Dialog({
            Title = "Save Notify",
            Content = "Confirm For Save Position",
            Buttons = {
                {
                    Title = "Confirm",
                    Callback = function()
                        if HumanoidRootPart then
                            _G.Settings.Farm.Position = {
                                X = HumanoidRootPart.CFrame.X,
                                Y = HumanoidRootPart.CFrame.Y,
                                Z = HumanoidRootPart.CFrame.Z,
                                Yaw = HumanoidRootPart.CFrame:ToEulerAnglesYXZ()
                            }
                            getgenv().SaveSetting()
                            savedPosition = HumanoidRootPart.CFrame
                            print("Position Saved!")
                        else
                            print("HumanoidRootPart not found!")
                        end
                    end
                },
                {
                    Title = "Cancel",
                    Callback = function()
                        print("Cancle Succ")
                    end
                }
            }
        })
    end
})

local StartFarmTogle = Tabs.Main:AddToggle("StartFarmTogle", {Title = "Enable Farm", Default = _G.Settings.Farm.Enable })
StartFarmTogle:OnChanged(function(value)
    _G.Settings.Farm.Enable = value
    getgenv().SaveSetting()
end)

local BossFarmTogle = Tabs.Main:AddToggle("BossFarmTogle", {Title = "Enable Boss Farm", Default = _G.Settings.Boss.Enable })
BossFarmTogle:OnChanged(function(value)
   _G.Settings.Boss.Enable = value
    getgenv().SaveSetting()
end)


local SellallTogle = Tabs.Main:AddToggle("SellallTogle", {Title = "Auto Sell [All]", Default = _G.Settings.Fish.SellAll })
SellallTogle:OnChanged(function(value)
    _G.Settings.Fish.SellAll = value
    getgenv().SaveSetting()
end)


local SellAllEvent = ReplicatedStorage:WaitForChild("events"):WaitForChild("SellAll")

-- Initialize sell timer
local Selltime = tick()

-- Start the auto-sell loop
spawn(function()
    while task.wait() do
        if not _G.Settings.Fish.SellAll then return end
        if tick() - Selltime >= 600 then
            local success, err = pcall(function()
                SellAllEvent:InvokeServer()
            end)
            if success then
                Selltime = tick() -- Reset timer only on success
                print("Sold all fish!",tick())
            else
                warn("Failed to sell: " .. tostring(err))
            end
        end
    end
end)


local function ChangRod(rodName)
    repeat task.wait() 
        game:GetService("ReplicatedStorage").packages.Net["RF/Rod/Equip"]:InvokeServer(rodName)
    until LocalPlayer.Backpack:FindFirstChild(rodName) or Character:FindFirstChild(rodName)
    print("Changed Rod : ",rodName)
end



local function ensureRod(rodName)
    local Backpack = LocalPlayer:WaitForChild("Backpack")
    if not Backpack:FindFirstChild(rodName) and not Character:FindFirstChild(rodName) then
        print("Ensure : ",rodName)
        repeat task.wait() 
            game:GetService("ReplicatedStorage").packages.Net["RF/Rod/Equip"]:InvokeServer(rodName)
        until LocalPlayer.Backpack:FindFirstChild(rodName) or Character:FindFirstChild(rodName)
        print("Change Rod Success",rodName)
        return
    end
end

local function ActivateTotem()
    local Equiped = Character:FindFirstChild("Sundial Totem")
    if Equiped then
        Equiped:Activate()
        return true
    end
    return false
end


local function TeleportMode()
    local Mode = _G.Settings.Farm.Mode
    if Mode == "Trash" then
        Status:SetTitle("Status : Farm Trash")
        return CFrame.new(-1143.84082, 134.632812, -1080.47131, 0.986154318, 7.84733611e-09, -0.165830299, -1.20236212e-08, 1, -2.4180201e-08, 0.165830299, 2.58392898e-08, 0.986154318)
    elseif Mode == "Money" then
        Status:SetTitle("Status : Farm Money")
        return CFrame.new(-715.607483, -864.453674, -121.647392, -0.722895741, 7.16114954e-08, 0.690957129, 3.09414503e-08, 1, -7.12693264e-08, -0.690957129, -3.01410772e-08, -0.722895741)
    elseif Mode == "Level" then
        Status:SetTitle("Status : Farm Level")
        return CFrame.new(1376.12842, -603.603577, 2337.55347, 0.945005476, -3.90646875e-08, -0.32705453, 4.45639081e-08, 1, 9.32092448e-09, 0.32705453, -2.33831532e-08, 0.945005476)
    elseif Mode == "Enchant Relic" then
        Status:SetTitle("Status : Farm Enchant Relic")
        return CFrame.new(990.893005, -737.973633, 1465.72644, -0.978376806, -8.6212566e-09, 0.206830382, -8.02586353e-09, 1, 3.71772391e-09, -0.206830382, 1.97734251e-09, -0.978376806)
    elseif Mode == "Save Position" then
        Status:SetTitle("Status : Farm Save Position")
        return savedPosition
    end
end

local function ResetrodWhennotFound(name)
    local playerStats = workspace.PlayerStats[PlayerName]
    local rodValue = playerStats.T[PlayerName].Stats.rod.Value
    local RodChar = Character:FindFirstChild(rodValue)
    local bober = RodChar and RodChar:FindFirstChild("bobber")
    local value = RodChar and RodChar:FindFirstChild("values")
    local bite = value and value:FindFirstChild("bite")
    if bober and bite.Value == true then
        for i,v in pairs(bober:GetDescendants()) do
            if v.Name == name and v:IsA("Model") then
                return true
            end
        end
    end
    return false
end



local function GetSelfDistance(Position)
    local RootPart = HumanoidRootPart
    return (RootPart.Position - Position).Magnitude
end
local function handleBossTarget(name, targetCFrame, distanceThreshold, platformStand)
    local distance = GetSelfDistance(targetCFrame.Position)
    if distance > distanceThreshold then
        game.Players.LocalPlayer.Character.Humanoid:UnequipTools()
    end

    TP(targetCFrame)

    if platformStand then
        -- game.Players.LocalPlayer.Character.Humanoid.PlatformStand = true
    end

    if distance < distanceThreshold then
        getgenv().Ready = true
    end
end

local function handleBossTargetB(name, targetCFrame, distanceThreshold, platformStand)
    local distance = GetSelfDistance(targetCFrame.Position)
    if distance > distanceThreshold then
        game.Players.LocalPlayer.Character.Humanoid:UnequipTools()
    end

    TPB(targetCFrame)

    -- if name == "Forsaken Veil - Scylla" then
    --     if ResetrodWhennotFound("Scylla") == false then
    --         game.Players.LocalPlayer.Character.Humanoid:UnequipTools()
    --     end
    -- end

    if platformStand then
        -- game.Players.LocalPlayer.Character.Humanoid.PlatformStand = true
    end

    if distance < distanceThreshold then
        getgenv().Ready = true
    end
end

local function CheckBoss()
    local Zone = workspace.zones
    local fish = Zone:FindFirstChild("Fishing")
    local SelectedTable = _G.Settings.Boss.SelectBoss
    if type(SelectedTable) ~= "table" then return nil end

    local bossEventNames = {}
    for name in pairs(SelectedTable) do
        bossEventNames[name] = true
    end

    for _, obj in ipairs(workspace.zones.fishing:GetChildren()) do
        if obj:IsA("Part") then
            if bossEventNames[obj.Name] then
                return obj.Name --, "zone"
            end
        end
    end

    return nil 
end


local function CheckBoss2()
    local bossList = _G.Settings.Boss.SelectBoss
    local players = game:GetService("Players")

    if type(bossList) ~= "table" then return nil end

    -- Convert bossList keys to a lookup set for faster access
    local bossNames = {}
    for name in pairs(bossList) do
        bossNames[name] = true
    end

    for _, obj in ipairs(workspace:GetChildren()) do
        if obj:IsA("Model") and not players:GetPlayerFromCharacter(obj) then
            if bossNames[obj.Name] then
                return obj.Name
            end
        end
    end

    return nil
    
end


local function CheckAuroraTotem()
    AuroraTotem = LocalPlayer.Backpack:FindFirstChild("Aurora Totem") or Character:FindFirstChild("Aurora Totem")
    if AuroraTotem then
        return true
    else
        return false
    end
end

local function Checkweather()
    local WorldFolder = ReplicatedStorage:WaitForChild("world")
    local WeatherValue = WorldFolder:WaitForChild("weather").Value
    if WeatherValue:match("Aurora") then
        return true
    else
        return false
    end
end

local function CheckDayNight()
    local WorldFolder = ReplicatedStorage:WaitForChild("world")
    local CycleValue = WorldFolder:WaitForChild("cycle").Value
    if CycleValue == "Day" then
        return "Day"
    elseif CycleValue == "Night" then
        return "Night"
    else
        return "Dusk"
    end
end



spawn(function()

    local Players = game:GetService("Players")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local RunService = game:GetService("RunService")
    local Workspace = game:GetService("Workspace")

    local LocalPlayer = Players.LocalPlayer
    local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
    local Backpack = LocalPlayer:WaitForChild("Backpack")
    local Humanoid = Character:WaitForChild("Humanoid")


    local BOSS_TARGETS = {
        ["Elder Mossjaw"] = {
            cframe = CFrame.new(-4861.78271, -1793.96008, -10126.1406, 0.999018729, 9.09287579e-08, -0.0442892015, -9.21281185e-08, 1, -2.50390126e-08, 0.0442892015, 2.90947231e-08, 0.999018729),
            threshold = 10
        },
        ["MossjawHunt"] = {
            cframe = CFrame.new(-4861.78271, -1793.96008, -10126.1406, 0.999018729, 9.09287579e-08, -0.0442892015, -9.21281185e-08, 1, -2.50390126e-08, 0.0442892015, 2.90947231e-08, 0.999018729),
            threshold = 10
        },
        ["Forsaken Veil - Scylla"] = {
            cframe = CFrame.new(-2508.34229, -11224.4805, 6893.28467, -0.0316809788, -3.53211824e-08, -0.99949801, 2.09912301e-08, 1, -3.60042769e-08, 0.99949801, -2.21213448e-08, -0.0316809788),
            threshold = 10
        },
        ["Megalodon Default"] = {
            offset = Vector3.new(0, 20, 0),
            zone = "Megalodon Default",
            threshold = 10,
            platformStand = true
        },
        ["Megalodon Ancient"] = {
            offset = Vector3.new(0, 20, 0),
            zone = "Megalodon Ancient",
            threshold = 10,
            platformStand = true
        },
        ["The Kraken Pool"] = {
            offset = Vector3.new(0, 70, 0),
            zone = "The Kraken Pool",
            threshold = 10,
            platformStand = true
        },
        ["Ancient Kraken Pool"] = {
            offset = Vector3.new(0, 70, 0),
            zone = "Ancient Kraken Pool",
            threshold = 10,
            platformStand = true
        },
        ["Orcas Pool"] = {
            offset = Vector3.new(0, 90, 0),
            zone = "Orcas Pool",
            threshold = 10,
            platformStand = true
        },
        ["Ancient Orcas Pool"] = {
            offset = Vector3.new(0, 90, 0),
            zone = "Ancient Orcas Pool",
            threshold = 10,
            platformStand = true
        },
        ["FischFright25"] = {
            offset = Vector3.new(0, 80, 0),
            zone = "FischFright25",
            threshold = 10,
            platformStand = true
        },
        ["Whales Pool"] = {
            offset = Vector3.new(0, 80, 0),
            zone = "Whales Pool",
            threshold = 10,
            platformStand = true
        },
        ["Colossal Blue Dragon"] = {
            offset = Vector3.new(0, -10, 0),
            zone = "Colossal Blue Dragon",
            threshold = 10,
            platformStand = true
        },
        ["Colossal Ethereal Dragon"] = {
            offset = Vector3.new(0, -10, 0),
            zone = "Colossal Ethereal Dragon",
            threshold = 10,
            platformStand = true
        },
        ["Colossal Ancient Dragon"] = {
            offset = Vector3.new(0, -10, 0),
            zone = "Colossal Ancient Dragon",
            threshold = 10,
            platformStand = true
        },
    }

    local ZonesFolder = Workspace:WaitForChild("zones"):WaitForChild("fishing")
    local function getBossTargetCFrame(info)
        if info.cframe then
            return info.cframe
        elseif info.zone then
            local zone = ZonesFolder:FindFirstChild(info.zone)
            if zone then
                return zone.CFrame * CFrame.new(info.offset or Vector3.zero)
            end
        end
        return nil
    end


    RunService.Heartbeat:Connect(function()
        if not _G.Settings.Farm.Enable then
            getgenv().Ready = false
            return
        end

        xpcall(function()

            local WorldFolder = ReplicatedStorage:WaitForChild("world")
            local WeatherValue = WorldFolder:WaitForChild("weather").Value
            local CycleValue = WorldFolder:WaitForChild("cycle").Value
            local ZonesFolder = Workspace:WaitForChild("zones"):WaitForChild("fishing")

            local ROD_SCYLLA = _G.Settings.Farm.Rod.ScyllaRod or "Rod Of The Zenith"
            local ROD_MOSSJAW = _G.Settings.Farm.Rod.MossjawRod or "Elder Mossripper"
            local ROD_MAIN = _G.Settings.Farm.Rod.FarmRod or "Tryhard Rod"

            local Settings = _G.Settings
            local Farm = Settings.Farm
            local Boss = Settings.Boss
            local ModeFarm = Farm.Mode

            local Totem = Backpack:FindFirstChild("Sundial Totem")
            local EquippedTotem = Character:FindFirstChild("Sundial Totem")
            local BossSpawn = CheckBoss() or CheckBoss2()
            local BossInfo = BossSpawn and BOSS_TARGETS[BossSpawn]

           
    
            if Farm.EnableBoat then
                if CheckBoatSpawn() == false then
                    print("Buy Boat ",_G.Settings.Farm.SelectBoat)
                    TP(CFrame.new(357.625305, 133.644257, 257.625977, 0.0732683763, -5.62927838e-09, 0.997312248, 1.60819891e-09, 1, 5.52630119e-09, -0.997312248, 1.19897337e-09, 0.0732683763))
                    local args = {
                        [1] = {
                            ["voice"] = 8,
                            ["idle"] = workspace:WaitForChild("world"):WaitForChild("npcs"):WaitForChild("Moosewood Shipwright"):WaitForChild("description"):WaitForChild("idle"),
                            ["npc"] = workspace:WaitForChild("world"):WaitForChild("npcs"):WaitForChild("Moosewood Shipwright")
                        }
                    }

                    workspace:WaitForChild("world"):WaitForChild("npcs"):WaitForChild("Moosewood Shipwright"):WaitForChild("shipwright"):WaitForChild("giveUI"):InvokeServer(unpack(args))
                    local args = {
                            [1] = _G.Settings.Farm.SelectBoat
                        }
                        game:GetService("ReplicatedStorage"):WaitForChild("packages"):WaitForChild("Net"):WaitForChild("RF/Boats/Spawn"):InvokeServer(unpack(args))
                    repeat task.wait()
                    until CheckBoatSpawn() == true
                    if game:GetService("Players").LocalPlayer.PlayerGui.hud.safezone.shipwright.Visible == true then
                        game:GetService("Players").LocalPlayer.PlayerGui.hud.safezone.shipwright.Visible = false
                    end
                elseif CheckBoatSpawn() then
                    if Character.Humanoid.Sit == false then
                        for _,x in pairs(workspace.active.boats:GetChildren()) do
                            if x.Name == game.Players.LocalPlayer.Name then
                                local CBoat = x:FindFirstChild(_G.Settings.Farm.SelectBoat)
                                if CBoat then
                                    for i,v in pairs(CBoat:GetDescendants()) do
                                        if v:IsA("ProximityPrompt") and v.Name == "sitprompt" then
                                            fireproximityprompt(v)
                                        end
                                    end
                                end
                            end
                        end
                    else
                        if Boss.Enable then
                            if BossSpawn and BossInfo then
                                AutoFreeze = false
                                if BossSpawn == "Forsaken Veil - Scylla" then
                                    ensureRod(ROD_SCYLLA)
                                elseif BossSpawn == "Elder Mossjaw" or BossSpawn == "MossjawHunt" then
                                    ensureRod(ROD_MOSSJAW)
                                else 
                                    ensureRod(ROD_MAIN)
                                end

                                local targetCFrame = getBossTargetCFrame(BossInfo)
                                if targetCFrame then
                                    Status:SetTitle("Status : Farm "..BossSpawn)
                                    handleBossTargetB(BossSpawn, targetCFrame, BossInfo.threshold, BossInfo.platformStand)
                                    return
                                end
                            end


                            if Boss.Mode == "Re Day" then
                                Status:SetTitle("Status : Re Day Find Boss")
                                if not WeatherValue:match("Aurora") then
                                    if EquippedTotem then
                                        local currentCycle = CycleValue
                                        if currentCycle == "Day" or currentCycle == "Night" then
                                            task.wait(1)
                                            ClickCamera()
                                            repeat task.wait() until not Settings.Farm.Enable or Boss.Mode ~= "Re Day" or WorldFolder:WaitForChild("cycle").Value ~= currentCycle
                                        end
                                    else
                                        Humanoid:EquipTool(Totem)
                                    end
                                else
                                    ensureRod(ROD_MAIN)
                                    if ModeFarm == "Save Position" then
                                        AutoFreeze = false
                                        Status:SetTitle("Status : Position")
                                        TPB(savedPosition)
                                    else
                                        Status:SetTitle("Status : Non Position")
                                        rememberPosition()
                                        AutoFreeze = true
                                    end
                                    getgenv().Ready = true
                                end
                            else
                                ensureRod(ROD_MAIN)
                                if ModeFarm == "Save Position" then
                                    AutoFreeze = false
                                    Status:SetTitle("Status : Position")
                                    TPB(savedPosition)
                                else
                                    Status:SetTitle("Status : Non Position")
                                    rememberPosition()
                                    AutoFreeze = true
                                end
                                getgenv().Ready = true
                            end
                        else
                            ensureRod(ROD_MAIN)
                            if ModeFarm == "Save Position" then
                                AutoFreeze = false
                                Status:SetTitle("Status : Position")
                                TPB(savedPosition)
                            else
                                Status:SetTitle("Status : Non Position")
                                rememberPosition()
                                AutoFreeze = true
                            end
                            getgenv().Ready = true
                        end
                    end
                end
            else
                if Boss.Enable then
                    if BossSpawn and BossInfo then
                        AutoFreeze = false
                        -- if BossSpawn == "Forsaken Veil - Scylla" then
                        --     ensureRod(ROD_SCYLLA)
                        -- elseif BossSpawn == "Elder Mossjaw" or BossSpawn == "MossjawHunt" then
                        --     ensureRod(ROD_MOSSJAW)
                        -- else 
                        --     ensureRod(ROD_MAIN)
                        -- end

                        

                        local targetCFrame = getBossTargetCFrame(BossInfo)
                        if targetCFrame then
                            Status:SetTitle("Status : Farm "..tostring(BossSpawn))
                            handleBossTarget(BossSpawn, targetCFrame, BossInfo.threshold, BossInfo.platformStand)
                            return
                        end
                    end


                    if Boss.Mode == "Re Day" then
                        Status:SetTitle("Status : Re Day Find Boss")
                        if not WeatherValue:match("Aurora") then
                            if EquippedTotem then
                                local currentCycle = CycleValue
                                EquippedTotem:Activate()
                                repeat task.wait(1)
                                    CycleValue = WorldFolder:WaitForChild("cycle").Value
                                until CycleValue ~= currentCycle or not Settings.Farm.Enable or Boss.Mode ~= "Re Day"
                            else
                                Humanoid:EquipTool(Totem)
                            end
                        else
                            -- ensureRod(ROD_MAIN)
                            TP(TeleportMode())
                            getgenv().Ready = true
                        end
                    else
                        -- ensureRod(ROD_MAIN)
                        TP(TeleportMode())
                        getgenv().Ready = true
                    end
                else
                    -- ensureRod(ROD_MAIN)
                    TP(TeleportMode())
                    getgenv().Ready = true
                end
            end
        end, warn)
    end)
end)

local function CheckSundialTotem()
    SundialTotem = LocalPlayer.Backpack:FindFirstChild("Sundial Totem") or Character:FindFirstChild("Sundial Totem")
    if SundialTotem then
        return true
    else
        return false
    end
end

local function CheckRainBow()
    local WorldFolder = ReplicatedStorage:WaitForChild("world")
    local WeatherValue = WorldFolder:WaitForChild("weather").Value
    if WeatherValue:match("Rainbow") then
        return true
    else
        return false
    end
end

local function equipTool(toolName)
	local backpack = LocalPlayer:WaitForChild("Backpack")
	for _, item in pairs(backpack:GetChildren()) do
		if item:IsA("Tool") and item.Name == toolName then
			item.Parent = LocalPlayer.Character
			print(toolName .. " equipped.")
			return item
		end
	end
	print(toolName .. " not found in backpack!")
	return nil
end

local function unequipTool(toolName)
	local char = LocalPlayer.Character
	if char then
		for _, item in pairs(char:GetChildren()) do
			if item:IsA("Tool") and item.Name == toolName then
				item.Parent = LocalPlayer.Backpack
				print(toolName .. " unequipped.")
			end
		end
	end
end

local function useTool(tool)
	if tool and tool:IsA("Tool") then
		task.wait(0.3)
		tool:Activate()
		print(tool.Name .. " used.")
	end
end

local world = ReplicatedStorage:WaitForChild("world")
local cycle = world:WaitForChild("cycle")
local weather = world:WaitForChild("weather")


local function CheckInventory(itemName)
    local character = LocalPlayer.Character
    local backpack = game:GetService("Players").LocalPlayer:FindFirstChild("Backpack") -- LocalPlayer:FindFirstChild("Backpack")
    if not character:FindFirstChild(itemName) and not backpack:FindFirstChild(itemName) then 
        return false 
    end
    return true
end


-- local lastCheck = 0
-- local RESET_TIME = 10
-- local LastReel = tick()
-- spawn(function()
--     while RunService.Heartbeat:Wait() do
--         if getgenv().Ready then 

--             local BOSS_TARGETS = {
--                 ["Elder Mossjaw"] = {
--                     cframe = CFrame.new(-4861.78271, -1793.96008, -10126.1406, 0.999018729, 9.09287579e-08, -0.0442892015, -9.21281185e-08, 1, -2.50390126e-08, 0.0442892015, 2.90947231e-08, 0.999018729),
--                     threshold = 10
--                 },
--                 ["MossjawHunt"] = {
--                     cframe = CFrame.new(-4861.78271, -1793.96008, -10126.1406, 0.999018729, 9.09287579e-08, -0.0442892015, -9.21281185e-08, 1, -2.50390126e-08, 0.0442892015, 2.90947231e-08, 0.999018729),
--                     threshold = 10
--                 },
--                 ["Forsaken Veil - Scylla"] = {
--                     cframe = CFrame.new(-2508.34229, -11224.4805, 6893.28467, -0.0316809788, -3.53211824e-08, -0.99949801, 2.09912301e-08, 1, -3.60042769e-08, 0.99949801, -2.21213448e-08, -0.0316809788),
--                     threshold = 10
--                 },
--                 ["Megalodon Default"] = {
--                     offset = Vector3.new(0, 20, 0),
--                     zone = "Megalodon Default",
--                     threshold = 10,
--                     platformStand = true
--                 },
--                 ["Megalodon Ancient"] = {
--                     offset = Vector3.new(0, 20, 0),
--                     zone = "Megalodon Ancient",
--                     threshold = 10,
--                     platformStand = true
--                 },
--                 ["The Kraken Pool"] = {
--                     offset = Vector3.new(0, 70, 0),
--                     zone = "The Kraken Pool",
--                     threshold = 10,
--                     platformStand = true
--                 },
--                 ["Ancient Kraken Pool"] = {
--                     offset = Vector3.new(0, 70, 0),
--                     zone = "Ancient Kraken Pool",
--                     threshold = 10,
--                     platformStand = true
--                 },
--                 ["Orcas Pool"] = {
--                     offset = Vector3.new(0, 90, 0),
--                     zone = "Orcas Pool",
--                     threshold = 10,
--                     platformStand = true
--                 },
--                 ["Ancient Orcas Pool"] = {
--                     offset = Vector3.new(0, 90, 0),
--                     zone = "Ancient Orcas Pool",
--                     threshold = 10,
--                     platformStand = true
--                 },
--                 ["FischFright25"] = {
--                     offset = Vector3.new(0, 80, 0),
--                     zone = "FischFright25",
--                     threshold = 10,
--                     platformStand = true
--                 },
--                 ["Whales Pool"] = {
--                     offset = Vector3.new(0, 80, 0),
--                     zone = "Whales Pool",
--                     threshold = 10,
--                     platformStand = true
--                 },
--                 ["Colossal Blue Dragon"] = {
--                     offset = Vector3.new(0, -10, 0),
--                     zone = "Colossal Blue Dragon",
--                     threshold = 10,
--                     platformStand = true
--                 },
--                 ["Colossal Ethereal Dragon"] = {
--                     offset = Vector3.new(0, -10, 0),
--                     zone = "Colossal Ethereal Dragon",
--                     threshold = 10,
--                     platformStand = true
--                 },
--                 ["Colossal Ancient Dragon"] = {
--                     offset = Vector3.new(0, -10, 0),
--                     zone = "Colossal Ancient Dragon",
--                     threshold = 10,
--                     platformStand = true
--                 },
--             }
            
--             local function equipAndUseSundial()
--                 unequipTool("Aurora Totem")
--                 local sundial = equipTool("Sundial Totem")
--                 if sundial then
--                     useTool(sundial)
--                 end
--             end

--             local function equipAndUseAurora()
--                 unequipTool("Sundial Totem")
--                 local aurora = equipTool("Aurora Totem")
--                 if aurora then
--                     useTool(aurora)
--                 end
--             end

--             local success, result = pcall(function()
--                 local playerStats = workspace.PlayerStats[PlayerName]
--                 local rodValue = playerStats.T[PlayerName].Stats.rod.Value
--                 local rodCharacter = Character:FindFirstChild(rodValue)
--                 local rodTool = LocalPlayer.Backpack:FindFirstChild(rodValue)
--                 local ShakeDelay = _G.Settings.Farm.Shake.Delay
--                 local CastMode = _G.Settings.Farm.Cast.Mode
--                 local AuroraTotem, SundialTotem = Character:FindFirstChild("Aurora Totem"), Character:FindFirstChild("Sundial Totem")

--                 tmssme:SetTitle("Status Farm : True")


--                 if AutoAurora and CheckAuroraTotem() and CheckSundialTotem() and not Checkweather() and not CheckRainBow() then
--                     if cycle.Value == "Day" then
--                         equipAndUseSundial()
--                         local connection
--                         connection = cycle:GetPropertyChangedSignal("Value"):Connect(function()
--                             if cycle.Value == "Night" then
--                                 connection:Disconnect()
--                                 equipAndUseAurora()
--                                 if weather.Value ~= "Aurora_Borealis" then
--                                     weather:GetPropertyChangedSignal("Value"):Wait()
--                                 end
--                             end
--                         end)
--                     elseif cycle.Value == "Night" then
--                         equipAndUseAurora()
--                         local connection1
--                         connection1 = cycle:GetPropertyChangedSignal("Value"):Connect(function()
--                             if cycle.Value == "Day" then
--                                 connection1:Disconnect()
--                                 equipAndUseSundial()
--                                 local connection2
--                                 connection2 = cycle:GetPropertyChangedSignal("Value"):Connect(function()
--                                     if cycle.Value == "Night" then
--                                         connection2:Disconnect()
--                                         equipAndUseAurora()
--                                         if weather.Value ~= "Aurora_Borealis" then
--                                             weather:GetPropertyChangedSignal("Value"):Wait()
--                                         end
--                                     end
--                                 end)
--                             end
--                         end)
--                     end
--                 end


--                 local ROD_SCYLLA = _G.Settings.Farm.Rod.ScyllaRod or "Rod Of The Zenith"
--                 local ROD_MOSSJAW = _G.Settings.Farm.Rod.MossjawRod or "Elder Mossripper"
--                 local ROD_MAIN = _G.Settings.Farm.Rod.FarmRod or "Tryhard Rod"
--                 local Rod_Event = _G.Settings.Farm.Rod.Admin_Event or "Cerulean Fang Rod"


--                 local Settings = _G.Settings
--                 local Farm = Settings.Farm
--                 local Boss = Settings.Boss
--                 local ModeFarm = Farm.Mode
--                 local BossSpawn = CheckBoss() or CheckBoss2()
--                 local EventState = game:GetService("ReplicatedStorage").world.admin_event.Value


--                 local RodSelect
--                 if EventState ~= "None" then
--                     if not CheckInventory(Rod_Event) then
--                         print(Rod_Event.." not found in inventory")
--                         ChangRod(Rod_Event)
--                         RodSelect = Rod_Event
--                     else
--                         RodSelect = Rod_Event
--                     end
--                 elseif Boss.Enable then
--                     if BossSpawn then
--                         if BossSpawn == "Forsaken Veil - Scylla" then
--                             if not CheckInventory(ROD_SCYLLA) then
--                                 print(ROD_SCYLLA.." not found in inventory")
--                                 ChangRod(ROD_SCYLLA)
--                                 RodSelect = ROD_SCYLLA
--                             else
--                                 RodSelect = ROD_SCYLLA
--                             end
--                         elseif BossSpawn == "Elder Mossjaw" or BossSpawn == "MossjawHunt" then
--                             if not CheckInventory(ROD_MOSSJAW) then
--                                 print(ROD_MOSSJAW.." not found in inventory")
--                                 ChangRod(ROD_MOSSJAW)
--                                 RodSelect = ROD_MOSSJAW
--                             else
--                                 RodSelect = ROD_MOSSJAW
--                             end
--                         else 
--                             if not CheckInventory(ROD_MAIN) then
--                                 print(ROD_MAIN.." not found in inventory")
--                                 ChangRod(ROD_MAIN)
--                                 RodSelect = ROD_MAIN
--                             else
--                                 RodSelect = ROD_MAIN
--                             end
--                         end
--                     else
--                         if not CheckInventory(ROD_MAIN) then
--                             print(ROD_MAIN.." not found in inventory")
--                             ChangRod(ROD_MAIN)
--                             RodSelect = ROD_MAIN
--                         else
--                             RodSelect = ROD_MAIN
--                         end
--                     end
--                 else
--                     if not CheckInventory(ROD_MAIN) then
--                         print(ROD_MAIN.." not found in inventory")
--                         ChangRod(ROD_MAIN)
--                         RodSelect = ROD_MAIN
--                     else
--                         RodSelect = ROD_MAIN
--                     end
--                 end


                
--                 if not Character:FindFirstChild(RodSelect) then
--                     print("wait for equip tool ",RodSelect)
--                     repeat RunService.Heartbeat:Wait() until LocalPlayer.Backpack:FindFirstChild(RodSelect) or not getgenv().Ready
--                     if LocalPlayer.Backpack:FindFirstChild(RodSelect) then
--                         print("Equip Tool ",RodSelect)
--                         LocalPlayer.Character.Humanoid:EquipTool(LocalPlayer.Backpack:FindFirstChild(RodSelect))
--                     end
--                     rodCharacter = Character:FindFirstChild(RodSelect)
--                     print("wait for rod ",RodSelect)
--                     repeat RunService.Heartbeat:Wait() 
--                         rodCharacter = Character:FindFirstChild(RodSelect)
--                     until rodCharacter or not getgenv().Ready
--                     print("Found rod ",RodSelect)
--                 else
--                     repeat RunService.Heartbeat:Wait()
--                         -- print("fishing...")
--                         local rodCharacter = Character:FindFirstChild(RodSelect)
--                         local bobber = rodCharacter:FindFirstChild("bobber")
--                         local shakeUi = PlayerGui:FindFirstChild("shakeui")
--                         local reelUi = PlayerGui:FindFirstChild("reel")
--                         if not bobber and _G.Settings.Farm.Cast.Enable then
--                             print("cast")
--                             local castPower = (_G.Settings.Farm.Cast.Mode == "Perfect" and 100) or (_G.Settings.Farm.Cast.Mode == "Random" and math.random(75,100)) or 100
--                             rodCharacter.events.castAsync:InvokeServer(castPower, 1)
--                             repeat wait() until rodCharacter:FindFirstChild("bobber") or not getgenv().Ready or not Character:FindFirstChild(RodSelect)
--                         elseif shakeUi and _G.Settings.Farm.Shake.Enable then
--                             print("shake")
--                             repeat RunService.Heartbeat:Wait(ShakeDelay)
--                                 local safezone = shakeUi:FindFirstChild("safezone")
--                                 local button = safezone and safezone:FindFirstChild("button")
--                                 if button then
--                                     GuiService.SelectedObject = button
--                                     if GuiService.SelectedObject == button then
--                                         VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
--                                         VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
--                                     end
--                                 end
--                                 shakeUi = PlayerGui:FindFirstChild("shakeui")
--                             until not shakeUi or not getgenv().Ready or not Character:FindFirstChild(RodSelect)
--                         elseif reelUi and _G.Settings.Farm.Reel.Enable then
--                             print("reel")
--                             local RodState = workspace:WaitForChild("PlayerStats")[PlayerName].T[PlayerName].Stats.rod.Value
--                             local Mode = _G.Settings.Farm.Reel.Mode
--                             local Bar = _G.Settings.Farm.Reel.Bar
--                             local BareelProgress = _G.Settings.Farm.Reel.ReelBarprogress
--                             local playerGui = LocalPlayer:FindFirstChild("PlayerGui")

--                             -- repeat RunService.Heartbeat:Wait()
--                                 local reel = PlayerGui:FindFirstChild("reel")
--                                 local bar = reel and reel:FindFirstChild("bar")
--                                 local playerbar = bar and bar:FindFirstChild("playerbar")
--                                 playerbar:GetPropertyChangedSignal('Position'):Wait()
--                                 task.wait(1)
--                                 pcall(function()
--                                     game.ReplicatedStorage:WaitForChild("events"):WaitForChild("reelfinished"):FireServer(100, true)
--                                 end)
--                                 repeat wait() until not PlayerGui:FindFirstChild("reel") or not getgenv().Ready or not Character:FindFirstChild(RodSelect)
--                                 print("Reel Finished")
--                                 -- until not playerbar or not getgenv().Ready or not Character:FindFirstChild(RodSelect)
--                         end
--                     until not getgenv().Ready or not Character:FindFirstChild(RodSelect)
--                 end
--             end)
            
--             if not success then
--                 warn("Error:", result)
--             end
--         else
--             tmssme:SetTitle("Status Farm : False")
--         end
--     end
-- end)

task.spawn(function()
    while task.wait() do
        if getgenv().Ready then
            local BOSS_TARGETS = {
                ["Elder Mossjaw"] = {
                    cframe = CFrame.new(-4861.78271, -1793.96008, -10126.1406, 0.999018729, 9.09287579e-08, -0.0442892015, -9.21281185e-08, 1, -2.50390126e-08, 0.0442892015, 2.90947231e-08, 0.999018729),
                    threshold = 10
                },
                ["MossjawHunt"] = {
                    cframe = CFrame.new(-4861.78271, -1793.96008, -10126.1406, 0.999018729, 9.09287579e-08, -0.0442892015, -9.21281185e-08, 1, -2.50390126e-08, 0.0442892015, 2.90947231e-08, 0.999018729),
                    threshold = 10
                },
                ["Forsaken Veil - Scylla"] = {
                    cframe = CFrame.new(-2508.34229, -11224.4805, 6893.28467, -0.0316809788, -3.53211824e-08, -0.99949801, 2.09912301e-08, 1, -3.60042769e-08, 0.99949801, -2.21213448e-08, -0.0316809788),
                    threshold = 10
                },
                ["Megalodon Default"] = {
                    offset = Vector3.new(0, 20, 0),
                    zone = "Megalodon Default",
                    threshold = 10,
                    platformStand = true
                },
                ["Megalodon Ancient"] = {
                    offset = Vector3.new(0, 20, 0),
                    zone = "Megalodon Ancient",
                    threshold = 10,
                    platformStand = true
                },
                ["The Kraken Pool"] = {
                    offset = Vector3.new(0, 70, 0),
                    zone = "The Kraken Pool",
                    threshold = 10,
                    platformStand = true
                },
                ["Ancient Kraken Pool"] = {
                    offset = Vector3.new(0, 70, 0),
                    zone = "Ancient Kraken Pool",
                    threshold = 10,
                    platformStand = true
                },
                ["Orcas Pool"] = {
                    offset = Vector3.new(0, 90, 0),
                    zone = "Orcas Pool",
                    threshold = 10,
                    platformStand = true
                },
                ["Ancient Orcas Pool"] = {
                    offset = Vector3.new(0, 90, 0),
                    zone = "Ancient Orcas Pool",
                    threshold = 10,
                    platformStand = true
                },
                ["FischFright25"] = {
                    offset = Vector3.new(0, 80, 0),
                    zone = "FischFright25",
                    threshold = 10,
                    platformStand = true
                },
                ["Whales Pool"] = {
                    offset = Vector3.new(0, 80, 0),
                    zone = "Whales Pool",
                    threshold = 10,
                    platformStand = true
                },
                ["Colossal Blue Dragon"] = {
                    offset = Vector3.new(0, -10, 0),
                    zone = "Colossal Blue Dragon",
                    threshold = 10,
                    platformStand = true
                },
                ["Colossal Ethereal Dragon"] = {
                    offset = Vector3.new(0, -10, 0),
                    zone = "Colossal Ethereal Dragon",
                    threshold = 10,
                    platformStand = true
                },
                ["Colossal Ancient Dragon"] = {
                    offset = Vector3.new(0, -10, 0),
                    zone = "Colossal Ancient Dragon",
                    threshold = 10,
                    platformStand = true
                },
            }


            local suc , err = pcall(function()
                tmssme:SetTitle("Status Farm : True")
                local ShakeDelay = _G.Settings.Farm.Shake.Delay
                local CastMode = _G.Settings.Farm.Cast.Mode
                -----------------------------
                local ROD_SCYLLA = _G.Settings.Farm.Rod.ScyllaRod or "Rod Of The Zenith"
                local ROD_MOSSJAW = _G.Settings.Farm.Rod.MossjawRod or "Elder Mossripper"
                local ROD_MAIN = _G.Settings.Farm.Rod.FarmRod or "Tryhard Rod"
                local Rod_Event = _G.Settings.Farm.Rod.Admin_Event or "Cerulean Fang Rod"
                -----------------------------
                local Settings = _G.Settings
                local Farm = Settings.Farm
                local Boss = Settings.Boss
                local ModeFarm = Farm.Mode
                local BossSpawn = CheckBoss() or CheckBoss2()
                local EventState = game:GetService("ReplicatedStorage").world.admin_event.Value


                _G.RodSelect = nil
                if EventState ~= "None" then
                    _G.RodSelect = Rod_Event
                elseif Boss.Enable then
                    if BossSpawn then
                        if BossSpawn == "Forsaken Veil - Scylla" then
                            _G.RodSelect = ROD_SCYLLA
                        elseif BossSpawn == "Elder Mossjaw" or BossSpawn == "MossjawHunt" then
                            _G.RodSelect = ROD_MOSSJAW
                        else 
                            _G.RodSelect = ROD_MAIN
                        end
                    else
                        _G.RodSelect = ROD_MAIN
                    end
                else
                    _G.RodSelect = ROD_MAIN
                end



                if not Character:FindFirstChild(_G.RodSelect) then
                    if not LocalPlayer.Backpack:FindFirstChild(_G.RodSelect) then
                        ChangRod(_G.RodSelect)
                        -- print("Changing Rod to : ",_G.RodSelect)
                    end
                    print("wait for equip tool : ",_G.RodSelect)
                    repeat RunService.Heartbeat:Wait(1) until LocalPlayer.Backpack:FindFirstChild(_G.RodSelect) or not getgenv().Ready
                    if LocalPlayer.Backpack:FindFirstChild(_G.RodSelect) then
                        print("Equip Tool : ",_G.RodSelect)
                        LocalPlayer.Character.Humanoid:EquipTool(LocalPlayer.Backpack:FindFirstChild(_G.RodSelect))
                    end
                    repeat RunService.Heartbeat:Wait(1) until Character:FindFirstChild(_G.RodSelect) or not getgenv().Ready
                    print("Equiped Rod : ",_G.RodSelect)
                end

                local rodCharacter = Character:FindFirstChild(_G.RodSelect)
                local bobber = rodCharacter:FindFirstChild("bobber")
                local ShakeUi = PlayerGui:FindFirstChild("shakeui")
                local ReelUi = PlayerGui:FindFirstChild("reel")

                if not bobber and _G.Settings.Farm.Cast.Enable then
                    print("cast")
                    local castPower = (_G.Settings.Farm.Cast.Mode == "Perfect" and 100) or (_G.Settings.Farm.Cast.Mode == "Random" and math.random(75,100)) or 100
                    rodCharacter.events.castAsync:InvokeServer(castPower, math.huge)
                    task.wait(0.5)
                end

                if ShakeUi and _G.Settings.Farm.Shake.Enable then
                    print("shake")
                    repeat 
                        RunService.Heartbeat:Wait(ShakeDelay)
                        local safezone = ShakeUi:FindFirstChild("safezone")
                        local button = safezone and safezone:FindFirstChild("button")
                        if button then
                            GuiService.SelectedObject = button
                            if GuiService.SelectedObject == button then
                                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
                                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
                            end
                        end
                        ShakeUi = PlayerGui:FindFirstChild("shakeui")
                    until not ShakeUi or not getgenv().Ready or not Character:FindFirstChild(_G.RodSelect)
                end

                if ReelUi and _G.Settings.Farm.Reel.Enable then
                    print("reel")
                    pcall(function()
                        local reel = PlayerGui:FindFirstChild("reel")
                        local bar = reel and reel:FindFirstChild("bar")
                        local playerbar = bar and bar:FindFirstChild("playerbar")
                        playerbar:GetPropertyChangedSignal('Position'):Wait()
                        print("Reel Position Changed")
                        task.wait(0.8)
                        game.ReplicatedStorage:WaitForChild("events"):WaitForChild("reelfinished"):FireServer(100, true)
                    end)
                    repeat task.wait() until not PlayerGui:FindFirstChild("reel") or not getgenv().Ready or not Character:FindFirstChild(_G.RodSelect)
                    print("Reel Finished")
                end
            end)

            if not suc then
                warn("Error:", err)
            end
        end
    end
end)

local FarmSection = Tabs.Main:AddSection("Setting Farm")

local Mfv = Tabs.Main:AddDropdown("Mfv", {
    Title = "Select Mode Farm",
    Values = {"Money","Trash","Level","Enchant Relic","Save Position","Freeze"},
    Multi = false,
    Default = _G.Settings.Farm.Mode,
})

Mfv:OnChanged(function(Value)
    _G.Settings.Farm.Mode = Value
    getgenv().SaveSetting()
end)


local CMV = Tabs.Main:AddDropdown("CMV", {
    Title = "Select Mode Cast",
    Values = {"Perfect","Random"},
    Multi = false,
    Default = _G.Settings.Farm.Cast.Mode,
})

CMV:OnChanged(function(Value)
    _G.Settings.Farm.Cast.Mode = Value
    getgenv().SaveSetting()
end)



local SSDL = Tabs.Main:AddInput("SSDL", {
    Title = "Set Shake Delay",
    Default = _G.Settings.Farm.Shake["Delay"],
    Numeric = true, -- Only allows numbers
    Finished = true, -- Only calls callback when you press enter
    Callback = function(Value)
        _G.Settings.Farm.Shake["Delay"] = Value
        getgenv().SaveSetting()
    end
})

-- local SRBPDL = Tabs.Main:AddInput("SRBPDL", {
--     Title = "Set Reel Barprogress[Fast Mode only]",
--     Default = _G.Settings.Farm.Reel.ReelBarprogress,
--     Numeric = true, -- Only allows numbers
--     Finished = true, -- Only calls callback when you press enter
--     Callback = function(Value)
--         _G.Settings.Farm.Reel.ReelBarprogress = Value
--         getgenv().SaveSetting()
--     end
-- })

-- local RMV = Tabs.Main:AddDropdown("RMV", {
--     Title = "Select Bar Reel",
--     Values = {"Center","Large"},
--     Multi = false,
--     Default = _G.Settings.Farm.Reel.Bar,
-- })

-- RMV:OnChanged(function(Value)
--     _G.Settings.Farm.Reel.Bar = Value
--     getgenv().SaveSetting()
-- end)

-- local RMV = Tabs.Main:AddDropdown("RMV", {
--     Title = "Select Mode Reel",
--     Values = {"Safe 80","Fast[Risk]"},
--     Multi = false,
--     Default = _G.Settings.Farm.Reel.Mode,
-- })

-- RMV:OnChanged(function(Value)
--     _G.Settings.Farm.Reel.Mode = Value
--     getgenv().SaveSetting()
-- end)

local Myboat = {}
local PlayersStats = workspace.PlayerStats[PlayerName].T[PlayerName].Boats
for i,v in pairs(PlayersStats:GetChildren()) do
    table.insert(Myboat,v.Name)
end

table.sort(Myboat,function(a,b) return a:lower() < b:lower() end)

local Selectb = Tabs.Main:AddDropdown("Selectb", {
    Title = "Select Boat",
    Values = Myboat,
    Multi = false,
    Default = _G.Settings.Farm.SelectBoat,
})

Selectb:OnChanged(function(Value)
    _G.Settings.Farm.SelectBoat = Value
    getgenv().SaveSetting()
end)


local FarmSection = Tabs.Main:AddSection("Boss")

bosslist = {
    "FischFright25",
    "Elder Mossjaw",
    "MossjawHunt",
    "Forsaken Veil - Scylla",
    "Megalodon Default",
    "Megalodon Ancient",
    "The Kraken Pool",
    "Ancient Kraken Pool",
    "Orcas Pool",
    "Whales Pool",
    "Ancient Orcas Pool",
    "Colossal Blue Dragon",
    "Colossal Ethereal Dragon",
    "Colossal Ancient Dragon"
}

local MultiDropdown = Tabs.Main:AddDropdown("MultiDropdown", {
    Title = "Select Boss",
    Description = "Select Boss Farm",
    Values = bosslist,
    Multi = true,
    Default = _G.Settings.Boss.SelectBoss,
})


MultiDropdown:OnChanged(function(Value)
    _G.Settings.Boss.SelectBoss = Value
    getgenv().SaveSetting()
end)


local SelectModeFarmBoss = Tabs.Main:AddDropdown("SelectModeFarmBoss", {
    Title = "Select Mode Farm Boss",
    Description = "Select Mode Farm Boss",
    Values = {"With Farm","Re Day"},
    Multi = false,
    Default =  _G.Settings.Boss.Mode,
})


SelectModeFarmBoss:OnChanged(function(Value)
    _G.Settings.Boss.Mode = Value
    getgenv().SaveSetting()
end)


local FarmSection = Tabs.Main:AddSection("Crab Cage")



local PlaceCrabcage = Tabs.Main:AddToggle("PlaceCrabcage", {Title = "Auto Place Crab Cage", Default = false })

PlaceCrabcage:OnChanged(function(value)
    startAutoPlace = value
end)

spawn(function()
    while task.wait() do
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local crabCage = character:FindFirstChild("Crab Cage")
        pcall(function()
            if startAutoPlace then
                local events = game:GetService("ReplicatedStorage"):FindFirstChild("events")
                if events then
                    local cancelEmote = events:FindFirstChild("CancelEmote")
                    if cancelEmote then
                        cancelEmote:FireServer()
                    end
                end
                if LocalPlayer.Backpack:FindFirstChild("Crab Cage") then
                    Character.Humanoid:EquipTool(game.Players.LocalPlayer.Backpack:FindFirstChild("Crab Cage"))
                elseif Character:FindFirstChild("Crab Cage") then
                    if crabCage and crabCage:FindFirstChild("Deploy") then
                        -- -- local args = {
                        -- --     [1] = CFrame.new(character.HumanoidRootPart.Position)
                        -- -- }
                        -- crabCage.Deploy:FireServer(CFrame.new(character.HumanoidRootPart.Position))
                    Character:FindFirstChild("Crab Cage").Deploy:FireServer(game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame)
                    end
                    task.wait(0.1)
                else
                    Fluent:Notify({
                        Title = "Hypexz v2",
                        Content = "No Crab Cage",
                        Duration = 3
                    })
                    Options.PlaceCrabcage:SetValue(false)
                    return
                end
            end
        end)
    end
end)

local CollectCrabcage = Tabs.Main:AddToggle("CollectCrabcage", {Title = "Auto Collect Crab Cage", Default = false })

CollectCrabcage:OnChanged(function(value)
    AutoCollectCrabCage = value
end)

local skibidy

spawn(function()
    while task.wait() do
        if AutoCollectCrabCage then
            for i,v in pairs(workspace.active.crabcages:GetDescendants()) do
                if v.Name == PlayerName then
                    local prompt = v.Prompt
                    if prompt then
                        prompt.HoldDuration = 0
                        fireproximityprompt(prompt)
                    end
                end
            end
        end
    end
end)

spawn(function()
    while wait() do
        for i,v in pairs(workspace.active.crabcages:GetDescendants()) do
            if v:IsA("Part") or v:IsA("MeshPart") then
                v.Transparency = 1
            end
        end
    end
end)

local AutobuyCrabCage = Tabs.Main:AddToggle("AutobuyCrabCage", {Title = "Auto Buy Crab Cage", Default = false })

AutobuyCrabCage:OnChanged(function(value)
    AutobuyCrabCagevalue = value
end)

spawn(function()
    while task.wait() do
        if AutobuyCrabCagevalue then
            pcall(function()
                TP(CFrame.new(474.875, 150.50001525878906, 232.84576416015625))
                for i, v in pairs(workspace.world.interactables["Crab Cage"]:GetChildren()) do
                    if v.Name == "Crab Cage" then
                        for j, z in pairs(v:GetChildren()) do
                            if z.Name == "PromptTemplate" and z:IsA("ProximityPrompt") then
                                fireproximityprompt(z)
                            end
                        end
                    end
                end

                task.wait(0.1)
                for i,v in pairs(game:GetService("Players").LocalPlayer.PlayerGui.over:GetDescendants()) do
                    if v:IsA("TextBox") and v.Name == "amount" then
                        v.Text = 50
                    end
                end
                for _, v in pairs(game:GetService("Players").LocalPlayer.PlayerGui.over:GetDescendants()) do
                    if v:IsA("ImageButton") or v:IsA("TextButton") and v.Name == 'confirm' then
                        for i, Signal in pairs(Signals) do
                            firesignal(v[Signal])
                        end
                    end
                end
            end)
        end
    end
end)


local FarmSection = Tabs.Main:AddSection("Treasure Hunt")

local AutoRepairtoggle = Tabs.Main:AddToggle("AutoRepairtoggle", {Title = "Auto Repair Map", Default = false })

AutoRepairtoggle:OnChanged(function(value)
    AutoRepair = value
end)

spawn(function()
    while task.wait() do
        if AutoRepair then
            local Player = game.Players.LocalPlayer
            local Jack = workspace.world.npcs:FindFirstChild("Jack Marrow")
            if not Jack then 
                TP(CFrame.new(-2824.359, 214.311, 1518.130))
                repeat wait() until workspace.world.npcs:FindFirstChild("Jack Marrow") or not  AutoRepair
            else
                for _, v in pairs(Player.Backpack:GetChildren()) do
                    if v.Name == "Treasure Map" then
                        Player.Character.Humanoid:EquipTool(v)
                        workspace.world.npcs["Jack Marrow"].treasure.repairmap:InvokeServer()
                    end
                end
            end
        end
    end
end)


local AutoOpenChestToggle = Tabs.Main:AddToggle("AutoOpenChestToggle", {Title = "Auto Open Cheast", Default = false })

AutoOpenChestToggle:OnChanged(function(value)
    AutoOpenChest = value
end)

spawn(function()
    while task.wait() do
        if AutoOpenChest then
            for _, v in ipairs(workspace.world.chests:GetDescendants()) do
                if v.ClassName == "ProximityPrompt" then
                    v.HoldDuration = 0
                end
            end

            for _, v in pairs(workspace.world.chests:GetDescendants()) do
                if v:IsA("Part") and v:FindFirstChild("ChestSetup") then
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.CFrame
                    for _, prompt in pairs(workspace.world.chests:GetDescendants()) do
                        if prompt.Name == "ProximityPrompt" then
                            fireproximityprompt(prompt)
                        end
                    end
                    task.wait(1)
                end
            end
        end
    end
end)

local FarmSection = Tabs.Main:AddSection("Enable Setting")

local EnableCastToggle = Tabs.Main:AddToggle("EnableCastToggle", {Title = "Enable Cast", Default = _G.Settings.Farm.Cast.Enable })

EnableCastToggle:OnChanged(function(value)
    _G.Settings.Farm.Cast.Enable = value
    getgenv().SaveSetting()
end)

local EnableShakeToggle = Tabs.Main:AddToggle("EnableShakeToggle", {Title = "Enable Shake", Default = _G.Settings.Farm.Shake.Enable })

EnableShakeToggle:OnChanged(function(value)
    _G.Settings.Farm.Shake.Enable = value
    getgenv().SaveSetting()
end)

local EnableReelToggle = Tabs.Main:AddToggle("EnableReelToggle", {Title = "Enable Reel", Default = _G.Settings.Farm.Reel.Enable })

EnableReelToggle:OnChanged(function(value)
    _G.Settings.Farm.Reel.Enable = value
    getgenv().SaveSetting()
end)


local EnableBoatToggle = Tabs.Main:AddToggle("EnableBoatToggle", {Title = "Enable Farm WithBoat", Default = _G.Settings.Farm.EnableBoat })

EnableBoatToggle:OnChanged(function(value)
    _G.Settings.Farm.EnableBoat = value
    getgenv().SaveSetting()
end)

local FarmSection = Tabs.Rod:AddSection("Rod Setting")

local PathRod = workspace.PlayerStats[PlayerName].T[PlayerName].Rods
local RodNames = {}
local RodNameSet = {}

for _, v in pairs(PathRod:GetChildren()) do
    if not RodNameSet[v.Name] then
        table.insert(RodNames, v.Name)
        RodNameSet[v.Name] = true
    end
end

table.sort(RodNames, function(a, b)
    return a:lower() < b:lower()
end)

local SelectRodm = Tabs.Rod:AddDropdown("SelectRodm", {
    Title = "Select Main Rod",
    Values = RodNames,
    Multi = false,
    Default = _G.Settings.Farm.Rod.FarmRod,
})

SelectRodm:OnChanged(function(value)
    _G.Settings.Farm.Rod.FarmRod = value
    getgenv().SaveSetting()
end)

local SelectRodsc = Tabs.Rod:AddDropdown("SelectRodsc", {
    Title = "Select Scylla Rod",
    Values = RodNames,
    Multi = false,
    Default = _G.Settings.Farm.Rod.ScyllaRod,
})

SelectRodsc:OnChanged(function(value)
    _G.Settings.Farm.Rod.ScyllaRod = value
    getgenv().SaveSetting()
end)

local SelectRodmj = Tabs.Rod:AddDropdown("SelectRodmj", {
    Title = "Select MossJaw Rod",
    Values = RodNames,
    Multi = false,
    Default = _G.Settings.Farm.Rod.MossjawRod,
})

SelectRodmj:OnChanged(function(value)
    _G.Settings.Farm.Rod.MossjawRod = value
    getgenv().SaveSetting()
end)


local SelectRodam = Tabs.Rod:AddDropdown("SelectRodam", {
    Title = "Select Admin Event Rod",
    Values = RodNames,
    Multi = false,
    Default = _G.Settings.Farm.Rod.Admin_Event,
})

SelectRodam:OnChanged(function(value)
    _G.Settings.Farm.Rod.Admin_Event = value
    getgenv().SaveSetting()
end)


Tabs.Rod:AddButton({
    Title = "Refresh Rod List",
    Description = "Refresh Rod List",
    Callback = function()
        table.Clear(RodNames)
        for _, v in pairs(PathRod:GetChildren()) do
            RodNameSet[v.Name] = false
            if not RodNameSet[v.Name] then
                table.insert(RodNames, v.Name)
                RodNameSet[v.Name] = true
            end
        end
        table.sort(RodNames, function(a, b)
            return a:lower() < b:lower()
        end)
        Options.SelectRodm:UpdateOptions(RodNames)
        Options.SelectRodsc:UpdateOptions(RodNames)
        Options.SelectRodmj:UpdateOptions(RodNames)
        Options.SelectRodam:UpdateOptions(RodNames)
    end
})


local extraTPs = {
    {
        Name = "Carrot Garden", Position = Vector3.new(3744, -1116, -1108)
    },
    {
        Name = "Crystal Cove",
        Position = Vector3.new(1364, -612, 2472)
    },
    {
        Name = "Underground Music Venue",
        Position = Vector3.new(2043, -645, 2471)
    },
    {
        Name = "Castaway Cliffs",
        Position = Vector3.new(655, 179, -1793)
    },
    {
        Name = "Luminescent Cavern",
        Position = Vector3.new(-1016, -337, -4071)
    },
    {
        Name = "Crimson Cavern",
        Position = Vector3.new(-1013, -340, -4891)
    },
    {
        Name = "Oscar's Locker",
        Position = Vector3.new(266, -387, 3407)
    },
    {
        Name = "The Boom Ball",
        Position = Vector3.new(-1296, -900, -3479)
    },
    {
        Name = "Lost Jungle",
        Position = Vector3.new(-2690, 149, -2051)
    }
}

local tpFolder = workspace:WaitForChild("world"):WaitForChild("spawns"):WaitForChild("TpSpots")

local tpNames = {}
for _, spot in ipairs(tpFolder:GetChildren()) do
    table.insert(tpNames, spot.Name)
end

for _, tp in ipairs(extraTPs) do
    table.insert(tpNames, tp.Name)
end

table.sort(tpNames,function(a,b) return a:lower() < b:lower() end)

local teleport_running = false
local function StartTeleport()
    if teleport_running then return end
    teleport_running = true
    
    local hrp = Character.HumanoidRootPart
    local spot = tpFolder:FindFirstChild(selectedIsland)

    if not spot then
        for _, tp in ipairs(extraTPs) do
            if tp.Name == selectedIsland then
                spot = {CFrame = CFrame.new(tp.Position)}
                break
            end
        end
    end

    if hrp and spot then
        pcall(function() hrp.CFrame = spot.CFrame + Vector3.new(0,5,0) end)
    end
    task.wait()

teleport_running = false

end

local SelectTplocla = Tabs.Teleport:AddDropdown("", {
    Title = "Select Location",
    Values = tpNames,
    Multi = false,
    Default = 1,
})


SelectTplocla:OnChanged(function(Value)
    selectedIsland = Value
end)

Tabs.Teleport:AddButton({
    Title = "Teleport",
    Description = "",
    Callback = function()
        StartTeleport()
    end
})


local FarmSection = Tabs.Teleport:AddSection("Enchant")

local Encchantlist = {
    "Abyssal",
    "Blessed",
    "Blood Reckoning",
    "Breezed",
    "Chaotic",
    "Chronos",
    "Clever",
    "Controlled",
    "Divine",
    "Flashline",
    "Ghastly",
    "Hasty",
    "Insight",
    "Long",
    "Lucky",
    "Momentum",
    "Mutated",
    "Noir",
    "Quality",
    "Resilient",
    "Scavenger",
    "Sea King",
    "Scrapper",
    "Steady",
    "Storming",
    "Swift",
    "Unbreakable",
    "Wormhole"
}

table.sort(Encchantlist,function(a,b) return a:lower() < b:lower() end)

local SelectEnc = Tabs.Teleport:AddDropdown("SelectEnc", {
    Title = "Select Enchant",
    Values = Encchantlist,
    Multi = false,
    Default = 1,
})

SelectEnc:OnChanged(function(value)
    SelectedEnc = value
end)


local SatrtEnchant = Tabs.Teleport:AddToggle("SatrtEnchant", {Title = "Start Enchant", Default = false })


SatrtEnchant:OnChanged(function(value)
    AutoEnchant = value
end)

 spawn(function()
    while task.wait() do
        -- local suc , err = pcall(function()
            if AutoEnchant then
                local RodState = workspace:WaitForChild("PlayerStats")[PlayerName].T[PlayerName].Stats.rod.Value
                if workspace.PlayerStats[PlayerName].T[PlayerName].Rods[RodState].Value == SelectedEnc then
                    Fluent:Notify({
                        Title = "Hypexz v2",
                        Content = (RodState.." : Found Enc : "..SelectedEnc),
                        Duration = 3
                    })
                    Options.SatrtEnchant:SetValue(false)
                    return
                end
                TP(CFrame.new(1309.2786865234375, -802.427001953125, -83.36397552490234))
                wait(.2)
                if not game.Players.LocalPlayer.Character:FindFirstChild("Enchant Relic") then
                    EnchantRelic = nil
                    for _, v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
                        if v:IsA('Tool') and v.Name == 'Enchant Relic' then
                            EnchantRelic = v
                        end
                    end
                    game.Players.LocalPlayer.Character.Humanoid:EquipTool(EnchantRelic)
                else
                    for _, Enchant in pairs(workspace.world.interactables:GetChildren()) do
                        if Enchant:IsA('Model') and Enchant.Name == 'Enchant Altar' then
                            Enchant.PromptTemplate.HoldDuration = 0
                            if workspace.world.interactables["Enchant Altar"].PromptTemplate.Enabled == true then
                                fireproximityprompt(Enchant.PromptTemplate)
                            end
                            wait(0.3)
                            if game:GetService("Players").LocalPlayer.PlayerGui.over:FindFirstChild("prompt") then
                                for _, Button in pairs(game:GetService("Players").LocalPlayer.PlayerGui.over:GetDescendants()) do
                                    if Button:IsA("ImageButton") or Button:IsA("TextButton") and Button.Name == 'confirm' then
                                        for i, Signal in pairs(Signals) do
                                            firesignal(Button[Signal])
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        -- end)
    end
end)


local ExaltedList = {
    "Anomalous",
    "Herculean",
    "Immortal",
    "Invincible",
    "Mystical",
    "Piercing",
    "Quantum",
    "Sea Overlord"
}

table.sort(ExaltedList,function(a,b) return a:lower() < b:lower() end)

local SelectExEnc = Tabs.Teleport:AddDropdown("SelectExEnc", {
    Title = "Select Exalted Enchant",
    Values = ExaltedList,
    Multi = false,
    Default = 1,
})

SelectExEnc:OnChanged(function(value)
    SelectedExEnc = value
end)


local SatrtExEnchant = Tabs.Teleport:AddToggle("SatrtExEnchant", {Title = "Start Exalted Enchant", Default = false })


SatrtExEnchant:OnChanged(function(value)
    AutoExEnchant = value
    local RodState = workspace:WaitForChild("PlayerStats")[PlayerName].T[PlayerName].Stats.rod.Value
    spawn(function()
        while task.wait() do
            -- xpcall(function()
                if AutoExEnchant then
                    if workspace.PlayerStats[PlayerName].T[PlayerName].Rods[RodState].Value == SelectedExEnc then
                        Fluent:Notify({
                            Title = "Hypexz v2",
                            Content = (RodState.." : Found Enc : "..SelectedExEnc),
                            Duration = 3
                        })
                        Options.SatrtEnchant:SetValue(false)
                        return
                    end
                    TP(CFrame.new(1309.2786865234375, -802.427001953125, -83.36397552490234))
                    wait(.2)
                    if not game.Players.LocalPlayer.Character:FindFirstChild("Exalted Relic") then
                        EnchantRelic = nil
                        for _, v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
                            if v:IsA('Tool') and v.Name == 'Exalted Relic' then
                                EnchantRelic = v
                            end
                        end
                        game.Players.LocalPlayer.Character.Humanoid:EquipTool(EnchantRelic)
                    else
                        for _, Enchant in pairs(workspace.world.interactables:GetChildren()) do
                            if Enchant:IsA('Model') and Enchant.Name == 'Enchant Altar' then
                                Enchant.PromptTemplate.HoldDuration = 0
                                if workspace.world.interactables["Enchant Altar"].PromptTemplate.Enabled == true then
                                    fireproximityprompt(Enchant.PromptTemplate)
                                end
                                wait(1)
                                if game:GetService("Players").LocalPlayer.PlayerGui.over:FindFirstChild("prompt") then
                                    for _, Button in pairs(game:GetService("Players").LocalPlayer.PlayerGui.over:GetDescendants()) do
                                        if Button:IsA("ImageButton") or Button:IsA("TextButton") and Button.Name == 'confirm' then
                                            for i, Signal in pairs(Signals) do
                                                firesignal(Button[Signal])
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            -- end,print)
        end
    end)
end)


local CosmicList = {
    "Cryogenic",
    "Glittered",
    "Overclocked",
    "Sea Prince",
    "Tenacity",
    "Tryhard",
    "Wise"
}

local FarmSection = Tabs.Teleport:AddSection("Server")

local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local placeId = game.PlaceId
local jobId = game.JobId
local function rejoinServer()
    TeleportService:TeleportToPlaceInstance(placeId, jobId, player)
end



Tabs.Teleport:AddButton({
    Title = "Rejoin Server",
    Description = "Rejoin Your Server",
    Callback = function()
       game:GetService("TeleportService"):Teleport(game.PlaceId)
    end
})

Tabs.Teleport:AddButton({
    Title = "Vip Server",
    Description = "Create Vip Server",
    Callback = function()
       local md5 = {}
        local hmac = {}
        local base64 = {}

        do
            do
                local T = {
                    0xd76aa478,
                    0xe8c7b756,
                    0x242070db,
                    0xc1bdceee,
                    0xf57c0faf,
                    0x4787c62a,
                    0xa8304613,
                    0xfd469501,
                    0x698098d8,
                    0x8b44f7af,
                    0xffff5bb1,
                    0x895cd7be,
                    0x6b901122,
                    0xfd987193,
                    0xa679438e,
                    0x49b40821,
                    0xf61e2562,
                    0xc040b340,
                    0x265e5a51,
                    0xe9b6c7aa,
                    0xd62f105d,
                    0x02441453,
                    0xd8a1e681,
                    0xe7d3fbc8,
                    0x21e1cde6,
                    0xc33707d6,
                    0xf4d50d87,
                    0x455a14ed,
                    0xa9e3e905,
                    0xfcefa3f8,
                    0x676f02d9,
                    0x8d2a4c8a,
                    0xfffa3942,
                    0x8771f681,
                    0x6d9d6122,
                    0xfde5380c,
                    0xa4beea44,
                    0x4bdecfa9,
                    0xf6bb4b60,
                    0xbebfbc70,
                    0x289b7ec6,
                    0xeaa127fa,
                    0xd4ef3085,
                    0x04881d05,
                    0xd9d4d039,
                    0xe6db99e5,
                    0x1fa27cf8,
                    0xc4ac5665,
                    0xf4292244,
                    0x432aff97,
                    0xab9423a7,
                    0xfc93a039,
                    0x655b59c3,
                    0x8f0ccc92,
                    0xffeff47d,
                    0x85845dd1,
                    0x6fa87e4f,
                    0xfe2ce6e0,
                    0xa3014314,
                    0x4e0811a1,
                    0xf7537e82,
                    0xbd3af235,
                    0x2ad7d2bb,
                    0xeb86d391,
                }

                local function add(a, b)
                    local lsw = bit32.band(a, 0xFFFF) + bit32.band(b, 0xFFFF)
                    local msw = bit32.rshift(a, 16) + bit32.rshift(b, 16) + bit32.rshift(lsw, 16)
                    return bit32.bor(bit32.lshift(msw, 16), bit32.band(lsw, 0xFFFF))
                end

                local function rol(x, n)
                    return bit32.bor(bit32.lshift(x, n), bit32.rshift(x, 32 - n))
                end

                local function F(x, y, z)
                    return bit32.bor(bit32.band(x, y), bit32.band(bit32.bnot(x), z))
                end
                local function G(x, y, z)
                    return bit32.bor(bit32.band(x, z), bit32.band(y, bit32.bnot(z)))
                end
                local function H(x, y, z)
                    return bit32.bxor(x, bit32.bxor(y, z))
                end
                local function I(x, y, z)
                    return bit32.bxor(y, bit32.bor(x, bit32.bnot(z)))
                end

                function md5.sum(message)
                    local a, b, c, d = 0x67452301, 0xefcdab89, 0x98badcfe, 0x10325476

                    local message_len = #message
                    local padded_message = message .. "\128"
                    while #padded_message % 64 ~= 56 do
                        padded_message = padded_message .. "\0"
                    end

                    local len_bytes = ""
                    local len_bits = message_len * 8
                    for i = 0, 7 do
                        len_bytes = len_bytes .. string.char(bit32.band(bit32.rshift(len_bits, i * 8), 0xFF))
                    end
                    padded_message = padded_message .. len_bytes

                    for i = 1, #padded_message, 64 do
                        local chunk = padded_message:sub(i, i + 63)
                        local X = {}
                        for j = 0, 15 do
                            local b1, b2, b3, b4 = chunk:byte(j * 4 + 1, j * 4 + 4)
                            X[j] = bit32.bor(b1, bit32.lshift(b2, 8), bit32.lshift(b3, 16), bit32.lshift(b4, 24))
                        end

                        local aa, bb, cc, dd = a, b, c, d

                        local s = { 7, 12, 17, 22, 5, 9, 14, 20, 4, 11, 16, 23, 6, 10, 15, 21 }

                        for j = 0, 63 do
                            local f, k, shift_index
                            if j < 16 then
                                f = F(b, c, d)
                                k = j
                                shift_index = j % 4
                            elseif j < 32 then
                                f = G(b, c, d)
                                k = (1 + 5 * j) % 16
                                shift_index = 4 + (j % 4)
                            elseif j < 48 then
                                f = H(b, c, d)
                                k = (5 + 3 * j) % 16
                                shift_index = 8 + (j % 4)
                            else
                                f = I(b, c, d)
                                k = (7 * j) % 16
                                shift_index = 12 + (j % 4)
                            end

                            local temp = add(a, f)
                            temp = add(temp, X[k])
                            temp = add(temp, T[j + 1])
                            temp = rol(temp, s[shift_index + 1])

                            local new_b = add(b, temp)
                            a, b, c, d = d, new_b, b, c
                        end

                        a = add(a, aa)
                        b = add(b, bb)
                        c = add(c, cc)
                        d = add(d, dd)
                    end

                    local function to_le_hex(n)
                        local s = ""
                        for i = 0, 3 do
                            s = s .. string.char(bit32.band(bit32.rshift(n, i * 8), 0xFF))
                        end
                        return s
                    end

                    return to_le_hex(a) .. to_le_hex(b) .. to_le_hex(c) .. to_le_hex(d)
                end
            end

            do
                function hmac.new(key, msg, hash_func)
                    if #key > 64 then
                        key = hash_func(key)
                    end

                    local o_key_pad = ""
                    local i_key_pad = ""
                    for i = 1, 64 do
                        local byte = (i <= #key and string.byte(key, i)) or 0
                        o_key_pad = o_key_pad .. string.char(bit32.bxor(byte, 0x5C))
                        i_key_pad = i_key_pad .. string.char(bit32.bxor(byte, 0x36))
                    end

                    return hash_func(o_key_pad .. hash_func(i_key_pad .. msg))
                end
            end

            do
                local b = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"

                function base64.encode(data)
                    return (
                        (data:gsub(".", function(x)
                            local r, b_val = "", x:byte()
                            for i = 8, 1, -1 do
                                r = r .. (b_val % 2 ^ i - b_val % 2 ^ (i - 1) > 0 and "1" or "0")
                            end
                            return r
                        end) .. "0000"):gsub("%d%d%d?%d?%d?%d?", function(x)
                            if #x < 6 then
                                return ""
                            end
                            local c = 0
                            for i = 1, 6 do
                                c = c + (x:sub(i, i) == "1" and 2 ^ (6 - i) or 0)
                            end
                            return b:sub(c + 1, c + 1)
                        end) .. ({ "", "==", "=" })[#data % 3 + 1]
                    )
                end
            end
        end

        local function GenerateReservedServerCode(placeId)
            local uuid = {}
            for i = 1, 16 do
                uuid[i] = math.random(0, 255)
            end

            uuid[7] = bit32.bor(bit32.band(uuid[7], 0x0F), 0x40) -- v4
            uuid[9] = bit32.bor(bit32.band(uuid[9], 0x3F), 0x80) -- RFC 4122

            local firstBytes = ""
            for i = 1, 16 do
                firstBytes = firstBytes .. string.char(uuid[i])
            end

            local gameCode =
                string.format("%02x%02x%02x%02x-%02x%02x-%02x%02x-%02x%02x-%02x%02x%02x%02x%02x%02x", table.unpack(uuid))

            local placeIdBytes = ""
            local pIdRec = placeId
            for _ = 1, 8 do
                placeIdBytes = placeIdBytes .. string.char(pIdRec % 256)
                pIdRec = math.floor(pIdRec / 256)
            end

            local content = firstBytes .. placeIdBytes

            local SUPERDUPERSECRETROBLOXKEYTHATTHEYDIDNTCHANGEEVERSINCEFOREVER = "e4Yn8ckbCJtw2sv7qmbg" -- legacy leaked key from ages ago that still works due to roblox being roblox.
            local signature = hmac.new(SUPERDUPERSECRETROBLOXKEYTHATTHEYDIDNTCHANGEEVERSINCEFOREVER, content, md5.sum)

            local accessCodeBytes = signature .. content

            local accessCode = base64.encode(accessCodeBytes)
            accessCode = accessCode:gsub("+", "-"):gsub("/", "_")

            local pdding = 0
            accessCode, _ = accessCode:gsub("=", function()
                pdding = pdding + 1
                return ""
            end)

            accessCode = accessCode .. tostring(pdding)

            return accessCode, gameCode
        end

        local accessCode, _ = GenerateReservedServerCode(game.PlaceId)
        game.RobloxReplicatedStorage.ContactListIrisInviteTeleport:FireServer(game.PlaceId, "", accessCode)
    end
})


local FarmSection = Tabs.Shop:AddSection("Totem")


local TotemList = {
    "Aurora",
    "Sundial",
    "Windset",
    "Smokescreen",
    "Tempest"
}

table.sort(TotemList,function(a,b) return a:lower() < b:lower() end)

local SelectTotem = Tabs.Shop:AddDropdown("SelectTotem", {
    Title = "Select Totem",
    Values = TotemList,
    Multi = false,
    Default = 1,
})

SelectTotem:OnChanged(function(Value)
    SelectedTOtem = Value
end)

local TotemInfo = {
    ["Aurora"] = CFrame.new(-1811, -137, -3282),
    ["Sundial"] = CFrame.new(-1148, 135, -1075),
    ["Windset"] = CFrame.new(2849, 178, 2702),
    ["Smokescreen"] = CFrame.new(2789, 140, -625),
    ["Tempest"] = CFrame.new(35, 133, 1943)
}

Tabs.Shop:AddButton({
    Title = "Teleport To Totem",
    Description = "warp To Selected Totem",
    Callback = function()
        TP(TotemInfo[SelectedTOtem])
    end
})

local BaitsList = {
    "Bait Crate",
    "Quality Bait Crate",
    "Tropical Bait Crate",
    "Coral Geode"
}


local BaitInfo = {
    ["Bait Crate"] = CFrame.new(-1470, 133, 669),
    ["Quality Bait Crate"] = CFrame.new(-220.0375518798828, 134.93197631835938, 1891.3602294921875),
    ["Tropical Bait Crate"] = CFrame.new(-922.9197998046875, 131.4174041748047, -1104.6754150390625),
    ["Coral Geode"] = CFrame.new(-1645, -210, -2855)
}

table.sort(BaitsList,function(a,b) return a:lower() < b:lower() end)

local SelectBait = Tabs.Shop:AddDropdown("SelectBait", {
    Title = "Select Bait Create",
    Values = BaitsList,
    Multi = false,
    Default = 1,
})


SelectBait:OnChanged(function(Value)
    SelectedBait = Value
end)


local AmountBait = Tabs.Shop:AddInput("AmountBait", {
    Title = "Bait [per 1t ime]",
    Default = 50,
    Numeric = true, 
    Finished = true,
    Callback = function(Value)
        AmountBaitValue = Value
        print(AmountBaitValue)
    end
})

local StatBuyBait = Tabs.Shop:AddToggle("StatBuyBait", {Title = "Start Buy Bait", Default = false })

StatBuyBait:OnChanged(function(value)
    pstartbuy = value
end)

spawn(function()
    while task.wait() do
        if pstartbuy then 
            local suc , err = pcall(function()
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = BaitInfo[SelectedBait]
                if SelectedBait == "Tropical Bait Crate" then
                    for _, v in pairs(workspace:GetDescendants()) do
                        if v:IsA('Model') and v.Name == "Tropical Bait Crate" then
                            local nested = v:FindFirstChild("Tropical Bait Crate")
                            if nested and nested:FindFirstChild("PromptTemplate") then
                                local prompt = nested.PromptTemplate
                                if prompt:IsA("ProximityPrompt") then
                                    fireproximityprompt(prompt)
                                end
                            end
                        end
                    end
                else
                    for _, v in pairs(workspace.world.interactables:GetDescendants()) do
                        if v:IsA('Model') and v.Name == SelectedBait then
                            for _, x in pairs(v:GetDescendants()) do
                                if x:IsA('ProximityPrompt') and x.Name == 'PromptTemplate' then
                                    fireproximityprompt(x)
                                end
                            end
                        end
                    end 
                end
                task.wait()
                for i,v in pairs(game:GetService("Players").LocalPlayer.PlayerGui.over:GetDescendants()) do
                    if v:IsA("TextBox") and v.Name == "amount" then
                        v.Text = tonumber(AmountBaitValue)
                    end
                end

                local Signals = {
                    "Activated",
                    "MouseButton1Down",
                    "MouseButton2Down",
                    "MouseButton1Click",
                    "MouseButton2Click"
                }
                for _, v in pairs(game:GetService("Players").LocalPlayer.PlayerGui.over:GetDescendants()) do
                    if v:IsA("ImageButton") or v:IsA("TextButton") and v.Name == 'confirm' then
                        for i, Signal in pairs(Signals) do
                            firesignal(v[Signal])
                        end
                    end
                end
            end)
            if not suc then
                warn(err)  
            end
        end
    end
end)

local Openbiat = Tabs.Shop:AddToggle("Openbiat", {Title = "Auto Open Bait", Default = false })

Openbiat:OnChanged(function(value)
    AutoOpenBait = value
end)


spawn(function()
    while RunService.Heartbeat:Wait() do
        if AutoOpenBait then 
            if LocalPlayer.Backpack:FindFirstChild(SelectedBait) then
                Character.Humanoid:EquipTool(LocalPlayer.Backpack:FindFirstChild(SelectedBait))
            elseif Character:FindFirstChild(SelectedBait) then
                game:GetService("VirtualUser"):CaptureController()
                game:GetService("VirtualUser"):ClickButton1(Vector2.new(851, 158), game:GetService("Workspace").Camera.CFrame)
            else
                Fluent:Notify({
                    Title = "Hypexz v2",
                    Content = "No have : "..SelectedBait,
                    Duration = 3
                })
                AutoOpenBait = false
                return
            end
        end
    end
end)

local FarmSection = Tabs.Shop:AddSection("Daily Shop")

-- game:GetService("Players").LocalPlayer.PlayerGui.hud.safezone.BlackMarket.Visible 

Tabs.Shop:AddButton({
    Title = "Open Black Market",
    Description = "",
    Callback = function()
        game:GetService("Players").LocalPlayer.PlayerGui.hud.safezone.BlackMarket.Visible = true
    end
})


local FarmSection = Tabs.Shop:AddSection("Daily Shop")

local Itemlist = {
    "Sundial Totem",
    "Enchant Relic",
    "Meteor Totem",
    "Exalted Relic",
    "Mutation Totem",
    "Aurora Totem",
    "Shiny Totem",
    "Scylla Hunt Totem",
    "Megalodon Hunt Totem",
    "Kraken Hunt Totem",
    "Sparkling Totem",
    "Lunar Thread",
    "Moonstone",
    "Nuke"
}


table.sort(Itemlist,function(a,b) return a:lower() < b:lower() end)

local SelectItemDialyShop = Tabs.Shop:AddDropdown("SelectItemDialyShop", {
    Title = "Select Item",
    Values = Itemlist,
    Multi = true,
    Default = _G.Settings.Daily_Shop.SelectItem,
})



SelectItemDialyShop:OnChanged(function(Value)
    _G.Settings.Daily_Shop.SelectItem = Value
    getgenv().SaveSetting()
end)

for i,v in pairs(_G.Settings.Daily_Shop.SelectItem) do
    print(v)
end




local AutoBuyDailyShop = Tabs.Shop:AddToggle("AutoBuyDailyShop", {Title = "Auto Buy", Default = _G.Settings.Daily_Shop.Enable })



AutoBuyDailyShop:OnChanged(function(Value)
    _G.Settings.Daily_Shop.Enable = Value
    getgenv().SaveSetting()
end)

spawn(function()
    while task.wait() do
        if _G.Settings.Daily_Shop.Enable then
            xpcall(function()
                local Players = game:GetService("Players")
                local ReplicatedStorage = game:GetService("ReplicatedStorage")
                local player = Players.LocalPlayer
                local dailyShopList = player.PlayerGui:WaitForChild("hud").safezone.DailyShop.List
                local BuyParent = {}
                local SSr = _G.Settings.Daily_Shop.SelectItem
                for _, v in pairs(dailyShopList:GetDescendants()) do
                    if v.Name == "Label" and v:IsA("TextLabel") then
                        local itemName = v.Text 
                        if table.find(SSr,itemName) then
                            table.insert(BuyParent, v.Parent)
                        end
                    end
                end

                for _, itemFrame in pairs(BuyParent) do
                    local soldOut = itemFrame:FindFirstChild("SoldOut")
                    if soldOut and not soldOut.Visible then
                        local itemName = itemFrame.Name -- or itemFrame.Label.Text
                        pcall(function()
                            ReplicatedStorage
                                :WaitForChild("packages")
                                :WaitForChild("Net")
                                :WaitForChild("RE/DailyShop/Purchase")
                                :FireServer(itemName)
                        end)
                    end
                end
            end,warn)
        end
    end
end)






SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)

-- Ignore keys that are used by ThemeManager.
-- (we dont want configs to save themes, do we?)
SaveManager:IgnoreThemeSettings()

-- You can add indexes of elements the save manager should ignore
SaveManager:SetIgnoreIndexes({})

-- use case for doing it this way:
-- a script hub could have themes in a global folder
-- and game configs in a separate folder per game
InterfaceManager:SetFolder("Hypexzv2ScriptHub")
SaveManager:SetFolder("Hypexzv2ScriptHub/specific-game")

InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)


Window:SelectTab(1)

Fluent:Notify({
    Title = "Hypexz v2",
    Content = "The script has been loaded.",
    Duration = 8
})

SaveManager:LoadAutoloadConfig()

EnableNoclip()

task.spawn(function()
    wait(1)
    if _G.Settings.Farm.Enable then
        AutoFish5()
    end
end)

getgenv().ToggleAutoFish = function(enabled)
    AutoFish = enabled
    if enabled then
        AutoFish5()
    end
end

getgenv().ToggleAutoFreeze = function(enabled)
    AutoFreeze = enabled
    if enabled then
        AutoFreezeHandler()
    end
end

getgenv().ToggleNoclip = function(enabled)
    Noclip = enabled
end

getgenv().ToggleAntiAfk = function(enabled)
    AntiAfk = enabled
    if enabled then
        AntiAfkHandler()
    end
end

getgenv().TeleportToSpot = function(spotName)
    if teleportSpots[spotName] then
        TP(teleportSpots[spotName])
    else
        warn("Teleport spot not found: " .. tostring(spotName))
    end
end

getgenv().TeleportToFishArea = function(areaName)
    if FishAreas[areaName] then
        TP(FishAreas[areaName])
    else
        warn("Fish area not found: " .. tostring(areaName))
    end
end

getgenv().TeleportToNPC = function(npcName)
    if racistPeople[npcName] then
        TP(racistPeople[npcName])
    else
        warn("NPC not found: " .. tostring(npcName))
    end
end

getgenv().TeleportToRod = function(rodName)
    if itemSpots[rodName] then
        TP(itemSpots[rodName])
    else
        warn("Rod/Item not found: " .. tostring(rodName))
    end
end

getgenv().SellAllFish = function()
    SellFishAndReturnAll()
    print("Selling all fish...")
end

getgenv().SellOneFish = function()
    SellFishAndReturnOne()
    print("Selling one fish...")
end

getgenv().ToggleAutoAppraiser = function(enabled)
    AutoAppraiser = enabled
    if enabled then
        Appraise()
    end
end

getgenv().OptimizePerformance = function()
    OptimizePerformance()
end

getgenv().RestoreGraphics = function()
    RestoreGraphics()
end

print("\n╔════════════════════════════════════════════════╗")
print("║       Fisch Script v22 - Enhanced Edition      ║")
print("╚════════════════════════════════════════════════╝")

print("\n🎣 TELEPORT COMMANDS:")
print("  • TeleportToSpot('name') - Teleport to location (27 spots)")
print("  • TeleportToFishArea('name') - Teleport to fishing area (24 areas)")
print("  • TeleportToNPC('name') - Teleport to NPC (22 NPCs)")
print("  • TeleportToRod('name') - Teleport to rod/item (18 items)")

print("\n🐟 AUTO FISHING:")
print("  • ToggleAutoFish(true) - Auto fishing shake mode")
print("  • ToggleAutoFreeze(true) - Freeze at current position")
print("  • ToggleNoclip(true) - Walk through walls")
print("  • ToggleAntiAfk(true) - Prevent AFK kick")
print("  • ToggleAutoAppraiser(true) - Auto appraise fish")

print("\n💰 MERCHANT & SALES:")
print("  • SellAllFish() - Sell all fish to merchant")
print("  • SellOneFish() - Sell one fish to merchant")

print("\n⚙️  PERFORMANCE:")
print("  • OptimizePerformance() - Remove effects & simplify graphics")
print("  • RestoreGraphics() - Restore default graphics")

print("\n📊 AVAILABLE LOCATIONS:")
print("  ✓ Teleport Spots: 27 (altar, arch, birch, brine...)")
print("  ✓ Fish Areas: 24 (Roslit_Bay, Ocean, Snowcap_Pond...)")
print("  ✓ NPC Locations: 22 (Witch, Pierre, Merchant, Appraiser...)")
print("  ✓ Rod/Item Spots: 18 (Training_Rod, Lucky_Rod, Midas_Rod...)")

print("\n═══════════════════════════════════════════════════\n")


