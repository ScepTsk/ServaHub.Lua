local v1 = game:GetService("UserInputService")

local function v2()
	local v3 = Instance.new("ScreenGui", game.Players.LocalPlayer.PlayerGui)
	local v4 = Instance.new("Frame")
	local v5 = UDim2.new(0, 200, 0, 120)
	v4.Size = v5
	v5 = UDim2.new(0.5, -100, 0.5, -60)
	v4.Position = v5
	v5 = Color3.fromRGB(50, 50, 50)
	v4.BackgroundColor3 = v5
	v4.Parent = v3
	v5 = Instance.new("TextLabel")
	local v6 = UDim2.new(0, 180, 0, 30)
	v5.Size = v6
	v6 = UDim2.new(0.5, -90, 0.5, -55)
	v5.Position = v6
	v5.Text = "Fling GUI"
	v5.BackgroundTransparency = 1
	v6 = Color3.fromRGB(255, 255, 255)
	v5.TextColor3 = v6
	v5.Parent = v4
	v6 = Instance.new("TextButton")
	local v7 = UDim2.new(0, 180, 0, 30)
	v6.Size = v7
	v7 = UDim2.new(0.5, -90, 0.5, -15)
	v6.Position = v7
	v6.Text = "Off"
	v7 = Color3.fromRGB(100, 100, 100)
	v6.BackgroundColor3 = v7
	v6.Parent = v4
	v7 = Instance.new("TextButton")
	local v8 = UDim2.new(0, 30, 0, 30)
	v7.Size = v8
	v8 = UDim2.new(0, 10, 1, -40)
	v7.Position = v8
	v7.Text = "I"
	v8 = Color3.fromRGB(100, 100, 100)
	v7.BackgroundColor3 = v8
	v7.Parent = v3
	v8 = Instance.new("TextLabel")
	local v9 = UDim2.new(0, 180, 0, 20)
	v8.Size = v9
	v9 = UDim2.new(0.5, -90, 0.5, 25)
	v8.Position = v9
	v8.Text = "Credits: X"
	v8.BackgroundTransparency = 1
	v9 = Color3.fromRGB(255, 255, 255)
	v8.TextColor3 = v9
	v8.Parent = v4

	local function v10(a)
		if not _u0 then
			local v11 = UDim2.new(_u3.X.Scale, _u3.X.Offset + ((a.Position - _u1).X), _u3.Y.Scale, _u3.Y.Offset + ((a.Position - _u1).Y))
			_u2.Position = v11
		end
	end

	local function v12(a, b)
		if b then
			_u0 = true
			_u1 = a.Position
			_u2 = _u3.Position
			a.Changed:Connect(function()
				if _u0.UserInputState == Enum.UserInputState.End then
					_u1 = false
				end
			end)
		end
	end

	v5.InputBegan:Connect(25)
	_u0.InputChanged:Connect(255)
	return v3, v4, v6, v7, v8
end

local v18, v19, v20, v21 = game()
v20.MouseButton1Click:Connect(function()
	_u0 = not _u0

	if not _u0 then
		_u1.Text = "On"
	else
		_u1.Text = "Off"
	end
end)
v21.MouseButton1Click:Connect(function() _u0.Visible = not _u0.Visible end)
function()
	while true do
		local v13 = game:GetService("RunService")
		v13.Heartbeat:Wait()

-- https://leakd.fr
		if not _u0 then
		end

		while true do

			if not _u0 then

				if not v14 then

					if not v14.Parent then

						if not v15 then

							if v15.Parent then
							else
							else
							else
								local v16 = game:GetService("RunService")
								v16.Heartbeat:Wait()
								v16 = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

								if v16 then
									v16 = game.Players.LocalPlayer.Character:FindFirstChild("Torso")

									if v16 then
										v16 = game.Players.LocalPlayer.Character:FindFirstChild("UpperTorso")
									end

								end

							end

						end

					end

				end

			end

		end

		if not _u0 then
		end

		local v17 = Vector3.new(0, 10000, 0)
		v16.Velocity = v16.Velocity * 10000 + v17
		v16 = game:GetService("RunService")
		v16.RenderStepped:Wait()

		if not game.Players.LocalPlayer.Character then

			if not game.Players.LocalPlayer.Character.Parent then

				if not v16 then

					if not v16.Parent then
						v16.Velocity = v16.Velocity
					end

				end

			end

		end

		v16 = game:GetService("RunService")
		v16.Stepped:Wait()

		if not game.Players.LocalPlayer.Character then
		end

		if not game.Players.LocalPlayer.Character.Parent then
		end

		if not v16 then
		end

		if not v16.Parent then
		end

		v16 = Vector3.new(0, 0.1, 0)
		v16.Velocity = v16.Velocity + v16
	end
end()
