const KANA_TO_ROM={
"ア":"a", "イ":"i", "ウ":"u", "エ":"e","オ":"o",
"あ":"a", "い":"i", "う":"u", "え":"e","お":"o",
"カ":"ka", "キ":"ki", "ク":"ku", "ケ":"ke", "コ":"ko",
"か":"ka", "き":"ki", "く":"ku", "け":"ke", "こ":"ko",
"ガ":"ga", "ギ":"gi", "グ":"gu", "ゲ":"ge", "ゴ":"go",
"が":"ga", "ぎ":"gi", "ぐ":"gu", "げ":"ge", "ご":"go",
"サ":"sa", "シ":"shi","ス":"su", "セ":"se", "ソ":"so",
"さ":"sa", "し":"shi","す":"su", "せ":"se", "そ":"so",
"ザ":"za", "ジ":"ji", "ズ":"zu", "ゼ":"ze", "ゾ":"zo",
"ざ":"za", "じ":"ji", "ず":"zu", "ぜ":"ze", "ぞ":"zo",
"タ":"ta", "チ":"chi","ツ":"tsu","テ":"te", "ト":"to",
"た":"ta", "ち":"chi","つ":"tsu","て":"te", "と":"to",
"ダ":"da", "ヂ":"dji","ヅ":"dzu","デ":"de", "ド":"do",
"だ":"da", "ぢ":"dji","づ":"dzu","で":"de", "ど":"do",
"ナ":"na", "ニ":"ni", "ヌ":"nu", "ネ":"ne", "ノ":"no",
"な":"na", "に":"ni", "ぬ":"nu", "ね":"ne", "の":"no",
"ハ":"ha", "ヒ":"hi", "フ":"fu", "ヘ":"he", "ホ":"ho",
"は":"ha", "ひ":"hi", "ふ":"fu", "へ":"he", "ほ":"ho",
"バ":"ba", "ビ":"bi", "ブ":"bu", "ベ":"be", "ボ":"bo",
"ば":"ba", "び":"bi", "ぶ":"bu", "べ":"be", "ぼ":"bo",
"パ":"pa", "ピ":"pi", "プ":"pu", "ペ":"pe", "ポ":"po",
"ぱ":"pa", "ぴ":"pi", "ぷ":"pu", "ぺ":"pe", "ぽ":"po",
"マ":"ma", "ミ":"mi", "ム":"mu", "メ":"me", "モ":"mo",
"ま":"ma", "み":"mi", "む":"mu", "め":"me", "も":"mo",
"ヤ":"ya", "ユ":"yu", "ヨ":"yo",
"や":"ya", "ゆ":"yu", "よ":"yo",
"ラ":"ra", "リ":"ri", "ル":"ru","レ":"re","ロ":"ro",
"ら":"ra", "り":"ri", "る":"ru","れ":"re","ろ":"ro",
"ワ":"wa", "ヰ":"wi", "ヱ":"we", "ヲ":"wo", "ン":"nn",
"わ":"wa", "ゐ":"wi", "ゑ":"we", "を":"wo", "ん":"nn",
"ァ":"xa", "ィ":"xi", "ゥ":"xu", "ェ":"xe", "ォ":"xo",
"ぁ":"xa", "ぃ":"xi", "ぅ":"xu", "ぇ":"xe", "ぉ":"xo",
"ッ":"xtsu","ャ":"xya", "ュ":"xyu", "ョ":"xyo",
"っ":"xtsu","ゃ":"xya", "ゅ":"xyu", "ょ":"xyo",
"ヴ":"vu", "ヵ":"xka","ヶ":"ga","ヮ":"xwa",
"ゎ":"xwa",
"ー":"-", "−":"-", "゛":'"', "゜":"'", "、":",", "。":".",
"：":":", "　" : " ", "＠" : "@", "（" : "(", "）" : ")",
" " : " "}

func convertToRomanji(sentence: String) -> String:
	var convertedRomanji: String = ""
	for char in sentence:
		if char in KANA_TO_ROM: convertedRomanji += KANA_TO_ROM[char]
		else: convertedRomanji += char
	return convertedRomanji

func isKana(char: String) -> bool:
	if char in KANA_TO_ROM: return true
	return false
