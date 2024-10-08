func parse_beatmap_osu(path):
	var beatmapsection = {}
	var file = FileAccess.open(path, FileAccess.READ)
	var content = file.get_as_text().split("\n")
	var currentsection
	var sections = {}
	
	for line in content:
		line = line.replace("\r", "")
		if line == "":
			continue
		if "[" in line and "]" in line:
			currentsection = line.replace("[", "").replace("]", "")
			beatmapsection[currentsection] = []
		else:
			if beatmapsection:
				beatmapsection[currentsection].append(line)
				
	for section in beatmapsection:
		var temp
		if section in ["General", "Editor", "Metadata", "Difficulty"]:
			temp = {}
			if section in ["General", "Editor"]:
				for text in beatmapsection[section]:	
					if (text.split(":")[1])[0] == " ":
						temp[text.split(":")[0]] = (text.split(": ")[1])
					else:
						temp[text.split(":")[0]] = (text.split(":")[1])
				sections[section] = temp
			if section in ["Metadata", "Difficulty"]:
				for text in beatmapsection[section]:
					temp[text.split(":")[0]] = (text.split(":")[1])
				sections[section] = temp
		if section == "Events":
			var background = []
			var video = []
			var breaks = []
			for text in beatmapsection[section]:
				var textsplits = text.split(",")
				temp = {}
				if text[0] == "/":
					continue
				if textsplits[0] == "0" and textsplits[1] == "0":
					temp["filename"] = text.split(",")[2].replace('"', "")
					if len(text.split(",")) - 1 < 3:
						temp["Xoffset"] = 0
						temp["Yoffset"] = 0
					else:
						temp["Xoffset"] = text.split(",")[3]
						temp["Yoffset"] = text.split(",")[4]
					background.append(temp)
				if textsplits[0] in ["1", "Video"]:
					temp["starttime"] = text.split(",")[1]
					temp["filename"] = text.split(",")[2].replace('"', "")
					if len(text.split(",")) - 1 < 3:
						temp["Xoffset"] = 0
						temp["Yoffset"] = 0
					else:
						temp["Xoffset"] = text.split(",")[3]
						temp["Yoffset"] = text.split(",")[4]
					video.append(temp)
				if textsplits[0] in ["2", "Break"]:
					temp["starttime"] = text.split(",")[1]
					temp["endtime"] = text.split(",")[2]
					breaks.append(temp)
			var constucttemp = {}
			constucttemp["background"] = background
			constucttemp["video"] = background
			constucttemp["break"] = background
			sections[section] = constucttemp
		if section in ["TimingPoints", "HitObjects"]:
			sections[section] = beatmapsection[section]
	return sections
