extends Control

@export var bg_color : Color = Color.BLACK
@export var to_scene : PackedScene = null
@export var title_color := Color.BLUE_VIOLET
@export var text_color := Color.WHITE
@export var title_font : FontFile = null
@export var text_font : FontFile = null
@export var Music : AudioStream = null
@export var Use_Video_Audio : bool = false
@export var Video : VideoStream = null
@onready var Anthem = $Anthem
const section_time := 2.0
const line_time := 0.3
const base_speed := 70
const speed_up_multiplier := 10.0

var scroll_speed : float = base_speed
var speed_up := false

@onready var colorrect := $ColorRect
@onready var videoplayer := $VideoPlayer
@onready var line := $CreditsContainer/Line
var started := false
var finished := false

var section
var section_next := true
var section_timer := 0.0
var line_timer := 0.0
var curr_line := 0
var lines := []

var credits = [
	[
		"A game by Donald Peters"
	],[
		"Programming",
		"Programmer Name: Donald Peters",
	],[
		"3D Models",
		"John Rambo Character Model",
		"This work is based on 'John Rambo' (https://sketchfab.com/3d-models/john-rambo-d82a5f6418f24667971389705cac054a)",
		"by Tremolo_1404_ (https://sketchfab.com/Tremolo_1404_)",
		"licensed under CC-BY-4.0 (http://creativecommons.org/licenses/by/4.0/)",
		"Watchtower",
		"This work is based on 'Watch tower' (https://sketchfab.com/3d-models/watch-tower-042f327a0f4c4fc9bf458903666bb257)",
		"by _SeF_ (https://sketchfab.com/_SeF_)",
		"licensed under CC-BY-4.0 (http://creativecommons.org/licenses/by/4.0/)",
		"Photorealistic Bush",
		"This work is based on 'Photorealistic Bush' (https://sketchfab.com/3d-models/photorealistic-bush-8db54bf299954daa9ee29b233e923672)",
		"by Adrian Sheremet (https://sketchfab.com/adriansheremet)",
		"licensed under CC-BY-4.0 (http://creativecommons.org/licenses/by/4.0/)",
		"Twig",
		"This work is based on 'Twig' (https://sketchfab.com/3d-models/twig-747011772e8346ffbb3162416c5f9122)",
		"by amanda_98 (https://sketchfab.com/amanda_98)",
		"licensed under CC-BY-4.0 (http://creativecommons.org/licenses/by/4.0/)",
		"Military Car",
		"This work is based on 'Armored Car' (https://sketchfab.com/3d-models/armored-car-1a3ffbb3ccea4c42a6cf6e81ca8216d2)",
		"by Fredrik (https://sketchfab.com/kird3rf)",
		"licensed under CC-BY-4.0 (http://creativecommons.org/licenses/by/4.0/)",
		"Wooden Box",
		"This work is based on 'Wooden Box LP' (https://sketchfab.com/3d-models/wooden-box-lp-2701a235065048d0a3756b0a36d284e9)",
		"by yevheniia (https://sketchfab.com/yevheniia)",
		"licensed under CC-BY-4.0 (http://creativecommons.org/licenses/by/4.0/)",
		"Military Gas Can",
		"This work is based on 'Military Can' (https://sketchfab.com/3d-models/military-can-979d07024db44615a401bfe5d2bf84db)",
		"by JacobGroneman (https://sketchfab.com/JacobGroneman)",
		"licensed under CC-BY-4.0 (http://creativecommons.org/licenses/by/4.0/)",
		"MedKit",
		"This work is based on 'Medkit' (https://sketchfab.com/3d-models/medkit-bda966f7d9ac42a1bcd6e77481be0897)",
		"by DJMaesen (https://sketchfab.com/bumstrum)",
		"licensed under CC-BY-4.0 (http://creativecommons.org/licenses/by/4.0/)",
		"AKM",
		"This work is based on 'AKM' (https://sketchfab.com/3d-models/akm-fe8b79ae8a8142fb9ba706912c6b9df8)",
		"by Armored Wave (https://sketchfab.com/armoredwave)",
		"licensed under CC-BY-4.0 (http://creativecommons.org/licenses/by/4.0/)",
		"",
		"7.62 MM Bullet",
		"This work is based on '7.62 MM Bullet' (https://sketchfab.com/3d-models/762-mm-bullet-50728532d8cf489d9d02deeffb19ea31)",
		"by mucahitkutukde (https://sketchfab.com/mucahitkutukde)",
		"licensed under CC-BY-4.0 (http://creativecommons.org/licenses/by/4.0/)",
		"Bullet 9MM",
		"This work is based on 'Bullet 9x19' (https://sketchfab.com/3d-models/bullet-9x19-ce2f0c76c48a4cec8f2902709daa7946)",
		"by MyNameIsVoo (https://sketchfab.com/mynameisvoo)",
		"licensed under CC-BY-4.0 (http://creativecommons.org/licenses/by/4.0/)",
		"Grass 02",
		"This work is based on 'Grass 02' (https://sketchfab.com/3d-models/grass-02-539d1c154c944e24a04478ee32f0a960)",
		"by Digital screen official (https://sketchfab.com/ck212575)",
		"licensed under CC-BY-4.0 (http://creativecommons.org/licenses/by/4.0/)",
		"Mighty Oak Trees",
		"This work is based on 'Mighty Oak Trees' (https://sketchfab.com/3d-models/mighty-oak-trees-4f6ab5594a8a415aba3f958682b9ced5)",
		"by Jagobo (https://sketchfab.com/Jagobo)",
		"licensed under CC-BY-4.0 (http://creativecommons.org/licenses/by/4.0/)",
		"Russian Flag",
		"'Flag of Russia' (https://skfb.ly/6ZGRO) by Wittybacon ",
		"is licensed under Creative Commons Attribution (http://creativecommons.org/licenses/by/4.0/)."

	],[
		"Materials",
		"Cracked Mud material",
		"CC Attribute CC0 by Joao Paulo of 3dtextures.me and Qwertygiy",
		"Diamond Steel Material",
		"Qwertygiy; MIT; 2019-03-28"
	
	],[
		"Pictures",
		"Rambo Png wallpaper",
		"https://wallpaperaccess.com/rambo",
		"Rambo png image",
		"Pngimg.com License - Attribution-NonCommercial 4.0 International",
		"https://pngimg.com/image/31805",
		"Broken Brick Wall Picture",
		"https://www.pngkey.com/download/u2q8a9a9e6w7q8u2_broken-brick-png-transparent-broken-brick-wall-png/",
		"Russian Flag PNG",
		"Image by <a href='https://pixabay.com/users/motorolla-1945999/?utm_source=link-attribution&utm_medium=referral&utm_campaign=image&utm_content=1168880>Leonid</a>",
		"from <a href=https://pixabay.com//?utm_source=link-attribution&utm_medium=referral&utm_campaign=image&utm_content=1168880'>Pixabay</a>",
		"Blue Arrow PNG",
"		<a href=https://pngtree.com/freepng/blue-arrow-gradient-button-icon_5464335.html>",
		"png image from pngtree.com/</a>",
	],[
		"Music",
		"Background Music",
		"By Royalty Free Copyright Music",
		"[Copyright Free Trailer Music] -  Resurgence  by @Ghostrifter Official",
		"Copyright Free Military Music -  Legionnaire  by @Scott Buckley",
		"Epic Non Copyrighted Music "
		
	],[
		"Sound Effects",
		"Stick Snap 2 by Pixabay",
		"9mm pisol shoot short reverb by Pixabay",
		"Star Wars Death Noise by Free Sound Effects",
		"https://www.youtube.com/watch?v=LesARFyzWqI&list=PLfQvBJO9MX4ClkeLKsnoweoV5f5RRmWxj&index=3",
		"Error Sound Effect",
		"Attribution to u_8iuwl7zrk0",
		"https://pixabay.com/sound-effects/search/error/?pagi=2",
		"Healing Sound Effect",
		"Sound Effect from <a href=https://pixabay.com/sound-effects/?utm_source=link-attribution&utm_medium=referral&utm_campaign=music&utm_content=36672>Pixabay</a>",
		"Car Sound",
		"Sound Effect from <a href=https://pixabay.com/?utm_source=link-attribution&utm_medium=referral&utm_campaign=music&utm_content=5998>Pixabay</a>",
		"Explosion sfx",
		"Sound Effect from <a href=https://pixabay.com/sound-effects/?utm_source=link-attribution&utm_medium=referral&utm_campaign=music&utm_content=6288>Pixabay</a>",
		"Oof sfx",
		"Sound Effect from <a href=https://pixabay.com/sound-effects/?utm_source=link-attribution&utm_medium=referral&utm_campaign=music&utm_content=97698>Pixabay</a>",
		"Homemade OOf",
		"Sound Effect from <a href=https://pixabay.com/sound-effects/?utm_source=link-attribution&utm_medium=referral&utm_campaign=music&utm_content=47509>Pixabay</a>",
		"Womp Womp sfx",
		"https://www.myinstants.com/en/instant/womp-womp-womp-55094/",
		"CC Attribute to unofficialopinions",
		"Victory sfx",
		"Sound Effect from <a href=https://pixabay.com/sound-effects/?utm_source=link-attribution&utm_medium=referral&utm_campaign=music&utm_content=6185>Pixabay</a>",
		"success sfx",
		"Sound Effect from <a href=https://pixabay.com/sound-effects/?utm_source=link-attribution&utm_medium=referral&utm_campaign=music&utm_content=6297>Pixabay</a>"
		

		
	],[
		"Animations",
		"All Animations are Imported From Mixamo",
		"Skins on Animated Bodies Are Imported from Mixamo",
		"Mixamo Additional Terms  Effective as of June 23, 2021. Replaces all prior versions.",
		"These Additional Terms govern your use of Mixamo and are incorporated into the Adobe General Terms",
		"of Use ('General Terms') located at www.adobe.com/go/terms (these Additional Terms and the General Terms are collectively referred to as 'Terms')",
		"Capitalized terms not defined here have the same meaning as defined in the General Terms. References to 'Services'",
		"in these Additional Terms are to the Mixamo services.",  
		"1. Restriction on AI/ML. You will not, and will not instruct or allow third parties to,",
		"use the Services or Software (or any content, data, output, or other information received or derived from",
		"the Services or Software) to directly or indirectly create, train, test, or otherwise improve any",
		"machine learning algorithms or artificial intelligence systems, including,",
		"but not limited to, any architectures, models, or weights.",
		"Mixamo Additional Terms_en_US-20210623 ",

	],[
		"Tools used",
		"Developed with Godot Engine",
		"https://godotengine.org/license",
		"",
		"First Person Controller-FPS",
		"MIT License Copyright (c) 2021 Danyl Bekhoucha",
		"",
		"Permission is hereby granted, free of charge, to any person obtaining a copy",
		"of this software and associated documentation files (the 'Software'), to deal",
		"in the Software without restriction, including without limitation the rights",
		"to use, copy, modify, merge, publish, distribute, sublicense, and/or sell",
		"copies of the Software, and to permit persons to whom the Software is",
		"furnished to do so, subject to the following conditions:",
		"The above copyright notice and this permission notice shall be included in all",
		"copies or substantial portions of the Software.",
		"",
		"THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR",
		"IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,",
		"FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE",
		"AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER",
		"LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,",
		"OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.",
		"",
		"BSD License",
		"For FBX2glTF software",
		"",
		"Copyright (c) 2020-2022 V-Sekai contributors.",
		"Copyright (c) Facebook, Inc. and its affiliates. All rights reserved.",
		"",
		"Redistribution and use in source and binary forms, with or without modification,",
		"are permitted provided that the following conditions are met:",
		" * Redistributions of source code must retain the above copyright notice, this",
		"list of conditions and the following disclaimer.",
		" * Redistributions in binary form must reproduce the above copyright notice,",
		"this list of conditions and the following disclaimer in the documentation",
		"and/or other materials provided with the distribution.",
		"",
		"* Neither the name Facebook nor the names of its contributors may be used to",
		"endorse or promote products derived from this software without specific",
		"prior written permission.",
		"",
		"THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS 'AS IS' AND",
		"ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED",
		"WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE",
		"DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR",
		"ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES",
		"(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;",
		"LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON",
		"ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT",
		"(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS",
		"SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.",
		"",
		"Credits-Godot",
		"MIT License",
		"",
		"Copyright (c) 2019 Ben Bishop",
		"",
		"Permission is hereby granted, free of charge, to any person obtaining a copy",
		"of this software and associated documentation files (the 'Software'), to deal",
		"in the Software without restriction, including without limitation the rights",
		"to use, copy, modify, merge, publish, distribute, sublicense, and/or sell",
		"copies of the Software, and to permit persons to whom the Software is",
		"furnished to do so, subject to the following conditions:",
		"",
		"The above copyright notice and this permission notice shall be included in all",
		"copies or substantial portions of the Software.",
		"",
		"THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR",
		"IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,",
		"FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE",
		"AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER",
		"LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,",
		"OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE",
		"SOFTWARE."
		
	],[
		"As this is my final project",
		"For my final class at Augustana",
		"Thank you to all who has helped me",
		"Special thanks",
		"Mom and Dad",
		"Dr.Stonedahl",
		"My Classmates",
		"The Entire Department",
		"Energy Drinks",
		"And Finally",
		"You"
		
		
	]
]

func _ready():
	Anthem.play()
	colorrect.color = bg_color
	videoplayer.set_stream(Video)
	if !Use_Video_Audio:
		var stream = AudioStreamPlayer.new()
		stream.set_stream(Music)
		add_child(stream)
		videoplayer.set_volume_db(-80)
		stream.play()
	else:
		videoplayer.set_volume_db(0)
	videoplayer.play()
	

func _process(delta):
	scroll_speed = base_speed * delta
	
	if section_next:
		section_timer += delta * speed_up_multiplier if speed_up else delta
		if section_timer >= section_time:
			section_timer -= section_time
			
			if credits.size() > 0:
				started = true
				section = credits.pop_front()
				curr_line = 0
				add_line()
	
	else:
		line_timer += delta * speed_up_multiplier if speed_up else delta
		if line_timer >= line_time:
			line_timer -= line_time
			add_line()
	
	if speed_up:
		scroll_speed *= speed_up_multiplier
	
	if lines.size() > 0:
		for l in lines:
			l.set_global_position(l.get_global_position() - Vector2(0, scroll_speed))
			if l.get_global_position().y < l.get_line_height():
				lines.erase(l)
				l.queue_free()
	elif started:
		finish()


func finish():
	if not finished:
		finished = true
		if to_scene != null:
			var path = to_scene.get_path()
			get_tree().change_scene_to_file(path)
		else:
			get_tree().quit()


func add_line():
	var new_line = line.duplicate()
	new_line.text = section.pop_front()
	lines.append(new_line)
	if curr_line == 0:
		if title_font != null:
			new_line.set("theme_override_fonts/font", title_font)
		new_line.set("theme_override_colors/font_color", title_color)
	
	else:
		if text_font != null:
			new_line.set("theme_override_fonts/font", text_font)
		new_line.set("theme_override_colors/font_color", text_color)
	
	$CreditsContainer.add_child(new_line)
	
	if section.size() > 0:
		curr_line += 1
		section_next = false
	else:
		section_next = true


func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		finish()
	if event.is_action_pressed("ui_down") and !event.is_echo():
		speed_up = true
	if event.is_action_released("ui_down") and !event.is_echo():
		speed_up = false
